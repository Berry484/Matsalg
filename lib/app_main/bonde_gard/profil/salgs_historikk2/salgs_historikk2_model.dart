import '/flutter_flow/flutter_flow_util.dart';
import 'salgs_historikk2_widget.dart' show SalgsHistorikk2Widget;
import 'package:flutter/material.dart';

class SalgsHistorikk2Model extends FlutterFlowModel<SalgsHistorikk2Widget> {
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
