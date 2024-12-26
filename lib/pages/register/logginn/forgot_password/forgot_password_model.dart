import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_model.dart';
import 'forgot_password_widget.dart' show ForgotPasswordWidget;
import 'package:flutter/material.dart';

class ForgotPasswordModel extends FlutterFlowModel<ForgotPasswordWidget> {
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
//---------------------------------------------------------------------------------------------------------------
//--------------------Variables used througout-------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  late bool passordVisibility;
  late bool passordConfirmVisibility;
  bool isloading = false;
  bool otpCodeSent = false;
  bool changPassword = false;
  String? errorMessage;
  String? verificationId;
  String? newPassword;

//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes, Controllers and validators-----------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  FocusNode? telefonnummerFocusNode;
  FocusNode? landskodeFocusNode;
  FocusNode? otpCodeFocusNode;
  FocusNode? passwordChangeNode;
  FocusNode? passwordChangeConfirmNode;

  TextEditingController? otpCodeTextController;
  TextEditingController? telefonnummerTextController;
  TextEditingController? landskodeTextController;
  TextEditingController? passwordChangeController;
  TextEditingController? passwordChangeConfirmController;

//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes and controller for the text fields----------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  String? Function(BuildContext, String?)? telefonnummerTextControllerValidator;
  String? Function(BuildContext, String?)? landskodeTextControllerValidator;
  String? Function(BuildContext, String?)? otpCodeTextControllerValidator;
  String? Function(BuildContext, String?)? passwordChangeControllerValidator;
  String? Function(BuildContext, String?)?
      passwordChangeControllerConfirmValidator;

  String? _telefonnummerTextControllerValidator(
      BuildContext context, String? val) {
    return null; // No validation errors.
  }

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

    if (val != passwordChangeController?.text) {
      return 'Passord må være like';
    }

    if (val.length < 7) {
      return 'Krever minst 7 tegn';
    }

    return null;
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Initstate and dispose----------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  @override
  void initState(BuildContext context) {
    telefonnummerTextControllerValidator =
        _telefonnummerTextControllerValidator;
    passwordChangeControllerValidator = _passwordChangeControllerValidator;
    passwordChangeControllerConfirmValidator =
        _passwordChangeControllerConfirmValidator;

    passordVisibility = false;
    passordConfirmVisibility = false;
  }

  @override
  void dispose() {
    telefonnummerFocusNode?.dispose();
    telefonnummerTextController?.dispose();

    landskodeFocusNode?.dispose();
    landskodeTextController?.dispose();

    otpCodeFocusNode?.dispose();
    otpCodeTextController?.dispose();

    passwordChangeNode?.dispose();
    passwordChangeController?.dispose();

    passwordChangeConfirmNode?.dispose();
    passwordChangeConfirmController?.dispose();
  }
}
