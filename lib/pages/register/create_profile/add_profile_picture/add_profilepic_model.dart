import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'add_profilepic_widget.dart' show AddProfilePicWidget;
import 'package:flutter/material.dart';

class ProfilRedigerModel extends FlutterFlowModel<AddProfilePicWidget> {
//---------------------------------------------------------------------------------------------------------------
//--------------------Variables used througout-------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

//---------------------------------------------------------------------------------------------------------------
//--------------------Initstate and dispose----------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
