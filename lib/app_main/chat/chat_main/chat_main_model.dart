import '/app_main/vanlig_bruker/custom_nav_bar_user/chat_nav_bar/chat_nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'chat_main_widget.dart' show ChatMainWidget;
import 'package:flutter/material.dart';

class ChatMainModel extends FlutterFlowModel<ChatMainWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for ChatNavBar component.
  late ChatNavBarModel chatNavBarModel;

  @override
  void initState(BuildContext context) {
    chatNavBarModel = createModel(context, () => ChatNavBarModel());
  }

  @override
  void dispose() {
    chatNavBarModel.dispose();
  }
}
