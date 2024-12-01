import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'hjem_widget.dart' show HjemWidget;
import 'package:flutter/material.dart';

class HjemModel extends FlutterFlowModel<HjemWidget> {
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
    tabBarController?.dispose();
  }
}
