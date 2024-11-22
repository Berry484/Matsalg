import '/app_main/vanlig_bruker/custom_nav_bar_user/legg_ut_nav_bar/legg_ut_nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'legg_ut_matvare_widget.dart' show LeggUtMatvareWidget;
import 'package:flutter/material.dart';

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
    if (val!.toLowerCase() == 'null') {
      return 'Felt kan ikke være null';
    }
    if (val.isEmpty) {
      return 'Felt må fylles ut';
    }

    return null;
  }

// State field(s) for ProduktBeskrivelse widget.
  FocusNode?
      produktBeskrivelseFocusNode; // This will manage focus for the description input.
  TextEditingController?
      produktBeskrivelseTextController; // Controller for the product description text input.

// Validator for ProduktBeskrivelse text controller.
  String? Function(BuildContext, String?)?
      produktBeskrivelseTextControllerValidator;

// Validation logic for the product description input.
  String? _produktBeskrivelseTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Felt må fylles ut'; // Field must be filled.
    }
    if (val.toLowerCase() == 'null') {
      return 'Felt kan ikke være null'; // Field cannot be null.
    }
    return null; // No validation errors.
  }

  // State field(s) for ProduktPrisSTK widget.
  FocusNode? produktPrisSTKFocusNode;
  TextEditingController? produktPrisSTKTextController;
  String? Function(BuildContext, String?)?
      produktPrisSTKTextControllerValidator;
  // State field(s) for AntallStk widget.
  FocusNode? antallStkFocusNode;
  TextEditingController? antallStkTextController;
  String? Function(BuildContext, String?)? antallStkTextControllerValidator;
  String? _antallStkTextControllerValidator(BuildContext context, String? val) {
    if (val!.toLowerCase() == 'null') {
      return 'Felt kan ikke være null';
    }
    if (val.isEmpty) {
      return 'Felt må fylles ut';
    }

    // Try parsing the string to a number
    final number = double.tryParse(val);

    // Check if the parsing failed or the number is not greater than 0
    if (number == null || number < 0) {
      val = '0';
      return 'Verdi må være større enn 0';
    }

    return null; // If all checks pass, return null (no error)
  }

  // State field(s) for Checkbox widget.
  bool? checkboxValue;
  // Model for LeggUtNavBar component.
  late LeggUtNavBarModel leggUtNavBarModel;

  @override
  void initState(BuildContext context) {
    produktNavnTextControllerValidator = _produktNavnTextControllerValidator;
    produktBeskrivelseTextControllerValidator =
        _produktBeskrivelseTextControllerValidator;
    antallStkTextControllerValidator = _antallStkTextControllerValidator;
    leggUtNavBarModel = createModel(context, () => LeggUtNavBarModel());
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

    leggUtNavBarModel.dispose();
  }
}
