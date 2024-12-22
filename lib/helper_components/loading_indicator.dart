import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//-----------------------------------------------------------------------------------------------------------------------
//--------------------Shows a basic loading indicator from cupertino in the middle of the page---------------------------
//-----------------------------------------------------------------------------------------------------------------------
void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black26,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false, // Disable the back button
        child: Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CupertinoActivityIndicator(
                  radius: 12,
                  color: Colors.blue, // Adjust color as needed
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
