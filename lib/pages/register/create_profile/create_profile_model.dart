import '../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'create_profile_widget.dart' show OpprettProfilWidget;
import 'package:flutter/material.dart';

class OpprettProfilModel extends FlutterFlowModel<OpprettProfilWidget> {
  final formKey = GlobalKey<FormState>();
//---------------------------------------------------------------------------------------------------------------
//--------------------Variables used througout-------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  bool isDataUploading = false;
  late bool passordVisibility;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes, Controllers and validators-----------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  FocusNode? brukernavnFocusNode;
  FocusNode? etternavnFocusNode;
  FocusNode? passordFocusNode;
  FocusNode? fornavnFocusNode;
  FocusNode? emailFocusNode;

  TextEditingController? brukernavnTextController;
  TextEditingController? fornavnTextController;
  TextEditingController? etternavnTextController;
  TextEditingController? emailTextController;
  TextEditingController? passordTextController;

//---------------------------------------------------------------------------------------------------------------
//--------------------Validators---------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
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

  String? _passordTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Passordet må minst være 7 tegn';
    }

    if (val.length < 7) {
      return 'Krever minst 7 tegn';
    }

    return null;
  }

  String? _emailTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'E-post  opptatt eller ugyldig';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'E-post adressen er ugyldig';
    }
    return null;
  }

  String? _etternavnTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Ugyldig etternavn';
    }

    return null;
  }

  String? _fornavnTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Ugyldig fornavn';
    }

    return null;
  }

  String? Function(BuildContext, String?)? passordTextControllerValidator;
  String? Function(BuildContext, String?)? emailTextControllerValidator;
  String? Function(BuildContext, String?)? etternavnTextControllerValidator;
  String? Function(BuildContext, String?)? fornavnTextControllerValidator;
  String? Function(BuildContext, String?)? brukernavnTextControllerValidator;

//---------------------------------------------------------------------------------------------------------------
//--------------------Initstate and dispose----------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
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

//
}
