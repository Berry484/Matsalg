import '../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'velg_o_t_p_widget.dart' show VelgOTPWidget;
import 'package:flutter/material.dart';

class VelgOTPModel extends FlutterFlowModel<VelgOTPWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for email widget.
  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    emailFocusNode?.dispose();
    emailTextController?.dispose();
  }
}
