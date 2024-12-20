import '/flutter_flow/flutter_flow_util.dart';
import 'add_profilepic_widget.dart' show AddProfilePicWidget;
import 'package:flutter/material.dart';

class ProfilRedigerModel extends FlutterFlowModel<AddProfilePicWidget> {
  ///  State fields for stateful widgets in this page.

  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
