import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mat_salg/models/matvarer.dart';
import 'package:mat_salg/my_ip.dart';
import 'dart:async';

class ApiLike {
  static const String baseUrl = ApiConstants.baseUrl;

//---------------------------------------------------------------------------------------------------------------
//--------------------Sends a like to the backend so it will be written that you liked that specific food--------
//---------------------------------------------------------------------------------------------------------------
  static Future<http.Response?> sendLike(String? token, int? matId) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      // Make the API request and parse the response
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/likes?mat_id=$matId'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 21));
      return response;
    } on SocketException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------DELETES a like to the backend so it will be written that you dont like that food anymore---
//---------------------------------------------------------------------------------------------------------------
  static Future<http.Response?> deleteLike(String? token, int? matId) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request and parse the response
      final response = await http
          .delete(
            Uri.parse('$baseUrl/api/likes?mat_id=$matId'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 21));
      return response;
    } on SocketException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Gets all the food items that you have liked------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<List<Matvarer>?> getAllLikes(String? token) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request and parse the response
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/likes/mine'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 21)); // Timeout after 5 seconds

      // Check if the response is successful (status code 200)
      if (response.statusCode == 200) {
        // Decode the JSON response

        final List<dynamic> jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));
        // Convert the JSON into a list of Matvarer objects
        return Matvarer.matvarerFromSnapShot(jsonResponse);
      } else {
        // Handle unsuccessful response
        return null;
      }
    } on SocketException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Checks if you have liked a specific food listing-------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<bool?> getChecklike(String? token, int? matId) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request and parse the response
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/likes/check?matId=$matId'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 21)); // Timeout after 5 seconds

      if (response.statusCode == 200) {
        // Parse the response body to a boolean value
        final responseBody = response.body.toLowerCase();
        if (responseBody == 'true') {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } on SocketException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

//
}
