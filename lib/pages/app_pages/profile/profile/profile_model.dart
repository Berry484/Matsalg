import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:mat_salg/models/matvarer.dart';
import 'profile_page.dart' show ProfilePage;
import 'package:flutter/material.dart';

class ProfileModel extends FlutterFlowModel<ProfilePage> {
//---------------------------------------------------------------------------------------------------------------
//--------------------Variables used througout-------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  List<Matvarer>? matvarer;
  List<Matvarer>? likesmatvarer;
  Map<String, dynamic>? userInfo;
  bool isloading = false;
  bool end = false;
  bool likesisloading = true;
  bool isExpanded = false;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int page = 0;

//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes, Controllers and validators for the text fields---------------------------------
//---------------------------------------------------------------------------------------------------------------
  TabController? tabBarController;

//---------------------------------------------------------------------------------------------------------------
//--------------------Initstate and dispose----------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }
}
