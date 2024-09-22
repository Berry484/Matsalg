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
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController4;
  String? Function(BuildContext, String?)? textController4Validator;

  @override
  void initState(BuildContext context) {}

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
