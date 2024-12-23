import '../../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import '../../../../../helper_components/flutter_flow/form_field_controller.dart';
import 'choose_payment_widget.dart' show ChoosePaymentWidget;
import 'package:flutter/material.dart';

class ChoosePaymentModel extends FlutterFlowModel<ChoosePaymentWidget> {
//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes, Controllers and validators-----------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  FormFieldController<String>? radioButtonValueController;
  String? get radioButtonValue => radioButtonValueController?.value;

//---------------------------------------------------------------------------------------------------------------
//--------------------Initstate and dispose----------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
