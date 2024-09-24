import '/flutter_flow/flutter_flow_util.dart';
import 'profil_copy2_copy_widget.dart' show ProfilCopy2CopyWidget;
import 'package:flutter/material.dart';

class ProfilCopy2CopyModel extends FlutterFlowModel<ProfilCopy2CopyWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
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
