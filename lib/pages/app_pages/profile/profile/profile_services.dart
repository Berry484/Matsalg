import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:mat_salg/app_state.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/logging.dart';
import 'package:mat_salg/my_ip.dart';
import 'package:mat_salg/pages/app_pages/profile/profile/profile_page.dart';
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
      logger.d('En feil oppstod, $e');
    }
  }

//
}
