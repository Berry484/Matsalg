import '/flutter_flow/flutter_flow_util.dart';
import 'bekreft_t_l_f_widget.dart' show BekreftTLFWidget;
import 'package:flutter/material.dart';

class BekreftTLFModel extends FlutterFlowModel<BekreftTLFWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for PhoneNumberField widget.
  FocusNode? phoneNumberFieldFocusNode;
  TextEditingController? phoneNumberFieldTextController;
  String? Function(BuildContext, String?)?
      phoneNumberFieldTextControllerValidator;
  String? _phoneNumberFieldTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Felt må fylles ut';
    }

    if (val.length < 8) {
      return 'Krever minst 8 sifre';
    }
    if (val.length > 8) {
      return 'Maks 8 sifte';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    phoneNumberFieldTextControllerValidator =
        _phoneNumberFieldTextControllerValidator;
  }

  @override
  void dispose() {
    phoneNumberFieldFocusNode?.dispose();
    phoneNumberFieldTextController?.dispose();
  }
}
