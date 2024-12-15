import '/flutter_flow/flutter_flow_util.dart';
import 'logginn_widget.dart' show LogginnWidget;
import 'package:flutter/material.dart';

class LogginnModel extends FlutterFlowModel<LogginnWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for email widget.
  FocusNode? telefonnummerFocusNode;
  TextEditingController? telefonnummerTextController;
  String? Function(BuildContext, String?)? telefonnummerTextControllerValidator;

  FocusNode? passordFocusNode;
  TextEditingController? passordTextController;
  late bool passordVisibility;
  String? Function(BuildContext, String?)? passordTextControllerValidator;
  FocusNode? landskodeFocusNode;
  TextEditingController? landskodeTextController;
  String? Function(BuildContext, String?)? landskodeTextControllerValidator;

  String? _telefonnummerTextControllerValidator(
      BuildContext context, String? val) {
    return null; // No validation errors.
  }

  @override
  void initState(BuildContext context) {
    telefonnummerTextControllerValidator =
        _telefonnummerTextControllerValidator;
    passordVisibility = false;
  }

  @override
  void dispose() {
    telefonnummerFocusNode?.dispose();
    telefonnummerTextController?.dispose();
    landskodeFocusNode?.dispose();
    landskodeTextController?.dispose();
    passordFocusNode?.dispose();
    passordTextController?.dispose();
  }
}
