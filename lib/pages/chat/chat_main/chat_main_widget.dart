import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mat_salg/pages/chat/MessagePreview/message_preview_widget.dart';
import 'package:mat_salg/pages/chat/chat_main/chat_main_model.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_theme.dart';
import 'package:shimmer/shimmer.dart';
import '../../../helper_components/flutter_flow/flutter_flow_util.dart';
export 'chat_main_model.dart';

class ChatMainWidget extends StatefulWidget {
  const ChatMainWidget({super.key});

  @override
  State<ChatMainWidget> createState() => _ChatMainWidgetState();
}

class _ChatMainWidgetState extends State<ChatMainWidget>
    with TickerProviderStateMixin {
  late ChatMainModel _model;
  late Conversation conversation;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatMainModel());
    FFAppState().addListener(_onAppStateChanged);
    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
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
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) {
            return;
          }
        },
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
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: SafeArea(
                    child: Container(
                      decoration: const BoxDecoration(),
                      child: Stack(
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  13, 0, 13, 0),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 50, // Integer height
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(
                                          0), // Integer padding
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            14), // Integer radius
                                      ),
                                      child:
                                          CupertinoSlidingSegmentedControl<int>(
                                        backgroundColor:
                                            const Color(0xFFEBEBED),
                                        thumbColor: CupertinoColors.white,
                                        groupValue:
                                            _model.tabBarController!.index,
                                        onValueChanged: (int? index) {
                                          if (index != null) {
                                            _model.tabBarController!
                                                .animateTo(index);
                                            [
                                              () async {},
                                              () async {
                                                safeSetState(() {});
                                              },
                                              () async {
                                                safeSetState(() {});
                                              }
                                            ][index]();
                                          }
                                        },
                                        children: const {
                                          0: Text(
                                            'Alle',
                                            style: TextStyle(
                                              fontFamily:
                                                  'Nunito', // Apple's system font
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600,
                                              color: CupertinoColors.black,
                                            ),
                                          ),
                                          1: Text(
                                            'Kjøp',
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600,
                                              color: CupertinoColors.black,
                                            ),
                                          ),
                                          2: Text(
                                            'Salg',
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600,
                                              color: CupertinoColors.black,
                                            ),
                                          ),
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      controller: _model.tabBarController,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 13, 0, 0),
                                          child: RefreshIndicator.adaptive(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              onRefresh: () async {
                                                HapticFeedback.selectionClick();
                                              },
                                              child: Column(
                                                children: [
                                                  if (FFAppState()
                                                      .conversations
                                                      .where((conversation) {
                                                    // Check if the conversation is empty (no valid messages)
                                                    return conversation.messages
                                                            .isNotEmpty &&
                                                        conversation.messages
                                                            .any((msg) => msg
                                                                .content
                                                                .isNotEmpty);
                                                  }).isEmpty)
                                                    Expanded(
                                                      child: ListView(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0, 0, 0, 100),
                                                        children: [
                                                          SizedBox(
                                                            width: MediaQuery
                                                                    .sizeOf(
                                                                        context)
                                                                .width,
                                                            height: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .height -
                                                                350,
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0,
                                                                        40,
                                                                        0,
                                                                        0),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Align(
                                                                      alignment:
                                                                          const AlignmentDirectional(
                                                                              0,
                                                                              1),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          // First Profile Outline
                                                                          buildProfileOutline(
                                                                            context,
                                                                            100,
                                                                            Colors.grey[300]?.withOpacity(1) ??
                                                                                Colors.grey.withOpacity(0.3), // Reduce opacity
                                                                            Colors.grey[300]?.withOpacity(1) ??
                                                                                Colors.grey.withOpacity(0.3), // Reduce opacity
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

                                                                          const SizedBox(
                                                                              height: 8.0),
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            child:
                                                                                Text(
                                                                              'Du har ingen samtaler ennå',
                                                                              textAlign: TextAlign.center,
                                                                              style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                    fontFamily: 'Nunito',
                                                                                    color: FlutterFlowTheme.of(context).primaryText,
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
                                                  if (FFAppState()
                                                      .conversations
                                                      .where((conversation) {
                                                    // Check if the conversation is empty (no valid messages)
                                                    return conversation.messages
                                                            .isNotEmpty &&
                                                        conversation.messages
                                                            .any((msg) => msg
                                                                .content
                                                                .isNotEmpty);
                                                  }).isNotEmpty)
                                                    Expanded(
                                                      child: ListView.builder(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0, 0, 0, 100),
                                                        itemCount: FFAppState()
                                                            .conversations
                                                            .where(
                                                                (conversation) {
                                                          // Check if the conversation is empty (no valid messages)
                                                          return conversation
                                                                  .messages
                                                                  .isNotEmpty &&
                                                              conversation
                                                                  .messages
                                                                  .any((msg) => msg
                                                                      .content
                                                                      .isNotEmpty);
                                                        }).length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final conversation = FFAppState()
                                                              .conversations
                                                              .where((conversation) =>
                                                                  conversation
                                                                      .messages
                                                                      .isNotEmpty &&
                                                                  conversation
                                                                      .messages
                                                                      .any((msg) => msg
                                                                          .content
                                                                          .isNotEmpty))
                                                              .toList()[index];

                                                          String
                                                              lastMessageTime =
                                                              '';
                                                          if (conversation
                                                              .messages
                                                              .isNotEmpty) {
                                                            lastMessageTime =
                                                                conversation
                                                                    .messages
                                                                    .first
                                                                    .time;
                                                          }

                                                          return InkWell(
                                                            splashFactory:
                                                                InkRipple
                                                                    .splashFactory,
                                                            splashColor: Colors
                                                                .grey[100],
                                                            onTap: () {
                                                              context.pushNamed(
                                                                'message',
                                                                queryParameters: {
                                                                  'conversation': serializeParam(
                                                                      conversation
                                                                          .toJson(),
                                                                      ParamType
                                                                          .JSON),
                                                                },
                                                              ).then((_) =>
                                                                  setState(
                                                                      () {}));
                                                            },
                                                            child:
                                                                wrapWithModel(
                                                              model: _model
                                                                  .messagePreviewModel,
                                                              updateCallback: () =>
                                                                  safeSetState(
                                                                      () {}),
                                                              child:
                                                                  MessagePreviewWidget(
                                                                messageTitle: conversation
                                                                        .deleted
                                                                    ? 'deleted_user'
                                                                    : conversation
                                                                        .username,
                                                                messageContent: conversation
                                                                        .messages
                                                                        .isNotEmpty
                                                                    ? conversation
                                                                        .messages
                                                                        .first
                                                                        .content // Last message content
                                                                    : 'Ingen meldinger enda',
                                                                messageImage:
                                                                    conversation
                                                                        .profilePic,
                                                                isUnread:
                                                                    !conversation
                                                                        .messages
                                                                        .firstWhere(
                                                                          (message) =>
                                                                              !message.me, // Find the first message that was not sent by me
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
                                                ],
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 13, 0, 0),
                                          child: RefreshIndicator.adaptive(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              onRefresh: () async {
                                                HapticFeedback.selectionClick();
                                              },
                                              child: Column(
                                                children: [
                                                  if (FFAppState()
                                                      .conversations
                                                      .where((conversation) {
                                                    // Check if the conversation is empty (no valid messages)
                                                    return conversation.messages
                                                            .isNotEmpty &&
                                                        conversation.messages
                                                            .any((msg) => msg
                                                                .content
                                                                .isNotEmpty);
                                                  }).isEmpty)
                                                    Expanded(
                                                      child: ListView(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0, 0, 0, 100),
                                                        children: [
                                                          SizedBox(
                                                            width: MediaQuery
                                                                    .sizeOf(
                                                                        context)
                                                                .width,
                                                            height: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .height -
                                                                350,
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0,
                                                                        40,
                                                                        0,
                                                                        0),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Align(
                                                                      alignment:
                                                                          const AlignmentDirectional(
                                                                              0,
                                                                              1),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          // First Profile Outline
                                                                          buildProfileOutline(
                                                                            context,
                                                                            100,
                                                                            Colors.grey[300]?.withOpacity(1) ??
                                                                                Colors.grey.withOpacity(0.3), // Reduce opacity
                                                                            Colors.grey[300]?.withOpacity(1) ??
                                                                                Colors.grey.withOpacity(0.3), // Reduce opacity
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

                                                                          const SizedBox(
                                                                              height: 8.0),
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            child:
                                                                                Text(
                                                                              'Du har ingen samtaler ennå',
                                                                              textAlign: TextAlign.center,
                                                                              style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                    fontFamily: 'Nunito',
                                                                                    color: FlutterFlowTheme.of(context).primaryText,
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
                                                  if (FFAppState()
                                                      .conversations
                                                      .where((conversation) {
                                                    // Check if the conversation is empty (no valid messages)
                                                    return conversation.messages
                                                            .isNotEmpty &&
                                                        conversation.messages
                                                            .any((msg) => msg
                                                                .content
                                                                .isNotEmpty);
                                                  }).isNotEmpty)
                                                    Expanded(
                                                      child: ListView.builder(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0, 0, 0, 100),
                                                        itemCount: FFAppState()
                                                            .conversations
                                                            .where(
                                                                (conversation) {
                                                          // Check if the conversation is empty (no valid messages)
                                                          return conversation
                                                                  .messages
                                                                  .isNotEmpty &&
                                                              conversation
                                                                  .messages
                                                                  .any((msg) => msg
                                                                      .content
                                                                      .isNotEmpty);
                                                        }).length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final conversation = FFAppState()
                                                              .conversations
                                                              .where((conversation) =>
                                                                  conversation
                                                                      .messages
                                                                      .isNotEmpty &&
                                                                  conversation
                                                                      .messages
                                                                      .any((msg) => msg
                                                                          .content
                                                                          .isNotEmpty))
                                                              .toList()[index];

                                                          String
                                                              lastMessageTime =
                                                              '';
                                                          if (conversation
                                                              .messages
                                                              .isNotEmpty) {
                                                            lastMessageTime =
                                                                conversation
                                                                    .messages
                                                                    .first
                                                                    .time;
                                                          }

                                                          return InkWell(
                                                            splashFactory:
                                                                InkRipple
                                                                    .splashFactory,
                                                            splashColor: Colors
                                                                .grey[100],
                                                            onTap: () {
                                                              context.pushNamed(
                                                                'message',
                                                                queryParameters: {
                                                                  'conversation': serializeParam(
                                                                      conversation
                                                                          .toJson(),
                                                                      ParamType
                                                                          .JSON),
                                                                },
                                                              ).then((_) =>
                                                                  setState(
                                                                      () {}));
                                                            },
                                                            child:
                                                                wrapWithModel(
                                                              model: _model
                                                                  .messagePreviewModel,
                                                              updateCallback: () =>
                                                                  safeSetState(
                                                                      () {}),
                                                              child:
                                                                  MessagePreviewWidget(
                                                                messageTitle: conversation
                                                                        .deleted
                                                                    ? 'deleted_user'
                                                                    : conversation
                                                                        .username,
                                                                messageContent: conversation
                                                                        .messages
                                                                        .isNotEmpty
                                                                    ? conversation
                                                                        .messages
                                                                        .first
                                                                        .content // Last message content
                                                                    : 'Ingen meldinger enda',
                                                                messageImage:
                                                                    conversation
                                                                        .profilePic,
                                                                isUnread:
                                                                    !conversation
                                                                        .messages
                                                                        .firstWhere(
                                                                          (message) =>
                                                                              !message.me, // Find the first message that was not sent by me
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
                                                ],
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 13, 0, 0),
                                          child: RefreshIndicator.adaptive(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              onRefresh: () async {
                                                HapticFeedback.selectionClick();
                                              },
                                              child: Column(
                                                children: [
                                                  if (FFAppState()
                                                      .conversations
                                                      .where((conversation) {
                                                    // Check if the conversation is empty (no valid messages)
                                                    return conversation.messages
                                                            .isNotEmpty &&
                                                        conversation.messages
                                                            .any((msg) => msg
                                                                .content
                                                                .isNotEmpty);
                                                  }).isEmpty)
                                                    Expanded(
                                                      child: ListView(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0, 0, 0, 100),
                                                        children: [
                                                          SizedBox(
                                                            width: MediaQuery
                                                                    .sizeOf(
                                                                        context)
                                                                .width,
                                                            height: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .height -
                                                                350,
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0,
                                                                        40,
                                                                        0,
                                                                        0),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Align(
                                                                      alignment:
                                                                          const AlignmentDirectional(
                                                                              0,
                                                                              1),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          // First Profile Outline
                                                                          buildProfileOutline(
                                                                            context,
                                                                            100,
                                                                            Colors.grey[300]?.withOpacity(1) ??
                                                                                Colors.grey.withOpacity(0.3), // Reduce opacity
                                                                            Colors.grey[300]?.withOpacity(1) ??
                                                                                Colors.grey.withOpacity(0.3), // Reduce opacity
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

                                                                          const SizedBox(
                                                                              height: 8.0),
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            child:
                                                                                Text(
                                                                              'Du har ingen samtaler ennå',
                                                                              textAlign: TextAlign.center,
                                                                              style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                    fontFamily: 'Nunito',
                                                                                    color: FlutterFlowTheme.of(context).primaryText,
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
                                                  if (FFAppState()
                                                      .conversations
                                                      .where((conversation) {
                                                    // Check if the conversation is empty (no valid messages)
                                                    return conversation.messages
                                                            .isNotEmpty &&
                                                        conversation.messages
                                                            .any((msg) => msg
                                                                .content
                                                                .isNotEmpty);
                                                  }).isNotEmpty)
                                                    Expanded(
                                                      child: ListView.builder(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0, 0, 0, 100),
                                                        itemCount: FFAppState()
                                                            .conversations
                                                            .where(
                                                                (conversation) {
                                                          // Check if the conversation is empty (no valid messages)
                                                          return conversation
                                                                  .messages
                                                                  .isNotEmpty &&
                                                              conversation
                                                                  .messages
                                                                  .any((msg) => msg
                                                                      .content
                                                                      .isNotEmpty);
                                                        }).length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final conversation = FFAppState()
                                                              .conversations
                                                              .where((conversation) =>
                                                                  conversation
                                                                      .messages
                                                                      .isNotEmpty &&
                                                                  conversation
                                                                      .messages
                                                                      .any((msg) => msg
                                                                          .content
                                                                          .isNotEmpty))
                                                              .toList()[index];

                                                          String
                                                              lastMessageTime =
                                                              '';
                                                          if (conversation
                                                              .messages
                                                              .isNotEmpty) {
                                                            lastMessageTime =
                                                                conversation
                                                                    .messages
                                                                    .first
                                                                    .time;
                                                          }

                                                          return InkWell(
                                                            splashFactory:
                                                                InkRipple
                                                                    .splashFactory,
                                                            splashColor: Colors
                                                                .grey[100],
                                                            onTap: () {
                                                              context.pushNamed(
                                                                'message',
                                                                queryParameters: {
                                                                  'conversation': serializeParam(
                                                                      conversation
                                                                          .toJson(),
                                                                      ParamType
                                                                          .JSON),
                                                                },
                                                              ).then((_) =>
                                                                  setState(
                                                                      () {}));
                                                            },
                                                            child:
                                                                wrapWithModel(
                                                              model: _model
                                                                  .messagePreviewModel,
                                                              updateCallback: () =>
                                                                  safeSetState(
                                                                      () {}),
                                                              child:
                                                                  MessagePreviewWidget(
                                                                messageTitle: conversation
                                                                        .deleted
                                                                    ? 'deleted_user'
                                                                    : conversation
                                                                        .username,
                                                                messageContent: conversation
                                                                        .messages
                                                                        .isNotEmpty
                                                                    ? conversation
                                                                        .messages
                                                                        .first
                                                                        .content // Last message content
                                                                    : 'Ingen meldinger enda',
                                                                messageImage:
                                                                    conversation
                                                                        .profilePic,
                                                                isUnread:
                                                                    !conversation
                                                                        .messages
                                                                        .firstWhere(
                                                                          (message) =>
                                                                              !message.me, // Find the first message that was not sent by me
                                                                          orElse: () => Message(
                                                                              read: true,
                                                                              content: '',
                                                                              time: '',
                                                                              me: false), // Return a default Message if no other user's message is found
                                                                        )
                                                                        .read,
                                                                messageTime:
                                                                    lastMessageTime,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
