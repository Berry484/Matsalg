import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/models/user.dart';
import 'package:mat_salg/models/user_info.dart';
import 'package:mat_salg/models/user_info_search.dart';
import 'package:mat_salg/my_ip.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'dart:async';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:mat_salg/logging.dart';

class UserInfoService {
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  static const String baseUrl = ApiConstants.baseUrl;

//---------------------------------------------------------------------------------------------------------------
//--------------------Creates a user in the postgreSQL backend. NOTE this does NOT create the user in firebase---
//---------------------------------------------------------------------------------------------------------------
  Future<http.Response> createUserInPostgres({
    required String token,
    required String username,
    required String? email,
    required String? phoneNumber,
    required String firstName,
    required String lastName,
    String? bio,
    LatLng? posisjon,
  }) async {
    try {
      // Base URL for the calls
      const String baseUrl = ApiConstants.baseUrl;

      // Create the user data as a Map
      final Map<String, dynamic> userData = {
        "username": username,
        "email": email,
        "firstname": firstName,
        "lastname": lastName,
        "phoneNumber": phoneNumber,
        "lat": posisjon?.latitude.toString(),
        "lng": posisjon?.longitude.toString(),
      };

      final String jsonBody = jsonEncode(userData);
      final uri = Uri.parse('$baseUrl/rrh/brukere/create');

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final response = await http.post(
        uri,
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
//--------------------Retrieves all the information about a sepcific user----------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<http.Response> checkUserInfo(String? token) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Using the timeout method

      final response = await http
          .get(
            Uri.parse('$baseUrl/rrh/brukere/brukerinfo'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 21)); // Set timeout to 5 seconds

      final decodedBody = utf8.decode(response.bodyBytes);
      return http.Response(decodedBody, response.statusCode);
    } on SocketException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Updates the users information like username, firstname etc in the postgreSQL backend-------
//---------------------------------------------------------------------------------------------------------------
  Future<http.Response> updateUserInfo({
    required String? username,
    required String? bio,
    required String? firstname,
    required String? lastname,
    required String? email,
    required bool? termsService,
    String? profilepic,
    String? token,
  }) async {
    try {
      // Create the user info data as a Map
      final Map<String, dynamic> userInfoData = {
        "username": username,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "bio": bio,
        "termsService": termsService
      };

      // Only add profilepic if it's not null
      if (profilepic != null) {
        userInfoData["profilepic"] = profilepic;
      }

      // Convert the Map to JSON
      final String jsonBody = jsonEncode(userInfoData);

      // Prepare headers
      final headers = {
        'Content-Type': 'application/json',
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
    } on SocketException {
      rethrow;
    } catch (e) {
      logger.e('Error updating user information');
      rethrow;
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Updates the users position in the postgreSQL backend---------------------------------------
//---------------------------------------------------------------------------------------------------------------
  Future<http.Response> updatePosisjon({
    String? token,
  }) async {
    try {
      final Map<String, dynamic> userInfoData = {
        "lat": FFAppState().brukerLat,
        "lng": FFAppState().brukerLng,
      };

      // Convert the Map to JSON
      final String jsonBody = jsonEncode(userInfoData);

      // Prepare headers
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      // Send the POST request
      final response = await http.post(
        Uri.parse('$baseUrl/rrh/brukere'),
        headers: headers,
        body: jsonBody,
      );

      return response;
    } on SocketException {
      rethrow;
    } catch (e) {
      logger.e('Error updating user position');
      rethrow;
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Uploads profile picture to postgreSQL backend----------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  Future<String?> uploadProfilePic({
    String? token,
    required Uint8List? fileData, // The file data as nullable Uint8List
    String fileType = 'jpeg', // Default to 'jpeg'
    String? username,
  }) async {
    try {
      // Check if fileData is null
      if (fileData == null) {
        logger.e('FileData was null');
        return null;
      }

      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('$baseUrl/files/rrh/sendbilde'),
        );

        if (token != null) {
          request.headers['Authorization'] = 'Bearer $token';
        }

        // Add file data (Uint8List) to the request
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            fileData,
            contentType:
                MediaType('image', fileType), // Use image/jpeg by default
            filename: 'profilepic.$fileType',
          ),
        );

        // Include the username as a part of the request
        if (username != null) {
          request.fields['username'] = username;
          request.fields['profilbilde'] = 'true';
        }

        // Send the request and wait for the response
        var response = await request.send();

        // Get the response status code
        var responseString = await http.Response.fromStream(response);

        // Check if the status code is 200 (success)
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseJson =
              jsonDecode(responseString.body);
          return responseJson['fileLink']; // Return the file link as a string
        } else {
          return null;
        }
      } catch (e) {
        logger.e('FileData was exception');
        return null;
      }
    } on SocketException {
      rethrow;
    } catch (e) {
      logger.e('FileData was exception');
      rethrow;
    }
  }

//-----------------------------------------------------------------------------------------------------------------------
//--------------------Updates variables about a user wether he has liked any foods etc so I can display empty widgets----
//-----------------------------------------------------------------------------------------------------------------------
  Future<http.Response?> updateUserStats(
      BuildContext context, bool? updateFromListener) async {
    try {
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        logger.e('No token could be fetched');
        throw (Exception);
      } else {
        final headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        };

        // Using the timeout method

        final response = await http
            .get(
              Uri.parse('$baseUrl/rrh/brukere/seBrukerInfo'),
              headers: headers,
            )
            .timeout(const Duration(seconds: 21));

        final jsonResponse = json.decode(response.body);

        FFAppState().liked = jsonResponse['hasLiked'] ?? false;
        FFAppState().lagtUt = jsonResponse['hasPosted'] ?? false;
        if (updateFromListener != true) {
          FFAppState().hasNotification =
              jsonResponse['hasNotification'] ?? false;
          FFAppState().notificationAlert.value =
              jsonResponse['hasUnreadNotification'] ?? false;
        }
        return response;
      }
    } on SocketException {
      logger.e('Socket exception');
      rethrow;
    } catch (e) {
      logger.e('Somethiid unexpected happend updating user stats: $e');
      rethrow;
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Gets the last time a specific user was active----------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<http.Response?> getLastActiveTime(
      String? token, String uid) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http
          .get(
            Uri.parse('$baseUrl/rrh/brukere/seLastActiveTime?username=$uid'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 21));

      if (response.statusCode == 200) {
        return response;
      } else {
        logger.d('Failed to fetch last active time: ${response.statusCode}');
        return null;
      }
    } on SocketException {
      rethrow;
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Gets the User Info from a specific user using the uid--------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<List<User>?> checkUser(String? token, String? uid) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request
      final response = await http
          .get(
            Uri.parse('$baseUrl/rrh/brukere/brukerinfo?username=$uid'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 21)); // Timeout after 5 seconds

      // Check if the response is successful (status code 200)
      if (response.statusCode == 200) {
        // Decode the response body
        final dynamic jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));

        // If the response is not a list, wrap it in a list before passing to fromSnapshot
        if (jsonResponse is Map<String, dynamic>) {
          return User.usersFromSnapshot([jsonResponse]);
        } else if (jsonResponse is List) {
          return User.usersFromSnapshot(jsonResponse);
        }
      }
      if (response.statusCode == 410) {
        throw ('user-deleted');
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
//--------------------Searches for users by a string query and returns a list of up to 20 matches----------------
//---------------------------------------------------------------------------------------------------------------
  static Future<List<UserInfoSearch>?> searchUsers(
      String? token, String? query) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      if (query != null && query.isNotEmpty) {
        final response = await http
            .get(
              Uri.parse('$baseUrl/rrh/brukere/search?query=$query'),
              headers: headers,
            )
            .timeout(const Duration(seconds: 21));
        if (response.statusCode == 200) {
          List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
          List<UserInfoSearch> profiler = data.map((userData) {
            return UserInfoSearch(
              uid: userData['uid'] ?? '',
              username: userData['username'] ?? '',
              firstname: userData['firstname'] ?? '',
              lastname: userData['lastname'] ?? '',
              profilepic: userData['profilepic'] ?? '',
            );
          }).toList();
          return profiler;
        }
      } else {
        return null;
      }
    } on SocketException {
      rethrow;
    } catch (e) {
      rethrow;
    }
    return null;
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Updates information about the user in app states-------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  Future<void> fetchData(BuildContext context) async {
    try {
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return;
      } else {
        final response = await UserInfoService.checkUserInfo(token);
        if (response.statusCode == 200) {
          final decodedResponse = jsonDecode(response.body);
          final userInfo = decodedResponse['userInfo'] ?? {};
          LatLng? location = await getCurrentUserLocation(
              defaultLocation: const LatLng(0.0, 0.0));
          if (location != const LatLng(0.0, 0.0)) {
            FFAppState().brukerLat = location.latitude;
            FFAppState().brukerLng = location.longitude;
          } else {
            FFAppState().brukerLat = userInfo['lat'] ?? 59.9138688;
            FFAppState().brukerLng = userInfo['lng'] ?? 10.7522454;
          }

          FFAppState().brukernavn = userInfo['username'] ?? '';
          FFAppState().email = userInfo['email'] ?? '';
          FFAppState().firstname = userInfo['firstname'] ?? '';
          FFAppState().lastname = userInfo['lastname'] ?? '';
          FFAppState().bio = userInfo['bio'] ?? '';
          FFAppState().profilepic = userInfo['profilepic'] ?? '';
          FFAppState().followersCount = decodedResponse['followersCount'] ?? 0;
          FFAppState().followingCount = decodedResponse['followingCount'] ?? 0;
          FFAppState().ratingTotalCount =
              decodedResponse['ratingTotalCount'] ?? 0;
          FFAppState().ratingAverageValue =
              decodedResponse['ratingAverageValue'] ?? 5.0;
          if (!context.mounted) return;

          updateUserStats(context, true);
        }
        if (response.statusCode == 401) {
          FFAppState().login = false;
          if (!context.mounted) return;
          context.goNamed('registrer');
          return;
        }
      }
    } on SocketException {
      if (!context.mounted) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      logger.d('En feil oppstod, $e');
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Deletes the current user and returns the response object-----------------------------------
//---------------------------------------------------------------------------------------------------------------
  Future<http.Response?> deleteUser(
      BuildContext context, String username) async {
    try {
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        throw Exception('No token available');
      }

      // The backend API endpoint for deleting the user
      final response = await http.delete(
        Uri.parse('$baseUrl/rrh/brukere/delete?username=$username'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 21));

      return response;
    } on SocketException {
      if (!context.mounted) return null;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      if (!context.mounted) return null;
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
    return null;
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Lists blocked users------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<List<UserInfo>?> listBlocked(String? token) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request with a timeout of 5 seconds
      final response = await http
          .get(
            Uri.parse('$baseUrl/block/user'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 21)); // Timeout after 5 seconds

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
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------blocks or unblocks a user------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<http.Response?> blockUpdate(
      String? token, String? get, bool delete) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      // Make the API request and parse the response
      final response = await http
          .post(
            Uri.parse('$baseUrl/block/user?get=$get&delete=$delete'),
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

//
}
