import '/flutter_flow/flutter_flow_util.dart';
import 'velg_pos_widget.dart' show VelgPosWidget;
import 'package:flutter/material.dart';

class VelgPosModel extends FlutterFlowModel<VelgPosWidget> {
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
