import 'dart:io';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/pages/app_pages/orders/order_product_details/product_model.dart';
import 'package:mat_salg/services/food_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:mat_salg/services/location_service.dart';

class ProductServices {
  final ProductModel model;
  final OrdreInfo ordreInfo;
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final ApiFoodService apiFoodService = ApiFoodService();
  final LocationService locationService = LocationService();
  final appState = FFAppState();

  ProductServices({required this.model, required this.ordreInfo});

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
        if (ordreInfo.foodDetails.lat == 0 || ordreInfo.foodDetails.lng == 0) {
          model.poststed = null;
        }
        if ((ordreInfo.foodDetails.lat == null ||
                ordreInfo.foodDetails.lat == 0) ||
            (ordreInfo.foodDetails.lng == null ||
                ordreInfo.foodDetails.lng == 0)) {
          model.poststed = null;
        }

        String? response = await locationService.getKommune(token,
            ordreInfo.foodDetails.lat ?? 0, ordreInfo.foodDetails.lng ?? 0);

        if (response.isNotEmpty) {
          String formattedResponse =
              response[0].toUpperCase() + response.substring(1).toLowerCase();
          model.poststed = formattedResponse;
        }
        appState.updateUI();
      }
    } on SocketException {
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Enters a conversation wiht a specific user-------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  Future<void> enterConversation(
    BuildContext context,
  ) async {
    try {
      if (model.loading) {
        return;
      }
      model.loading = true;

      Conversation existingConversation = FFAppState().conversations.firstWhere(
        (conv) => conv.user == ordreInfo.foodDetails.uid,
        orElse: () {
          final newConversation = Conversation(
            username: ordreInfo.foodDetails.username ?? '',
            user: ordreInfo.foodDetails.uid ?? '',
            lastactive: ordreInfo.foodDetails.lastactive,
            profilePic: ordreInfo.foodDetails.profilepic ?? '',
            messages: [],
          );

          FFAppState().conversations.add(newConversation);

          // Return the new conversation
          return newConversation;
        },
      );

      String? serializedConversation = serializeParam(
        existingConversation.toJson(),
        ParamType.JSON,
      );

      model.loading = false;
      if (serializedConversation != null) {
        context.pushNamed(
          'message',
          queryParameters: {
            'conversation': serializedConversation,
          },
        );
      }
    } on SocketException {
      model.loading = false;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      model.loading = false;
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

//
}
