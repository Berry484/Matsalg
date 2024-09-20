import '/app_main/bonde_gard/custom_navbar/profile_custom_nav_bar/profile_custom_nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'profil2_widget.dart' show Profil2Widget;
import 'package:flutter/material.dart';

class Profil2Model extends FlutterFlowModel<Profil2Widget> {
  ///  State fields for stateful widgets in this page.

  // Model for ProfileCustomNavBar component.
  late ProfileCustomNavBarModel profileCustomNavBarModel;

  @override
  void initState(BuildContext context) {
    profileCustomNavBarModel =
        createModel(context, () => ProfileCustomNavBarModel());
  }

  @override
  void dispose() {
    profileCustomNavBarModel.dispose();
  }
}
