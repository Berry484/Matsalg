import 'package:flutter/material.dart';
import 'package:mat_salg/api/web_socket.dart';
import 'package:mat_salg/app_main/chat/MessagePreview/message_preview_widget.dart';
import 'package:mat_salg/app_main/chat/chat_main/chat_main_model.dart';
import 'package:mat_salg/flutter_flow/flutter_flow_theme.dart';
import '/app_main/vanlig_bruker/custom_nav_bar_user/chat_nav_bar/chat_nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
export 'chat_main_model.dart';

class ChatMainWidget extends StatefulWidget {
  const ChatMainWidget({super.key});

  @override
  State<ChatMainWidget> createState() => _ChatMainWidgetState();
}

class _ChatMainWidgetState extends State<ChatMainWidget> {
  late ChatMainModel _model;
  late WebSocketService _webSocketService; // Declare WebSocketService
  late Conversation conversation;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatMainModel());
    _webSocketService = WebSocketService();
    FFAppState().addListener(_onAppStateChanged);
    setState(() {});
  }

  @override
  void dispose() {
    FFAppState().removeListener(_onAppStateChanged);
    _model.dispose();
    super.dispose();
  }

  void _onAppStateChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primary,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).alternate),
            automaticallyImplyLeading: false,
            title: Align(
              alignment: const AlignmentDirectional(0, 0),
              child: Text(
                'Mine samtaler',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Montserrat',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 20,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: SafeArea(
            top: true,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                        0, 0, 0, 100), // Adjust padding as needed
                    itemCount: FFAppState().conversations.length,
                    itemBuilder: (context, index) {
                      final conversation = FFAppState().conversations[index];
                      String lastMessageTime = '';
                      if (conversation.messages.isNotEmpty) {
                        lastMessageTime = conversation.messages.first.time;
                      }

                      return InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          context.pushNamed(
                            'message',
                            queryParameters: {
                              'conversation': serializeParam(
                                conversation
                                    .toJson(), // Pass the conversation in JSON format
                                ParamType.JSON,
                              ),
                            },
                          );
                        },
                        child: wrapWithModel(
                          model: _model.messagePreviewModel,
                          updateCallback: () => safeSetState(() {}),
                          child: MessagePreviewWidget(
                            messageTitle: conversation
                                .user, // Use the user's name from the conversation
                            messageContent: conversation.messages.isNotEmpty
                                ? conversation.messages.first
                                    .content // Last message content
                                : 'Ingen meldinger enda',
                            messageImage: conversation.profilePic,
                            isUnread: !conversation.messages
                                .firstWhere(
                                  (message) => !message
                                      .me, // Find the first message that was not sent by me
                                  orElse: () => Message(
                                      read: true,
                                      content: '',
                                      time: '',
                                      me: false), // Return a default Message if no other user's message is found
                                )
                                .read,
                            messageTime:
                                lastMessageTime, // Display last message time
                          ),
                        ),
                      );
                    },
                  ),
                ),
                wrapWithModel(
                  model: _model.chatNavBarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: const ChatNavBarWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
