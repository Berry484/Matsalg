import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'contact_page.dart' show ContactPage;
import 'package:flutter/material.dart';

class ContactModel extends FlutterFlowModel<ContactPage> {
//---------------------------------------------------------------------------------------------------------------
//--------------------Variables used througout-------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  bool loading = false;

//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes, Controllers and validators for the text fields---------------------------------
//---------------------------------------------------------------------------------------------------------------
  FocusNode? bioFocusNode;
  FocusNode? emailFocusNode;

  TextEditingController? bioTextController;
  TextEditingController? emailTextController;

//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes and controller for the text fields----------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  String? Function(BuildContext, String?)? bioTextControllerValidator;
  String? Function(BuildContext, String?)? emailTextControllerValidator;

//---------------------------------------------------------------------------------------------------------------
//--------------------Initstate and dispose----------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    emailFocusNode?.dispose();
    emailTextController?.dispose();
    bioFocusNode?.dispose();
    bioTextController?.dispose();
  }
}
