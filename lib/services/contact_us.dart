import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mat_salg/my_ip.dart';
import 'dart:async';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_util.dart';

class ContactUs {
  static const String baseUrl = ApiConstants.baseUrl;

//---------------------------------------------------------------------------------------------------------------
//--------------------Makes a report about a user and sends it to me---------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  Future<http.Response> reportUser({
    required String? token,
    required String to,
    required String description,
    required int? matId,
  }) async {
    try {
      // Create the user info data as a Map
      final Map<String, dynamic> userInfoData = {
        "to": to,
        "description": description,
        "matId": matId,
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
            '$baseUrl/api/reportUser'), // Endpoint for creating or updating user info
        headers: headers,
        body: jsonBody,
      );
      return response;
    } on SocketException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Allows the user to contact me and gives me their email so I can contact back---------------
//---------------------------------------------------------------------------------------------------------------
  Future<http.Response> contactUs({
    required String? token,
    required String description,
    required String email,
  }) async {
    try {
      // Create the user info data as a Map
      final Map<String, dynamic> userInfoData = {
        "description": description,
        "email": email,
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
            '$baseUrl/api/reportUser/contact'), // Endpoint for creating or updating user info
        headers: headers,
        body: jsonBody,
      );
      return response;
    } on SocketException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
