import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:mat_salg/helper_components/widgets/loading_indicator.dart';
import 'package:mat_salg/pages/app_pages/orders/give_rating/rating_page.dart';
import 'package:mat_salg/services/food_service.dart';
import 'package:mat_salg/services/purchase_service.dart';
import 'info_model.dart';

class InfoServices {
  final InfoModel model;
  final OrdreInfo ordreInfo;
  final ApiFoodService apiFoodService = ApiFoodService();
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();

  InfoServices({required this.model, required this.ordreInfo});

//---------------------------------------------------------------------------------------------------------------
//--------------------Returns the correct status for the product-------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  String getStatusText() {
    if (ordreInfo.trekt == true) {
      return ordreInfo.kjopte == true
          ? 'Du trakk budet'
          : 'Kjøperen trakk budet';
    }
    if (ordreInfo.godkjent != true &&
        ordreInfo.hentet != true &&
        ordreInfo.trekt != true &&
        ordreInfo.avvist != true) {
      return ordreInfo.kjopte == true
          ? 'Venter svar fra selgeren'
          : 'Svar på budet';
    }
    if (ordreInfo.avvist == true) {
      return ordreInfo.kjopte == true
          ? 'Selgeren avslo budet'
          : 'Du avslo budet';
    }
    if (ordreInfo.godkjent == true && ordreInfo.hentet != true) {
      return ordreInfo.kjopte == true
          ? 'Budet er godkjent,\nkontakt selgeren'
          : 'Budet er godkjent,\nkontakt kjøperen';
    }
    if (ordreInfo.hentet == true) {
      return ordreInfo.kjopte == true
          ? 'Kjøpet er fullført'
          : 'Salget er fullført';
    }
    return '';
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Enters a conversation with a user----------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  Future<void> enterConversation(
    BuildContext context,
  ) async {
    try {
      if (model.loading) return;
      model.loading = true;

      Conversation existingConversation = FFAppState().conversations.firstWhere(
        (conv) =>
            conv.user ==
            (ordreInfo.kjopte == true ? ordreInfo.selger : ordreInfo.kjoper),
        orElse: () {
          // If no conversation is found, create a new one and add it to the list
          final newConversation = Conversation(
            username: (ordreInfo.kjopte == true
                ? ordreInfo.selgerUsername ?? ''
                : ordreInfo.kjoperUsername ?? ''),
            user:
                ordreInfo.kjopte == true ? ordreInfo.selger : ordreInfo.kjoper,
            deleted: false,
            lastactive: ordreInfo.kjopte == true
                ? ordreInfo.foodDetails.lastactive
                : ordreInfo.lastactive,
            profilePic: ordreInfo.kjopte == true
                ? ordreInfo.foodDetails.profilepic ?? ''
                : ordreInfo.kjoperProfilePic ?? '',
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

//---------------------------------------------------------------------------------------------------------------
//--------------------The user confirms that the product is received--------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  Future<void> confirmReceived(
    BuildContext context,
  ) async {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("Bekreftelse"),
          content: const Text("Bekrefter du at du har mottatt matvaren?"),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Nei, avbryt",
                style: TextStyle(color: Colors.red),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () async {
                try {
                  if (model.loading) return;

                  model.loading = true;
                  showLoadingDialog(context);
                  String? token = await firebaseAuthService.getToken(context);
                  if (token != null) {
                    final response = await PurchaseService.hentMat(
                        id: ordreInfo.id, hentet: true, token: token);
                    if (response.statusCode == 200) {
                      if (!context.mounted) return;
                      Toasts.showAccepted(context, 'Handelen er fullført');
                      if (model.loading) {
                        if (!context.mounted) return;
                        model.loading = false;
                        Navigator.of(context).pop();
                      }
                      Navigator.pop(context);
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        isDismissible: false,
                        enableDrag: false,
                        backgroundColor: Colors.transparent,
                        barrierColor: const Color.fromARGB(60, 17, 0, 0),
                        useRootNavigator: true,
                        context: context,
                        builder: (context) {
                          return GestureDetector(
                            onTap: () => FocusScope.of(context).unfocus(),
                            child: Padding(
                              padding: MediaQuery.viewInsetsOf(context),
                              child: RatingPage(
                                  kjop: true, username: ordreInfo.selger),
                            ),
                          );
                        },
                      ).then((value) => model.loading = false);
                    } else {
                      if (!context.mounted) return;
                      if (model.loading) {
                        model.loading = false;
                        Navigator.of(context).pop();
                      }
                      Toasts.showErrorToast(
                          context, 'En uforventet feil oppstod');
                    }
                  }
                } on SocketException {
                  if (!context.mounted) return;
                  if (model.loading) {
                    model.loading = false;
                    Navigator.of(context).pop();
                  }
                  Toasts.showErrorToast(context, 'Ingen internettforbindelse');
                } catch (e) {
                  if (!context.mounted) return;
                  if (model.loading) {
                    model.loading = false;
                    Navigator.of(context).pop();
                  }
                  Navigator.pop(context);
                  Toasts.showErrorToast(context, 'En feil oppstod');
                }
              },
              child: const Text(
                "Ja, bekreft",
                style: TextStyle(
                  color: CupertinoColors.systemBlue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------The user cancels his bid-------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  Future<void> cancelBid(
    BuildContext context,
  ) async {
    try {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text("Bekreftelse"),
            content:
                const Text("Er du sikker på at du ønsker å trekke budet ditt?"),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  if (model.loading) {
                    return;
                  }
                  model.loading = true;
                  Navigator.of(context).pop();
                  model.loading = false;
                },
                child: const Text(
                  "Nei",
                  style: TextStyle(
                    color: CupertinoColors.systemBlue,
                  ),
                ),
              ),
              CupertinoDialogAction(
                onPressed: () async {
                  try {
                    if (model.loading) return;
                    model.loading = true;
                    showLoadingDialog(context);
                    String? token = await firebaseAuthService.getToken(context);
                    if (token != null) {
                      final response = await PurchaseService.trekk(
                          id: ordreInfo.id, trekt: true, token: token);
                      if (response.statusCode == 200) {
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                        Navigator.pop(context);
                        Toasts.showAccepted(context, 'Budet ble trekt');
                        Navigator.pop(context);
                      } else {
                        if (!context.mounted) return;
                        if (model.loading) {
                          model.loading = false;
                          Navigator.of(context).pop();
                        }
                        Navigator.pop(context);
                        Toasts.showErrorToast(
                            context, 'En uforventet feil oppstod');
                        return;
                      }
                    }
                  } catch (e) {
                    if (!context.mounted) return;
                    if (model.loading) {
                      model.loading = false;
                      Navigator.of(context).pop();
                    }
                    Navigator.pop(context);
                    Toasts.showErrorToast(
                        context, 'En uforventet feil oppstod');
                    return;
                  }
                },
                child: const Text(
                  "Ja",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
    } on SocketException {
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------The user declines the bid from the buyer---------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  Future<void> declineBid(
    BuildContext context,
  ) async {
    try {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text("Bekreftelse"),
            content: const Text("Er du sikker på at du ønsker å avslå budet?"),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  model.loading = false;
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Nei, avbryt",
                  style: TextStyle(
                    color: CupertinoColors.systemBlue,
                  ),
                ),
              ),
              CupertinoDialogAction(
                onPressed: () async {
                  try {
                    if (model.loading) return;

                    model.loading = true;
                    showLoadingDialog(context);
                    String? token = await firebaseAuthService.getToken(context);
                    if (token != null) {
                      final response = await PurchaseService.avvis(
                          id: ordreInfo.id,
                          avvist: true,
                          godkjent: false,
                          token: token);

                      if (response.statusCode == 200) {
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                        Navigator.pop(context);
                        Toasts.showAccepted(context, 'Budet ble avslått');
                        Navigator.pop(context);
                      } else {
                        if (!context.mounted) return;
                        if (model.loading) {
                          model.loading = false;
                          Navigator.of(context).pop();
                        }
                        Toasts.showErrorToast(
                            context, 'En uforventet feil oppstod');
                        return;
                      }
                    }
                  } on SocketException {
                    if (!context.mounted) return;
                    if (model.loading) {
                      model.loading = false;
                      Navigator.of(context).pop();
                    }
                    Toasts.showErrorToast(
                        context, 'Ingen internettforbindelse');
                  } catch (e) {
                    if (!context.mounted) return;
                    if (model.loading) {
                      model.loading = false;
                      Navigator.of(context).pop();
                    }
                    Toasts.showErrorToast(context, 'En feil oppstod');
                  }
                },
                child: const Text(
                  "Ja, avslå",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
    } on SocketException {
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------The user accepts the bid from the buyer---------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  Future<void> acceptBid(
    BuildContext context,
  ) async {
    try {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          bool godkjennIsLoading = false;
          return CupertinoAlertDialog(
            title: const Text("Bekreftelse"),
            content: const Text("Er du sikker på at du ønsker å godta budet?"),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text(
                  "Nei, avbryt",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w400),
                ),
              ),
              CupertinoDialogAction(
                onPressed: () async {
                  try {
                    if (godkjennIsLoading) return;

                    godkjennIsLoading = true;
                    showLoadingDialog(context);
                    String? token = await firebaseAuthService.getToken(context);
                    if (token != null) {
                      final response = await PurchaseService.svarBud(
                          id: ordreInfo.id, godkjent: true, token: token);
                      if (response.statusCode == 200) {
                        if (!context.mounted) {
                          return;
                        }
                        Navigator.of(context).pop();
                        Navigator.pop(context);
                        Toasts.showAccepted(context, 'Budet ble godkjent');
                        Navigator.pop(context);
                      } else {
                        if (!context.mounted) {
                          return;
                        }
                        if (model.loading) {
                          model.loading = false;
                          Navigator.of(context).pop();
                        }
                        Toasts.showErrorToast(
                            context, 'En uforventet feil oppstod');
                        return;
                      }
                    }
                  } on SocketException {
                    if (!context.mounted) return;
                    if (model.loading) {
                      model.loading = false;
                      Navigator.of(context).pop();
                    }
                    Toasts.showErrorToast(
                        context, 'Ingen internettforbindelse');
                  } catch (e) {
                    if (!context.mounted) return;
                    if (model.loading) {
                      model.loading = false;
                      Navigator.of(context).pop();
                    }
                    Toasts.showErrorToast(context, 'En feil oppstod');
                  }
                },
                child: const Text("Ja, godta",
                    style: TextStyle(
                      color: CupertinoColors.systemBlue,
                    )),
              ),
            ],
          );
        },
      );
    } on SocketException {
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

//
}
