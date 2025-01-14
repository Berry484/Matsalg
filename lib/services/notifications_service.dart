import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mat_salg/models/notification_info.dart';
import 'package:mat_salg/my_ip.dart';
import 'dart:async';

class NotificationsService {
  static const String baseUrl = ApiConstants.baseUrl;

//---------------------------------------------------------------------------------------------------------------
//--------------------Gets back the notifications----------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<List<NotificationInfo>?> getAllNotifications(
      String? token) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final response = await http
          .get(
            Uri.parse('$baseUrl/notifications'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        if (data.isEmpty) {
          return [];
        }
        List<NotificationInfo> ratings = data.map((userData) {
          String? username = userData['username'];
          String? profilepic = userData['profilePic'];
          String? productImage = userData['productImage'];
          DateTime time = DateTime.tryParse(userData['time']) ?? DateTime.now();
          String sender = userData['sender'];
          String receiver = userData['receiver'];
          int? matId = userData['matId'];
          String type = userData['type'] ?? '';

          return NotificationInfo(
            sender: sender,
            receiver: receiver,
            productImage: productImage,
            username: username,
            profilepic: profilepic,
            matId: matId,
            type: type,
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
//--------------------Marks all notifications as read------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<http.Response> markRead(String? token) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // POST request to mark all notifications as read
      final response = await http
          .post(
            Uri.parse('$baseUrl/notifications/mark-read'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 8));

      return response;
    } on SocketException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

//
}
