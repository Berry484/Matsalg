import '/flutter_flow/flutter_flow_util.dart';
import 'bekreft_o_t_p_widget.dart' show BekreftOTPWidget;
import 'package:flutter/material.dart';

class BekreftOTPModel extends FlutterFlowModel<BekreftOTPWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for PinCode widget.
  TextEditingController? pinCodeController;
  String? Function(BuildContext, String?)? pinCodeControllerValidator;

  @override
  void initState(BuildContext context) {
    pinCodeController = TextEditingController();
  }

  @override
  void dispose() {
    pinCodeController?.dispose();
  }
}
