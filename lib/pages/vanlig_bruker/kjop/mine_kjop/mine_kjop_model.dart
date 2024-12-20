import '/flutter_flow/flutter_flow_util.dart';
import 'mine_kjop_widget.dart' show MineKjopWidget;
import 'package:flutter/material.dart';

class MineKjopModel extends FlutterFlowModel<MineKjopWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Model for KjopNavBar component.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }
}
