import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:mat_salg/app_state.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/my_ip.dart';
import 'package:mat_salg/pages/app_pages/profile/profile/profile_page.dart';
import 'package:mat_salg/services/food_service.dart';
import 'package:mat_salg/services/like_service.dart';
import 'package:mat_salg/services/user_service.dart';

class ProfileServices {
  static const String baseUrl = ApiConstants.baseUrl;
  final ProfileModel model;
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final UserInfoService userInfoService = UserInfoService();

  ProfileServices({required this.model});

//---------------------------------------------------------------------------------------------------------------
//--------------------Gets all the products the user has liked---------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  Future<void> getAllLikes(BuildContext context, String token) async {
    try {
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return;
      } else {
        model.likesmatvarer = await ApiLike.getAllLikes(token);
        if (model.likesmatvarer != null && model.likesmatvarer!.isEmpty) {
          return;
        } else {
          FFAppState().liked = false;
        }
        model.likesisloading = false;
      }
    } on SocketException {
      if (context.mounted != true) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      if (context.mounted != true) return;
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Refreshes variables about the user and his products----------------------------------------
//---------------------------------------------------------------------------------------------------------------
  Future<void> refreshPage(BuildContext context) async {
    try {
      model.isloading = true;
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        model.isloading = false;
        return;
      } else {
        if (!context.mounted) return;
        ApiFoodService.getMyFoods(token, 0);
        getAllLikes(context, token);
        userInfoService.fetchData(context);
        model.isloading = false;
      }
    } on SocketException {
      model.isloading = false;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      model.isloading = false;
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Gets my OWN food listings from the backend-------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  Future<List<Matvarer>?> getMyFoods(BuildContext context) async {
    try {
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return null;
      } else {
        final headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        };

        final response = await http
            .get(
              Uri.parse(
                  '$baseUrl/rrh/send/matvarer/mine?userLat=${FFAppState().brukerLat}&userLng=${FFAppState().brukerLng}&size=44&page=${model.page}'),
              headers: headers,
            )
            .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds

        // Check if the response is successful (status code 200)
        if (response.statusCode == 200) {
          final List<dynamic> jsonResponse =
              jsonDecode(utf8.decode(response.bodyBytes));

          List<Matvarer>? nyeMatvarer =
              Matvarer.matvarerFromSnapShot(jsonResponse);
          if (nyeMatvarer.isNotEmpty) {
            FFAppState().matvarer.addAll(nyeMatvarer);
          } else {
            model.end = true;
          }
          return Matvarer.matvarerFromSnapShot(jsonResponse);
        } else {
          // Handle unsuccessful response
          return null;
        }
      }
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }

//
}
