import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'package:mat_salg/MyIP.dart';

class Securestorage {
// Create an instance of FlutterSecureStorage
  static const FlutterSecureStorage storage = FlutterSecureStorage();

// Global variable to hold the token in memory
  static String? authToken;
  String baseurl = ApiConstants.baseUrl;

// Global variable to hold the validity status of the token
  bool validToken = false; // Default value

// Function to write the token to secure storage
  Future<String?> writeToken(String? token) async {
    try {
      await storage.write(key: 'access_token', value: token);
      authToken = token;
      return token;
    } catch (e) {
      return null;
    }
  }

// Function to read the token from secure storage
  Future<String?> readToken() async {
    try {
      final token = await storage.read(key: 'access_token');
      if (token != null) {
        authToken = token;
        return token;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
