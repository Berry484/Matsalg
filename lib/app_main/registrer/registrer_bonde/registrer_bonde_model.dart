import '/flutter_flow/flutter_flow_util.dart';
import 'registrer_bonde_widget.dart' show RegistrerBondeWidget;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for Passord widget.
  FocusNode? passordFocusNode;
  TextEditingController? passordTextController;
  late bool passordVisibility;
  String? Function(BuildContext, String?)? passordTextControllerValidator;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

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
  // State field(s) for Kommune widget.
  FocusNode? kommuneFocusNode;
  TextEditingController? kommuneTextController;
  String? Function(BuildContext, String?)? kommuneTextControllerValidator;
  // State field(s) for GardsNumme widget.
  FocusNode? gardsNummeFocusNode;
  TextEditingController? gardsNummeTextController;
  String? Function(BuildContext, String?)? gardsNummeTextControllerValidator;
  // State field(s) for BruksNummer widget.
  FocusNode? bruksNummerFocusNode;
  TextEditingController? bruksNummerTextController;
  String? Function(BuildContext, String?)? bruksNummerTextControllerValidator;
  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressTextController;
  String? Function(BuildContext, String?)? emailAddressTextControllerValidator;
  // State field(s) for Telefonnummer widget.
  FocusNode? telefonnummerFocusNode;
  TextEditingController? telefonnummerTextController;
  String? Function(BuildContext, String?)? telefonnummerTextControllerValidator;
  String? _telefonnummerTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for Checkbox widget.
  bool? checkboxValue;

  @override
  void initState(BuildContext context) {
    bondeGardNavnTextControllerValidator =
        _bondeGardNavnTextControllerValidator;
    passordVisibility = false;
    telefonnummerTextControllerValidator =
        _telefonnummerTextControllerValidator;
  }

  @override
  void dispose() {
    bondeGardNavnFocusNode?.dispose();
    bondeGardNavnTextController?.dispose();

    passordFocusNode?.dispose();
    passordTextController?.dispose();

    tabBarController?.dispose();
    gateNavnFocusNode?.dispose();
    gateNavnTextController?.dispose();

    gateNummerFocusNode?.dispose();
    gateNummerTextController?.dispose();

    postNummerFocusNode?.dispose();
    postNummerTextController?.dispose();

    byFocusNode?.dispose();
    byTextController?.dispose();

    kommuneFocusNode?.dispose();
    kommuneTextController?.dispose();

    gardsNummeFocusNode?.dispose();
    gardsNummeTextController?.dispose();

    bruksNummerFocusNode?.dispose();
    bruksNummerTextController?.dispose();

    emailAddressFocusNode?.dispose();
    emailAddressTextController?.dispose();

    telefonnummerFocusNode?.dispose();
    telefonnummerTextController?.dispose();
  }
}
