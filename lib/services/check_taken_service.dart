import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mat_salg/my_ip.dart';
import 'dart:async';

class CheckTakenService {
  static const String baseUrl = ApiConstants.baseUrl;

//---------------------------------------------------------------------------------------------------------------
//--------------------Checks if a user in postgres has the same email--------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<http.Response> checkEmailTaken(String email) async {
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

//---------------------------------------------------------------------------------------------------------------
//--------------------Checks if a user in postgres has the same username-----------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<http.Response> checkUsernameTaken(String username) async {
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

//---------------------------------------------------------------------------------------------------------------
//--------------------Checks if a user in postgres has the same phoneNumber--------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<http.Response> checkPhoneTaken(String phone) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/rrh/phoneLedig?phone=$phone'));
      return response; // Return the response
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }

//
}
