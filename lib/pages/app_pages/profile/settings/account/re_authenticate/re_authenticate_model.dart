import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_model.dart';
import 're_authenticate_widget.dart' show ReAuthenticateWidget;
import 'package:flutter/material.dart';

class ReAuthenticateModel extends FlutterFlowModel<ReAuthenticateWidget> {
//---------------------------------------------------------------------------------------------------------------
//--------------------Variables used througout-------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  late bool passordVisibility;

//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes, Controllers and validators-----------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  FocusNode? passwordChangeNode;

  TextEditingController? passwordChangeController;

//---------------------------------------------------------------------------------------------------------------
//--------------------Validators---------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  String? Function(BuildContext, String?)? passwordChangeControllerValidator;

//---------------------------------------------------------------------------------------------------------------
//--------------------Initstate and dispose----------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  @override
  void initState(BuildContext context) {
    passordVisibility = false;
  }

  @override
  void dispose() {
    passwordChangeNode?.dispose();
    passwordChangeController?.dispose();
  }
}
