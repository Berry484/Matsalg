import 'package:mat_salg/models/user_info.dart';

import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'followers_widget.dart' show FollowersWidget;
import 'package:flutter/material.dart';

class FollowersModel extends FlutterFlowModel<FollowersWidget> {
//---------------------------------------------------------------------------------------------------------------
//--------------------Variables used througout-------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  bool folger = false;
  bool isloading = true;
  List<UserInfo>? brukere;

//---------------------------------------------------------------------------------------------------------------
//--------------------Initstate and dispose----------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
