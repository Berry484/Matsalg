import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'mat_detalj_bondegard_widget.dart' show MatDetaljBondegardWidget;
import 'package:flutter/material.dart';

class MatDetaljBondegardModel
    extends FlutterFlowModel<MatDetaljBondegardWidget> {
  ///  Local state fields for this page.

  bool? liker = false;
  bool folges = false;

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
