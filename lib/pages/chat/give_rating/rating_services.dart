import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/pages/chat/give_rating/rating_page.dart';
import 'package:mat_salg/services/rating_service.dart';
import 'package:mat_salg/services/user_service.dart';

class RatingServices {
  final RatingModel model;
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final UserInfoService userInfoService = UserInfoService();

  RatingServices({required this.model});

//---------------------------------------------------------------------------------------------------------------
//--------------------Gets the current user location if available------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  Future<void> giveRating(
      BuildContext context, bool kjop, String username, int matId) async {
    try {
      if (model.messageIsLoading) return;
      model.messageIsLoading = true;
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        model.messageIsLoading = false;
        return;
      }
      int rating = model.ratingBarValue?.round() ?? 5;
      try {
        await RatingService.giRating(token, username, rating, kjop, matId);

        if (!context.mounted) return;
        HapticFeedback.selectionClick();
        Toasts.showAccepted(context, 'Vurdering sendt');
        model.messageIsLoading = false;
        Navigator.pop(context, true);
        if (kjop) return;
        Navigator.pop(context, true);
        Navigator.pop(context, true);
      } catch (e) {
        if (!context.mounted) return;
        model.messageIsLoading = false;
        Navigator.pop(context, true);
        if (kjop) return;
        Navigator.pop(context, true);
        Navigator.pop(context, true);
      }
    } on SocketException {
      model.messageIsLoading = false;
      if (!context.mounted) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      model.messageIsLoading = false;
      if (!context.mounted) return;
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

//
}
