import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogUtils {
//---------------------------------------------------------------------------------------------------------------
//--------------------Displays a custom cupertino dialog---------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  static Future<void> showSimpleDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String buttonText,
    VoidCallback? onButtonPressed,
  }) async {
    await showDialog(
      context: context,
      builder: (alertDialogContext) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(alertDialogContext); // Dismiss the dialog
                if (onButtonPressed != null) {
                  onButtonPressed(); // Execute the callback
                }
              },
              child: Text(
                buttonText,
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

//
}
