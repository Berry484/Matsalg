import '/flutter_flow/flutter_flow_util.dart';
import 'registrer_widget.dart' show RegistrerWidget;
import 'package:flutter/material.dart';

class RegistrerModel extends FlutterFlowModel<RegistrerWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // State field(s) for EmailLogin widget.
  FocusNode? emailLoginFocusNode;
  TextEditingController? emailLoginTextController;
  String? Function(BuildContext, String?)? emailLoginTextControllerValidator;
  String? _emailLoginTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Felt må fylles ut';
    }

    return null;
  }

  // State field(s) for PassordLogin widget.
  FocusNode? passordLoginFocusNode;
  TextEditingController? passordLoginTextController;
  late bool passordLoginVisibility;
  String? Function(BuildContext, String?)? passordLoginTextControllerValidator;
  String? _passordLoginTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Felt må fylles ut';
    }

    return null;
  }

  // State field(s) for EpostLag widget.
  FocusNode? epostLagFocusNode;
  TextEditingController? epostLagTextController;
  String? Function(BuildContext, String?)? epostLagTextControllerValidator;
  String? _epostLagTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'E-post ugyldig eller opptatt';
    }

    // Check if the email format is valid
    if (!RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}')
        .hasMatch(val)) {
      return 'Ugyldig epostformat'; // Invalid email format
    }

    return null;
  }

  // State field(s) for PassordLag widget.
  FocusNode? passordLagFocusNode;
  TextEditingController? passordLagTextController;
  late bool passordLagVisibility;
  String? Function(BuildContext, String?)? passordLagTextControllerValidator;
  String? _passordLagTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Passord må være like';
    }

    return null;
  }

  // State field(s) for BekreftPassordLag widget.
  FocusNode? bekreftPassordLagFocusNode;
  TextEditingController? bekreftPassordLagTextController;
  late bool bekreftPassordLagVisibility;
  String? Function(BuildContext, String?)?
      bekreftPassordLagTextControllerValidator;
  String? _bekreftPassordLagTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Passord må være like';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    emailLoginTextControllerValidator = _emailLoginTextControllerValidator;
    passordLoginVisibility = false;
    passordLoginTextControllerValidator = _passordLoginTextControllerValidator;
    epostLagTextControllerValidator = _epostLagTextControllerValidator;
    passordLagVisibility = false;
    passordLagTextControllerValidator = _passordLagTextControllerValidator;
    bekreftPassordLagVisibility = false;
    bekreftPassordLagTextControllerValidator =
        _bekreftPassordLagTextControllerValidator;
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    emailLoginFocusNode?.dispose();
    emailLoginTextController?.dispose();

    passordLoginFocusNode?.dispose();
    passordLoginTextController?.dispose();

    epostLagFocusNode?.dispose();
    epostLagTextController?.dispose();

    passordLagFocusNode?.dispose();
    passordLagTextController?.dispose();

    bekreftPassordLagFocusNode?.dispose();
    bekreftPassordLagTextController?.dispose();
  }
}
