import 'package:mat_salg/models/user.dart';
import 'package:mat_salg/models/user_info_rating.dart';

import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'ratings_widget.dart' show RatingsWidget;
import 'package:flutter/material.dart';

class RatingsModel extends FlutterFlowModel<RatingsWidget> {
//---------------------------------------------------------------------------------------------------------------
//--------------------Variables used througout-------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  List<UserInfoRating>? ratings;
  List<UserInfoRating>? kjopratings = [];
  List<UserInfoRating>? selgratings = [];
  List<User>? brukerinfo;
  User? bruker;
  String? username;
  bool ratingisLoading = true;
  bool ingenRatings = false;

//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes, Controllers and validators-----------------------------------------------------
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
