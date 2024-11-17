import 'dart:io';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mat_salg/MyIP.dart';
import 'package:mat_salg/api/web_socket.dart';
import 'package:mat_salg/app_main/chat/message/message_model.dart';
import 'package:mat_salg/app_main/chat/messageBubble/message_bubbles_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatefulWidget {
  const MessageWidget({
    super.key,
    required this.conversation,
  });

  final dynamic conversation;

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  late WebSocketService _webSocketService; // Declare WebSocketService
  late Conversation conversation;

  late MessageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Directly assign the passed conversation to the _conversation variable
    conversation = Conversation.fromJson(widget.conversation);
    _model = createModel(context, () => MessageModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    FFAppState().addListener(_onAppStateChanged);
    markRead();
  }

  void markRead() {
    _webSocketService = WebSocketService();
    _webSocketService.markAllMessagesAsRead(conversation.user);
  }

  void showErrorToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        left: 16.0,
        right: 16.0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8)
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  FontAwesomeIcons.solidTimesCircle,
                  color: Colors.black,
                  size: 30.0,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  @override
  void dispose() {
    FFAppState().removeListener(_onAppStateChanged);
    _model.dispose();
    super.dispose();
  }

  void _onAppStateChanged() {
    setState(() {
      markRead();
      // _webSocketService.markAllMessagesAsRead(conversation.user);
      conversation = FFAppState().conversations.firstWhere(
            (conv) => conv.user == conversation.user,
            orElse: () =>
                conversation, // Keeps current conversation if not updated
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primary,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(85),
          child: SafeArea(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  automaticallyImplyLeading: true,
                  scrolledUnderElevation: 0.0,
                  leading: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        try {
                          if (conversation.messages.isEmpty) {
                            // Access the global app state (FFAppState)
                            final appState = FFAppState();

                            // Remove the conversation from the list if it has no messages
                            appState.conversations.removeWhere(
                                (conv) => conv.user == conversation.user);

                            // Notify listeners to update the UI (if necessary)
                            appState.notifyListeners();
                          }

                          context.pop();
                        } on SocketException {
                          showErrorToast(context, 'Ingen internettforbindelse');
                        } catch (e) {
                          showErrorToast(context, 'En feil oppstod');
                        }
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xFF357BF7),
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: const [],
                  flexibleSpace: FlexibleSpaceBar(
                    title: GestureDetector(
                      onTap: () {
                        context.pushNamed(
                          'BrukerPage',
                          queryParameters: {
                            'username': serializeParam(
                              conversation.user.toLowerCase(),
                              ParamType.String,
                            ),
                          },
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.network(
                              '${ApiConstants.baseUrl}${conversation.profilePic}',
                              width: 45,
                              height: 45,
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) {
                                return Image.asset(
                                  'assets/images/profile_pic.png',
                                  width: 45,
                                  height: 45,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 3, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 0, 0),
                                  child: Text(
                                    conversation.user,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          fontSize: 13,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 14,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    centerTitle: true,
                    expandedTitleScale: 1.0,
                  ),
                  elevation: 0,
                ),
                // Bottom border container
                Container(
                    height: 0.3, // Thickness of the border
                    color: FlutterFlowTheme.of(context).secondaryText),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 1,
            child: Stack(
              alignment: const AlignmentDirectional(0, 1),
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          reverse: true,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: conversation.messages.map((message) {
                            bool showDelivered = false;
                            bool showLest = false;

                            // Parse the message.time string into DateTime
                            DateTime currentMessageDate = DateTime.parse(message
                                .time); // Assuming message.time is in a parseable format

                            // Find the most recent message on the same day
                            DateTime? mostRecentTime;
                            bool isMostRecent = false;

                            // Find the most recent message for the current day
                            for (var msg in conversation.messages) {
                              DateTime msgDate = DateTime.parse(msg
                                  .time); // Convert other message time string to DateTime
                              if (msgDate.year == currentMessageDate.year &&
                                  msgDate.month == currentMessageDate.month &&
                                  msgDate.day == currentMessageDate.day) {
                                if (mostRecentTime == null ||
                                    msgDate.isAfter(mostRecentTime)) {
                                  mostRecentTime = msgDate;
                                  isMostRecent = msg == message;
                                }
                              }
                            }

                            // Check if this is the first message where message.me == true
                            if (message.me == true &&
                                conversation.messages.indexOf(message) ==
                                    conversation.messages
                                        .indexWhere((msg) => msg.me == true)) {
                              // If message.read is true, set showLest to true, else showDelivered to true
                              if (message.read == true) {
                                showLest = true;
                              } else {
                                showDelivered = true;
                              }
                            }

                            return MessageBubblesWidget(
                              mesageText: message.content,
                              blueBubble: message.me == true,
                              showDelivered: showDelivered,
                              showTail: true,
                              showLest: showLest,
                              messageTime: isMostRecent
                                  ? message.time
                                  : null, // Pass the string time if it's the most recent message for the day
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    // This will push the input field to the bottom of the screen
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 10,
                            sigmaY: 10,
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Color(0xB3FFFFFF),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 0, 16, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(0, 0),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(12, 0, 0, 0),
                                            child: TextFormField(
                                              controller: _model.textController,
                                              focusNode:
                                                  _model.textFieldFocusNode,
                                              onChanged: (_) =>
                                                  EasyDebounce.debounce(
                                                '_model.textController',
                                                const Duration(
                                                    milliseconds: 200),
                                                () => safeSetState(() {}),
                                              ),
                                              autofocus: false,
                                              textCapitalization:
                                                  TextCapitalization.sentences,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                hintText: 'Melding',
                                                hintStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          letterSpacing: 0.0,
                                                        ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                                filled: true,
                                                fillColor:
                                                    const Color(0x7FFFFFFF),
                                                contentPadding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        14, 16, 24, 16),
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                        lineHeight: 1,
                                                      ),
                                              validator: _model
                                                  .textControllerValidator
                                                  .asValidator(context),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (_model.textController!.text
                                                .trim()
                                                .isNotEmpty) {
                                              _webSocketService.sendMessage(
                                                conversation.user,
                                                _model.textController!.text,
                                              );
                                              setState(() {
                                                _model.textController!.clear();
                                              });
                                            }
                                          },
                                          child: const Stack(
                                            children: [
                                              Align(
                                                alignment:
                                                    AlignmentDirectional(1, 0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 6, 0),
                                                  child: Icon(
                                                    Icons.send_rounded,
                                                    color: Color(0xFF357BF7),
                                                    size: 25,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
