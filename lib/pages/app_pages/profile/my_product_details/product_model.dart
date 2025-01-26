import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'product_page.dart' show ProductPage;
import 'package:flutter/material.dart';

class ProductModel extends FlutterFlowModel<ProductPage> {
//---------------------------------------------------------------------------------------------------------------
//--------------------Variables used througout-------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  bool slettIsLoading = false;
  bool isExpanded = false;
  bool? liker = false;
  bool isAnimating = false;
  bool showHeart = false;

//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes, Controllers and validators-----------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  PageController? pageViewController;

//---------------------------------------------------------------------------------------------------------------
//--------------------Functions for the Controllers--------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 1;
//---------------------------------------------------------------------------------------------------------------
//--------------------Initstate and dispose----------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
