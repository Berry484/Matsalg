import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'category_widget.dart' show CategoryWidget;
import 'package:flutter/material.dart';

class CategoryModel extends FlutterFlowModel<CategoryWidget> {
//---------------------------------------------------------------------------------------------------------------
//--------------------Variables used througout-------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  List<Matvarer>? matvarer;
  List<Matvarer>? allmatvarer;
  bool isloading = true;
  bool empty = false;
  int sorterVerdi = 1;

//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes, Controllers and validators-----------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  FocusNode? textFieldFocusNode;

  TextEditingController? textController;

//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes and controller for the text fields----------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  String? Function(BuildContext, String?)? textControllerValidator;

//---------------------------------------------------------------------------------------------------------------
//--------------------Initstate and dispose----------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
