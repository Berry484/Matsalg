import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mat_salg/MyIP.dart';
import 'dart:async';
import 'package:mat_salg/models/user_info_rating.dart';
import 'package:mat_salg/models/user_info_stats.dart';

class RatingService {
  static const String baseUrl = ApiConstants.baseUrl;

//---------------------------------------------------------------------------------------------------------------
//--------------------Sends a rating about a user to the backend-------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<http.Response?> giRating(
    String? token,
    String? uid,
    int rating,
    bool kjoper,
  ) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request and parse the response
      final response = await http
          .post(
            Uri.parse(
                '$baseUrl/api/ratings?receiver=$uid&value=$rating&kjoper=$kjoper'),
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
//--------------------Sends a rating from the seller to the buyer------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<http.Response> giveRating({
    required int id,
    required String token,
  }) async {
    try {
      // Base URL for the API
      const String baseUrl = ApiConstants.baseUrl; // Adjust as necessary

      // Create the user data as a Map
      final Map<String, dynamic> userData = {
        "id": id,
        "rated": true,
      };

      // Convert the Map to JSON
      final String jsonBody = jsonEncode(userData);

      // Prepare URL with encoded parameters
      final uri = Uri.parse('$baseUrl/ordre/updaterated');

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
//--------------------Gets back a list of the ratings from a specific user---------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<List<UserInfoRating>?> listRatings(
      String? token, String? uid) async {
    try {
      // Validate token and username
      if (token == null || uid == null || uid.isEmpty) {
        return null; // Early return for invalid inputs
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request with a timeout of 5 seconds
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/ratings/$uid'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        // Parse the response body
        List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        if (data.isEmpty) {
          return []; // Return an empty list if no ratings are found
        }

        List<UserInfoRating> ratings = data.map((userData) {
          // Ensure all keys are present and valid
          String username = userData['giverUsername'] ?? 'Unknown';
          String? profilepic = userData['giverProfilePic'];
          int value = userData['value'] ?? 0;
          bool kjoper = userData['kjoper'] ?? false;
          DateTime time = DateTime.tryParse(userData['time']) ?? DateTime.now();

          return UserInfoRating(
            username: username,
            profilepic: profilepic,
            value: value,
            kjoper: kjoper,
            time: time,
          );
        }).toList();

        return ratings;
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
//--------------------Gets back a list of your OWN ratings-------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<List<UserInfoRating>?> listMineRatings(String? token) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      // Make the API request with a timeout of 5 seconds
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/ratings/mine'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        if (data.isEmpty) {
          return [];
        }

        List<UserInfoRating> ratings = data.map((userData) {
          String username = userData['giverUsername'] ?? '';
          String? profilepic = userData['giverProfilePic'];
          int value = userData['value'] ?? 0;
          bool kjoper = userData['kjoper'] ?? false;
          DateTime time = DateTime.tryParse(userData['time']) ?? DateTime.now();

          return UserInfoRating(
            username: username,
            profilepic: profilepic,
            value: value,
            kjoper: kjoper,
            time: time,
          );
        }).toList();

        return ratings;
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
//--------------------Gets back a summary of ratings stats about a specific user---------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<UserInfoStats?> ratingSummary(
      String? token, String? uid) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request with a timeout of 5 seconds
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/ratings/summary/$uid'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        Map<String, dynamic> userData =
            jsonDecode(utf8.decode(response.bodyBytes));
        return UserInfoStats(
          totalCount: userData['totalCount'] ?? 0,
          averageValue: (userData['averageValue'] as num?)?.toDouble(),
        );
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
//--------------------Gets back a summary of ratings stats about yourself----------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<UserInfoStats?> mineRatingSummary(String? token) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request with a timeout of 5 seconds
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/ratings/summary/mine'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        Map<String, dynamic> userData =
            jsonDecode(utf8.decode(response.bodyBytes));

        return UserInfoStats(
          totalCount: userData['totalCount'] ?? 0,
          averageValue: (userData['averageValue'] as num?)?.toDouble() ?? 0,
        );
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
