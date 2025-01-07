import 'dart:io';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/my_ip.dart';
import 'package:mat_salg/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_util.dart';

import 'dart:async';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();

  factory WebSocketService() {
    return _instance;
  }

  // Private internal constructor
  WebSocketService._internal();

  late IOWebSocketChannel _ioWebSocketChannel;

  late Stream<dynamic> _innerStream;
  final _outerStreamSubject = BehaviorSubject<dynamic>();
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  Stream<dynamic> get stream => _outerStreamSubject.stream;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  bool _running = false;
  static const Duration retryDelay = Duration(seconds: 3);
  static const Duration listenerTimeout =
      Duration(seconds: 5); // Timeout for listener response

  Future<void> connect({bool? retrying}) async {
    try {
      if (_running) {
        logger.d("Connection attempt already in progress.");
        return;
      }

      _running = true;

      // Prevent redundant reconnections
      if (_isConnected && retrying == null) {
        logger.d("Already connected. No need to reconnect.");
        _running = false;
        return;
      }

      const String url = ApiConstants.baseSocketUrl;

      String? token = await firebaseAuthService.getToken(null);

      if (token == null || token.isEmpty) {
        logger.d('Error: Token is missing or invalid.');
        _isConnected = false;
        _running = false;
        return;
      }

      try {
        logger.d("Attempting to connect to WebSocket...");

        // Close existing connection if any
        await _cleanupConnection();

        // Establish a new WebSocket connection
        _ioWebSocketChannel = IOWebSocketChannel.connect(
          url,
          headers: {'Authorization': 'Bearer $token'},
        );

        // Ensure the inner stream is properly set
        _innerStream = _ioWebSocketChannel.stream.asBroadcastStream();

        // Add a listener to handle incoming messages
        await _listenWithTimeout(_innerStream);

        _isConnected = true;
        logger.d("WebSocket connection established.");
      } catch (e) {
        logger.d("Failed to connect to WebSocket: $e");
        _isConnected = false;
        handleLostConnection();
      } finally {
        _running = false;
      }
    } catch (e) {
      logger.d("Error when connecting$e");
    }
  }

  Future<void> _listenWithTimeout(Stream<dynamic> stream) async {
    final completer = Completer<void>();

    // Listen for a response or throw an exception if no response within timeout
    stream.listen(
      (event) {
        try {
          logger.d('Received message: $event');
          _outerStreamSubject.add(event);
          _onMessageReceived(event);
          if (completer.isCompleted) {
          } else {
            completer.complete();
          }
        } catch (e) {
          logger.d("error$e");
        }
      },
      onError: (error) {
        try {
          logger.d("WebSocket error: $error");
          completer.completeError(
              error); // Mark as error if there was a connection issue
        } catch (e) {
          logger.d("error$e");
        }
      },
      onDone: () {
        try {
          logger.d("WebSocket connection closed.");
          completer.completeError(
              Exception("Connection closed before receiving any response"));
        } catch (e) {
          logger.d("error$e");
        }
      },
    );

    // Wait for a response or timeout
    try {
      await Future.any([
        completer.future,
        Future.delayed(listenerTimeout),
      ]);

      // If we reach here, it means we either got a response or the timeout occurred
      if (completer.isCompleted) {
        logger.d("Listener received response.");
      } else {
        throw TimeoutException(
            "No response received within the timeout period.");
      }
    } catch (e) {
      // If an error occurs (including timeout), handle the reconnection
      logger.d("Error during listener setup: $e");
      rethrow; // Re-throw exception to trigger reconnection logic
    }
  }

  Future<void> _cleanupConnection() async {
    try {
      logger.d("Closing existing WebSocket connection...");
      await _ioWebSocketChannel.sink.close();
    } catch (e) {
      logger.d("Error during WebSocket cleanup: $e");
    }
  }

  void handleLostConnection() {
    logger.d("Handling lost connection...");
    Future.delayed(retryDelay, () async {
      logger.d("Reconnecting after delay...");
      await connect(retrying: true);
    });
  }

  void close() async {
    await _cleanupConnection();
    logger.d("WebSocket service closed.");
  }

  String _escapeControlCharactersInJson(String message) {
    // Escape newline, carriage return, and tab characters by replacing them with their escaped versions
    message = message.replaceAll('\n', r'\n'); // Escape newline
    message = message.replaceAll('\r', r'\r'); // Escape carriage return
    message = message.replaceAll('\t', r'\t'); // Escape tab

    // You can add more escape sequences here if needed for other special characters

    return message;
  }

  void _onMessageReceived(dynamic message) {
    try {
      message = _escapeControlCharactersInJson(message);
      var data = jsonDecode(message);

      if (data.containsKey('status') && data['status'] == 'read') {
        String receiver = data['receiver'] ?? ''; // Receiver from the message

        final appState = FFAppState();

        // Find the conversation with the receiver (i.e., the user who sent the "read" status)
        var conversation = appState.conversations.firstWhere(
          (conv) => conv.user == receiver,
          orElse: () =>
              throw (Exception), // If no conversation exists, return null
        );

        // Iterate over the messages in the conversation
        for (var message in conversation.messages) {
          // If the message is sent by 'me' (me == true), mark it as read
          if (message.me) {
            message.read = true; // Mark message as read
          }
        }
        // Notify listeners to update the UI
        appState.updateUI();
        logger.d(
            'Marked all messages sent by me as read for receiver: $receiver');
      }

      // Check if data is a Map (assumes the message is in JSON format)
      if (data is Map) {
        // If the message contains only the 'status' field, ignore it
        if (data.containsKey('status')) {
          logger.d("Received status update, ignoring...");
          return; // Ignore this message
        }

        // If this is the first message received after connection
        if ((data['conversations'] != null)) {
          try {
            final appState = FFAppState();
            appState.conversations.clear();
            var data = jsonDecode(message); // Assuming message is JSON string.

            // Check if the response contains 'conversations' key
            if (data is Map && data['conversations'] != null) {
              var conversationsList = data['conversations'] as List<dynamic>;

              // Parse and add new conversations to FFAppState
              for (var conversationJson in conversationsList) {
                var conv = Conversation.fromJson(conversationJson);
                appState.conversations.add(conv);
              }

              // Determine if any latest message is unread
              bool hasUnreadMessages =
                  appState.conversations.any((conversation) {
                return conversation.messages.isNotEmpty &&
                    !conversation
                        .messages.first.read && // Check the latest message
                    !conversation.messages.first.me; // Ensure it's sent by "me"
              });

              FFAppState().chatAlert.value = hasUnreadMessages;

              appState.updateUI();
            }
            return;
          } catch (e) {
            logger.d('Error parsing message: $e');
          }
        } else {
          var data = jsonDecode(message); // Assuming message is JSON string.
          // Proceed with normal message handling if sender and content are present
          String sender = data['sender'] ?? ''; // The sender of the message
          String content = data['content'] ?? ''; // The content of the message
          String username = data['username'] ?? '';
          String? lastactive = DateTime.now().toIso8601String();
          String profilePic =
              data['profile_picture'] ?? ''; // The sender of the message
          String time =
              data['time'] ?? DateTime.now().toIso8601String(); // Timestamp
          bool me = data['me'] ??
              false; // Flag indicating if the message was sent by the current user

          // Create a new Message object
          Message newMessage = Message(
            content: content,
            time: time,
            read: false, // Assuming the message is unread initially
            me: me,
          );
          FFAppState().chatAlert.value = true;
          // Access FFAppState to update the conversations globally
          final appState = FFAppState();

          bool empty = false;
          var conversation = appState.conversations.firstWhere(
            (conv) => conv.user == sender,
            orElse: () {
              // Set empty to true to indicate a new conversation is being created
              empty = true;
              return Conversation(
                user: sender,
                username: username,
                profilePic: profilePic,
                deleted: false,
                lastactive: lastactive,
                messages: [newMessage],
              );
            },
          );

          if (empty) {
            appState.conversations.add(conversation);
          }

          if (!empty) {
            conversation.messages.insert(0, newMessage);
          }

          appState.updateUI();
          logger.d("Notified listeners to update the UI");
        }
      }
    } catch (e) {
      logger.d('Error parsing message: $e');
    }
  }

  void sendMessage(
      String receiver, String content, String username, String? lastactive) {
    if (!_isConnected) {
      logger.d('WebSocket is not connected. Cannot send message.');
      throw const SocketException('');
    }

    // Manually escape special characters
    String escapedContent = content
        .replaceAll(r'\n', '\\n')
        .replaceAll(r'\r', '\\r')
        .replaceAll(r'\t', '\\t');

    // Create a new message object for the sent message
    Message newMessage = Message(
      content: escapedContent, // Use escaped content
      time: DateTime.now()
          .toIso8601String(), // Use current time for the sent message
      read: false, // Mark it as read (or modify as needed)
      me: true, // Mark this message as sent by the current user
    );

    // Access the global app state (FFAppState)
    final appState = FFAppState();

    // Find the existing conversation or create a new one if not found
    var conversation = appState.conversations.firstWhere(
      (conv) => conv.user == receiver,
      orElse: () => Conversation(
        username: username,
        user: receiver,
        lastactive: lastactive,
        deleted: false,
        profilePic: '',
        messages: [newMessage], // Start the conversation with the new message
      ),
    );

    // Always add the new message to the conversation's messages list
    conversation.messages
        .insert(0, newMessage); // Insert the message at the beginning

    // Send the message over WebSocket to the server (escaped)
    _sendMessageToServer(receiver, escapedContent);

    // Save the updated conversation list to SharedPreferences
    appState.updateUI();
  }

  void _sendMessageToServer(String receiver, String content) {
    final appState = FFAppState();
    // Prepare the message object in the correct format
    Map<String, dynamic> message = {
      'receiver': receiver,
      'content': content, // Use the escaped content
      'time': DateTime.now().toIso8601String(),
      'me': true, // Mark message as sent by the current user
    };

    // Send the encoded message over WebSocket
    _ioWebSocketChannel.sink.add(jsonEncode(message));

    // Save the updated conversation list to SharedPreferences
    appState.updateUI();
  }

  void _sendMarkAsReadRequest(String sender) {
    // if (!_isConnected) {
    //   return;
    // }

    // Prepare the message for the server
    Map<String, String> messageData = {
      'sender': sender,
      'read': 'true',
    };
    String jsonMessage = jsonEncode(messageData);

    // Send the message over WebSocket
    _ioWebSocketChannel.sink.add(jsonMessage);
    logger.d('Sent mark as read request: $jsonMessage');
  }

  void markAllMessagesAsRead(String sender) {
    // Ensure sender is not empty before proceeding
    if (sender.isEmpty) {
      return;
    }

    // Access FFAppState to update the conversations globally
    final appState = FFAppState();
    // Try to find the conversation with the sender (will not create a new one)
    var conversation = appState.conversations.firstWhere(
        (conv) => conv.user == sender,
        orElse: () =>
            throw (Exception) // This will return null, but not actually create a new conversation
        );

    bool updated = false;
    // Iterate over all messages and mark those from 'me == false' as read
    for (var message in conversation.messages) {
      if (!message.me && !message.read) {
        message.read = true;
        updated = true;
      }
    }
    bool hasUnreadMessages = appState.conversations.any((conversation) =>
        conversation.messages.any((message) => !message.me && !message.read));
    appState.chatAlert.value = hasUnreadMessages;
    if (updated) {
      _sendMarkAsReadRequest(sender);
    } else {}
  }
}
