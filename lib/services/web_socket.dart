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
  static const Duration listenerTimeout = Duration(seconds: 21);

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

        // Close existing connection
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
      _running = false;
      logger
          .d("Error when connecting will not retry as its outside the block$e");
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

          completer.completeError(Exception(
              error)); // Mark as error if there was a connection issue
        } catch (e) {
          logger.d("error$e");
        }
      },
      onDone: () {
        try {
          logger.d("WebSocket connection closed.");

          completer.completeError(
              Exception("Connection closed before receiving any response"));
          return;
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
    logger.d("Reconnecting after delay...");
    Future.delayed(retryDelay, () async {
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

      final appState = FFAppState();

      // Handle "read" status updates
      if (data.containsKey('status') && data['status'] == 'read') {
        String receiver = data['receiver'] ?? ''; // Receiver from the message
        int? matId = data['matId'] != null
            ? int.tryParse(data['matId'].toString())
            : null;

        // Find the conversation with the receiver and the matId
        var conversation = appState.conversations.firstWhere(
          (conv) => conv.user == receiver && conv.matId == matId,
          orElse: () => throw Exception('Conversation not found'),
        );

        for (var message in conversation.messages) {
          // If the message is sent by 'me', mark it as read
          if (message.me) {
            message.read = true;
          }
        }

        appState.updateUI();
        logger.d(
            'Marked all messages sent by me as read for receiver: $receiver, matId: $matId');
        return;
      }

      // Handle conversation list updates
      if (data is Map && data.containsKey('conversations')) {
        try {
          appState.conversations.clear();

          var conversationsList = data['conversations'] as List<dynamic>;
          for (var conversationJson in conversationsList) {
            var conv = Conversation.fromJson(conversationJson);
            appState.conversations.add(conv);
          }

          bool hasUnreadMessages = appState.conversations.any((conversation) {
            return conversation.messages.isNotEmpty &&
                !conversation.messages.first.read &&
                !conversation.messages.first.me;
          });

          appState.chatAlert.value = hasUnreadMessages;
          appState.updateUI();
          return;
        } catch (e) {
          logger.d('Error parsing conversation list: $e');
        }
      }

      // Handle a single message
      if (data.containsKey('sender') && data.containsKey('content')) {
        String sender = data['sender'] ?? '';
        String content = data['content'] ?? '';
        String username = data['username'] ?? '';
        String? lastactive = DateTime.now().toIso8601String();
        String profilePic = data['profile_picture'] ?? '';
        String time = data['time'] ?? DateTime.now().toIso8601String();
        bool me = data['me'] ?? false;
        int? matId = data['matId'] != null
            ? int.tryParse(data['matId'].toString())
            : null;

        // Create a new Message object
        Message newMessage = Message(
          content: content,
          time: time,
          read: false,
          matId: matId,
          me: me,
          showDelivered: null,
          showLest: null,
          isMostRecent: null,
          showTime: null,
        );

        appState.chatAlert.value = true;

        // Additional fields for the Conversation
        String? productImage = data['productImage'];
        if (productImage == null || productImage.isEmpty) {
          productImage = null;
        }

        // Ensure these fields are parsed correctly as bool?
        bool? slettet = _parseBool(data['slettet']);
        bool? kjopt = _parseBool(data['kjopt']);
        bool isOwner = _parseBool(data['isOwner']) ?? false;

        // Find or create a conversation based on the sender and matId
        bool empty = false;
        var conversation = appState.conversations.firstWhere(
          (conv) => conv.user == sender && conv.matId == matId,
          orElse: () {
            empty = true;
            return Conversation(
              user: sender,
              username: username,
              profilePic: profilePic,
              deleted: false,
              lastactive: lastactive,
              matId: matId,
              messages: [newMessage],
              productImage: productImage,
              slettet: slettet,
              kjopt: kjopt,
              isOwner: isOwner,
            );
          },
        );

        // If the conversation is empty (new), insert it at the 0th index, otherwise move the existing one to the top
        if (empty) {
          appState.conversations.insert(
              0, conversation); // Insert the new conversation at index 0
        } else {
          // If the conversation exists, move it to the top by removing and reinserting it at index 0
          appState.conversations.remove(conversation);
          appState.conversations.insert(0, conversation);
          conversation.messages
              .insert(0, newMessage); // Add the new message to the conversation
        }

        appState.updateUI();
        logger.d(
            "Added message to conversation with sender: $sender, matId: $matId");
      }
    } catch (e) {
      logger.d('Error parsing message: $e');
    }
  }

  void sendMessage(String receiver, String content, String username,
      String? lastactive, int? matId) {
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
      content: escapedContent,
      time: DateTime.now().toIso8601String(),
      read: false,
      me: true,
      matId: matId,
    );

    final appState = FFAppState();

    // Find the existing conversation based on both `receiver` and `matId`
    var existingIndex = appState.conversations.indexWhere((conv) =>
        conv.user == receiver &&
        conv.matId == matId); // Include matId in the matching logic

    Conversation conversation;
    if (existingIndex != -1) {
      // Conversation exists, fetch it
      conversation = appState.conversations[existingIndex];
      // Remove the conversation from its current position
      appState.conversations.removeAt(existingIndex);
    } else {
      // Create a new conversation if not found
      conversation = Conversation(
        username: username,
        user: receiver,
        lastactive: lastactive,
        deleted: false,
        profilePic: '',
        matId: matId,
        messages: [],
      );
    }

    // Always add the new message to the conversation's messages list
    conversation.messages.insert(0, newMessage);

    // Add the conversation to the start of the list
    appState.conversations.insert(0, conversation);

    // Send the message to the server
    _sendMessageToServer(receiver, escapedContent, matId);

    // Update UI
    appState.updateUI();
  }

  void _sendMessageToServer(String receiver, String content, int? matId) {
    final appState = FFAppState();
    // Prepare the message object in the correct format
    Map<String, dynamic> message = {
      'receiver': receiver,
      'content': content,
      'time': DateTime.now().toIso8601String(),
      'me': true,
      "matId": matId,
    };

    _ioWebSocketChannel.sink.add(jsonEncode(message));

    appState.updateUI();
  }

  void _sendMarkAsReadRequest(String sender, int? matId) {
    // Prepare the message data including the matId
    Map<String, dynamic> messageData = {
      'sender': sender,
      'matId': matId,
      'read': true, // Use a boolean for better consistency with JSON standards
    };
    String jsonMessage = jsonEncode(messageData);

    // Send the message over WebSocket
    _ioWebSocketChannel.sink.add(jsonMessage);
    logger.d('Sent mark as read request: $jsonMessage');
  }

  void markAllMessagesAsRead(String sender, int? matId) {
    // Ensure sender is not empty before proceeding
    if (sender.isEmpty) {
      return;
    }

    // Access FFAppState to update the conversations globally
    final appState = FFAppState();

    // Try to find the conversation with the sender and matId
    var conversation = appState.conversations
        .firstWhere((conv) => conv.user == sender && conv.matId == matId);

    bool updated = false;

    // Iterate over all messages and mark those from 'me == false' as read
    for (var message in conversation.messages) {
      if (!message.me && !message.read) {
        message.read = true;
        updated = true;
      }
    }

    // Update the chat alert state if any unread messages remain
    bool hasUnreadMessages = appState.conversations.any((conversation) =>
        conversation.messages.any((message) => !message.me && !message.read));
    appState.chatAlert.value = hasUnreadMessages;

    // Send a mark-as-read request to the server if messages were updated
    if (updated) {
      _sendMarkAsReadRequest(sender, matId);
    }
  }

  bool? _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    } else if (value is String) {
      return value.toLowerCase() == 'true';
    }
    return null;
  }
}
