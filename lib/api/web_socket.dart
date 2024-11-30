import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mat_salg/MyIP.dart';
import 'package:mat_salg/SecureStorage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:mat_salg/flutter_flow/flutter_flow_util.dart';

import 'dart:async';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();

  factory WebSocketService() {
    return _instance;
  }

  // Private internal constructor
  WebSocketService._internal();

  late IOWebSocketChannel _ioWebSocketChannel;

  WebSocketSink get _sink => _ioWebSocketChannel.sink;
  late Stream<dynamic> _innerStream;
  final _outerStreamSubject = BehaviorSubject<dynamic>();
  Stream<dynamic> get stream => _outerStreamSubject.stream;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  bool _isManuallyClosed = false;
  bool _running = false;
  static const Duration retryDelay = Duration(seconds: 3);
  static const Duration listenerTimeout =
      Duration(seconds: 5); // Timeout for listener response

  Future<void> connect({bool? retrying}) async {
    try {
      if (_running) {
        print("Connection attempt already in progress.");
        return;
      }

      _running = true;

      // Prevent redundant reconnections
      if (_isConnected && retrying == null) {
        print("Already connected. No need to reconnect.");
        _running = false;
        return;
      }

      const String url = ApiConstants.baseSocketUrl;

      String? token = await _getToken();

      if (token == null || token.isEmpty) {
        print('Error: Token is missing or invalid.');
        _isConnected = false;
        _running = false;
        return;
      }

      try {
        print("Attempting to connect to WebSocket...");

        // Close existing connection if any
        await _cleanupConnection();

        // Establish a new WebSocket connection
        _ioWebSocketChannel = await IOWebSocketChannel.connect(
          url,
          headers: {'Authorization': 'Bearer $token'},
        );

        // Ensure the inner stream is properly set
        _innerStream = _ioWebSocketChannel.stream.asBroadcastStream();

        // Add a listener to handle incoming messages
        await _listenWithTimeout(_innerStream);

        _isConnected = true;
        print("WebSocket connection established.");
      } catch (e) {
        print("Failed to connect to WebSocket: $e");
        _isConnected = false;
        handleLostConnection();
      } finally {
        _running = false;
      }
    } catch (e) {
      print("Error when connecting$e");
    }
  }

  Future<void> _listenWithTimeout(Stream<dynamic> stream) async {
    final completer = Completer<void>();

    // Listen for a response or throw an exception if no response within timeout
    stream.listen(
      (event) {
        try {
          print('Received message: $event');
          _outerStreamSubject.add(event);
          _onMessageReceived(event);
          if (completer.isCompleted) {
          } else {
            completer.complete();
          }
        } catch (e) {
          print("error$e");
        }
      },
      onError: (error) {
        try {
          print("WebSocket error: $error");
          completer.completeError(
              error); // Mark as error if there was a connection issue
        } catch (e) {
          print("error$e");
        }
      },
      onDone: () {
        try {
          print("WebSocket connection closed.");
          completer.completeError(
              Exception("Connection closed before receiving any response"));
        } catch (e) {
          print("error$e");
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
        print("Listener received response.");
      } else {
        throw TimeoutException(
            "No response received within the timeout period.");
      }
    } catch (e) {
      // If an error occurs (including timeout), handle the reconnection
      print("Error during listener setup: $e");
      throw e; // Re-throw exception to trigger reconnection logic
    }
  }

  Future<void> _cleanupConnection() async {
    try {
      if (_ioWebSocketChannel != null) {
        print("Closing existing WebSocket connection...");
        await _ioWebSocketChannel.sink.close();
      }
    } catch (e) {
      print("Error during WebSocket cleanup: $e");
    }
  }

  void handleLostConnection() {
    print("Handling lost connection...");
    Future.delayed(retryDelay, () async {
      print("Reconnecting after delay...");
      await connect(retrying: true);
    });
  }

  void close() async {
    _isManuallyClosed = true;
    await _cleanupConnection();
    print("WebSocket service closed.");
  }

  void _onMessageReceived(dynamic message) {
    try {
      var data = jsonDecode(message);

      if (data.containsKey('status') && data['status'] == 'read') {
        String receiver = data['receiver'] ?? ''; // Receiver from the message

        // Access FFAppState to update the conversations globally
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
        appState.notifyListeners();
        print('Marked all messages sent by me as read for receiver: $receiver');
      }

      // Check if data is a Map (assumes the message is in JSON format)
      if (data is Map) {
        // If the message contains only the 'status' field, ignore it
        if (data.containsKey('status')) {
          print("Received status update, ignoring...");
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

              // Clear previous conversations in FFAppState

              // Parse and add new conversations to FFAppState
              for (var conversationJson in conversationsList) {
                var conv = Conversation.fromJson(conversationJson);
                appState.conversations.add(conv);
              }

              // notifyListeners() to update the UI

              appState.notifyListeners();
              // const Duration(seconds: 1000);
              // appState.notifyListeners();
            }
            return;
          } catch (e) {
            print('Error parsing message: $e');
          }
        } else {
          var data = jsonDecode(message); // Assuming message is JSON string.
          // Proceed with normal message handling if sender and content are present
          String sender = data['sender'] ?? ''; // The sender of the message
          String content = data['content'] ?? ''; // The content of the message
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
          // Access FFAppState to update the conversations globally
          final appState = FFAppState();

          bool _empty = false;

          var conversation = appState.conversations.firstWhere(
            (conv) => conv.user == sender,
            orElse: () {
              // Set _empty to true to indicate a new conversation is being created
              _empty = true;
              return Conversation(
                user: sender,
                profilePic: profilePic,
                messages: [newMessage],
              );
            },
          );

          if (_empty) {
            appState.conversations.add(conversation);
          }

          if (!_empty) {
            conversation.messages.insert(0, newMessage);
          }

          appState.notifyListeners();
          print("Notified listeners to update the UI");
        }
      }
    } catch (e) {
      print('Error parsing message: $e');
    }
  }

  void sendMessage(String receiver, String content) {
    if (!_isConnected) {
      print('WebSocket is not connected. Cannot send message.');
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
        user: receiver,
        profilePic: '', // Default profile picture (empty or placeholder)
        messages: [newMessage], // Start the conversation with the new message
      ),
    );

    // Always add the new message to the conversation's messages list
    conversation.messages
        .insert(0, newMessage); // Insert the message at the beginning

    // Send the message over WebSocket to the server (escaped)
    _sendMessageToServer(receiver, escapedContent);

    // Save the updated conversation list to SharedPreferences
    appState.notifyListeners();
  }

  void _sendMessageToServer(String receiver, String content) {
    final appState = FFAppState();
    print(content);
    // Prepare the message object in the correct format
    Map<String, dynamic> message = {
      'receiver': receiver,
      'content': content, // Use the escaped content
      'time': DateTime.now().toIso8601String(),
      'me': true, // Mark message as sent by the current user
    };

    // Send the encoded message over WebSocket
    _ioWebSocketChannel.sink.add(jsonEncode(message));
    print(message);

    // Save the updated conversation list to SharedPreferences
    appState.notifyListeners();
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
    print('Sent mark as read request: $jsonMessage');
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
        message.read = true; // Mark the message as read
        updated =
            true; // Set flag to indicate we've updated at least one message
      }
    }
    if (updated) {
      _sendMarkAsReadRequest(sender);
    } else {}
  }

  Future<String?> _getToken() async {
    return await Securestorage().readToken();
  }
}
