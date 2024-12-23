import '../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'velg_t_l_f_widget.dart' show VelgTLFWidget;
import 'package:flutter/material.dart';

class VelgTLFModel extends FlutterFlowModel<VelgTLFWidget> {
  final formKey = GlobalKey<FormState>();
//---------------------------------------------------------------------------------------------------------------
//--------------------Variables used througout-------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
/*



*/
//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes, Controllers and validators-----------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  FocusNode? landskodeFocusNode;
  FocusNode? telefonnummerFocusNode;

  TextEditingController? landskodeTextController;
  TextEditingController? telefonnummerTextController;

//---------------------------------------------------------------------------------------------------------------
//--------------------Validators---------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  String? Function(BuildContext, String?)? landskodeTextControllerValidator;
  String? Function(BuildContext, String?)? telefonnummerTextControllerValidator;

  String? _telefonnummerTextControllerValidator(
      BuildContext context, String? val) {
    return null; // No validation errors.
  }

//---------------------------------------------------------------------------------------------------------------
//--------------------Initstate and dispose----------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  @override
  void initState(BuildContext context) {
    telefonnummerTextControllerValidator =
        _telefonnummerTextControllerValidator;
  }

  @override
  void dispose() {
    landskodeFocusNode?.dispose();
    landskodeTextController?.dispose();

    telefonnummerFocusNode?.dispose();
    telefonnummerTextController?.dispose();
  }
}
