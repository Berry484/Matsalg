import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mat_salg/my_ip.dart';
import 'dart:async';

class PushNotificationService {
  static const String baseUrl = ApiConstants.baseUrl;

//-------------------------------------------------------------------------------------------------------------------------------------------------
//--------------------Tells the backend that this user wants to recive push notifications when a specific user posts-------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------------
  static Future<http.Response?> varslingBruker(
      String? token, String? uid, bool varsling) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      // Make the API request and parse the response
      final response = await http
          .put(
            Uri.parse('$baseUrl/api/varsling?bruker=$uid&varsling=$varsling'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds
      return response;
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }

//-------------------------------------------------------------------------------------------------------------------------------------------------
//--------------------Tells the backend that this user wants push notification when a specific food becomes available after having been sold out---
//-------------------------------------------------------------------------------------------------------------------------------------------------
  static Future<http.Response?> varslingMatTilgjengelig(
      String? token, int matId, bool varsling) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final response = varsling == true
          ? await http
              .post(
                Uri.parse('$baseUrl/api/updates?matId=$matId'),
                headers: headers,
              )
              .timeout(const Duration(seconds: 5))
          : await http
              .delete(
                Uri.parse('$baseUrl/api/updates?matId=$matId'),
                headers: headers,
              )
              .timeout(const Duration(seconds: 5));
      return response;
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }

//
}
