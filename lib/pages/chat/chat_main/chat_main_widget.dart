import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    hide Message;
import 'package:mat_salg/helper_components/widgets/empty_list/no_message_widget.dart';
import 'package:mat_salg/pages/chat/MessagePreview/message_preview_widget.dart';
import 'package:mat_salg/pages/chat/chat_main/chat_main_model.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_theme.dart';
import 'package:mat_salg/services/firebase_service.dart';
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
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

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
    checkPushPermission();
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

  Future<void> checkPushPermission() async {
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }

    final settings = await _firebaseMessaging.getNotificationSettings();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseApi().initNotifications();
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return;
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.notDetermined) {
      if (Platform.isIOS) {
        if (!mounted) return;
        context.pushNamed('RequestPush');
      }
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
                      fontSize: 18,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            toolbarHeight: 45,
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
                                                    return conversation.messages
                                                            .isNotEmpty &&
                                                        conversation.messages
                                                            .any((msg) => msg
                                                                .content
                                                                .isNotEmpty);
                                                  }).isEmpty)
                                                    const NoConversationsView(
                                                        message:
                                                            'Du har ingen samtaler ennå'),
                                                  if (FFAppState()
                                                      .conversations
                                                      .where((conversation) {
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
                                                                0, 0, 0, 20),
                                                        itemCount: FFAppState()
                                                            .conversations
                                                            .where(
                                                                (conversation) {
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
                                                                productImage:
                                                                    conversation
                                                                        .productImage,
                                                                slettet:
                                                                    conversation
                                                                        .slettet,

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
                                                                purchased:
                                                                    conversation
                                                                            .purchased ??
                                                                        false,
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
                                                        conversation.isOwner !=
                                                            true &&
                                                        conversation
                                                                .productImage !=
                                                            null &&
                                                        conversation.messages
                                                            .any((msg) => msg
                                                                .content
                                                                .isNotEmpty);
                                                  }).isEmpty)
                                                    const NoConversationsView(
                                                        message:
                                                            'Du har ingen samtaler med selgere ennå'),
                                                  if (FFAppState()
                                                      .conversations
                                                      .where((conversation) {
                                                    return conversation.messages
                                                            .isNotEmpty &&
                                                        conversation.isOwner !=
                                                            true &&
                                                        conversation
                                                                .productImage !=
                                                            null &&
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
                                                                0, 0, 0, 20),
                                                        itemCount: FFAppState()
                                                            .conversations
                                                            .where(
                                                                (conversation) {
                                                          // Check if the conversation is empty (no valid messages)
                                                          return conversation
                                                                  .messages
                                                                  .isNotEmpty &&
                                                              conversation
                                                                      .isOwner !=
                                                                  true &&
                                                              conversation
                                                                      .productImage !=
                                                                  null &&
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
                                                                          .isOwner !=
                                                                      true &&
                                                                  conversation
                                                                          .productImage !=
                                                                      null &&
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
                                                                slettet:
                                                                    conversation
                                                                        .slettet,
                                                                productImage:
                                                                    conversation
                                                                        .productImage,
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
                                                                purchased:
                                                                    conversation
                                                                            .purchased ??
                                                                        false,
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
                                                        conversation.isOwner ==
                                                            true &&
                                                        conversation.messages
                                                            .any((msg) => msg
                                                                .content
                                                                .isNotEmpty);
                                                  }).isEmpty)
                                                    const NoConversationsView(
                                                        message:
                                                            'Du har ingen samtaler med kjøpere ennå'),
                                                  if (FFAppState()
                                                      .conversations
                                                      .where((conversation) {
                                                    // Check if the conversation is empty (no valid messages)
                                                    return conversation.messages
                                                            .isNotEmpty &&
                                                        conversation.isOwner ==
                                                            true &&
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
                                                                0, 0, 0, 20),
                                                        itemCount: FFAppState()
                                                            .conversations
                                                            .where(
                                                                (conversation) {
                                                          // Check if the conversation is empty (no valid messages)
                                                          return conversation
                                                                  .messages
                                                                  .isNotEmpty &&
                                                              conversation
                                                                      .isOwner ==
                                                                  true &&
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
                                                                          .isOwner ==
                                                                      true &&
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
                                                                slettet:
                                                                    conversation
                                                                        .slettet,
                                                                productImage:
                                                                    conversation
                                                                        .productImage,
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
                                                                purchased:
                                                                    conversation
                                                                            .purchased ??
                                                                        false,
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
