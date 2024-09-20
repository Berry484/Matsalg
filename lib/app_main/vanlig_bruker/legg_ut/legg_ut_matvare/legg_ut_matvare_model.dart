import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'legg_ut_matvare_widget.dart' show LeggUtMatvareWidget;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class LeggUtMatvareModel extends FlutterFlowModel<LeggUtMatvareWidget> {
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
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // State field(s) for ProduktPrisSTK widget.
  FocusNode? produktPrisSTKFocusNode;
  TextEditingController? produktPrisSTKTextController;
  String? Function(BuildContext, String?)?
      produktPrisSTKTextControllerValidator;
  // State field(s) for ProduktPrisKg widget.
  FocusNode? produktPrisKgFocusNode;
  TextEditingController? produktPrisKgTextController;
  String? Function(BuildContext, String?)? produktPrisKgTextControllerValidator;
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

    tabBarController?.dispose();
    produktPrisSTKFocusNode?.dispose();
    produktPrisSTKTextController?.dispose();

    produktPrisKgFocusNode?.dispose();
    produktPrisKgTextController?.dispose();

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
