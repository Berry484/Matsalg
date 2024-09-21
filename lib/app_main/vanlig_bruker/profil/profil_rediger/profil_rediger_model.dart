import '/flutter_flow/flutter_flow_util.dart';
import 'profil_rediger_widget.dart' show ProfilRedigerWidget;
import 'package:flutter/material.dart';

class ProfilRedigerModel extends FlutterFlowModel<ProfilRedigerWidget> {
  ///  State fields for stateful widgets in this page.

  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  // State field(s) for TlfNummer widget.
  FocusNode? tlfNummerFocusNode;
  TextEditingController? tlfNummerTextController;
  String? Function(BuildContext, String?)? tlfNummerTextControllerValidator;
  // State field(s) for Navn widget.
  FocusNode? navnFocusNode;
  TextEditingController? navnTextController;
  String? Function(BuildContext, String?)? navnTextControllerValidator;
  // State field(s) for Email widget.
  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tlfNummerFocusNode?.dispose();
    tlfNummerTextController?.dispose();

    navnFocusNode?.dispose();
    navnTextController?.dispose();

    emailFocusNode?.dispose();
    emailTextController?.dispose();
  }
}
