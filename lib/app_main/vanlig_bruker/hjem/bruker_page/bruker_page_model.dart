import '/flutter_flow/flutter_flow_util.dart';
import 'bruker_page_widget.dart' show BrukerPageWidget;
import 'package:flutter/material.dart';

class BrukerPageModel extends FlutterFlowModel<BrukerPageWidget> {
  ///  Local state fields for this page.

  bool folger = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }
}
