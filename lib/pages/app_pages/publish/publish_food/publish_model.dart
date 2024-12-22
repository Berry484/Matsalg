import 'package:image_picker/image_picker.dart';

import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'publish_page.dart' show PublishPage;
import 'package:flutter/material.dart';

class PublishModel extends FlutterFlowModel<PublishPage> {
  final formKey = GlobalKey<FormState>();
  late Matvarer matvare;

//---------------------------------------------------------------------------------------------------------------
//--------------------Variables used througout-------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  int selectedValue = 0;
  bool merSolgtIsLoading = false;
  bool leggUtLoading = false;
  bool oppdaterLoading = false;
  bool isFocused = false;
  bool test = true;
  bool isDataUploading = false;
  String? kommune;
  String? kategori;
  String? velgkategori;
  LatLng? selectedLatLng;
  LatLng? currentselectedLatLng =
      LatLng(FFAppState().brukerLat, FFAppState().brukerLng);
  List<XFile> unselectedImages = [
    XFile('ImagePlaceHolder.jpg'),
    XFile('ImagePlaceHolder.jpg'),
    XFile('ImagePlaceHolder.jpg'),
    XFile('ImagePlaceHolder.jpg'),
    XFile('ImagePlaceHolder.jpg'),
  ];
  List<XFile> selectedImages = [];

//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes, Controllers and validators for the text fields---------------------------------
//---------------------------------------------------------------------------------------------------------------
  FocusNode? produktPrisSTKFocusNode;
  FocusNode? produktNavnFocusNode;
  FocusNode? produktBeskrivelseFocusNode;
  FocusNode? antallStkFocusNode;

  TextEditingController? produktNavnTextController;
  TextEditingController? produktBeskrivelseTextController;
  TextEditingController? produktPrisSTKTextController;
  TextEditingController? antallStkTextController;

//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes and controller for the text fields----------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  String? Function(BuildContext, String?)? produktNavnTextControllerValidator;
  String? Function(BuildContext, String?)?
      produktBeskrivelseTextControllerValidator;
  String? Function(BuildContext, String?)?
      produktPrisSTKTextControllerValidator;
  String? Function(BuildContext, String?)? antallStkTextControllerValidator;

//---------------------------------------------------------------------------------------------------------------
//--------------------Logic for when to give an error when validating the text fields----------------------------
//---------------------------------------------------------------------------------------------------------------
  String? _produktNavnTextControllerValidator(
      BuildContext context, String? val) {
    if (val!.toLowerCase() == 'null') {
      return 'Felt kan ikke være null';
    }
    if (val.isEmpty) {
      return 'Felt må fylles ut';
    }

    return null;
  }

  String? _produktBeskrivelseTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Felt må fylles ut';
    }
    if (val.toLowerCase() == 'null') {
      return 'Felt kan ikke være null';
    }
    return null;
  }

  String? _produktPrisSTKTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Felt må fylles ut';
    }
    if (val.toLowerCase() == 'null') {
      return 'Felt kan ikke være null';
    }
    return null;
  }

  String? _antallStkTextControllerValidator(BuildContext context, String? val) {
    if (val!.toLowerCase() == 'null') {
      return 'Felt kan ikke være null';
    }
    if (val.isEmpty) {
      return 'Felt må fylles ut';
    }
    final number = double.tryParse(val);

    if (number == null || number < 0) {
      val = '0';
      return 'Verdi må være større enn 0';
    }

    return null;
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Initstate and dispose----------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  @override
  void initState(BuildContext context) {
    produktNavnTextControllerValidator = _produktNavnTextControllerValidator;
    produktBeskrivelseTextControllerValidator =
        _produktBeskrivelseTextControllerValidator;
    produktPrisSTKTextControllerValidator =
        _produktPrisSTKTextControllerValidator;
    antallStkTextControllerValidator = _antallStkTextControllerValidator;
  }

  @override
  void dispose() {
    produktNavnFocusNode?.dispose();
    produktNavnTextController?.dispose();

    produktBeskrivelseFocusNode?.dispose();
    produktBeskrivelseTextController?.dispose();

    produktPrisSTKFocusNode?.dispose();
    produktPrisSTKTextController?.dispose();

    antallStkFocusNode?.dispose();
    antallStkTextController?.dispose();
  }

//
}
