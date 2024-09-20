import '/flutter_flow/flutter_flow_util.dart';
import 'rediger_antall2_widget.dart' show RedigerAntall2Widget;
import 'package:flutter/material.dart';

class RedigerAntall2Model extends FlutterFlowModel<RedigerAntall2Widget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
