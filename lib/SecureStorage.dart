import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
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

// Function to read the token from storage, store it in memory, and send an HTTP GET request
  Future<void> readAndStoreTokenInMemory() async {
    try {
      final token =
          await readToken(); // Use the readToken function to get the token
      if (token != null) {
        authToken = token; // Store the token in the global variable
        print('Token stored in memory successfully!');

        // Send an HTTP GET request with the token as a Bearer token, with a timeout
        final response = await http.get(
          Uri.parse('$baseurl/rrh/test_noe'),
          headers: {
            'Authorization': 'Bearer $authToken',
            'Content-Type': 'application/json',
          },
        ).timeout(const Duration(seconds: 5)); // Set a timeout of 5 seconds

        if (response.statusCode == 200) {
          print('Request successful! Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
          validToken = true; // Set global ValidToken to true
        } else {
          print('Request failed! Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
          validToken = false;
        }
      } else {
        print('No token found to store in memory');
        validToken = false;
      }
    } on TimeoutException catch (e) {
      print('Request timed out: $e');
      validToken = false;
    } catch (e) {
      print('Error storing token in memory and making HTTP request: $e');
      validToken = false;
    }
  }
}
