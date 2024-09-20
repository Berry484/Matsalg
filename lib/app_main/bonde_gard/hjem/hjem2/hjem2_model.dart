import '/app_main/bonde_gard/custom_navbar/home_custom_nav_bar/home_custom_nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'hjem2_widget.dart' show Hjem2Widget;
import 'package:flutter/material.dart';

class Hjem2Model extends FlutterFlowModel<Hjem2Widget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // Model for HomeCustomNavBar component.
  late HomeCustomNavBarModel homeCustomNavBarModel;

  @override
  void initState(BuildContext context) {
    homeCustomNavBarModel = createModel(context, () => HomeCustomNavBarModel());
  }

  @override
  void dispose() {
    homeCustomNavBarModel.dispose();
  }
}
