// import 'dart:convert';
// import 'package:mat_salg/MyIP.dart';
// import 'package:mat_salg/SecureStorage.dart';
// import 'dart:io';

// import 'package:mat_salg/flutter_flow/flutter_flow_util.dart';

// class WebSocketService {
//   late WebSocket _socket;
//   bool _isConnected = false;
//   static const String url = ApiConstants.baseSocketUrl;

//   WebSocketService();

//   Future<void> connect() async {
//     if (_isConnected) {
//       print("Already connected. Skipping connection.");
//       return;
//     }

//     try {
//       String? token = await _getToken();

//       if (token == null) {
//         print('Token is null, cannot connect');
//         return;
//       }

//       print('Connecting to WebSocket server: $url');

//       _socket = await WebSocket.connect(
//         url,
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//       );

//       _isConnected = true;

//       _socket.listen(
//         (message) {
//           _onMessageReceived(message); // Handle message internally
//         },
//         onError: (error) {
//           print('WebSocket error: $error');
//         },
//         onDone: () {
//           print('WebSocket connection closed');
//           _isConnected = false;
//         },
//       );
//     } catch (e) {
//       print('Error during WebSocket connection: $e');
//     }
//   }

//   // Method to handle incoming messages and parse them
//   void _onMessageReceived(dynamic message) {
//     try {
//       var data = jsonDecode(message); // Assuming message is JSON string.

//       // Check if the response contains 'conversations' key
//       if (data is Map && data['conversations'] != null) {
//         var conversationsList = data['conversations'] as List<dynamic>;

//         // Access FFAppState to update the conversations globally
//         final appState = FFAppState();

//         // Clear previous conversations in FFAppState
//         appState.conversations.clear();

//         // Parse and add new conversations to FFAppState
//         for (var conversationJson in conversationsList) {
//           var conv = Conversation.fromJson(conversationJson);
//           appState.conversations.add(conv);
//         }

//         // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
//         appState.notifyListeners();
//         print(message);
//       }
//     } catch (e) {
//       print('Error parsing message: $e');
//     }
//   }

//   Future<String?> _getToken() async {
//     return await Securestorage().readToken();
//   }

//   void close() {
//     if (_isConnected) {
//       _socket.close();
//       _isConnected = false;
//       print('WebSocket connection closed');
//     }
//   }
// }

import 'dart:convert';
import 'package:mat_salg/MyIP.dart';
import 'package:mat_salg/SecureStorage.dart';
import 'dart:io';

import 'package:mat_salg/flutter_flow/flutter_flow_util.dart';

class WebSocketService {
  late WebSocket _socket;
  bool _isConnected = false;
  bool _isFirstMessage = true; // Flag to handle the first message differently
  static const String url = ApiConstants.baseSocketUrl;

  WebSocketService();

  // Method to connect to the WebSocket
  Future<void> connect() async {
    if (_isConnected) {
      print("Already connected. Skipping connection.");
      return;
    }

    try {
      String? token = await _getToken();

      if (token == null) {
        print('Token is null, cannot connect');
        return;
      }

      print('Connecting to WebSocket server: $url');

      _socket = await WebSocket.connect(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      _isConnected = true;

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
          _isConnected = false;
        },
      );
    } catch (e) {
      print('Error during WebSocket connection: $e');
    }
  }

  // Handle incoming messages
  void _onMessageReceived(dynamic message) {
    try {
      var data = jsonDecode(message);

      // Check if data is a Map (assumes the message is in JSON format)
      if (data is Map) {
        String sender = data['sender'] ?? ''; // The sender of the message
        String content = data['content'] ?? ''; // The content of the message
        String time =
            data['time'] ?? DateTime.now().toIso8601String(); // Timestamp
        bool me = data['me'] ??
            false; // Flag indicating if the message was sent by the current user

        // Log incoming message details
        print("Received WebSocket message:");

        // Create a new Message object
        Message newMessage = Message(
          content: content,
          time: time,
          read: false, // Assuming the message is unread initially
          me: me,
        );

        // Access FFAppState to update the conversations globally
        final appState = FFAppState();

        // Log the current conversations in appState before update
        print("Current conversations before update:");
        appState.conversations.forEach((conv) {
          print("Conversation with ${conv.user}:");
          conv.messages.forEach((msg) {
            print("  - ${msg.content} at ${msg.time}, read: ${msg.read}");
          });
        });

        // If this is the first message received after connection
        if (_isFirstMessage) {
          try {
            var data = jsonDecode(message); // Assuming message is JSON string.

            // Check if the response contains 'conversations' key
            if (data is Map && data['conversations'] != null) {
              var conversationsList = data['conversations'] as List<dynamic>;

              // Access FFAppState to update the conversations globally
              final appState = FFAppState();

              // Clear previous conversations in FFAppState
              appState.conversations.clear();

              // Parse and add new conversations to FFAppState
              for (var conversationJson in conversationsList) {
                var conv = Conversation.fromJson(conversationJson);
                appState.conversations.add(conv);
              }

              // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
              appState.notifyListeners();
              print(message);
            }
          } catch (e) {
            print('Error parsing message: $e');
          }
          _isFirstMessage = false;
        } else {
          // Normal message handling for new incoming messages
          var conversation = appState.conversations
              .where((conv) => conv.user == sender)
              .toList()
              .firstWhere(
                (conv) => conv.user == sender,
                orElse: () => Conversation(
                  user: sender,
                  profilePic:
                      '', // Default profile picture (or use a placeholder)
                  messages: [
                    newMessage
                  ], // Start the conversation with the new message
                ),
              );

          // Add the new message at the beginning (not the end) of the conversation
          conversation.messages.insert(0, newMessage);

          // Add the conversation to the app state if it's new
          if (!appState.conversations.contains(conversation)) {
            appState.conversations.add(conversation);
          }

          conversation.messages.forEach((msg) {});

          // Notify listeners to update the UI
          appState.notifyListeners();
          print("Notified listeners to update the UI");
        }
      }
    } catch (e) {
      print('Error parsing message: $e');
    }
  }

  // Fetch the token to use for authorization in the WebSocket connection
  Future<String?> _getToken() async {
    return await Securestorage().readToken();
  }

  // Close the WebSocket connection
  void close() {
    if (_isConnected) {
      _socket.close();
      _isConnected = false;
      print('WebSocket connection closed');
    }
  }
}
