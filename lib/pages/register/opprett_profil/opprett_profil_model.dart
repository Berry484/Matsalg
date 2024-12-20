import '../../../helper_components/flutter_flow/flutter_flow_util.dart';
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

    if (val.length < 4) {
      return 'Brukernavnet må minst være 4 tegn';
    }

    if (!RegExp(kTextValidatorUsernameRegex).hasMatch(val)) {
      return 'Brukernavnet er ugyldig';
    }
    return null;
  }

  // State field(s) for Fornavn widget.
  FocusNode? fornavnFocusNode;
  TextEditingController? fornavnTextController;
  String? Function(BuildContext, String?)? fornavnTextControllerValidator;
  String? _fornavnTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
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
      return 'Ugyldig etternavn';
    }

    return null;
  }

  // State field(s) for email widget.
  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;
  String? _emailTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'E-post  opptatt eller ugyldig';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'E-post adressen er ugyldig';
    }
    return null;
  }

  // State field(s) for Passord widget.
  FocusNode? passordFocusNode;
  TextEditingController? passordTextController;
  late bool passordVisibility;
  String? Function(BuildContext, String?)? passordTextControllerValidator;
  String? _passordTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Passordet må minst være 7 tegn';
    }

    if (val.length < 7) {
      return 'Krever minst 7 tegn';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    brukernavnTextControllerValidator = _brukernavnTextControllerValidator;
    fornavnTextControllerValidator = _fornavnTextControllerValidator;
    etternavnTextControllerValidator = _etternavnTextControllerValidator;
    emailTextControllerValidator = _emailTextControllerValidator;
    passordVisibility = false;
    passordTextControllerValidator = _passordTextControllerValidator;
  }

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

    passordFocusNode?.dispose();
    passordTextController?.dispose();
  }
}
