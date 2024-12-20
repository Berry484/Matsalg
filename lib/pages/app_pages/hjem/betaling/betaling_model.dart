import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'betaling_widget.dart' show BetalingWidget;
import 'package:flutter/material.dart';

class BetalingModel extends FlutterFlowModel<BetalingWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for AntallStk widget.
  FocusNode? antallStkFocusNode;
  TextEditingController? antallStkTextController;
  String? Function(BuildContext, String?)? antallStkTextControllerValidator;
  String? _antallStkTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Ugyldig antall';
    }

    if (val == '0') {
      return 'Ugyldig antall';
    }

    if (val.isEmpty) {
      return 'Ugyldig antall';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    antallStkTextControllerValidator = _antallStkTextControllerValidator;
  }

  @override
  void dispose() {
    antallStkFocusNode?.dispose();
    antallStkTextController?.dispose();
  }
}
