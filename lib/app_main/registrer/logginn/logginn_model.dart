import '/flutter_flow/flutter_flow_util.dart';
import 'logginn_widget.dart' show LogginnWidget;
import 'package:flutter/material.dart';

class LogginnModel extends FlutterFlowModel<LogginnWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for email widget.
  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;
  // State field(s) for passord widget.
  FocusNode? passordFocusNode;
  TextEditingController? passordTextController;
  late bool passordVisibility;
  String? Function(BuildContext, String?)? passordTextControllerValidator;

  @override
  void initState(BuildContext context) {
    passordVisibility = false;
  }

  @override
  void dispose() {
    emailFocusNode?.dispose();
    emailTextController?.dispose();

    passordFocusNode?.dispose();
    passordTextController?.dispose();
  }
}
