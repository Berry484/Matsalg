import 'dart:io';

import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/pages/app_pages/hjem/product_details/details_widget.dart';
import 'package:mat_salg/services/food_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:mat_salg/services/location_service.dart';

class DetailsServices {
  final DetailsModel model;
  final Matvarer matvare;
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final ApiFoodService apiFoodService = ApiFoodService();
  final LocationService locationService = LocationService();
  final appState = FFAppState();

  DetailsServices({required this.model, required this.matvare});

//---------------------------------------------------------------------------------------------------------------
//--------------------Gets the poststed for the coordinates------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  Future<void> getPoststed(
    BuildContext context,
  ) async {
    try {
      String? token = await firebaseAuthService.getToken(context);

      if (token == null) {
        return;
      } else {
        if (matvare.lat == 0 || matvare.lng == 0) {
          model.poststed = null;
        }
        if ((matvare.lat == null || matvare.lat == 0) ||
            (matvare.lng == null || matvare.lng == 0)) {
          model.poststed = null;
        }

        String? response = await locationService.getKommune(
            token, matvare.lat ?? 0, matvare.lng ?? 0);

        if (response.isNotEmpty) {
          String formattedResponse =
              response[0].toUpperCase() + response.substring(1).toLowerCase();
          model.poststed = formattedResponse;
          appState.updateUI();
        }
      }
    } on SocketException {
      if (!context.mounted) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      if (!context.mounted) return;
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Gets all the product suggestions for this product listing----------------------------------
//---------------------------------------------------------------------------------------------------------------
  Future<void> getAllFoods(BuildContext context) async {
    try {
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return;
      } else {
        model.nyematvarer = await ApiFoodService.getAllFoods(token);

        if (model.nyematvarer != null && model.nyematvarer!.isNotEmpty) {
          model.isloading = false;
          return;
        } else {
          model.isloading = true;
        }
      }
    } on SocketException {
      if (!context.mounted) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      if (!context.mounted) return;
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Enters a conversation with a user----------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  Future<void> enterConversation(
    BuildContext context,
  ) async {
    try {
      if (model.messageIsLoading) {
        return;
      }
      model.messageIsLoading = true;

      Conversation existingConversation = FFAppState().conversations.firstWhere(
        (conv) => conv.user == matvare.uid,
        orElse: () {
          final newConversation = Conversation(
            username: matvare.username ?? '',
            user: matvare.uid ?? '',
            deleted: false,
            lastactive: matvare.lastactive,
            profilePic: matvare.profilepic ?? '',
            messages: [],
          );

          FFAppState().conversations.add(newConversation);
          return newConversation;
        },
      );

      String? serializedConversation = serializeParam(
        existingConversation.toJson(),
        ParamType.JSON,
      );

      model.messageIsLoading = false;
      if (serializedConversation != null) {
        Navigator.pop(context);
        context.pushNamed(
          'message',
          queryParameters: {
            'conversation': serializedConversation,
          },
        );
      }
    } on SocketException {
      model.messageIsLoading = false;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      model.messageIsLoading = false;
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

//
}
