import '/flutter_flow/flutter_flow_util.dart';
import 'registrer_bonde_widget.dart' show RegistrerBondeWidget;
import 'package:flutter/material.dart';

class RegistrerBondeModel extends FlutterFlowModel<RegistrerBondeWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for BondeGardNavn widget.
  FocusNode? bondeGardNavnFocusNode;
  TextEditingController? bondeGardNavnTextController;
  String? Function(BuildContext, String?)? bondeGardNavnTextControllerValidator;
  String? _bondeGardNavnTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Felt må fylles ut.';
    }

    return null;
  }

  // State field(s) for Kommune widget.
  FocusNode? kommuneFocusNode;
  TextEditingController? kommuneTextController;
  String? Function(BuildContext, String?)? kommuneTextControllerValidator;
  String? _kommuneTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Felt må fylles ut.';
    }

    return null;
  }

  // State field(s) for GardsNumme widget.
  FocusNode? gardsNummeFocusNode;
  TextEditingController? gardsNummeTextController;
  String? Function(BuildContext, String?)? gardsNummeTextControllerValidator;
  String? _gardsNummeTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Felt må fylles ut.';
    }

    return null;
  }

  // State field(s) for BruksNummer widget.
  FocusNode? bruksNummerFocusNode;
  TextEditingController? bruksNummerTextController;
  String? Function(BuildContext, String?)? bruksNummerTextControllerValidator;
  String? _bruksNummerTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Felt må fylles ut.';
    }

    return null;
  }

  // State field(s) for Checkbox widget.
  bool? checkboxValue;

  @override
  void initState(BuildContext context) {
    bondeGardNavnTextControllerValidator =
        _bondeGardNavnTextControllerValidator;
    kommuneTextControllerValidator = _kommuneTextControllerValidator;
    gardsNummeTextControllerValidator = _gardsNummeTextControllerValidator;
    bruksNummerTextControllerValidator = _bruksNummerTextControllerValidator;
  }

  @override
  void dispose() {
    bondeGardNavnFocusNode?.dispose();
    bondeGardNavnTextController?.dispose();

    kommuneFocusNode?.dispose();
    kommuneTextController?.dispose();

    gardsNummeFocusNode?.dispose();
    gardsNummeTextController?.dispose();

    bruksNummerFocusNode?.dispose();
    bruksNummerTextController?.dispose();
  }
}
