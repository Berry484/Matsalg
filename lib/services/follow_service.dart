import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mat_salg/my_ip.dart';
import 'dart:async';
import 'package:mat_salg/models/user_info.dart';

class FollowService {
  static const String baseUrl = ApiConstants.baseUrl;

//---------------------------------------------------------------------------------------------------------------
//--------------------Makes you follow a specific user-----------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<http.Response?> folgbruker(String? token, String? uid) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      // Make the API request and parse the response
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/follow?bruker=$uid'),
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

//---------------------------------------------------------------------------------------------------------------
//--------------------Makes you unfollow a specific user---------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<http.Response?> unfolgBruker(String? token, String? uid) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request and parse the response
      final response = await http
          .delete(
            Uri.parse('$baseUrl/api/unfollow?bruker=$uid'),
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

//---------------------------------------------------------------------------------------------------------------
//--------------------List all the users a user if following using users uid-------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<List<UserInfo>?> listFolger(String? token, String? uid) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request with a timeout of 5 seconds
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/folger/bruker?bruker=$uid'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds

      if (response.statusCode == 200) {
        // Parse the response body
        List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        // Map the dynamic data to UserInfo instances
        List<UserInfo> folgere = data.map((userData) {
          return UserInfo(
            uid: userData['uid'],
            username: userData['username'],
            firstname: userData['firstname'],
            lastname: userData['lastname'],
            profilepic: userData['profilepic'],
            following: userData['following'],
          );
        }).toList();

        return folgere;
      } else {
        return null;
      }
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------List all the users thats following a specific user using the uid---------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<List<UserInfo>?> listFolgere(String? token, String? uid) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request with a timeout of 5 seconds
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/folgere/folger?folger=$uid'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds

      if (response.statusCode == 200) {
        // Parse the response body
        List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        // Map the dynamic data to UserInfo instances
        List<UserInfo> folgere = data.map((userData) {
          return UserInfo(
            uid: userData['uid'],
            username: userData['username'],
            firstname: userData['firstname'],
            lastname: userData['lastname'],
            profilepic: userData['profilepic'],
            following: userData['following'],
          );
        }).toList();

        return folgere; // Return populated UserInfo list
      } else {
        // Handle any other response codes appropriately
        return null; // Or throw an error
      }
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Asks the backend how many users a user is following----------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<String?> tellFolger(String? token, String? uid) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request and parse the response
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/followers/folger?folger=$uid'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds
      if (response.statusCode == 200) {
        String? folger = response.body;
        return folger;
      } else {
        return null;
      }
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Asks the backend how many users a user is being followed by--------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<String?> tellFolgere(String? token, String? uid) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request and parse the response
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/followers/bruker?bruker=$uid'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds
      if (response.statusCode == 200) {
        String? folgere = response.body;
        return folgere;
      } else {
        return null;
      }
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Asks the backend how many users I AM is following------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<String?> tellMineFolger(String? token) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request and parse the response
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/followers/mine/folger'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds
      if (response.statusCode == 200) {
        String? folger = response.body;
        return folger;
      } else {
        return null;
      }
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Asks the backend how many users I AM being followed by-------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<String?> tellMineFolgere(String? token) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request and parse the response
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/followers/mine/bruker'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds
      if (response.statusCode == 200) {
        String? folgere = response.body;
        return folgere;
      } else {
        return null;
      }
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }

//
}
