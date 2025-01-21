import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_model.dart';
import 'package:mat_salg/models/user_info.dart';

import 'blocked_widget.dart' show BlockedWidget;
import 'package:flutter/material.dart';

class BlockedModel extends FlutterFlowModel<BlockedWidget> {
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
