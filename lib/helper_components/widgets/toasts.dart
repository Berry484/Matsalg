import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_theme.dart';

class Toasts {
//-----------------------------------------------------------------------------------------------------------------------
//--------------------Shows a basic error toast at the top of the page. this is used to tell the user an error occured---
//-----------------------------------------------------------------------------------------------------------------------
  static void showErrorToast(BuildContext context, String message) {
    HapticFeedback.lightImpact();
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 55.0,
        left: 16.0,
        right: 16.0,
        child: Material(
          color: Colors.transparent,
          child: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.up,
            onDismissed: (_) => overlayEntry.remove(),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(70, 0, 0, 0),
                    blurRadius: 1.0,
                    offset: Offset(0, 0.5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(height: 30),
                  const Icon(
                    FontAwesomeIcons.solidCircleXmark,
                    color: Colors.black,
                    size: 30.0,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      message,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Nunito',
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 17,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w700,
                          ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

//-----------------------------------------------------------------------------------------------------------------------
//--------------------Shows a basic toast that tells the user the action worked------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------
  static void showAccepted(BuildContext context, String message) {
    HapticFeedback.lightImpact();
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 56.0,
        left: 16.0,
        right: 16.0,
        child: Material(
          color: Colors.transparent,
          child: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.up, // Allow dismissing upwards
            onDismissed: (_) =>
                overlayEntry.remove(), // Remove overlay on dismiss
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(70, 0, 0, 0),
                    blurRadius: 1.0,
                    offset: Offset(0, 0.5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(height: 30),
                  Icon(
                    CupertinoIcons.checkmark_alt_circle_fill,
                    color: FlutterFlowTheme.of(context).alternate,
                    size: 35.0,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      message,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Nunito',
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 17,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

//
}
