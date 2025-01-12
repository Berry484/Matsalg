import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mat_salg/models/matvarer.dart';
import 'package:mat_salg/my_ip.dart';
import 'dart:async';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_util.dart';

class ApiFoodService {
  static const String baseUrl = ApiConstants.baseUrl;

//---------------------------------------------------------------------------------------------------------------
//--------------------Uploads a food item to the postgreSQL backend----------------------------------------------
//---------------------------------------------------------------------------------------------------------------
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
    required bool accuratePosition,
  }) async {
    try {
      final Map<String, dynamic> userInfoData = {
        "name": name,
        "imgUrl": imgUrl,
        "description": description,
        "price": price,
        "kategorier": [kategorier],
        "lat": posisjon?.latitude,
        "lng": posisjon?.longitude,
        "betaling": betaling,
        "kjopt": false,
        "slettet": false,
        "accuratePosition": accuratePosition,
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

//---------------------------------------------------------------------------------------------------------------
//--------------------Updates a food item in the backend---------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
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
    bool? accuratePosition,
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
        "kjopt": kjopt,
        "accuratePosition": accuratePosition,
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

//---------------------------------------------------------------------------------------------------------------
//--------------------Marks a food item as deleted in the backend so it wont be shown anymore--------------------
//---------------------------------------------------------------------------------------------------------------
  Future<http.Response> slettMatvare({
    required int? id,
    String? token, // Add token parameter
  }) async {
    try {
      final Map<String, dynamic> requestBody = {
        "slettet": true,
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

//---------------------------------------------------------------------------------------------------------------
//--------------------Marks a food item a sold out---------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  Future<http.Response> merkSolgt({
    required int? id,
    required bool solgt,
    String? token, // Add token parameter
  }) async {
    try {
      final Map<String, dynamic> requestBody = {"kjopt": solgt};

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

//---------------------------------------------------------------------------------------------------------------
//--------------------Gets all food listings from the backend----------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<List<Matvarer>?> getAllFoods(String? token, int page) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request and parse the response
      final response = await http
          .get(
            Uri.parse(
                '$baseUrl/rrh/send/matvarer?userLat=${FFAppState().brukerLat}&userLng=${FFAppState().brukerLng}&size=44&page=$page'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds

      // Check if the response is successful (status code 200)
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));
        return Matvarer.matvarerFromSnapShot(jsonResponse);
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
//--------------------Gets all food listings from the backend----------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<List<Matvarer>?> getSimilarFoods(
      String? token, int page, String keyword, int matId) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request and parse the response
      final response = await http
          .get(
            Uri.parse(
                '$baseUrl/rrh/send/matvarer/similar-products?userLat=${FFAppState().brukerLat}&userLng=${FFAppState().brukerLng}&size=44&page=$page&keyword=$keyword&matId=$matId'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));
        return Matvarer.matvarerFromSnapShot(jsonResponse);
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
//--------------------Gets my OWN food listings from the backend-------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<List<Matvarer>?> getMyFoods(String? token, int page) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final response = await http
          .get(
            Uri.parse('$baseUrl/rrh/send/matvarer/mine?size=44&page=$page'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5));

      // Check if the response is successful (status code 200)
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));
        return Matvarer.matvarerFromSnapShot(jsonResponse);
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
//--------------------Gets food listings from a SPECIFIC user by using the uid-----------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<List<Matvarer>?> getUserFood(
      String? token, String? username, int page) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Make the API request and parse the response
      final response = await http
          .get(
            Uri.parse(
                '$baseUrl/rrh/send/matvarer/mine?uid=$username&size=44&page=$page'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds

      // Check if the response is successful (status code 200)
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));
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

//---------------------------------------------------------------------------------------------------------------
//--------------------Gets food items from a category------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<List<Matvarer>?> getCategoryFood(
      String? token,
      int page,
      bool sortByPriceAsc,
      bool sortByPriceDesc,
      bool sortByDistance,
      int minPrice,
      int maxPrice,
      int? maxDistance,
      List<String> categories,
      String searchQuery) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Default categories if empty
      if (categories.isEmpty) {
        categories = ['kjøtt', 'grønt', 'meieri', 'bakverk', 'sjømat'];
      }

      // Handle maxPrice default
      if (maxPrice == 800) {
        maxPrice = 100000;
      }
      maxDistance ??= 100000;

      String categoriesParam = categories.join(',');

      final response = await http
          .get(
            Uri.parse(
                '$baseUrl/rrh/send/matvarer/filter?userLat=${FFAppState().brukerLat}&userLng=${FFAppState().brukerLng}&size=44&page=$page&sortByPriceAsc=$sortByPriceAsc&sortByPriceDesc=$sortByPriceDesc&sortByDistance=$sortByDistance&minPrice=$minPrice&maxPrice=$maxPrice&maxDistance=$maxDistance&categories=$categoriesParam&searchQuery=$searchQuery'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));
        return Matvarer.matvarerFromSnapShot(jsonResponse);
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
//--------------------Gets food items from a category count------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<String?> getCategoryFoodCount(String? token, int minPrice,
      int maxPrice, int? maxDistance, List<String> categories) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Default categories if empty
      if (categories.isEmpty) {
        categories = ['kjøtt', 'grønt', 'meieri', 'bakverk', 'sjømat'];
      }

      // Handle maxPrice default
      if (maxPrice == 800) {
        maxPrice = 100000;
      }
      maxDistance ??= 100000;

      String categoriesParam = categories.join(',');

      final response = await http
          .get(
            Uri.parse(
                '$baseUrl/rrh/send/matvarer/filter_count?userLat=${FFAppState().brukerLat}&userLng=${FFAppState().brukerLng}&minPrice=$minPrice&maxPrice=$maxPrice&maxDistance=$maxDistance&categories=$categoriesParam'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        String? count = response.body;
        return count;
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
//--------------------Gets food items from the users I am following----------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<List<Matvarer>?> getFolgerFood(String? token, int page) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final response = await http
          .get(
            Uri.parse(
                '$baseUrl/rrh/send/matvarer/following-foods?size=44&page=$page'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));
        return Matvarer.matvarerFromSnapShot(jsonResponse);
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
//--------------------Gets product details-----------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<Matvarer?> getProductDetails(String? token, int matId) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Perform the HTTP GET request
      final response = await http
          .get(
            Uri.parse('$baseUrl/rrh/send/matvarer/get/$matId'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5));

      // Check response status
      if (response.statusCode == 200) {
        // Parse and return the Matvarer object
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return Matvarer.fromJson(jsonResponse);
      } else if (response.statusCode == 410) {
        throw Exception('product-deleted');
      } else if (response.statusCode == 404) {
        throw Exception('Product not found for matId: $matId.');
      } else {
        throw Exception(
            'Failed to fetch product details: ${response.statusCode}');
      }
    } on SocketException {
      throw const SocketException('No Internet connection.');
    } on TimeoutException {
      throw TimeoutException('time-out');
    } catch (e) {
      rethrow;
    }
  }
//
}
