import '/flutter_flow/flutter_flow_util.dart';
import 'kjop_detalj_ventende_widget.dart' show KjopDetaljVentendeWidget;
import 'package:flutter/material.dart';

class KjopDetaljVentendeModel
    extends FlutterFlowModel<KjopDetaljVentendeWidget> {
  ///  Local state fields for this page.

  bool? liker = false;

  ///  State fields for stateful widgets in this page.

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
  void dispose() {}
}
