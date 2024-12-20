import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'profil_widget.dart' show ProfilWidget;
import 'package:flutter/material.dart';

class ProfilModel extends FlutterFlowModel<ProfilWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Model for ProfilNavBar component.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }
}
