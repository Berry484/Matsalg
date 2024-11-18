import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mat_salg/MyIP.dart';
import 'package:mat_salg/SecureStorage.dart';
import 'dart:io';

import 'package:mat_salg/flutter_flow/flutter_flow_util.dart';

import 'dart:async';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  late WebSocket _socket;
  bool _isConnected = false;
  static const String url = ApiConstants.baseSocketUrl;
  bool _isFirstMessage = true;

  // Private constructor
  WebSocketService._internal();

  // Factory constructor to return the same instance every time
  factory WebSocketService() {
    return _instance;
  }

  // Getter for _socket to access the WebSocket connection
  WebSocket get socket => _socket;

  // Method to connect to WebSocket
  Future<void> connect() async {
    // if (_isConnected) {
    //   print("WebSocket already connected.");
    //   return;
    // }

    try {
      _isFirstMessage = true;
      String? token = await _getToken();
      if (token == null) {
        print('Token is null, cannot connect');
        return;
      }

      print('Connecting to WebSocket server: $url');
      _socket = await WebSocket.connect(url, headers: {
        'Authorization': 'Bearer $token',
      });

      _isConnected = true;
      print("WebSocket connection established.");

      // Listen for incoming messages
      _socket.listen(
        (message) {
          _onMessageReceived(message); // Handle incoming message
        },
        onError: (error) {
          print('WebSocket error: $error');
        },
        onDone: () {
          print('WebSocket connection closed');
          final appState = FFAppState();
          appState.conversations.clear(); // Clear the conversations list
          _isFirstMessage = true;
          _isConnected = false;
        },
      );
    } catch (e) {
      print('Error during WebSocket connection: $e');
    }
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
        WidgetsBinding.instance.addPostFrameCallback((_) {
          appState.notifyListeners();
        });
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
        if (_isFirstMessage) {
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
              WidgetsBinding.instance.addPostFrameCallback((_) {
                appState.notifyListeners();
              });
              // const Duration(seconds: 1000);
              // appState.notifyListeners();
            }
            _isFirstMessage = false;
            return;
          } catch (e) {
            print('Error parsing message: $e');
          }
        } else {
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
          WidgetsBinding.instance.addPostFrameCallback((_) {
            appState.notifyListeners();
          });
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
      return;
    }

    // Create a new message object for the sent message
    Message newMessage = Message(
      content: content,
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

    // Save the updated conversation list to SharedPreferences
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appState.notifyListeners();
    });

    // Send the message over WebSocket to the server
    _sendMessageToServer(receiver, content);
  }

// Helper method to send the message via WebSocket
  void _sendMessageToServer(String receiver, String content) {
    // Check if WebSocket is connected
    if (!_isConnected) {
      return;
    }

    // Prepare the message object in the correct format
    Map<String, dynamic> message = {
      'receiver': receiver,
      'content': content,
      'time': DateTime.now().toIso8601String(),
      'me': true, // Mark message as sent by the current user
    };

    // Send the message as a JSON string to the WebSocket server
    _socket.add(jsonEncode(
        message)); // Assuming `_webSocket` is your WebSocket instance
  }

  void _sendMarkAsReadRequest(String sender) {
    if (!_isConnected) {
      return;
    }

    // Prepare the message for the server
    Map<String, String> messageData = {
      'sender': sender,
      'read': 'true',
    };
    String jsonMessage = jsonEncode(messageData);

    // Send the message over WebSocket
    _socket.add(jsonMessage);
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

  // Fetch token from secure storage
  Future<String?> _getToken() async {
    return await Securestorage().readToken();
  }

  // Close WebSocket connection
  void close() {
    if (_isConnected) {
      _socket.close();
      _isConnected = false;
      print('WebSocket connection closed');
    }
  }
}
