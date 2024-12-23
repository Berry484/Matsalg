import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'orders_page.dart' show OrdersPage;
import 'package:flutter/material.dart';

class OrdersModel extends FlutterFlowModel<OrdersPage> {
//---------------------------------------------------------------------------------------------------------------
//--------------------Variables used througout-------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  List<OrdreInfo>? ordreInfo;
  List<OrdreInfo>? salgInfo;
  List<OrdreInfo>? alleInfo;
  bool isloading = false;
  bool isKjopLoading = true;
  bool salgisLoading = true;
  bool kjopEmpty = false;
  bool salgEmpty = false;

//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes, Controllers and validators for the text fields---------------------------------
//---------------------------------------------------------------------------------------------------------------
  TabController? tabBarController;

//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes and controller for the text fields----------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

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
