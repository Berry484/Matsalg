import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mat_salg/User.dart';
import 'package:mat_salg/MyIP.dart';
import 'dart:async'; // Import this to use Future and TimeoutException
import 'package:mat_salg/flutter_flow/flutter_flow_util.dart';
import 'package:http_parser/http_parser.dart';

class ApiCalls {
  static const String baseUrl = ApiConstants.baseUrl;

  // Define the method to check if the email is taken
  Future<http.Response> checkEmailTaken(String email) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/rrh/epostledig?email=$email'));
      return response; // Return the response
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }

//----------------------------------------------------------------------------------------------
  Future<http.Response> checkUsernameTaken(String username) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/rrh/usernameledig?username=$username'));
      return response; // Return the response
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }

//----------------------------------------------------------------------------------------------
  Future<http.Response> checkPhoneTaken(String phoneNumber) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/rrh/check-phone?phoneNumber=$phoneNumber'));

      return response; // Return the response
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }

//----------------------------------------------------------------------------------------------
  Future<http.Response> checkUserInfo(String? token) async {
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
          .timeout(const Duration(seconds: 5)); // Set timeout to 5 seconds

      final decodedBody = utf8.decode(response.bodyBytes);
      return http.Response(decodedBody, response.statusCode);
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }

  Future<http.Response?> updateUserStats(String? token) async {
    try {
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
          .timeout(const Duration(seconds: 5)); // Set timeout to 5 seconds

      final jsonResponse = json.decode(response.body);

      FFAppState().liked = jsonResponse['hasLiked'] ?? false;
      FFAppState().lagtUt = jsonResponse['hasPosted'] ?? false;
      FFAppState().harKjopt = jsonResponse['hasBought'] ?? false;
      FFAppState().harSolgt = jsonResponse['hasSold'] ?? false;

      return response;
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }

  Future<String> getKommune(String? token) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      if (FFAppState().brukerLat == 59.9138688 &&
          FFAppState().brukerLng == 10.7522454) {
        return 'Norge';
      }
      final response = await http
          .get(
            Uri.parse(
                'https://ws.geonorge.no/adresser/v1/punktsok?lat=${FFAppState().brukerLat}&lon=${FFAppState().brukerLng}&radius=9999999999999&treffPerSide=1&side=1'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Set timeout to 5 seconds

      if (response.statusCode == 200) {
        // Parse the JSON response
        final jsonResponse = json.decode(response.body);

        // Extract the first "adresser" element and get the "kommunenavn"
        final kommunenavn = jsonResponse['adresser'][0]['poststed'];

        return kommunenavn ?? 'Norge';
      } else {
        return 'Norge';
      }
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }

  Future<String> leggutgetKommune(
      String? token, double brukerLat, double brukerLng) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http
          .get(
            Uri.parse(
                'https://ws.geonorge.no/adresser/v1/punktsok?lat=${brukerLat}&lon=${brukerLng}&radius=9999999999999&treffPerSide=1&side=1'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Set timeout to 5 seconds

      if (response.statusCode == 200) {
        // Parse the JSON response
        final jsonResponse = json.decode(response.body);

        // Extract the first "adresser" element and get the "kommunenavn"
        final kommunenavn = jsonResponse['adresser'][0]['poststed'];
        return kommunenavn ?? 'Norge';
      } else {
        return 'Norge';
      }
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }
}

//----------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------
class RegisterUser {
  Future<http.Response> createUser1({
    required String username,
    required String? email,
    required String? password,
    required String? phoneNumber,
    required String firstName,
    required String lastName,
    String? bio,
    LatLng? posisjon,
  }) async {
    try {
      // Base URL for the API
      const String baseUrl = ApiConstants.baseUrl; // Adjust as necessary

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

      // Prepare URL with encoded parameters
      final uri =
          Uri.parse('$baseUrl/rrh/bruker/opprett').replace(queryParameters: {
        'bio': bio,
        'lat': posisjon?.latitude.toString(),
        'lng': posisjon?.longitude.toString(),
      });

      // Send the POST request
      final response = await http.post(
        uri, // Use the updated URI with query parameters
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );

      return response; // Return the response
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }
}

class ApiUserSQL {
  // ----Create or Update User Info Method---------------
  // Method to create or update user information in the UserInfoController

  static const String baseUrl = ApiConstants.baseUrl; // Your base URL

  Future<http.Response> createOrUpdateUserInfo({
    required String username,
    required String bio,
    String? profilepic,
    required LatLng posisjon,
    String? token, // Add token parameter
  }) async {
    try {
      // Create the user info data as a Map
      final Map<String, dynamic> userInfoData = {
        "username": username,
        "bio": bio,
        "profilepic": profilepic,
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
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }

  Future<http.Response> updateUserInfo({
    required String? username,
    required String? bio,
    required String? firstname,
    required String? lastname,
    required String? email,
    String? profilepic,
    String? token,
  }) async {
    // Create the user info data as a Map
    final Map<String, dynamic> userInfoData = {
      "firstname": firstname,
      "lastname": lastname,
      "email": email,
      "bio": bio,
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
  }

  Future<http.Response> updatePosisjon({
    String? token, // Add token parameter
  }) async {
    // Create the user info data as a Map
    final Map<String, dynamic> userInfoData = {
      "lat": FFAppState().brukerLat,
      "lng": FFAppState().brukerLng,
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
  // Method to getAuthToken

  static const String baseUrl = ApiConstants.baseUrl; // Your base URL

  Future<String?> getAuthToken({
    required String? username,
    required String? password,
    required String? phoneNumber,
  }) async {
    try {
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
        return null; // Return null if there's an error
      }
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }
}

class ApiUploadProfilePic {
  static const String baseUrl = ApiConstants.baseUrl; // Your base URL

  Future<String?> uploadProfilePic({
    String? token,
    required Uint8List? fileData, // The file data as nullable Uint8List
    String fileType = 'jpeg', // Default to 'jpeg', can be changed as needed
    String? username,
  }) async {
    try {
      // Check if fileData is null
      if (fileData == null) {
        return null; // Handle the error as needed
      }

      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('$baseUrl/files/rrh/sendbilde'),
        );

        // If token is needed for authorization
        if (token != null) {
          request.headers['Authorization'] = 'Bearer $token';
        }

        // Add file data (Uint8List) to the request
        request.files.add(
          http.MultipartFile.fromBytes(
            'file', // Key should match the server's expected form-data key
            fileData,
            contentType:
                MediaType('image', fileType), // Use image/jpeg by default
            filename:
                'profilepic.$fileType', // Use a filename with the .jpeg extension
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
          return null; // Or handle the error as needed
        }
      } catch (e) {
        return null; // Handle exceptions as needed
      }
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }
}

class ApiUploadFood {
  // ----Upload food---------------

  static const String baseUrl = ApiConstants.baseUrl; // Your base URL

  Future<http.Response> uploadfood({
    required String? token,
    required String name,
    required var imgUrl,
    required String description,
    required int? price,
    required String? kategorier,
    required LatLng? posisjon,
    required bool? betaling,
    required bool kg,
    required int? antall,
  }) async {
    try {
      // Create the user info data as a Map
      final Map<String, dynamic> userInfoData = {
        "name": name,
        "imgUrl": imgUrl,
        "description": description,
        "price": price,
        "kategorier": [kategorier],
        "lat": posisjon?.latitude,
        "lng": posisjon?.longitude,
        "betaling": betaling,
        "antall": antall,
        "kjopt": false,
        "slettet": false,
        "kg": kg,
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
            '$baseUrl/rrh/send/matvarer'), // Endpoint for creating or updating user info
        headers: headers,
        body: jsonBody,
      );
      return response;
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }
}

class ApiMultiplePics {
  static const String baseUrl = ApiConstants.baseUrl; // Your base URL

  Future<List<String>?> uploadPictures({
    required String? token, // Required token parameter
    required List<Uint8List?> filesData, // Accept a list of Uint8List
    String fileType = 'jpeg', // Default to 'jpeg', can be changed as needed
  }) async {
    try {
      // Check if filesData is empty
      if (filesData.isEmpty) {
        return null; // Handle the error as needed
      }

      // Create a multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/files/rrh/flere_bilder'),
      );

      // If token is needed for authorization, add it to the request headers
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Iterate over each file and add it to the request under the key "files"
      for (int i = 0; i < filesData.length; i++) {
        if (filesData[i] != null) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'files', // Key must match the one expected by the server
              filesData[i]!,
              contentType: MediaType(
                  'image', fileType), // Default content type to image/jpeg
              filename:
                  'file_$i.$fileType', // Create a unique filename for each file
            ),
          );
        } else {}
      }

      // Send the request and wait for the response
      var response = await request.send();

      // Get the response body as a string
      var responseString = await http.Response.fromStream(response);
      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the response body as a List<dynamic>
        List<dynamic> responseJson = jsonDecode(responseString.body);

        // Extract 'fileLink' from each object in the list
        List<String> fileLinks = responseJson.map((file) {
          return file['fileLink'] as String;
        }).toList();
        return fileLinks; // Return the list of file links
      } else {
        return null; // Or handle the error as needed
      }
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }
}

class ApiGetAllFoods {
  static const String baseUrl = ApiConstants.baseUrl;

  static Future<List<Matvarer>?> getAllFoods(String? token) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request and parse the response
      final response = await http
          .get(
            Uri.parse(
                '$baseUrl/rrh/send/matvarer?userLat=${FFAppState().brukerLat}&userLng=${FFAppState().brukerLng}'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds

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
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }
}

class ApiGetMyFoods {
  static const String baseUrl = ApiConstants.baseUrl;

  static Future<List<Matvarer>?> getMyFoods(String? token) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request and parse the response
      final response = await http
          .get(
            Uri.parse(
                '$baseUrl/rrh/send/matvarer/mine?userLat=${FFAppState().brukerLat}&userLng=${FFAppState().brukerLng}'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds

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
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }
}

class ApiGetBonder {
  static const String baseUrl = ApiConstants.baseUrl;

  static Future<List<User>?> getAllBonder(String? token) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request
      final response = await http
          .get(
            Uri.parse('$baseUrl/rrh/brukere/bonde'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds

      // Check if the response is successful (status code 200)
      if (response.statusCode == 200) {
        // Decode the response body as UTF-8 to handle special characters like "å"
        final List<dynamic> jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));

        // Convert the JSON into a list of Bonder objects
        return User.usersFromSnapshot(jsonResponse);
      } else {
        // Handle unsuccessful response
        return null;
      }
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }
}

class ApiGetUser {
  static const String baseUrl = ApiConstants.baseUrl;

  static Future<List<User>?> checkUser(String? token, String? username) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request
      final response = await http
          .get(
            Uri.parse('$baseUrl/rrh/brukere/brukerinfo?username=$username'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds

      // Check if the response is successful (status code 200)
      if (response.statusCode == 200) {
        // Decode the response body
        final dynamic jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));

        // If the response is not a list, wrap it in a list before passing to fromSnapshot
        if (jsonResponse is Map<String, dynamic>) {
          return User.usersFromSnapshot(
              [jsonResponse]); // Wrap single object in a list
        } else if (jsonResponse is List) {
          return User.usersFromSnapshot(
              jsonResponse); // If it's already a list, pass it directly
        }
      } else {
        // Handle unsuccessful response
        return null;
      }
      return null;
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }
}

class ApiGetUserFood {
  static const String baseUrl = ApiConstants.baseUrl;

  static Future<List<Matvarer>?> getUserFood(
      String? token, String? username) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request and parse the response
      final response = await http
          .get(
            Uri.parse('$baseUrl/rrh/send/matvarer/mine?username=${username}'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds

      // Check if the response is successful (status code 200)
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));
        // Convert the JSON into a list of Matvarer objects
        return Matvarer.matvarerFromSnapShot(jsonResponse);
      } else {
        // Handle unsuccessful response
        return null;
      }
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }
}

class ApiLike {
  static const String baseUrl = ApiConstants.baseUrl;

  Future<http.Response?> sendLike(String? token, int? matId) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      // Make the API request and parse the response
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/likes?mat_id=${matId}'),
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

  Future<http.Response?> deleteLike(String? token, int? matId) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request and parse the response
      final response = await http
          .delete(
            Uri.parse('$baseUrl/api/likes?mat_id=${matId}'),
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
}

class ApiGetAllLikes {
  static const String baseUrl = ApiConstants.baseUrl;

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
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds

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
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }
}

class ApiCheckLiked {
  static const String baseUrl = ApiConstants.baseUrl;

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
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds

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
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }
}

class ApiFolg {
  static const String baseUrl = ApiConstants.baseUrl;

  Future<http.Response?> folgbruker(String? token, String? brukernavn) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      // Make the API request and parse the response
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/follow?bruker=$brukernavn'),
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

  Future<http.Response?> varslingBruker(
      String? token, String? brukernavn, bool varsling) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      // Make the API request and parse the response
      final response = await http
          .put(
            Uri.parse(
                '$baseUrl/api/varsling?bruker=${brukernavn}&varsling=${varsling}'),
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

  Future<http.Response?> varslingMatTilgjengelig(
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

  Future<http.Response?> unfolgBruker(String? token, String? brukernavn) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request and parse the response
      final response = await http
          .delete(
            Uri.parse('$baseUrl/api/unfollow?bruker=$brukernavn'),
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

  static Future<String?> tellFolger(String? token, String? brukernavn) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request and parse the response
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/followers/folger?folger=$brukernavn'),
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

  static Future<String?> tellFolgere(String? token, String? brukernavn) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request and parse the response
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/followers/bruker?bruker=$brukernavn'),
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

  static Future<List<UserInfo>?> listFolgere(
      String? token, String? username) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request with a timeout of 5 seconds
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/folgere/folger?folger=$username'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds

      if (response.statusCode == 200) {
        // Parse the response body
        List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        // Map the dynamic data to UserInfo instances
        List<UserInfo> folgere = data.map((userData) {
          return UserInfo(
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

  static Future<List<UserInfo>?> listFolger(
      String? token, String? username) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request with a timeout of 5 seconds
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/folger/bruker?bruker=$username'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds

      if (response.statusCode == 200) {
        // Parse the response body
        List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        // Map the dynamic data to UserInfo instances
        List<UserInfo> folgere = data.map((userData) {
          return UserInfo(
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
}

class UserInfo {
  final String username;
  final String firstname;
  final String lastname;
  final String profilepic;
  bool following;

  UserInfo({
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.profilepic,
    required this.following,
  });
}

class ApiKjop {
  static const String baseUrl = ApiConstants.baseUrl;

  Future<http.Response> kjopMat({
    required int matId,
    required int price,
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
            // Parse antall and ensure it has exactly 2 decimal places
            antall: orderData['antall'],

            // Parse pris and ensure it has exactly 2 decimal places
            pris: orderData['pris'],
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

            kjoperProfilePic: orderData['user']['profilepic'] as String?,
            foodDetails: foodDetails, // Pass the Matvarer instance here
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

  Future<http.Response> svarBud({
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

  Future<http.Response> hentMat({
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

  Future<http.Response> avvis({
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

  Future<http.Response> trekk({
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

  Future<http.Response> giveRating({
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
}

class ApiGetFilterFood {
  static const String baseUrl = ApiConstants.baseUrl;

  static Future<List<Matvarer>?> getFilterFood(
      String? token, String? kategorier) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http
          .get(
            Uri.parse(
                '$baseUrl/rrh/send/matvarer/filter?kategorier=$kategorier&userLat=${FFAppState().brukerLat}&userLng=${FFAppState().brukerLng}'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds
      // Check if the response is successful (status code 200)
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));
        // Convert the JSON into a list of Matvarer objects
        return Matvarer.matvarerFromSnapShot(jsonResponse);
      } else {
        // Handle unsuccessful response
        return null;
      }
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }

  static Future<List<Matvarer>?> getBondeFood(String? token) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request and parse the response
      final response = await http
          .get(
            Uri.parse(
                '$baseUrl/rrh/send/matvarer/bonde?userLat=${FFAppState().brukerLat}&userLng=${FFAppState().brukerLng}'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds
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
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }

  static Future<List<Matvarer>?> getFolgerFood(String? token) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request and parse the response
      final response = await http
          .get(
            Uri.parse(
                '$baseUrl/rrh/send/matvarer/folger?userLat=${FFAppState().brukerLat}&userLng=${FFAppState().brukerLng}'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds
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
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }
}

class ApiUpdateFood {
  static const String baseUrl = ApiConstants.baseUrl; // Your base URL

  Future<http.Response> slettMatvare({
    required int? id,
    String? token, // Add token parameter
  }) async {
    try {
      final Map<String, dynamic> requestBody = {"slettet": true};

      // Convert the Map to JSON
      final String jsonBody = jsonEncode(requestBody);

      // Prepare headers
      final headers = {
        'Content-Type': 'application/json',
        if (token != null)
          'Authorization': 'Bearer $token', // Add Bearer token if present
      };

      final response = await http.put(
        Uri.parse(
            '$baseUrl/rrh/send/matvarer/$id'), // Endpoint for updating user info
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

  Future<http.Response> merkSolgt({
    required int? id,
    required bool solgt,
    String? token, // Add token parameter
  }) async {
    try {
      final Map<String, dynamic> requestBody = {"kjopt": solgt, "antall": 0};

      // Convert the Map to JSON
      final String jsonBody = jsonEncode(requestBody);

      // Prepare headers
      final headers = {
        'Content-Type': 'application/json',
        if (token != null)
          'Authorization': 'Bearer $token', // Add Bearer token if present
      };

      final response = await http.put(
        Uri.parse(
            '$baseUrl/rrh/send/matvarer/$id'), // Endpoint for updating user info
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

  Future<http.Response> updateFood({
    String? token,
    required int? id,
    String? name,
    var imgUrl,
    String? description,
    String? price,
    String? kategorier,
    LatLng? posisjon,
    bool? betaling,
    bool? kg,
    int? antall,
    bool? kjopt,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {
        "name": name,
        "imgUrl": imgUrl,
        "description": description,
        "price": price,
        "kategorier": [kategorier],
        "lat": posisjon?.latitude,
        "lng": posisjon?.longitude,
        "betaling": betaling,
        "antall": antall,
        "kjopt": kjopt,
        "slettet": false,
        "kg": kg,
      };

      // Convert the Map to JSON
      final String jsonBody = jsonEncode(requestBody);

      // Prepare headers
      final headers = {
        'Content-Type': 'application/json',
        if (token != null)
          'Authorization': 'Bearer $token', // Add Bearer token if present
      };

      final response = await http.put(
        Uri.parse(
            '$baseUrl/rrh/send/matvarer/$id'), // Endpoint for updating user info
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
}

class ApiSearchUsers {
  static const String baseUrl = ApiConstants.baseUrl;

  static Future<List<UserInfoSearch>?> searchUsers(
      String? token, String? query) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      if (query != null && query.isNotEmpty) {
        // Make the API request with a timeout of 5 seconds
        final response = await http
            .get(
              Uri.parse('$baseUrl/rrh/brukere/search?query=$query'),
              headers: headers,
            )
            .timeout(const Duration(seconds: 5));
        if (response.statusCode == 200) {
          List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
          List<UserInfoSearch> profiler = data.map((userData) {
            return UserInfoSearch(
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
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
    return null;
  }
}

class UserInfoSearch {
  final String username;
  final String firstname;
  final String lastname;
  final String profilepic;

  UserInfoSearch({
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.profilepic,
  });
}

class ApiRating {
  static const String baseUrl = ApiConstants.baseUrl;

  Future<http.Response?> giRating(
    String? token,
    String? brukernavn,
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
                '$baseUrl/api/ratings?receiver=$brukernavn&value=$rating&kjoper=$kjoper'),
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

  static Future<List<UserInfoRating>?> listRatings(
      String? token, String? username) async {
    try {
      // Validate token and username
      if (token == null || username == null || username.isEmpty) {
        return null; // Early return for invalid inputs
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request with a timeout of 5 seconds
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/ratings/${username.toLowerCase()}'),
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

  static Future<UserInfoStats?> ratingSummary(
      String? token, String? username) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request with a timeout of 5 seconds
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/ratings/summary/$username'),
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
}

class UserInfoRating {
  final String username;
  final String? profilepic;
  final int value;
  bool? kjoper;
  final DateTime time;

  UserInfoRating({
    required this.username,
    this.profilepic, // Optional
    required this.value,
    required this.kjoper,
    required this.time,
  });
}

class UserInfoStats {
  final int? totalCount;
  final double? averageValue;

  UserInfoStats({
    required this.totalCount,
    required this.averageValue,
  });
}

class ReportUser {
  // ----Upload food---------------

  static const String baseUrl = ApiConstants.baseUrl; // Your base URL

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
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }

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
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }
}
