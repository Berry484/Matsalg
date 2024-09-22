import '/app_main/bonde_gard/custom_navbar/chat_custom_nav_bar/chat_custom_nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'bonde_chat_widget.dart' show BondeChatWidget;
import 'package:flutter/material.dart';

class BondeChatModel extends FlutterFlowModel<BondeChatWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for ChatCustomNavBar component.
  late ChatCustomNavBarModel chatCustomNavBarModel;

  @override
  void initState(BuildContext context) {
    chatCustomNavBarModel = createModel(context, () => ChatCustomNavBarModel());
  }

  @override
  void dispose() {
    chatCustomNavBarModel.dispose();
  }
}
