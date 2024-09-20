import '/flutter_flow/flutter_flow_util.dart';
import 'min_mat_detalj2_widget.dart' show MinMatDetalj2Widget;
import 'package:flutter/material.dart';

class MinMatDetalj2Model extends FlutterFlowModel<MinMatDetalj2Widget> {
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
