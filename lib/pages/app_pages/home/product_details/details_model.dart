import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:mat_salg/models/matvarer.dart';
import 'details_widget.dart' show DetailsWidget;
import 'package:flutter/material.dart';

class DetailsModel extends FlutterFlowModel<DetailsWidget> {
//---------------------------------------------------------------------------------------------------------------
//--------------------Variables used througout-------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  String? poststed;
  List<Matvarer>? nyematvarer;
  bool? liker = false;
  bool folges = false;
  bool? brukerFolger = false;
  bool messageIsLoading = false;
  bool showHeart = false;
  bool isloading = true;
  bool isAnimating = false;
  bool isExpanded = false;
  bool isDeleted = false;
  bool fetchingProductLoading = false;

//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes, Controllers and validators-----------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  PageController? pageViewController;

//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes and controller for the text fields----------------------------------------------
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
