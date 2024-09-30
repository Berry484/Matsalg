import 'package:http/http.dart' as http;
import 'package:mat_salg/MyIP.dart';
import 'package:mat_salg/flutter_flow/flutter_flow_util.dart';
import 'package:http_parser/http_parser.dart';

class ApiCalls {
  static const String baseUrl = ApiConstants.baseUrl; // Your base URL

  // Define the method to check if the email is taken
  Future<http.Response> checkEmailTaken(String email) async {
    final response =
        await http.get(Uri.parse('$baseUrl/rrh/epostledig?email=$email'));
    return response; // Return the response
  }

  Future<http.Response> checkUsernameTaken(String username) async {
    final response = await http
        .get(Uri.parse('$baseUrl/rrh/usernameledig?username=$username'));
    return response; // Return the response
  }

  Future<http.Response> checkPhoneTaken(String phoneNumber) async {
    final response = await http
        .get(Uri.parse('$baseUrl/rrh/check-phone?phoneNumber=$phoneNumber'));

    return response; // Return the response
  }

  Future<http.Response> checkUserInfo(String username, String? token) async {
    final headers = {
      'Content-Type': 'application/json',
      if (token != null)
        'Authorization': 'Bearer $token', // Add Bearer token if present
    };

    final response = await http.get(
      Uri.parse('$baseUrl/rrh/brukere/$username'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      // Parse the response body as JSON
      return response;
    } else {
      // Print error details if status code is not 200
      return response;
    }
  }

  Future<http.Response> whoOwnToken(String token) async {
    final response =
        await http.get(Uri.parse('$baseUrl/rrh/tokeneier?token=$token'));
    return response; // Return the response
  }
}

//----------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------

//----Opprett bruker i keycloak---------------
// Define the method to create a user
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
      'lat': posisjon?.latitude?.toString(),
      'lng': posisjon?.longitude?.toString(),
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
      "profile_picture": profilepic,
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
    String? username,
    required String? password,
    String? phoneNumber,
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
      // Handle the error

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
              'profile_pic.$fileType', // Use a filename with the .jpeg extension
        ),
      );

      // Include the username as a part of the request
      if (username != null) {
        request.fields['username'] = username; // Add username to the request
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
