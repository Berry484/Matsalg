import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'package:json_path/fun_extra.dart';
import 'package:mat_salg/Bonder.dart';
import 'package:mat_salg/MyIP.dart';
import 'dart:async'; // Import this to use Future and TimeoutException
import 'package:mat_salg/flutter_flow/flutter_flow_util.dart';
import 'package:http_parser/http_parser.dart';
import 'matvarer.dart';

class ApiCalls {
  static const String baseUrl = ApiConstants.baseUrl;

  // Define the method to check if the email is taken
  Future<http.Response> checkEmailTaken(String email) async {
    final response =
        await http.get(Uri.parse('$baseUrl/rrh/epostledig?email=$email'));
    return response; // Return the response
  }

//----------------------------------------------------------------------------------------------
  Future<http.Response> checkUsernameTaken(String username) async {
    final response = await http
        .get(Uri.parse('$baseUrl/rrh/usernameledig?username=$username'));
    return response; // Return the response
  }

//----------------------------------------------------------------------------------------------
  Future<http.Response> checkPhoneTaken(String phoneNumber) async {
    final response = await http
        .get(Uri.parse('$baseUrl/rrh/check-phone?phoneNumber=$phoneNumber'));

    return response; // Return the response
  }

//----------------------------------------------------------------------------------------------
  Future<http.Response> checkUserInfo(String? token) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    // Using the timeout method
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/rrh/brukere/brukerinfo'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Set timeout to 7 seconds

      return response;
    } on TimeoutException {
      return http.Response('Request timed out', 500);
    }
  }

  Future<String> getKommune(String? token) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http
          .get(
            Uri.parse(
                'https://ws.geonorge.no/adresser/v1/punktsok?lat=${FFAppState().brukerLat ?? 59.9138688}&lon=${FFAppState().brukerLng ?? 10.7522454}&radius=9999999999999&treffPerSide=1&side=1'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Set timeout to 5 seconds

      if (response.statusCode == 200) {
        // Parse the JSON response
        final jsonResponse = json.decode(response.body);

        // Extract the first "adresser" element and get the "kommunenavn"
        final kommunenavn = jsonResponse['adresser'][0]['kommunenavn'];

        return kommunenavn ?? 'Norge';
      } else {
        return 'Norge';
      }
    } on TimeoutException {
      return 'Norge';
    } catch (e) {
      return 'Norge';
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
    required String? price,
    required String? kategorier,
    required LatLng? posisjon,
    required bool? betaling,
    required bool kg,
    required String? antall,
  }) async {
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
  }
}

class ApiMultiplePics {
  static const String baseUrl = ApiConstants.baseUrl; // Your base URL

  Future<List<String>?> uploadPictures({
    required String? token, // Required token parameter
    required List<Uint8List?> filesData, // Accept a list of Uint8List
    String fileType = 'jpeg', // Default to 'jpeg', can be changed as needed
  }) async {
    // Check if filesData is empty
    if (filesData.isEmpty) {
      return null; // Handle the error as needed
    }

    try {
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
    } catch (e) {
      return null; // Handle exceptions as needed
    }
  }
}

class ApiGetAllFoods {
  static const String baseUrl = ApiConstants.baseUrl;

  static Future<List<Matvarer>?> getAllFoods(String? token) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
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
    } on TimeoutException {
      return null;
    } catch (e) {
      // Handle any other errors that might occur
      return null;
    }
  }
}

class ApiGetMyFoods {
  static const String baseUrl = ApiConstants.baseUrl;

  static Future<List<Matvarer>?> getMyFoods(String? token) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
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
    } on TimeoutException {
      return null;
    } catch (e) {
      // Handle any other errors that might occur
      return null;
    }
  }
}

class ApiGetBonder {
  static const String baseUrl = ApiConstants.baseUrl;

  static Future<List<Bonder>?> getAllBonder(String? token) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
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
        return Bonder.bonderFromSnapshot(jsonResponse);
      } else {
        // Handle unsuccessful response
        return null;
      }
    } on TimeoutException {
      return null;
    } catch (e) {
      // Handle any other errors that might occur
      return null;
    }
  }
}

class ApiGetUser {
  static const String baseUrl = ApiConstants.baseUrl;

  static Future<List<Bonder>?> checkUser(
      String? token, String? username) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
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
          return Bonder.bonderFromSnapshot(
              [jsonResponse]); // Wrap single object in a list
        } else if (jsonResponse is List) {
          return Bonder.bonderFromSnapshot(
              jsonResponse); // If it's already a list, pass it directly
        }
      } else {
        // Handle unsuccessful response
        return null;
      }
    } on TimeoutException {
      return null;
    } catch (e) {
      // Handle any other errors that might occur
      return null;
    }
  }
}

class ApiGetUserFood {
  static const String baseUrl = ApiConstants.baseUrl;

  static Future<List<Matvarer>?> getUserFood(
      String? token, String? username) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
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
    } on TimeoutException {
      return null;
    } catch (e) {
      // Handle any other errors that might occur
      return null;
    }
  }
}

class ApiLike {
  static const String baseUrl = ApiConstants.baseUrl;

  Future<http.Response?> sendLike(String? token, int? matId) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      // Make the API request and parse the response
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/likes?mat_id=${matId}'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds

      return response;
    } on TimeoutException {
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<http.Response?> deleteLike(String? token, int? matId) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      // Make the API request and parse the response
      final response = await http
          .delete(
            Uri.parse('$baseUrl/api/likes?mat_id=${matId}'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds
      return response;
    } on TimeoutException {
      return null;
    } catch (e) {
      return null;
    }
  }
}

class ApiGetAllLikes {
  static const String baseUrl = ApiConstants.baseUrl;

  static Future<List<Matvarer>?> getAllLikes(String? token) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
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
    } on TimeoutException {
      return null;
    } catch (e) {
      // Handle any other errors that might occur
      return null;
    }
  }
}

class ApiCheckLiked {
  static const String baseUrl = ApiConstants.baseUrl;

  static Future<bool?> getChecklike(String? token, int? matId) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
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
    } on TimeoutException {
      return false;
    } catch (e) {
      return false;
    }
  }
}

class ApiFolg {
  static const String baseUrl = ApiConstants.baseUrl;

  Future<http.Response?> folgbruker(String? token, String? brukernavn) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      // Make the API request and parse the response
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/follow?bruker=$brukernavn'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds
      return response;
    } on TimeoutException {
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<http.Response?> unfolgBruker(String? token, String? brukernavn) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      // Make the API request and parse the response
      final response = await http
          .delete(
            Uri.parse('$baseUrl/api/unfollow?bruker=$brukernavn'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds
      return response;
    } on TimeoutException {
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<String?> tellFolger(String? token, String? brukernavn) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
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
    } on TimeoutException {
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<String?> tellFolgere(String? token, String? brukernavn) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
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
    } on TimeoutException {
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<bool?> sjekkFolger(String? token, String? brukernavn) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      // Make the API request and parse the response
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/follows?bruker=$brukernavn'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds
      if (response.body.toLowerCase() == 'true') {
        return true;
      } else {
        return false;
      }
    } on TimeoutException {
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<String?> tellMineFolger(String? token) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
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
    } on TimeoutException {
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<String?> tellMineFolgere(String? token) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
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
    } on TimeoutException {
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<List<UserInfo>?> listFolgere(
      String? token, String? username) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
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
    } on TimeoutException {
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<List<UserInfo>?> listFolger(
      String? token, String? username) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
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
    } on TimeoutException {
      return null;
    } catch (e) {
      return null;
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
      if (token != null)
        'Authorization': 'Bearer $token', // Add Bearer token if present
    };

    // Send the POST request
    final response = await http.post(
      uri, // Use the updated URI with query parameters
      headers: headers,
      body: jsonBody,
    );
    return response; // Return the response
  }

  static Future<List<OrdreInfo>?> getKjop(String? token) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      // Make the API request with a timeout of 5 seconds
      final response = await http
          .get(
            Uri.parse(
                '$baseUrl/ordre/kjoper'), // Adjust the endpoint as necessary
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds

      if (response.statusCode == 200) {
        // Parse the response body
        List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        // Map the dynamic data to OrdreInfo instances
        List<OrdreInfo> kjopOrders = data.map((orderData) {
          // Check for foodDetails existence
          if (orderData['foodDetails'] == null) {
            throw Exception(
                'Food details not available for order ID: ${orderData['id']}');
          }

          // Extract food details and create Matvarer instance
          Matvarer foodDetails = Matvarer.fromJson(
              orderData['foodDetails']); // Use the new Matvarer.fromJson

          return OrdreInfo(
            id: orderData['id'], // Unique ID of the order
            kjoper: orderData['kjoper'], // Username of the buyer
            selger: orderData['selger'], // Username of the seller
            matId: orderData['matId'], // Corrected to 'matId'
            antall: orderData['antall'], // Quantity ordered
            pris: orderData['pris'], // Ensure this is a double
            time: DateTime.parse(orderData['time']), // Convert to DateTime
            godkjenttid: orderData['godkjenttid'] != null
                ? DateTime.parse(orderData['godkjenttid'])
                : null, // Parse if exists
            hentet: orderData['hentet'], // Status of whether picked up
            godkjent: orderData['godkjent'], // Approval status
            trekt: orderData['trekt'], // Approval status
            avvist: orderData['avvist'], // Approval status
            kjoperProfilePic: orderData['user']['profilepic'] as String?,
            foodDetails: foodDetails, // Pass the Matvarer instance here
          );
        }).toList();

        return kjopOrders; // Return populated OrdreInfo list
      } else {
        return null; // Or throw an error
      }
    } on TimeoutException {
      return null; // Handle timeout
    } catch (e) {
      return null; // Handle other errors
    }
  }

  static Future<List<OrdreInfo>?> getSalg(String? token) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      // Make the API request with a timeout of 5 seconds
      final response = await http
          .get(
            Uri.parse(
                '$baseUrl/ordre/selger'), // Adjust the endpoint as necessary
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds

      if (response.statusCode == 200) {
        // Parse the response body
        List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        // Map the dynamic data to OrdreInfo instances
        List<OrdreInfo> kjopOrders = data.map((orderData) {
          // Check for foodDetails existence
          if (orderData['foodDetails'] == null) {
            throw Exception(
                'Food details not available for order ID: ${orderData['id']}');
          }

          // Extract food details and create Matvarer instance
          Matvarer foodDetails = Matvarer.fromJson(
              orderData['foodDetails']); // Use the new Matvarer.fromJson

          return OrdreInfo(
            id: orderData['id'], // Unique ID of the order
            kjoper: orderData['kjoper'], // Username of the buyer
            selger: orderData['selger'], // Username of the seller
            matId: orderData['matId'], // Corrected to 'matId'
            antall: orderData['antall'], // Quantity ordered
            pris: orderData['pris'], // Ensure this is a double
            time: DateTime.parse(orderData['time']), // Convert to DateTime
            godkjenttid: orderData['godkjenttid'] != null
                ? DateTime.parse(orderData['godkjenttid'])
                : null, // Parse if exists
            hentet: orderData['hentet'], // Status of whether picked up
            godkjent: orderData['godkjent'], // Approval status
            trekt: orderData['trekt'], // Approval status
            avvist: orderData['avvist'], // Approval status
            kjoperProfilePic: orderData['user']['profilepic'] as String?,
            foodDetails: foodDetails, // Pass the Matvarer instance here
          );
        }).toList();
        return kjopOrders; // Return populated OrdreInfo list
      } else {
        return null; // Or throw an error
      }
    } on TimeoutException {
      return null; // Handle timeout
    } catch (e) {
      return null; // Handle other errors
    }
  }

  Future<http.Response> svarBud({
    required int id,
    required bool godkjent,
    required String token,
  }) async {
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
      if (token != null)
        'Authorization': 'Bearer $token', // Add Bearer token if present
    };

    // Send the POST request
    final response = await http.post(
      uri, // Use the updated URI with query parameters
      headers: headers,
      body: jsonBody,
    );
    return response; // Return the response
  }

  Future<http.Response> hentMat({
    required int id,
    required bool hentet,
    required String token,
  }) async {
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
      if (token != null)
        'Authorization': 'Bearer $token', // Add Bearer token if present
    };

    // Send the POST request
    final response = await http.post(
      uri, // Use the updated URI with query parameters
      headers: headers,
      body: jsonBody,
    );
    return response; // Return the response
  }

  Future<http.Response> avvis({
    required int id,
    required bool avvist,
    required bool godkjent,
    required String token,
  }) async {
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
      if (token != null)
        'Authorization': 'Bearer $token', // Add Bearer token if present
    };

    // Send the POST request
    final response = await http.post(
      uri, // Use the updated URI with query parameters
      headers: headers,
      body: jsonBody,
    );
    return response; // Return the response
  }

  Future<http.Response> trekk({
    required int id,
    required bool trekt,
    required String token,
  }) async {
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
      if (token != null)
        'Authorization': 'Bearer $token', // Add Bearer token if present
    };

    // Send the POST request
    final response = await http.post(
      uri, // Use the updated URI with query parameters
      headers: headers,
      body: jsonBody,
    );
    return response; // Return the response
  }
}

class ApiGetFilterFood {
  static const String baseUrl = ApiConstants.baseUrl;

  static Future<List<Matvarer>?> getFilterFood(
      String? token, String? kategorier) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http
          .get(
            Uri.parse(
                '$baseUrl/rrh/send/matvarer/filter?kategorier=${kategorier}&userLat=${FFAppState().brukerLat}&userLng=${FFAppState().brukerLng}'),
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
    } on TimeoutException {
      return null;
    } catch (e) {
      // Handle any other errors that might occur
      return null;
    }
  }

  static Future<List<Matvarer>?> getBondeFood(String? token) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
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
    } on TimeoutException {
      return null;
    } catch (e) {
      // Handle any other errors that might occur
      return null;
    }
  }

  static Future<List<Matvarer>?> getFolgerFood(String? token) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
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
    } on TimeoutException {
      return null;
    } catch (e) {
      // Handle any other errors that might occur
      return null;
    }
  }
}

class OrdreInfo {
  final int id;
  final String kjoper;
  final String selger;
  final int matId;
  final int antall;
  final int pris; // Ensure this is a double
  final DateTime time;
  final DateTime? godkjenttid;
  final bool? hentet;
  final bool? godkjent;
  final bool? trekt;
  final bool? avvist;
  final String? kjoperProfilePic;
  final Matvarer foodDetails; // Change this to Matvarer

  OrdreInfo({
    required this.id,
    required this.kjoper,
    required this.selger,
    required this.matId,
    required this.antall,
    required this.pris,
    required this.time,
    this.godkjenttid,
    required this.hentet,
    required this.godkjent,
    required this.trekt,
    required this.avvist,
    required this.kjoperProfilePic,
    required this.foodDetails, // Pass food details to the constructor
  });
}

class ApiUpdateFood {
  static const String baseUrl = ApiConstants.baseUrl; // Your base URL

  Future<http.Response> updateAntall({
    required String? antall,
    required int? id,
    String? token, // Add token parameter
  }) async {
    // Convert the String antall to double
    double? antallAsDouble;
    if (antall != null) {
      try {
        antallAsDouble = double.parse(antall);
      } catch (e) {
        return http.Response("", 400); // Return bad request if parsing fails
      }
    }

    final Map<String, dynamic> requestBody = {"antall": antallAsDouble};

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
  }
}
