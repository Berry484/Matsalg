import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:mat_salg/MyIP.dart';
import 'package:mat_salg/flutter_flow/flutter_flow_util.dart';

class ApiCalls {
  static const String baseUrl = ApiConstants.baseUrl; // Your base URL

  // Define the method to check if the email is taken
  Future<http.Response> checkEmailTaken(String email) async {
    final response =
        await http.get(Uri.parse('$baseUrl/rrh/epostledig?email=$email'));
    return response; // Return the response
  }

  Future<http.Response> checkUsernameTaken(String username) async {
    final response = await http
        .get(Uri.parse('$baseUrl/rrh/usernameledig?username=$username'));
    return response; // Return the response
  }

  Future<http.Response> checkPhoneTaken(String phoneNumber) async {
    final response = await http
        .get(Uri.parse('$baseUrl/rrh/check-phone?phoneNumber=$phoneNumber'));
    print(response.body);
    return response; // Return the response
  }

  //----Opprett bruker i keycloak---------------
  // Define the method to create a user
  Future<http.Response> createUser({
    required String username,
    required String? email,
    required String? password,
    required String? phoneNumber,
    required String firstName,
    required String lastName,
  }) async {
    // Create the user data as a Map
    final Map<String, dynamic> userData = {
      "username": username,
      "email": email,
      "emailVerified": true,
      "firstName": firstName,
      "lastName": lastName,
      "enabled": true,
      "attributes": {
        "phoneNumber": [phoneNumber] // Custom attributes as a list
      },
      "credentials": [
        {"type": "password", "value": password, "temporary": false}
      ]
    };

    // Convert the Map to JSON
    final String jsonBody = jsonEncode(userData);

    // Send the POST request
    final response = await http.post(
      Uri.parse(
          '$baseUrl/rrh/bruker/opprett'), // Adjust the endpoint as necessary
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );

    return response; // Return the response
  }
}

class ApiUserSQL {
  // ----Create or Update User Info Method---------------
  // Method to create or update user information in the UserInfoController

  static const String baseUrl = ApiConstants.baseUrl; // Your base URL

  Future<http.Response> createOrUpdateUserInfo({
    required String username,
    required String bio,
    required LatLng posisjon,
    String? token, // Add token parameter
  }) async {
    // Create the user info data as a Map
    final Map<String, dynamic> userInfoData = {
      "username": username,
      "bio": bio,
      "lat": posisjon.latitude,
      "lng": posisjon.longitude
    };

    // Convert the Map to JSON
    final String jsonBody = jsonEncode(userInfoData);

    // Prepare headers
    final headers = {
      'Content-Type': 'application/json',
      if (token != null)
        'Authorization': 'Bearer $token', // Add Bearer token if present
    };

    // Send the POST request
    final response = await http.post(
      Uri.parse(
          '$baseUrl/rrh/brukere'), // Endpoint for creating or updating user info
      headers: headers,
      body: jsonBody,
    );

    return response; // Return the response
  }
}

class ApiGetToken {
  // ----Create or Update User Info Method---------------
  // Method to create or update user information in the UserInfoController

  static const String baseUrl = ApiConstants.baseUrl; // Your base URL

  Future<String?> getAuthToken({
    String? username,
    required String? password,
    String? phoneNumber,
  }) async {
    // Create the user info data as a Map
    final Map<String, dynamic> userInfoData = {
      "username": username,
      "phoneNumber": phoneNumber,
      "password": password,
    };
    // Convert the Map to JSON
    final String jsonBody = jsonEncode(userInfoData);

    // Send the POST request
    final response = await http.post(
      Uri.parse(
          '$baseUrl/rrh/get-token'), // Endpoint for creating or updating user info
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );

    // Check if the response was successful
    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // Extract the access token
      String? accessToken = jsonResponse['access_token'];
      return accessToken; // Return the access token
    } else {
      // Handle the error
      print('Request failed with status: ${response.statusCode}.');
      print(response.body);
      print(username);
      print(password);
      print(phoneNumber);
      return null; // Return null if there's an error
    }
  }
}
