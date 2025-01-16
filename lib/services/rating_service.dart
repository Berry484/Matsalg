import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mat_salg/my_ip.dart';
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
    int matId,
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
                '$baseUrl/api/ratings?receiver=$uid&value=$rating&kjoper=$kjoper&matId=$matId'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 21)); // Timeout after 5 seconds

      return response;
    } on SocketException {
      rethrow;
    } catch (e) {
      rethrow;
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
          .timeout(const Duration(seconds: 21));

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
      rethrow;
    } catch (e) {
      rethrow;
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
          .timeout(const Duration(seconds: 21));
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
      rethrow;
    } catch (e) {
      rethrow;
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
          .timeout(const Duration(seconds: 21));
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
      rethrow;
    } catch (e) {
      rethrow;
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
          .timeout(const Duration(seconds: 21));

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
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Gets back if a user has given a rating to that user----------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<bool?> ratingBeenGiven(
      String? token, String give, String get, int? matId) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Construct the URL with query parameters
      final url = Uri.parse(
          '$baseUrl/api/ratings/exists?give=$give&get=$get&matId=$matId');

      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        // Parse the boolean response body
        return jsonDecode(response.body) as bool;
      } else {
        return false;
      }
    } on SocketException {
      rethrow;
    } on TimeoutException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
//
}
