import '../../../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'edit_page.dart' show EditPage;
import 'package:flutter/material.dart';

class EditModel extends FlutterFlowModel<EditPage> {
//---------------------------------------------------------------------------------------------------------------
//--------------------Variables used througout-------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  bool isLoading = false;
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes, Controllers and validators-----------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  FocusNode? brukernavnFocusNode;
  FocusNode? fornavnFocusNode;
  FocusNode? etternavnFocusNode;
  FocusNode? emailFocusNode;
  FocusNode? bioFocusNode;

  TextEditingController? brukernavnTextController;
  TextEditingController? fornavnTextController;
  TextEditingController? etternavnTextController;
  TextEditingController? emailTextController;
  TextEditingController? bioTextController;

//---------------------------------------------------------------------------------------------------------------
//--------------------Functions for the Controllers--------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  String? Function(BuildContext, String?)? bioTextControllerValidator;
  String? Function(BuildContext, String?)? brukernavnTextControllerValidator;
  String? Function(BuildContext, String?)? fornavnTextControllerValidator;
  String? Function(BuildContext, String?)? etternavnTextControllerValidator;
  String? Function(BuildContext, String?)? emailTextControllerValidator;

//---------------------------------------------------------------------------------------------------------------
//--------------------Initstate and dispose----------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    brukernavnFocusNode?.dispose();
    brukernavnTextController?.dispose();

    fornavnFocusNode?.dispose();
    fornavnTextController?.dispose();

    etternavnFocusNode?.dispose();
    etternavnTextController?.dispose();

    emailFocusNode?.dispose();
    emailTextController?.dispose();

    bioFocusNode?.dispose();
    bioTextController?.dispose();
  }
}
