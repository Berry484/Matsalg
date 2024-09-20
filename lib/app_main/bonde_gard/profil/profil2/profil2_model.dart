import '/app_main/bonde_gard/custom_navbar/dashboard_custom_nav_bar/dashboard_custom_nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'profil2_widget.dart' show Profil2Widget;
import 'package:flutter/material.dart';

class Profil2Model extends FlutterFlowModel<Profil2Widget> {
  ///  State fields for stateful widgets in this page.

  // Model for DashboardCustomNavBar component.
  late DashboardCustomNavBarModel dashboardCustomNavBarModel;

  @override
  void initState(BuildContext context) {
    dashboardCustomNavBarModel =
        createModel(context, () => DashboardCustomNavBarModel());
  }

  @override
  void dispose() {
    dashboardCustomNavBarModel.dispose();
  }
}
