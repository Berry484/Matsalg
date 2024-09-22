import '/app_main/bonde_gard/custom_navbar/ordre_custom_nav_bar/ordre_custom_nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'salg_widget.dart' show SalgWidget;
import 'package:flutter/material.dart';

class SalgModel extends FlutterFlowModel<SalgWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Model for OrdreCustomNavBar component.
  late OrdreCustomNavBarModel ordreCustomNavBarModel;

  @override
  void initState(BuildContext context) {
    ordreCustomNavBarModel =
        createModel(context, () => OrdreCustomNavBarModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    ordreCustomNavBarModel.dispose();
  }
}
