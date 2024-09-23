import '/flutter_flow/flutter_flow_util.dart';
import 'bekreft_o_t_p_widget.dart' show BekreftOTPWidget;
import 'package:flutter/material.dart';

class BekreftOTPModel extends FlutterFlowModel<BekreftOTPWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for PinCode widget.
  TextEditingController? pinCodeController;
  String? Function(BuildContext, String?)? pinCodeControllerValidator;
  String? _pinCodeControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Krever 4 siffere';
    }
    if (val.length < 4) {
      return 'Requires 4 characters.';
    }
    return null;
  }

  @override
  void initState(BuildContext context) {
    pinCodeController = TextEditingController();
    pinCodeControllerValidator = _pinCodeControllerValidator;
  }

  @override
  void dispose() {
    pinCodeController?.dispose();
  }
}
