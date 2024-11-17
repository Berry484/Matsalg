import 'package:mat_salg/app_main/chat/MessagePreview/message_preview_model.dart';

import '/app_main/vanlig_bruker/custom_nav_bar_user/chat_nav_bar/chat_nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'chat_main_widget.dart' show ChatMainWidget;
import 'package:flutter/material.dart';

class ChatMainModel extends FlutterFlowModel<ChatMainWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for ChatNavBar component.
  late ChatNavBarModel chatNavBarModel;
  late MessagePreviewModel messagePreviewModel;

  @override
  void initState(BuildContext context) {
    chatNavBarModel = createModel(context, () => ChatNavBarModel());
    messagePreviewModel = createModel(context, () => MessagePreviewModel());
  }

  @override
  void dispose() {
    chatNavBarModel.dispose();
  }
}
