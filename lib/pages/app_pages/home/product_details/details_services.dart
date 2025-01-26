import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/pages/app_pages/home/product_details/details_widget.dart';
import 'package:mat_salg/services/food_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:mat_salg/models/matvarer.dart';
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
      rethrow;
    } catch (e) {
      if (!context.mounted) return;
      rethrow;
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
        (conv) => conv.user == matvare.uid && conv.matId == matvare.matId,
        orElse: () {
          // If no existing conversation, create a new one with matId
          final newConversation = Conversation(
            username: matvare.username ?? '',
            user: matvare.uid ?? '',
            deleted: false,
            lastactive: matvare.lastactive,
            profilePic: matvare.profilepic ?? '',
            messages: [],
            matId: matvare.matId,
            productImage: matvare.imgUrls?.first,
          );

          FFAppState().conversations.insert(0, newConversation);
          return newConversation;
        },
      );

      String? serializedConversation = serializeParam(
        existingConversation.toJson(),
        ParamType.JSON,
      );

      model.messageIsLoading = false;
      if (matvare.uid == FirebaseAuth.instance.currentUser?.uid) {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text('Dette er din annonse'),
              content: const Text(
                  'Du kan ikke starte en samtale med deg selv igjennom matsalg.no'),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Ok',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            );
          },
        );
        return;
      }
      if (serializedConversation != null) {
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
