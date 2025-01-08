import 'dart:async';

import 'package:mat_salg/helper_components/flutter_flow/form_field_controller.dart';
import 'package:mat_salg/models/user_info_search.dart';

import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'home_page.dart' show HomePage;
import 'package:flutter/material.dart';

class HomeModel extends FlutterFlowModel<HomePage> {
//---------------------------------------------------------------------------------------------------------------
//--------------------Variables used througout-------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  List<Matvarer>? matvarer;
  List<Matvarer>? folgerMatvarer;
  List<UserInfoSearch>? profiler;
  int page = 0;
  int followerPage = 0;
  bool end = false;
  bool followerEnd = false;
  bool isloading = true;
  bool noWifi = false;
  bool folgermatLoading = true;
  bool profilisloading = false;
  Timer? debounce;
  String? dropDownValue;
  LatLng? currentUserLocationValue;
  Map<String, dynamic>? userInfo;

//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes, Controllers and validators-----------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  FocusNode? textFieldFocusNode;

  TabController? tabBarController;
  TextEditingController? textController;
  FormFieldController<String>? dropDownValueController;

//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes and controller for the text fields----------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  String? Function(BuildContext, String?)? textControllerValidator;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

//---------------------------------------------------------------------------------------------------------------
//--------------------Initstate and dispose----------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
    tabBarController?.dispose();
  }
}
