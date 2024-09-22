import '/app_main/bonde_gard/custom_navbar/se_custom_nav_bar/se_custom_nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'se_widget.dart' show SeWidget;
import 'package:flutter/material.dart';

class SeModel extends FlutterFlowModel<SeWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // Model for SeCustomNavBar component.
  late SeCustomNavBarModel seCustomNavBarModel;

  @override
  void initState(BuildContext context) {
    seCustomNavBarModel = createModel(context, () => SeCustomNavBarModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    seCustomNavBarModel.dispose();
  }
}
