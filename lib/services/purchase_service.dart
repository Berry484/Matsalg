import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mat_salg/my_ip.dart';
import 'dart:async';

import 'package:mat_salg/app_state.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/logging.dart';

class PurchaseService {
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  static const String baseUrl = ApiConstants.baseUrl;

//---------------------------------------------------------------------------------------------------------------
//--------------------Purchases a specific food item-------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<http.Response> kjopMat({
    required int matId,
    required int price,
    required int prisBetalt,
    required int antall,
    required String token,
  }) async {
    try {
      // Base URL for the API
      const String baseUrl = ApiConstants.baseUrl; // Adjust as necessary

      // Create the user data as a Map
      final Map<String, dynamic> userData = {
        "matId": matId,
        "pris": price,
        "prisbetalt": prisBetalt,
        "antall": antall,
      };

      // Convert the Map to JSON
      final String jsonBody = jsonEncode(userData);

      // Prepare URL with encoded parameters
      final uri = Uri.parse('$baseUrl/ordre');

      // Prepare headers
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Add Bearer token if present
      };

      // Send the POST request
      final response = await http.post(
        uri, // Use the updated URI with query parameters
        headers: headers,
        body: jsonBody,
      );
      return response; // Return the response
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Gets all foods you have purchased----------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<List<OrdreInfo>?> getAll(String? token) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request with a timeout of 5 seconds
      final response = await http
          .get(
            Uri.parse(
                '$baseUrl/ordre/alle'), // Adjust the endpoint as necessary
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds

      if (response.statusCode == 200) {
        // Parse the response body
        List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        // Map the dynamic data to OrdreInfo instances
        List<OrdreInfo> kjopOrders = data.map((orderData) {
          // Check for matCopyDetails existence
          if (orderData['matCopyDetails'] == null) {
            throw Exception(
                'Food details not available for order ID: ${orderData['id']}');
          }
          Matvarer foodDetails = Matvarer.fromJson(
              orderData['matCopyDetails']); // Use the new Matvarer.fromJson
          return OrdreInfo(
            id: orderData['id'], // Unique ID of the order
            kjoper: orderData['kjoper'], // Username of the buyer
            selger: orderData['selger'], // Username of the seller
            matId: orderData['matId'], // Corrected to 'matId'
            antall: orderData['antall'],
            pris: orderData['pris'],
            prisBetalt: orderData['prisbetalt'],
            time: DateTime.parse(orderData['time']), // Convert to DateTime
            godkjenttid: orderData['godkjenttid'] != null
                ? DateTime.parse(orderData['godkjenttid'])
                : null,
            updatetime: orderData['updatetime'] != null
                ? DateTime.parse(orderData['updatetime'])
                : null,
            hentet: orderData['hentet'], // Status of whether picked up
            godkjent: orderData['godkjent'], // Approval status
            trekt: orderData['trekt'], // Approval status
            avvist: orderData['avvist'], // Approval status
            kjopte: orderData['kjopte'],
            rated: orderData['rated'],
            lastactive: orderData['user']['lastactive'],
            kjoperProfilePic: orderData['user']['profilepic'] as String?,
            kjoperUsername: orderData['user']['username'] as String?,
            selgerUsername:
                orderData['matCopyDetails']['user']['username'] as String?,

            foodDetails: foodDetails,
          );
        }).toList();

        return kjopOrders; // Return populated OrdreInfo list
      } else {
        return null; // Or throw an error
      }
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Gets all your orders and stores them in the app state--------------------------------------
//---------------------------------------------------------------------------------------------------------------
  Future<void> getAllOrders() async {
    try {
      String? token = await firebaseAuthService.getToken(null);
      if (token == null) {
        return;
      } else {
        List<OrdreInfo>? alleInfo = await PurchaseService.getAll(token);
        if (alleInfo != null && alleInfo.isNotEmpty) {
          FFAppState().ordreInfo = alleInfo;
        }
      }
    } on SocketException {
      logger.d('Exception: Socket exception');
    } catch (e) {
      logger.d('Exception: getAll');
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Sends to the server if the user accepts or rejects the offer-------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<http.Response> svarBud({
    required int id,
    required bool godkjent,
    required String token,
  }) async {
    try {
      // Base URL for the API
      const String baseUrl = ApiConstants.baseUrl; // Adjust as necessary

      // Create the user data as a Map
      final Map<String, dynamic> userData = {
        "id": id,
        "godkjent": godkjent,
      };

      // Convert the Map to JSON
      final String jsonBody = jsonEncode(userData);

      // Prepare URL with encoded parameters
      final uri = Uri.parse('$baseUrl/ordre/update');

      // Prepare headers
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Add Bearer token if present
      };

      // Send the POST request
      final response = await http.post(
        uri, // Use the updated URI with query parameters
        headers: headers,
        body: jsonBody,
      );
      return response; // Return the response
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Tells the server that the user REJECTS the offer-------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<http.Response> avvis({
    required int id,
    required bool avvist,
    required bool godkjent,
    required String token,
  }) async {
    try {
      // Base URL for the API
      const String baseUrl = ApiConstants.baseUrl; // Adjust as necessary

      // Create the user data as a Map
      final Map<String, dynamic> userData = {
        "id": id,
        "avvist": avvist,
        "godkjent": godkjent,
      };

      // Convert the Map to JSON
      final String jsonBody = jsonEncode(userData);

      // Prepare URL with encoded parameters
      final uri = Uri.parse('$baseUrl/ordre/update');

      // Prepare headers
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Add Bearer token if present
      };

      // Send the POST request
      final response = await http.post(
        uri, // Use the updated URI with query parameters
        headers: headers,
        body: jsonBody,
      );
      return response; // Return the response
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Tells the server that the user regrets the offer and cancels it----------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<http.Response> trekk({
    required int id,
    required bool trekt,
    required String token,
  }) async {
    try {
      // Base URL for the API
      const String baseUrl = ApiConstants.baseUrl; // Adjust as necessary

      // Create the user data as a Map
      final Map<String, dynamic> userData = {
        "id": id,
        "trekt": trekt,
      };

      // Convert the Map to JSON
      final String jsonBody = jsonEncode(userData);

      // Prepare URL with encoded parameters
      final uri = Uri.parse('$baseUrl/ordre/update');

      // Prepare headers
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Add Bearer token if present
      };

      // Send the POST request
      final response = await http.post(
        uri, // Use the updated URI with query parameters
        headers: headers,
        body: jsonBody,
      );
      return response; // Return the response
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Tells the server that the user confirms that he has picked up the food---------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<http.Response> hentMat({
    required int id,
    required bool hentet,
    required String token,
  }) async {
    try {
      // Base URL for the API
      const String baseUrl = ApiConstants.baseUrl; // Adjust as necessary

      // Create the user data as a Map
      final Map<String, dynamic> userData = {
        "id": id,
        "hentet": hentet,
      };

      // Convert the Map to JSON
      final String jsonBody = jsonEncode(userData);

      // Prepare URL with encoded parameters
      final uri = Uri.parse('$baseUrl/ordre/update');

      // Prepare headers
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Add Bearer token if present
      };

      // Send the POST request
      final response = await http.post(
        uri, // Use the updated URI with query parameters
        headers: headers,
        body: jsonBody,
      );
      return response; // Return the response
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }

//
}
