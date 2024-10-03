import 'package:http/http.dart' as http;
import 'package:mat_salg/MyIP.dart';
import 'dart:async'; // Import this to use Future and TimeoutException
import 'package:mat_salg/flutter_flow/flutter_flow_util.dart';
import 'package:http_parser/http_parser.dart';
import 'app_main/vanlig_bruker/hjem/hjem/matvarer.dart';

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
      print(username);
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
    required List<String>? kategorier,
    required LatLng? posisjon,
    required bool? betaling,
    required bool kg,
  }) async {
    // Create the user info data as a Map
    final Map<String, dynamic> userInfoData = {
      "name": name,
      "imgUrl": imgUrl,
      "description": description,
      "price": price,
      "kategorier": kategorier,
      "lat": posisjon?.latitude,
      "lng": posisjon?.longitude,
      "betaling": betaling,
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
        } else {
          print('File data at index $i is null.'); // Debugging statement
        }
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
        print(
            'Failed to upload files. Status code: ${response.statusCode}, Response body: ${responseString.body}');
        return null; // Or handle the error as needed
      }
    } catch (e) {
      print('An error occurred: $e');
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
            Uri.parse('$baseUrl/rrh/send/matvarer'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds

      // Check if the response is successful (status code 200)
      if (response.statusCode == 200) {
        // Decode the JSON response

        final List<dynamic> jsonResponse = jsonDecode(response.body);
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
            Uri.parse('$baseUrl/rrh/send/matvarer/mine'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds

      // Check if the response is successful (status code 200)
      if (response.statusCode == 200) {
        // Decode the JSON response

        final List<dynamic> jsonResponse = jsonDecode(response.body);
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
