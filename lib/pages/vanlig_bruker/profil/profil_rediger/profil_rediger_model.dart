import '/flutter_flow/flutter_flow_util.dart';
import 'profil_rediger_widget.dart' show ProfilRedigerWidget;
import 'package:flutter/material.dart';

class ProfilRedigerModel extends FlutterFlowModel<ProfilRedigerWidget> {
  ///  State fields for stateful widgets in this page.

  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  // State field(s) for brukernavn widget.
  FocusNode? brukernavnFocusNode;
  TextEditingController? brukernavnTextController;
  String? Function(BuildContext, String?)? brukernavnTextControllerValidator;
  // State field(s) for fornavn widget.
  FocusNode? fornavnFocusNode;
  TextEditingController? fornavnTextController;
  String? Function(BuildContext, String?)? fornavnTextControllerValidator;
  // State field(s) for etternavn widget.
  FocusNode? etternavnFocusNode;
  TextEditingController? etternavnTextController;
  String? Function(BuildContext, String?)? etternavnTextControllerValidator;
  // State field(s) for email widget.
  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;
  // State field(s) for bio widget.
  FocusNode? bioFocusNode;
  TextEditingController? bioTextController;
  String? Function(BuildContext, String?)? bioTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    brukernavnFocusNode?.dispose();
    brukernavnTextController?.dispose();

    fornavnFocusNode?.dispose();
    fornavnTextController?.dispose();

    etternavnFocusNode?.dispose();
    etternavnTextController?.dispose();

    emailFocusNode?.dispose();
    emailTextController?.dispose();

    bioFocusNode?.dispose();
    bioTextController?.dispose();
  }
}
