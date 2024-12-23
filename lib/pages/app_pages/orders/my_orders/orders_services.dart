import 'dart:io';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/pages/app_pages/orders/my_orders/orders_model.dart';
import 'package:mat_salg/services/food_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:mat_salg/services/location_service.dart';
import 'package:mat_salg/services/purchase_service.dart';

class OrdersServices {
  final OrdersModel model;
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final ApiFoodService apiFoodService = ApiFoodService();
  final LocationService locationService = LocationService();
  final appState = FFAppState();

  OrdersServices({required this.model});

//---------------------------------------------------------------------------------------------------------------
//--------------------Gets the poststed for the coordinates------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  Future<void> getAll(BuildContext context) async {
    try {
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return;
      } else {
        model.alleInfo = await PurchaseService.getAll(token);
        if (context.mounted) {
          if (model.alleInfo != null && model.alleInfo!.isNotEmpty) {
            FFAppState().ordreInfo = model.alleInfo ?? [];
            model.isloading = false;

            model.ordreInfo =
                model.alleInfo!.where((order) => order.kjopte == true).toList();
            model.kjopEmpty = model.ordreInfo!.isEmpty;

            model.salgInfo = model.alleInfo!
                .where((order) => order.kjopte == false)
                .toList();
            model.salgEmpty = model.salgInfo!.isEmpty;

            model.isloading = false;
            model.salgisLoading = false;
            model.isKjopLoading = false;
          } else {
            model.kjopEmpty = true;
            model.salgEmpty = true;
          }
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

//
}
