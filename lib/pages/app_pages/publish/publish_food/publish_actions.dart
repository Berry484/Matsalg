import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/helper_components/loading_indicator.dart';
import 'package:mat_salg/services/food_service.dart';
import 'package:mat_salg/services/image_service.dart';
import 'package:mat_salg/services/location_service.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'publish_model.dart';
export 'publish_model.dart';

class PublishActions {
  final PublishModel model;
  final LocationService locationService = LocationService();
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final ApiFoodService apiFoodService = ApiFoodService();
  final ApiMultiplePics apiMultiplePics = ApiMultiplePics();

  PublishActions({required this.model});
//---------------------------------------------------------------------------------------------------------------
//--------------------Saves updates done to a food item----------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  Future<void> saveFoodUpdates(
    BuildContext context,
    Function(String title, String content) showDialogCallback,
    Function(String message, bool error) showToast,
    Function(String path, bool pop) navigate,
  ) async {
    try {
      if (model.formKey.currentState == null ||
          !model.formKey.currentState!.validate()) {
        return;
      }
      if (model.leggUtLoading == true) {
        return;
      }

      if (model.produktPrisSTKTextController.text.isEmpty) {
        await showDialogCallback(
          'Velg pris',
          'Velg en pris på matvaren',
        );
        model.leggUtLoading = false;
        navigate('', true);
        return;
      }

      if (model.selectedLatLng == null) {
        await showDialogCallback(
          'Velg posisjon',
          'Mangler posisjon',
        );
        model.leggUtLoading = false;
        navigate('', true);
        return;
      }

      model.leggUtLoading = true;
      showLoadingDialog(context);

      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return;
      } else {
        List<XFile> validImages = model.unselectedImages
            .where((image) =>
                image.path != 'ImagePlaceHolder.jpg' ||
                image.path.startsWith('/files/'))
            .toList();

        List<String> combinedLinks = model.unselectedImages
            .where((image) => image.path != 'ImagePlaceHolder.jpg')
            .map((image) => image.path)
            .toList();

        List<Uint8List?> filesData = [];

        for (var image in validImages) {
          try {
            Uint8List bytes = await image.readAsBytes();
            filesData.add(bytes);
          } catch (e) {
            filesData.add(null);
          }
        }

        final List<Uint8List> filteredFilesData = filesData
            .where((file) => file != null && file.isNotEmpty)
            .cast<Uint8List>()
            .toList();
        if (filteredFilesData.isNotEmpty) {
          final filelinks = await apiMultiplePics.uploadPictures(
              token: token, filesData: filteredFilesData);

          if (filelinks != null && filelinks.isNotEmpty) {
            int filelinksIndex = 0;

            for (int i = 0; i < combinedLinks.length; i++) {
              if (!combinedLinks[i].startsWith('/files/') &&
                  filelinksIndex < filelinks.length) {
                combinedLinks[i] = filelinks[filelinksIndex];
                filelinksIndex++;
              }
            }
          }
        }

        if (combinedLinks.isEmpty) {
          await showDialogCallback(
            'Mangler bilder',
            'Last opp minst 1 bilde',
          );
          model.leggUtLoading = false;
          navigate('', true);
          return;
        }

        String pris = model.produktPrisSTKTextController.text;
        bool kg = false;

        bool? kjopt;
        if (model.selectedValue == 0) {
          kjopt = true;
        } else {
          kjopt = false;
        }
        final response = await apiFoodService.updateFood(
          token: token,
          id: model.matvare.matId,
          name: model.produktNavnTextController.text,
          imgUrl: combinedLinks,
          description: model.produktBeskrivelseTextController.text,
          price: pris,
          kategorier: model.kategori,
          posisjon: model.selectedLatLng,
          antall: model.selectedValue,
          betaling: null,
          kg: kg,
          kjopt: kjopt,
        );

        if (response.statusCode == 200) {
          if (model.leggUtLoading) {
            navigate('', true);
          }
          model.leggUtLoading = false;

          navigate('', true);
          navigate('Profil', false);
          showToast('Oppdatert', false);
        } else {
          model.leggUtLoading = false;
        }
      }

      if (model.leggUtLoading) {
        navigate('', true);
      }
      model.leggUtLoading = false;
    } on SocketException {
      if (model.leggUtLoading) {
        navigate('', true);
      }
      model.leggUtLoading = false;
      showToast('Ingen internettforbindelse', true);
    } catch (e) {
      if (model.leggUtLoading) {
        navigate('', true);
      }
      model.leggUtLoading = false;
      showToast('En feil oppstod', true);
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Saves updates done to a food item----------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  Future<void> uploadFood(
    BuildContext context,
    Function(String title, String content) showDialogCallback,
    Function(String message, bool error) showToast,
    Function(String path, bool pop) navigate,
  ) async {
    try {
      if (model.formKey.currentState == null ||
          !model.formKey.currentState!.validate()) {
        return;
      }
      if (model.oppdaterLoading) {
        return;
      }

      if (model.kategori == null) {
        await showDialogCallback(
          'Mangler kategori',
          'Velg minst 1 kategori.',
        );
        model.oppdaterLoading = false;
        navigate('', true);
        return;
      }

      if (model.produktPrisSTKTextController.text.isEmpty) {
        await showDialogCallback(
          'Velg pris',
          'Velg en pris på matvaren',
        );
        model.oppdaterLoading = false;
        navigate('', true);
        return;
      }

      if (model.selectedLatLng == null) {
        await showDialogCallback(
          'Velg posisjon',
          'Mangler posisjon',
        );
        model.oppdaterLoading = false;
        navigate('', true);
        return;
      }

      model.oppdaterLoading = true;
      final token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return;
      } else {
        List<XFile> validImages = model.unselectedImages
            .where((image) => image.name != 'ImagePlaceHolder.jpg')
            .toList();

        List<Uint8List?> filesData = [];

        for (var image in validImages) {
          try {
            Uint8List bytes = await image.readAsBytes();
            filesData.add(bytes);
          } catch (e) {
            filesData.add(null);
          }
        }

        final List<Uint8List> filteredFilesData = filesData
            .where((file) => file != null && file.isNotEmpty)
            .cast<Uint8List>()
            .toList();
        final filelinks = await apiMultiplePics.uploadPictures(
          token: token,
          filesData: filteredFilesData,
        );
        String pris;
        bool kg;

        pris = model.produktPrisSTKTextController.text;
        kg = false;

        if (filelinks != null && filelinks.isNotEmpty) {
          final response = await apiFoodService.uploadfood(
            token: token,
            name: model.produktNavnTextController.text,
            imgUrl: filelinks,
            description: model.produktBeskrivelseTextController.text,
            price: int.parse(pris),
            kategorier: model.kategori,
            posisjon: model.selectedLatLng,
            antall: model.selectedValue,
            betaling: null,
            kg: kg,
          );

          if (response.statusCode == 200) {
            model.oppdaterLoading = false;
            navigate('BrukerLagtUtInfo', false);
          }
          if (response.statusCode == 401 ||
              response.statusCode == 404 ||
              response.statusCode == 500) {
            model.oppdaterLoading = false;
            FFAppState().login = false;
            navigate('registrer', false);
            return;
          }
        } else {
          model.oppdaterLoading = false;
          throw (Exception);
        }
        model.oppdaterLoading = false;
      }
      model.leggUtLoading = false;
    } on SocketException {
      if (model.leggUtLoading) {
        navigate('', true);
      }
      model.oppdaterLoading = false;
      showToast('Ingen internettforbindelse', true);
    } catch (e) {
      if (model.oppdaterLoading) {
        navigate('', true);
      }
      model.oppdaterLoading = false;
      showToast('En feil oppstod', true);
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Saves updates done to a food item----------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  Future<void> markSoldOut(
    BuildContext context,
    Function(String title, String content) showDialogCallback,
    Function(String message, bool error) showToast,
    Function(String path, bool pop) navigate,
  ) async {
    try {
      if (model.merSolgtIsLoading) {
        return;
      } else {
        model.merSolgtIsLoading = true;

        String? token = await firebaseAuthService.getToken(context);
        if (token == null) {
          return;
        }
        if (!context.mounted) return;
        bool confirmAction = await showCupertinoDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  title: Text("Bekreft handling"),
                  content: Text(
                    "Er du sikker på at du vil markere matvaren som utsolgt? Dette vil automatisk avslå alle bud. Du kan fjerne markeringen senere ved å øke antallet igjen.",
                  ),
                  actions: [
                    CupertinoDialogAction(
                      child: Text(
                        "Avbryt",
                        style: TextStyle(
                          fontSize: 18,
                          color: CupertinoColors.systemBlue,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                    ),
                    CupertinoDialogAction(
                      child: Text(
                        "Ja",
                        style: TextStyle(
                          fontSize: 18,
                          color: CupertinoColors.systemRed,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                    ),
                  ],
                );
              },
            ) ??
            false;

        if (confirmAction) {
          await apiFoodService.merkSolgt(
            token: token,
            id: model.matvare.matId,
            solgt: true,
          );
          if (context.mounted) Navigator.pop(context);
          navigate('Profil', false);
          showToast('Markert utsolgt', false);
        }

        model.merSolgtIsLoading = false;
      }
    } on SocketException {
      model.merSolgtIsLoading = false;
      showToast('Ingen internettforbindelse', true);
    } catch (e) {
      model.merSolgtIsLoading = false;
      showToast('En feil oppstod', true);
    }
  }

//
}
