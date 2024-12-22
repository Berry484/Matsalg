import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/helper_components/toasts.dart';
import 'package:mat_salg/logging.dart';
import 'package:mat_salg/services/location_service.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'publish_model.dart';
export 'publish_model.dart';

class PublishServices {
  final PublishModel model;
  final LocationService locationService = LocationService();
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final ImagePicker picker = ImagePicker();

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
  Future<void> getKommune(BuildContext context, double lat, double lng) async {
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

    double enteredQuantity =
        double.tryParse(model.antallStkTextController.text.trim()) ?? 0.0;
    bool quantityChanged = (enteredQuantity != (model.matvare.antall ?? 0.0));
    bool imgChanged = false;
    if (!rediger) {
      imgChanged = model.unselectedImages[0].path != 'ImagePlaceHolder.jpg' ||
          model.unselectedImages[1].path != 'ImagePlaceHolder.jpg' ||
          model.unselectedImages[2].path != 'ImagePlaceHolder.jpg' ||
          model.unselectedImages[3].path != 'ImagePlaceHolder.jpg' ||
          model.unselectedImages[4].path != 'ImagePlaceHolder.jpg';
    } else {
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
        quantityChanged ||
        imgChanged;
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Allows user to select either a single or multiple images to upload-------------------------
//---------------------------------------------------------------------------------------------------------------
  Future<void> selectImages(BuildContext context) async {
    try {
      // Show the Cupertino Action Sheet for choosing Camera or Gallery
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
          imageQuality: 80,
          maxWidth: 1200.00,
          maxHeight: 1200.00,
        );
        if (pickedImage != null) {
          pickedImages = [pickedImage];
        }
      } else if (choice == 'gallery') {
        if (placeholderCount >= 2) {
          pickedImages = await picker.pickMultiImage(
            imageQuality: 80,
            limit: placeholderCount,
            maxWidth: 1200.00,
            maxHeight: 1200.00,
          );
        } else {
          pickedImage = await picker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 80,
            maxWidth: 1200.00,
            maxHeight: 1200.00,
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
      } else {
        logger.d('No image was selected');
      }
    } catch (e) {
      logger.e('Error selecting images: $e');
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Updates the lat lng selected by the user---------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  void updateSelectedLatLng(BuildContext context, LatLng? newLatLng) {
    try {
      model.selectedLatLng = null;

      Timer(const Duration(milliseconds: 100), () {
        model.selectedLatLng = newLatLng;
      });
    } on SocketException {
      logger.e('Socket error in updateSelectedLatLng');
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      logger.e('Exception error in updateSelectedLatLng');
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

//
}
