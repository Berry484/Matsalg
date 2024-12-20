import 'package:mat_salg/pages/chat/MessagePreview/message_preview_model.dart';
import '../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'chat_main_widget.dart' show ChatMainWidget;
import 'package:flutter/material.dart';

class ChatMainModel extends FlutterFlowModel<ChatMainWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for ChatNavBar component.
  late MessagePreviewModel messagePreviewModel;

  @override
  void initState(BuildContext context) {
    messagePreviewModel = createModel(context, () => MessagePreviewModel());
  }

  @override
  void dispose() {}
}
