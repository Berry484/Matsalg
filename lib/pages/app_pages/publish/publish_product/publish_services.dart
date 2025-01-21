import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/helper_components/widgets/loading_indicators/loading_indicator.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/logging.dart';
import 'package:mat_salg/services/food_service.dart';
import 'package:mat_salg/services/image_service.dart';
import 'package:mat_salg/services/location_service.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'publish_model.dart';
export 'publish_model.dart';

class PublishServices {
  final PublishModel model;
  final LocationService locationService = LocationService();
  final ApiFoodService apiFoodService = ApiFoodService();
  final ApiMultiplePics apiMultiplePics = ApiMultiplePics();
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final ImagePicker picker = ImagePicker();
  final appState = FFAppState();

  PublishServices({required this.model});

//---------------------------------------------------------------------------------------------------------------
//--------------------Gets the current user location if available------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  Future<void> getUserLocation(BuildContext context) async {
    LatLng? location;
    location =
        await getCurrentUserLocation(defaultLocation: const LatLng(0.0, 0.0));
    if (location != const LatLng(0.0, 0.0)) {
      if (!context.mounted) return;
      String? token = await firebaseAuthService.getToken(context);

      if (token == null) {
        return;
      } else {
        String? response = await locationService.getKommune(
            token, location.latitude, location.longitude);
        if (response.isNotEmpty) {
          String formattedResponse =
              response[0].toUpperCase() + response.substring(1).toLowerCase();

          FFAppState().kommune = formattedResponse;
          model.kommune = formattedResponse;
        }

        model.selectedLatLng = LatLng(location.latitude, location.longitude);
        model.currentselectedLatLng = model.selectedLatLng;
      }
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Gets the kommmune of a specific lat lng----------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  void getKommune(BuildContext context, double lat, double lng) async {
    try {
      if (lat == 0 || lng == 0) {
        return;
      }
      String? token = await firebaseAuthService.getToken(context);

      if (token == null) {
        return;
      } else {
        String? response = await locationService.getKommune(token, lat, lng);

        if (response.isNotEmpty) {
          // Convert the response to lowercase and then capitalize the first letter
          String formattedResponse =
              response[0].toUpperCase() + response.substring(1).toLowerCase();

          FFAppState().kommune = formattedResponse;

          model.kommune = formattedResponse;
          appState.updateUI();
        }
      }
    } on SocketException {
      logger.e('Socket error in GetKommune');
      if (!context.mounted) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      logger.e('Exception error in GetKommune');
      if (!context.mounted) return;
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Returns true or false if there has been made any changes on a page-------------------------
//---------------------------------------------------------------------------------------------------------------
  bool hasChanges(BuildContext context, bool rediger) {
    bool nameChanged = model.produktNavnTextController.text.trim() !=
        (model.matvare.name ?? '').trim();
    bool descriptionChanged =
        model.produktBeskrivelseTextController.text.trim() !=
            (model.matvare.description ?? '').trim();
    bool priceChanged = model.produktPrisSTKTextController.text.trim() !=
        (model.matvare.price ?? '').toString();
    bool imgChanged = false;
    bool kjoptChanged = false;
    if (!rediger) {
      imgChanged = model.unselectedImages[0].path != 'ImagePlaceHolder.jpg' ||
          model.unselectedImages[1].path != 'ImagePlaceHolder.jpg' ||
          model.unselectedImages[2].path != 'ImagePlaceHolder.jpg' ||
          model.unselectedImages[3].path != 'ImagePlaceHolder.jpg' ||
          model.unselectedImages[4].path != 'ImagePlaceHolder.jpg';
    } else {
      if (model.matvare.kjopt != model.kjopt) {
        kjoptChanged = true;
      }
      for (int i = 0;
          i < model.unselectedImages.length &&
              i < model.matvare.imgUrls!.length;
          i++) {
        if (model.unselectedImages[i].path != model.matvare.imgUrls![i]) {
          imgChanged = true;
          break;
        }
      }
    }

    return nameChanged ||
        descriptionChanged ||
        priceChanged ||
        imgChanged ||
        kjoptChanged;
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Allows user to select either a single or multiple images to upload-------------------------
//---------------------------------------------------------------------------------------------------------------
  Future<void> selectImages(BuildContext context) async {
    try {
      final String? choice = await showCupertinoModalPopup<String>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context, 'camera'); // Camera choice
                },
                child: const Text(
                  'Kamera',
                  style: TextStyle(
                    fontSize: 19,
                    color: CupertinoColors.systemBlue,
                  ),
                ),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context, 'gallery');
                },
                child: const Text(
                  'Bildegalleri',
                  style: TextStyle(
                    fontSize: 19,
                    color: CupertinoColors.systemBlue,
                  ),
                ),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              isDestructiveAction: true,
              child: const Text(
                'Avbryt',
                style: TextStyle(
                  fontSize: 19,
                  color: CupertinoColors.systemRed,
                ),
              ),
            ),
          );
        },
      );

      if (choice == null) {
        return;
      }

      List<XFile>? pickedImages;
      XFile? pickedImage;

      List<XFile>? placeholderImages = model.unselectedImages
          .where((image) => image.name == 'ImagePlaceHolder.jpg')
          .toList();

      int placeholderCount = placeholderImages.length;

      if (choice == 'camera') {
        pickedImage = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 75,
          maxWidth: 750.00,
          maxHeight: 1000.00,
        );
        if (pickedImage != null) {
          pickedImages = [pickedImage];
        }
      } else if (choice == 'gallery') {
        if (placeholderCount >= 2) {
          pickedImages = await picker.pickMultiImage(
            limit: placeholderCount,
            imageQuality: 75,
            maxWidth: 750.00,
            maxHeight: 1000.00,
          );
        } else {
          pickedImage = await picker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 75,
            maxWidth: 750.00,
            maxHeight: 1000.00,
          );

          if (pickedImage != null) {
            pickedImages = [pickedImage];
          }
        }
      }

      if (pickedImages != null && pickedImages.isNotEmpty) {
        int selectedIndex = 0;
        for (int i = 0; i < model.unselectedImages.length; i++) {
          if (model.unselectedImages[i].path == 'ImagePlaceHolder.jpg' &&
              selectedIndex < pickedImages.length) {
            model.unselectedImages[i] = pickedImages[selectedIndex];
            selectedIndex++;
          }
          if (selectedIndex >= pickedImages.length) break;
        }
        model.selectedImages.addAll(pickedImages.sublist(selectedIndex));
        model.errorImage = null;
      } else {
        logger.d('No image was selected');
      }
    } catch (e) {
      logger.e('Error selecting images: $e');
    }
  }

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
        model.errorLocation = null;
        model.errorCategory = null;

        if (!validateModel()) {
          model.oppdaterLoading = false;
          return;
        }

        return;
      }
      if (model.oppdaterLoading) {
        return;
      }

      model.errorLocation = null;
      model.errorCategory = null;

      if (!validateModel()) {
        model.oppdaterLoading = false;
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

        final response = await apiFoodService.updateFood(
          token: token,
          id: model.matvare.matId,
          name: model.produktNavnTextController.text,
          imgUrl: combinedLinks,
          description: model.produktBeskrivelseTextController.text,
          price: pris,
          kategorier: model.kategori,
          posisjon: model.selectedLatLng,
          accuratePosition: model.accuratePosition,
          betaling: null,
          kg: kg,
          kjopt: model.kjopt,
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
    Function(String path, bool pop, String? imgPath) navigate,
  ) async {
    try {
      final nonPlaceholderImages = model.unselectedImages
          .where((image) => image.path != 'ImagePlaceHolder.jpg')
          .toList();

      if (model.formKey.currentState == null ||
          !model.formKey.currentState!.validate()) {
        if (!validateModel()) {
          model.oppdaterLoading = false;
          return;
        }
        return;
      }

      model.errorLocation = null;
      model.errorCategory = null;

      if (!validateModel()) {
        model.oppdaterLoading = false;
        return;
      }
      showLoadingDialog(context);

      final selectedImage = nonPlaceholderImages.first;
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
            betaling: null,
            accuratePosition: model.accuratePosition,
            kg: kg,
          );

          if (response.statusCode == 200) {
            navigate('BrukerLagtUtInfo', false, selectedImage.path);
          }
          if (response.statusCode == 401 ||
              response.statusCode == 404 ||
              response.statusCode == 500) {
            model.oppdaterLoading = false;
            FFAppState().login = false;
            navigate('registrer', false, null);
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
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  bool validateModel() {
    final nonPlaceholderImages = model.unselectedImages
        .where((image) => image.path != 'ImagePlaceHolder.jpg')
        .toList();
    bool canScroll = true;

    // Reset all error messages
    model.errorLocation = null;
    model.errorCategory = null;
    model.errorImage = null;

    // Validate images
    if (nonPlaceholderImages.isEmpty) {
      model.errorImage = 'Vennligst legg til minst ett bilde';
      if (model.topKey.currentContext != null) {
        Scrollable.ensureVisible(model.topKey.currentContext!,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        canScroll = false;
      }
    }

    if (model.titleValid != true && canScroll) {
      if (model.topKey.currentContext != null) {
        Scrollable.ensureVisible(model.topKey.currentContext!,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        canScroll = false;
      }
    }

    // Validate category
    if (model.kategori == null) {
      model.errorCategory = 'Felt må fylles ut';
      if (model.imageKey.currentContext != null && canScroll) {
        Scrollable.ensureVisible(model.imageKey.currentContext!,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        canScroll = false;
      }
    }

    // Validate location
    if (model.selectedLatLng == null) {
      model.errorLocation = 'Vennligst velg en posisjon';
    }

    // Validate description
    if (model.beskrivelseValid != true && canScroll) {
      if (model.titleKey.currentContext != null) {
        Scrollable.ensureVisible(model.titleKey.currentContext!,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        canScroll = false;
      }
    }

    // Validate price
    if (model.priceValid != true && canScroll) {
      if (model.titleKey.currentContext != null) {
        Scrollable.ensureVisible(model.titleKey.currentContext!,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        canScroll = false;
      }
    }

    // If any validation failed, set loading to false and return false
    if (!canScroll ||
        model.errorLocation != null ||
        model.errorCategory != null ||
        model.errorImage != null) {
      model.oppdaterLoading = false;
      return false;
    }

    // Validation passed
    return true;
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
                    "Er du sikker på at du vil markere varen som utsolgt?",
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
