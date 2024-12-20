import '../../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import '../../../../../helper_components/flutter_flow/form_field_controller.dart';
import 'velg_betaling_widget.dart' show VelgBetalingWidget;
import 'package:flutter/material.dart';

class VelgBetalingModel extends FlutterFlowModel<VelgBetalingWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for RadioButton widget.
  FormFieldController<String>? radioButtonValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  /// Additional helper methods.
  String? get radioButtonValue => radioButtonValueController?.value;
}
