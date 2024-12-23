import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'payment_page_widget.dart' show PaymentPageWidget;
import 'package:flutter/material.dart';

class PaymentPageModel extends FlutterFlowModel<PaymentPageWidget> {
  final formKey = GlobalKey<FormState>();

//---------------------------------------------------------------------------------------------------------------
//--------------------Variables used througout-------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  bool isLoading = false;
  int matpris = 1;
  bool isFocused = false;
  int selectedValue = 0;
  int kjopsBeskyttelse = 2;
  bool applePay = true;

//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes and controller for the text fields----------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  FocusNode? antallStkFocusNode;

  TextEditingController? antallStkTextController;

//---------------------------------------------------------------------------------------------------------------
//--------------------Validators---------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
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

//---------------------------------------------------------------------------------------------------------------
//--------------------Initstate and dispose----------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
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
