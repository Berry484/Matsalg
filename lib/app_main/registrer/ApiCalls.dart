import 'package:http/http.dart' as http;
import 'package:mat_salg/MyIP.dart';

class ApiCalls {
  static const String baseUrl = ApiConstants.baseUrl; // Your base URL

  // Define the method to check if the email is taken
  Future<http.Response> checkEmailTaken(String email) async {
    final response =
        await http.get(Uri.parse('$baseUrl/rrh/epostledig?email=$email'));
    return response; // Return the response
  }
}
