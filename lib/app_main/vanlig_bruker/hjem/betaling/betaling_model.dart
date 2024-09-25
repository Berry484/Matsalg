import '/flutter_flow/flutter_flow_util.dart';
import 'betaling_widget.dart' show BetalingWidget;
import 'package:flutter/material.dart';

class BetalingModel extends FlutterFlowModel<BetalingWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for AntallStk widget.
  FocusNode? antallStkFocusNode;
  TextEditingController? antallStkTextController;
  String? Function(BuildContext, String?)? antallStkTextControllerValidator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  String? _textController3Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Felt må fylles ut...';
    }

    return null;
  }

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController4;
  String? Function(BuildContext, String?)? textController4Validator;
  String? _textController4Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Felt må fylles ut...';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    textController3Validator = _textController3Validator;
    textController4Validator = _textController4Validator;
  }

  @override
  void dispose() {
    antallStkFocusNode?.dispose();
    antallStkTextController?.dispose();

    textFieldFocusNode1?.dispose();
    textController2?.dispose();

    textFieldFocusNode2?.dispose();
    textController3?.dispose();

    textFieldFocusNode3?.dispose();
    textController4?.dispose();
  }
}
