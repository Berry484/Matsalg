import '/flutter_flow/flutter_flow_util.dart';
import 'velg_t_l_f_widget.dart' show VelgTLFWidget;
import 'package:flutter/material.dart';

class VelgTLFModel extends FlutterFlowModel<VelgTLFWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for landskode widget.
  FocusNode? landskodeFocusNode;
  TextEditingController? landskodeTextController;
  String? Function(BuildContext, String?)? landskodeTextControllerValidator;
  // State field(s) for telefonnummer widget.
  FocusNode? telefonnummerFocusNode;
  TextEditingController? telefonnummerTextController;
  String? Function(BuildContext, String?)? telefonnummerTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    landskodeFocusNode?.dispose();
    landskodeTextController?.dispose();

    telefonnummerFocusNode?.dispose();
    telefonnummerTextController?.dispose();
  }
}
