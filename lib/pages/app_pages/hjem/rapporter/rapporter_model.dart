import '/flutter_flow/flutter_flow_util.dart';
import 'rapporter_widget.dart' show RapporterWidget;
import 'package:flutter/material.dart';

class RapporterModel extends FlutterFlowModel<RapporterWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for bio widget.
  FocusNode? bioFocusNode;
  TextEditingController? bioTextController;
  String? Function(BuildContext, String?)? bioTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    bioFocusNode?.dispose();
    bioTextController?.dispose();
  }
}
