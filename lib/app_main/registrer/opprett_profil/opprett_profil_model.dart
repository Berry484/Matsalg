import '/flutter_flow/flutter_flow_util.dart';
import 'opprett_profil_widget.dart' show OpprettProfilWidget;
import 'package:flutter/material.dart';

class OpprettProfilModel extends FlutterFlowModel<OpprettProfilWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  // State field(s) for Bio widget.
  FocusNode? bioFocusNode;
  TextEditingController? bioTextController;
  String? Function(BuildContext, String?)? bioTextControllerValidator;
  String? _bioTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Felt må fylles ut';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    bioTextControllerValidator = _bioTextControllerValidator;
  }

  @override
  void dispose() {
    bioFocusNode?.dispose();
    bioTextController?.dispose();
  }
}
