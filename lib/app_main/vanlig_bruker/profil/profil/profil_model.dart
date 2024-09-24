import '/app_main/vanlig_bruker/custom_nav_bar_user/profil_nav_bar/profil_nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'profil_widget.dart' show ProfilWidget;
import 'package:flutter/material.dart';

class ProfilModel extends FlutterFlowModel<ProfilWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Model for ProfilNavBar component.
  late ProfilNavBarModel profilNavBarModel;

  @override
  void initState(BuildContext context) {
    profilNavBarModel = createModel(context, () => ProfilNavBarModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    profilNavBarModel.dispose();
  }
}
