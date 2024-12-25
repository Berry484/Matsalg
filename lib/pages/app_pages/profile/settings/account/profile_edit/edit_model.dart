import '../../../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'edit_page.dart' show EditPage;
import 'package:flutter/material.dart';

class EditModel extends FlutterFlowModel<EditPage> {
  final formKey = GlobalKey<FormState>();
//---------------------------------------------------------------------------------------------------------------
//--------------------Variables used througout-------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  String? newPassword;
  bool isLoading = false;
  bool isDataUploading = false;
  late bool passordVisibility;
  late bool passordConfirmVisibility;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes, Controllers and validators-----------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  FocusNode? brukernavnFocusNode;
  FocusNode? fornavnFocusNode;
  FocusNode? etternavnFocusNode;
  FocusNode? emailFocusNode;
  FocusNode? bioFocusNode;
  FocusNode? passwordChangeNode;
  FocusNode? passwordChangeConfirmNode;

  TextEditingController? brukernavnTextController;
  TextEditingController? fornavnTextController;
  TextEditingController? etternavnTextController;
  TextEditingController? emailTextController;
  TextEditingController? bioTextController;
  TextEditingController? passwordChangeController;
  TextEditingController? passwordChangeConfirmController;

//---------------------------------------------------------------------------------------------------------------
//--------------------Functions for the Controllers--------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------

  String? _passwordChangeControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Passordet må minst være 7 tegn';
    }

    if (val.length < 7) {
      return 'Krever minst 7 tegn';
    }

    return null;
  }

  String? _passwordChangeControllerConfirmValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Passordet må minst være 7 tegn';
    }

    if (val != passwordChangeController.text) {
      return 'Passord må være like';
    }

    if (val.length < 7) {
      return 'Krever minst 7 tegn';
    }

    return null;
  }

  String? Function(BuildContext, String?)? bioTextControllerValidator;
  String? Function(BuildContext, String?)? brukernavnTextControllerValidator;
  String? Function(BuildContext, String?)? fornavnTextControllerValidator;
  String? Function(BuildContext, String?)? etternavnTextControllerValidator;
  String? Function(BuildContext, String?)? emailTextControllerValidator;
  String? Function(BuildContext, String?)? passwordChangeControllerValidator;
  String? Function(BuildContext, String?)?
      passwordChangeControllerConfirmValidator;

//---------------------------------------------------------------------------------------------------------------
//--------------------Initstate and dispose----------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  @override
  void initState(BuildContext context) {
    passwordChangeControllerValidator = _passwordChangeControllerValidator;
    passwordChangeControllerConfirmValidator =
        _passwordChangeControllerConfirmValidator;

    passordVisibility = false;
    passordConfirmVisibility = false;
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

    bioFocusNode?.dispose();
    bioTextController?.dispose();

    passwordChangeNode?.dispose();
    passwordChangeController?.dispose();

    passwordChangeConfirmNode?.dispose();
    passwordChangeConfirmController?.dispose();
  }
}
