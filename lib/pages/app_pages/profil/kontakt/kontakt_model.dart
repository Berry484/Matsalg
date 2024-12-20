import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'kontakt_widget.dart' show KontaktWidget;
import 'package:flutter/material.dart';

class RapporterModel extends FlutterFlowModel<KontaktWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for bio widget.
  FocusNode? bioFocusNode;
  TextEditingController? bioTextController;
  String? Function(BuildContext, String?)? bioTextControllerValidator;
  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    emailFocusNode?.dispose();
    emailTextController?.dispose();
    bioFocusNode?.dispose();
    bioTextController?.dispose();
  }
}
