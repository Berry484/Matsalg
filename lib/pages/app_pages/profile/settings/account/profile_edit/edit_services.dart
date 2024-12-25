import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/services/check_taken_service.dart';
import 'package:mat_salg/services/image_service.dart';
import 'package:mat_salg/services/user_service.dart';
import '../../../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'edit_model.dart';
export 'edit_model.dart';

class EditServices {
  final EditModel model;
  final String konto;
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final ApiMultiplePics apiMultiplePics = ApiMultiplePics();
  final UserInfoService userInfoService = UserInfoService();

  EditServices({required this.model, required this.konto});
//---------------------------------------------------------------------------------------------------------------
//--------------------Gets the current user location if available------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  bool isTextFieldEmpty() {
    if (konto == 'Brukernavn' &&
        (model.brukernavnTextController.text == FFAppState().brukernavn ||
            model.brukernavnTextController.text.trim().isEmpty)) {
      return true;
    } else if (konto == 'For- og etternavn' &&
        ((model.fornavnTextController.text == FFAppState().firstname &&
                model.etternavnTextController.text == FFAppState().lastname) ||
            model.fornavnTextController.text.trim().isEmpty ||
            model.etternavnTextController.text.trim().isEmpty)) {
      return true;
    } else if (konto == 'E-post' &&
        (model.emailTextController.text.trim().isEmpty ||
            model.emailTextController.text == FFAppState().email)) {
      return true;
    } else if (konto == 'Bio' &&
        (model.bioTextController.text == FFAppState().bio)) {
      return true;
    } else if (konto == 'Profilbilde' &&
        (model.uploadedLocalFile.bytes?.isEmpty ?? true)) {
      return true;
    }
    return false;
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Gets the current user location if available------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  Future<void> saveAccountUpdates(
    BuildContext context,
    Function(String title, String content) showDialogCallback,
    Function(String message, bool error) showToast,
    Function(String path, bool pop) navigate,
  ) async {
    try {
      if (model.isLoading) {
        return;
      }
      if (isTextFieldEmpty()) {
        return;
      }
      model.isLoading = true;
      if (model.emailTextController.text != FFAppState().email &&
          konto == 'E-post') {
        final response = await CheckTakenService.checkEmailTaken(
            model.emailTextController.text);
        if (response.statusCode != 200) {
          await showDialogCallback(
            'E-posten er opptatt',
            'Denne e-posten er allerede i bruk av en annen bruker.',
          );
          model.isLoading = false;
          navigate('', true);
          return;
        }
      }
      if (!context.mounted) return;
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return;
      } else {
        String? filelink;

        // Check if a file is selected and ready to upload
        if (model.uploadedLocalFile.bytes?.isNotEmpty ?? false) {
          final List<Uint8List?> filesData = [model.uploadedLocalFile.bytes];

          // Upload file and retrieve the list of links
          final List<String>? fileLinks = await apiMultiplePics.uploadPictures(
              token: token, filesData: filesData);

          // Set filelink to the first link if available
          if (fileLinks!.isNotEmpty) {
            filelink = fileLinks.first;
          }
        }
        String? username =
            konto == 'Brukernavn' ? model.brukernavnTextController.text : null;
        String? firstname = konto == 'For- og etternavn'
            ? model.fornavnTextController.text
            : null;
        String? lastname = konto == 'For- og etternavn'
            ? model.etternavnTextController.text
            : null;
        String? email =
            konto == 'E-post' ? model.emailTextController.text : null;
        String? bio = konto == 'Bio' ? model.bioTextController.text : null;
        // Only include profilepic in updateUserInfo if filelink is non-null
        final response = await userInfoService.updateUserInfo(
          token: token,
          username: username,
          firstname: firstname,
          lastname: lastname,
          email: email,
          bio: bio,
          profilepic: filelink,
          termsService: null,
        );
        final decodedBody = utf8.decode(response.bodyBytes);
        final decodedResponse = jsonDecode(decodedBody);
        if (response.statusCode == 200) {
          FFAppState().brukernavn = decodedResponse['username'] ?? '';
          FFAppState().email = decodedResponse['email'] ?? '';
          FFAppState().firstname = decodedResponse['firstname'] ?? '';
          FFAppState().lastname = decodedResponse['lastname'] ?? '';
          FFAppState().bio = decodedResponse['bio'] ?? '';
          FFAppState().profilepic = decodedResponse['profilepic'] ?? '';
          FFAppState().termsService = decodedResponse['termsService'] ?? false;

          model.isLoading = false;
          final appState = FFAppState();
          appState.updateUI();
          if (!context.mounted) return;
          Navigator.pop(context);
          showToast('Lagret', false);
          return;
        } else if (response.statusCode == 401) {
          model.isLoading = false;
          FFAppState().login = false;
          if (!context.mounted) return;
          context.goNamed('registrer');
          return;
        }
        if (decodedResponse['username'] == 'username_change_too_soon') {
          model.isLoading = false;
          showToast('Du må vente før du kan endre brukernavnet igjen', false);
          navigate('', true);
        }
        if (response.statusCode == 500) {
          model.isLoading = false;
          showToast('Brukernavnet er allerede brukt av en annen bruker', false);
        }
      }
      model.isLoading = false;
    } on SocketException {
      model.isLoading = false;
      showToast('Ingen internettforbindelse', false);
    } catch (e) {
      model.isLoading = false;
      showToast('En feil oppstod', false);
    }
  }

//
}
