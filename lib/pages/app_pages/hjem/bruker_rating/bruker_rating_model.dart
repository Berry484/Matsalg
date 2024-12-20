import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'bruker_rating_widget.dart' show BrukerRatingWidget;
import 'package:flutter/material.dart';

class BrukerRatingModel extends FlutterFlowModel<BrukerRatingWidget> {
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }
}
