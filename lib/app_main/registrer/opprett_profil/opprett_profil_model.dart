import '/flutter_flow/flutter_flow_util.dart';
import 'opprett_profil_widget.dart' show OpprettProfilWidget;
import 'package:flutter/material.dart';

class OpprettProfilModel extends FlutterFlowModel<OpprettProfilWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  // State field(s) for Brukernavn widget.
  FocusNode? brukernavnFocusNode;
  TextEditingController? brukernavnTextController;
  String? Function(BuildContext, String?)? brukernavnTextControllerValidator;
  String? _brukernavnTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Brukernavn  opptatt eller ugyldig';
    }

    if (!RegExp(kTextValidatorUsernameRegex).hasMatch(val)) {
      return 'Brukernavn ugyldig';
    }
    return null;
  }

  // State field(s) for Fornavn widget.
  FocusNode? fornavnFocusNode;
  TextEditingController? fornavnTextController;
  String? Function(BuildContext, String?)? fornavnTextControllerValidator;
  String? _fornavnTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Felt må fylles ut';
    }

    if (!RegExp(kTextValidatorUsernameRegex).hasMatch(val)) {
      return 'Ugyldig fornavn';
    }
    return null;
  }

  // State field(s) for Etternavn widget.
  FocusNode? etternavnFocusNode;
  TextEditingController? etternavnTextController;
  String? Function(BuildContext, String?)? etternavnTextControllerValidator;
  String? _etternavnTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Felt må fylles ut';
    }

    if (!RegExp(kTextValidatorUsernameRegex).hasMatch(val)) {
      return 'Ugyldig etternavn';
    }

    return null;
  }

  // State field(s) for Bio widget.
  FocusNode? bioFocusNode;
  TextEditingController? bioTextController;
  String? Function(BuildContext, String?)? bioTextControllerValidator;

  @override
  void initState(BuildContext context) {
    brukernavnTextControllerValidator = _brukernavnTextControllerValidator;
    fornavnTextControllerValidator = _fornavnTextControllerValidator;
    etternavnTextControllerValidator = _etternavnTextControllerValidator;
  }

  @override
  void dispose() {
    brukernavnFocusNode?.dispose();
    brukernavnTextController?.dispose();

    fornavnFocusNode?.dispose();
    fornavnTextController?.dispose();

    etternavnFocusNode?.dispose();
    etternavnTextController?.dispose();

    bioFocusNode?.dispose();
    bioTextController?.dispose();
  }
}
