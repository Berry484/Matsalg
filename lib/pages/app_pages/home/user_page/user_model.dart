import 'package:mat_salg/models/user.dart';
import 'package:mat_salg/models/matvarer.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'user_widget.dart' show UserWidget;
import 'package:flutter/material.dart';

class UserModel extends FlutterFlowModel<UserWidget> {
//---------------------------------------------------------------------------------------------------------------
//--------------------Variables used througout-------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  int page = 0;
  bool end = false;
  bool folger = false;
  bool isLoading = true;
  bool empty = false;
  bool matisLoading = true;
  bool? brukerFolger = false;
  bool folgerLoading = false;
  bool isExpanded = false;
  bool messageIsLoading = false;
  List<User>? brukerinfo;
  List<Matvarer>? matvarer;
  User? bruker;

//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes, Controllers and validators-----------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  TabController? tabBarController;
  PageController? pageViewController;

//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes and controller for the text fields----------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;

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
