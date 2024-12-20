import 'package:mat_salg/pages/chat/messageBubble/message_bubbles_model.dart';

import '../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'message_widget.dart' show MessageWidget;
import 'package:flutter/material.dart';

class MessageModel extends FlutterFlowModel<MessageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for messageBubbles component.
  late MessageBubblesModel messageBubblesModel;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {
    messageBubblesModel = createModel(context, () => MessageBubblesModel());
  }

  @override
  void dispose() {
    messageBubblesModel.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
