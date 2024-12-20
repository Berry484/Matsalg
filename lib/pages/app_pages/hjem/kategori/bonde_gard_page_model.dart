import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'bonde_gard_page_widget.dart' show BondeGardPageWidget;
import 'package:flutter/material.dart';

class BondeGardPageModel extends FlutterFlowModel<BondeGardPageWidget> {
  ///  State fields for stateful widgets in this page.

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
