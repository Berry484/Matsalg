import '/flutter_flow/flutter_flow_util.dart';
import 'bekreft_t_l_f_widget.dart' show BekreftTLFWidget;
import 'package:flutter/material.dart';

class BekreftTLFModel extends FlutterFlowModel<BekreftTLFWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for emailAddress-Create widget.
  FocusNode? emailAddressCreateFocusNode;
  TextEditingController? emailAddressCreateTextController;
  String? Function(BuildContext, String?)?
      emailAddressCreateTextControllerValidator;
  String? _emailAddressCreateTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for Telefonnummer widget.
  FocusNode? telefonnummerFocusNode;
  TextEditingController? telefonnummerTextController;
  String? Function(BuildContext, String?)? telefonnummerTextControllerValidator;
  String? _telefonnummerTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for Checkbox widget.
  bool? checkboxValue;

  @override
  void initState(BuildContext context) {
    emailAddressCreateTextControllerValidator =
        _emailAddressCreateTextControllerValidator;
    telefonnummerTextControllerValidator =
        _telefonnummerTextControllerValidator;
  }

  @override
  void dispose() {
    emailAddressCreateFocusNode?.dispose();
    emailAddressCreateTextController?.dispose();

    telefonnummerFocusNode?.dispose();
    telefonnummerTextController?.dispose();
  }
}
