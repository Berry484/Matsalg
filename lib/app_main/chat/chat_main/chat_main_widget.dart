import 'package:flutter/material.dart';
import 'package:mat_salg/app_main/chat/MessagePreview/message_preview_widget.dart';
import 'package:mat_salg/app_main/chat/chat_main/chat_main_model.dart';
import 'package:mat_salg/flutter_flow/flutter_flow_theme.dart';
import 'package:shimmer/shimmer.dart';
import '/flutter_flow/flutter_flow_util.dart';
export 'chat_main_model.dart';

class ChatMainWidget extends StatefulWidget {
  const ChatMainWidget({super.key});

  @override
  State<ChatMainWidget> createState() => _ChatMainWidgetState();
}

class _ChatMainWidgetState extends State<ChatMainWidget> {
  late ChatMainModel _model;
  late Conversation conversation;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatMainModel());
    FFAppState().addListener(_onAppStateChanged);
    setState(() {});
  }

// Helper method to build each profile outline with shimmer effect
  Widget buildProfileOutline(BuildContext context, int opacity, Color baseColor,
      Color highlightColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              width: 65.0,
              height: 65.0,
              decoration: BoxDecoration(
                color: Color.fromARGB(opacity, 255, 255, 255),
                borderRadius: BorderRadius.circular(100.0),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  child: Container(
                    width: 75.0,
                    height: 13.0,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(opacity, 255, 255, 255),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  child: Container(
                    width: 200,
                    height: 13.0,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(opacity, 255, 255, 255),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    FFAppState().removeListener(_onAppStateChanged);
    _model.dispose();
    super.dispose();
  }

  void _onAppStateChanged() {
    if (mounted) {
      setState(() {});
    }
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
                'Meldinger',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Nunito',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 20,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
            centerTitle: true,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
          body: SafeArea(
            top: true,
            child: Column(
              children: [
                if (FFAppState().conversations.where((conversation) {
                  // Check if the conversation is empty (no valid messages)
                  return conversation.messages.isNotEmpty &&
                      conversation.messages
                          .any((msg) => msg.content.isNotEmpty);
                }).isEmpty)
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(
                          0, 0, 0, 100), // Adjust padding as needed
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          height: MediaQuery.sizeOf(context).height - 350,
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 40, 0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: const AlignmentDirectional(0, 1),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        // First Profile Outline
                                        buildProfileOutline(
                                          context,
                                          100,
                                          Colors.grey[300]?.withOpacity(1) ??
                                              Colors.grey.withOpacity(
                                                  0.3), // Reduce opacity
                                          Colors.grey[300]?.withOpacity(1) ??
                                              Colors.grey.withOpacity(
                                                  0.3), // Reduce opacity
                                        ),

                                        // Second Profile Outline
                                        buildProfileOutline(
                                          context,
                                          80,
                                          Colors.grey[300]?.withOpacity(1) ??
                                              Colors.grey.withOpacity(1),
                                          Colors.grey[300]?.withOpacity(1) ??
                                              Colors.grey.withOpacity(1),
                                        ),

                                        // Third Profile Outline
                                        buildProfileOutline(
                                          context,
                                          50,
                                          Colors.grey[300]?.withOpacity(1) ??
                                              Colors.grey.withOpacity(1),
                                          Colors.grey[300]?.withOpacity(1) ??
                                              Colors.grey.withOpacity(1),
                                        ),

                                        // Fourth Profile Outline
                                        buildProfileOutline(
                                          context,
                                          38,
                                          Colors.grey[300]?.withOpacity(1) ??
                                              Colors.grey.withOpacity(1),
                                          Colors.grey[300]?.withOpacity(1) ??
                                              Colors.grey.withOpacity(1),
                                        ),

                                        const SizedBox(height: 8.0),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 0, 0, 0),
                                          child: Text(
                                            'Du har ingen samtaler ennå',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .headlineSmall
                                                .override(
                                                  fontFamily: 'Nunito',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  fontSize: 23,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (FFAppState().conversations.where((conversation) {
                  // Check if the conversation is empty (no valid messages)
                  return conversation.messages.isNotEmpty &&
                      conversation.messages
                          .any((msg) => msg.content.isNotEmpty);
                }).isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                          0, 0, 0, 100), // Adjust padding as needed
                      itemCount:
                          FFAppState().conversations.where((conversation) {
                        // Check if the conversation is empty (no valid messages)
                        return conversation.messages.isNotEmpty &&
                            conversation.messages
                                .any((msg) => msg.content.isNotEmpty);
                      }).length,
                      itemBuilder: (context, index) {
                        final conversation = FFAppState()
                            .conversations
                            .where((conversation) =>
                                conversation.messages.isNotEmpty &&
                                conversation.messages
                                    .any((msg) => msg.content.isNotEmpty))
                            .toList()[index];

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
                            ).then((_) => setState(() {}));
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
                // wrapWithModel(
                //   model: _model.chatNavBarModel,
                //   updateCallback: () => safeSetState(() {}),
                //   child: const ChatNavBarWidget(),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
