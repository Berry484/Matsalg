import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'leg_ut_mat2_widget.dart' show LegUtMat2Widget;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class LegUtMat2Model extends FlutterFlowModel<LegUtMat2Widget> {
  ///  Local state fields for this page.

  LatLng? brukermatsted;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  bool isDataUploading1 = false;
  FFUploadedFile uploadedLocalFile1 =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  bool isDataUploading2 = false;
  FFUploadedFile uploadedLocalFile2 =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  bool isDataUploading3 = false;
  FFUploadedFile uploadedLocalFile3 =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  bool isDataUploading4 = false;
  FFUploadedFile uploadedLocalFile4 =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  bool isDataUploading5 = false;
  FFUploadedFile uploadedLocalFile5 =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  // State field(s) for ProduktNavn widget.
  FocusNode? produktNavnFocusNode;
  TextEditingController? produktNavnTextController;
  String? Function(BuildContext, String?)? produktNavnTextControllerValidator;
  String? _produktNavnTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Felt må fylles ut';
    }

    return null;
  }

  // State field(s) for DropDown widget.
  List<String>? dropDownValue;
  FormFieldController<List<String>>? dropDownValueController;
  // State field(s) for ProduktBeskrivelse widget.
  FocusNode? produktBeskrivelseFocusNode;
  TextEditingController? produktBeskrivelseTextController;
  String? Function(BuildContext, String?)?
      produktBeskrivelseTextControllerValidator;
  String? _produktBeskrivelseTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Felt må fylles ut';
    }

    return null;
  }

  // State field(s) for TabBar widget.
  TabController? tabBarController1;
  int get tabBarCurrentIndex1 =>
      tabBarController1 != null ? tabBarController1!.index : 0;

  // State field(s) for ProduktPrisSTK widget.
  FocusNode? produktPrisSTKFocusNode;
  TextEditingController? produktPrisSTKTextController;
  String? Function(BuildContext, String?)?
      produktPrisSTKTextControllerValidator;
  // State field(s) for ProduktPrisKg widget.
  FocusNode? produktPrisKgFocusNode;
  TextEditingController? produktPrisKgTextController;
  String? Function(BuildContext, String?)? produktPrisKgTextControllerValidator;
  // State field(s) for ProduktMinMengde widget.
  FocusNode? produktMinMengdeFocusNode;
  TextEditingController? produktMinMengdeTextController;
  String? Function(BuildContext, String?)?
      produktMinMengdeTextControllerValidator;
  // State field(s) for AntallStk widget.
  FocusNode? antallStkFocusNode;
  TextEditingController? antallStkTextController;
  String? Function(BuildContext, String?)? antallStkTextControllerValidator;
  // State field(s) for TabBar widget.
  TabController? tabBarController2;
  int get tabBarCurrentIndex2 =>
      tabBarController2 != null ? tabBarController2!.index : 0;

  // State field(s) for GateNavn widget.
  FocusNode? gateNavnFocusNode;
  TextEditingController? gateNavnTextController;
  String? Function(BuildContext, String?)? gateNavnTextControllerValidator;
  // State field(s) for GateNummer widget.
  FocusNode? gateNummerFocusNode;
  TextEditingController? gateNummerTextController;
  String? Function(BuildContext, String?)? gateNummerTextControllerValidator;
  // State field(s) for PostNummer widget.
  FocusNode? postNummerFocusNode;
  TextEditingController? postNummerTextController;
  final postNummerMask = MaskTextInputFormatter(mask: '####');
  String? Function(BuildContext, String?)? postNummerTextControllerValidator;
  // State field(s) for By widget.
  FocusNode? byFocusNode;
  TextEditingController? byTextController;
  String? Function(BuildContext, String?)? byTextControllerValidator;

  @override
  void initState(BuildContext context) {
    produktNavnTextControllerValidator = _produktNavnTextControllerValidator;
    produktBeskrivelseTextControllerValidator =
        _produktBeskrivelseTextControllerValidator;
  }

  @override
  void dispose() {
    produktNavnFocusNode?.dispose();
    produktNavnTextController?.dispose();

    produktBeskrivelseFocusNode?.dispose();
    produktBeskrivelseTextController?.dispose();

    tabBarController1?.dispose();
    produktPrisSTKFocusNode?.dispose();
    produktPrisSTKTextController?.dispose();

    produktPrisKgFocusNode?.dispose();
    produktPrisKgTextController?.dispose();

    produktMinMengdeFocusNode?.dispose();
    produktMinMengdeTextController?.dispose();

    antallStkFocusNode?.dispose();
    antallStkTextController?.dispose();

    tabBarController2?.dispose();
    gateNavnFocusNode?.dispose();
    gateNavnTextController?.dispose();

    gateNummerFocusNode?.dispose();
    gateNummerTextController?.dispose();

    postNummerFocusNode?.dispose();
    postNummerTextController?.dispose();

    byFocusNode?.dispose();
    byTextController?.dispose();
  }
}
