import '/app_main/vanlig_bruker/custom_nav_bar_user/kjop_nav_bar/kjop_nav_bar_widget.dart';
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
  late KjopNavBarModel kjopNavBarModel;

  @override
  void initState(BuildContext context) {
    kjopNavBarModel = createModel(context, () => KjopNavBarModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    kjopNavBarModel.dispose();
  }
}
