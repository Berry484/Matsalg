import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mat_salg/my_ip.dart';
import 'package:mat_salg/services/user_service.dart';
import 'package:mat_salg/services/web_socket.dart';
import 'package:mat_salg/pages/chat/message/message_model.dart';
import 'package:mat_salg/pages/chat/messageBubble/message_bubbles_widget.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/pages/app_pages/hjem/rapporter/rapporter_widget.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_icon_button.dart';
import '../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../helper_components/flutter_flow/flutter_flow_util.dart';
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
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late MessageModel _model;
  late List<Message> _messageListWithFlags;
  late Conversation conversation;
  late WebSocketService _webSocketService;
  int _lastMessageCount = 0;

  @override
  void initState() {
    super.initState();

    _webSocketService = WebSocketService();
    conversation = Conversation.fromJson(widget.conversation);
    _lastMessageCount = conversation.messages.length;
    markRead();
    getLastActiveTime();
    _model = createModel(context, () => MessageModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _messageListWithFlags = _computeMessageFlags(conversation.messages);
    FFAppState().addListener(_onAppStateChanged);
    FFAppState().chatRoom = conversation.user;
  }

  void markRead() {
    FFAppState().chatAlert.value = false;
    _webSocketService.markAllMessagesAsRead(conversation.user);
    return;
  }

  Future<void> getLastActiveTime() async {
    try {
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return;
      } else {
        final response =
            await UserInfoService.getLastActiveTime(token, conversation.user);
        if (mounted) {
          if (response?.statusCode == 200) {
            final String responseBody = response?.body ?? '';

            if (_isValidTimestamp(responseBody)) {
              // Find the conversation in FFAppState and update the lastactive field
              FFAppState appState = FFAppState();
              Conversation? conv = appState.conversations.firstWhere(
                (conv) => conv.user == conversation.user,
                orElse: () => throw (Exception()), // If not found, return null
              );

              safeSetState(() {
                conversation.updateLastActive(response?.body);
                // Update the lastactive timestamp for the found conversation
                conv.updateLastActive(responseBody);
              });
            } else {
              Toasts.showErrorToast(context, 'Ugyldig tidspunkt mottatt.');
            }
          } else {
            Toasts.showErrorToast(
                context, 'Feil ved henting av siste aktiv tid.');
          }
        }
      }
    } on SocketException {
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

  bool _isValidTimestamp(String body) {
    try {
      DateTime.parse(body); // Try to parse it as a valid timestamp
      return true;
    } catch (e) {
      return false; // If it fails, it's not a valid timestamp
    }
  }

  String customTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inHours < 2) {
      return "Aktiv den siste timen";
    }

    // If it's today
    if (difference.inDays == 0) {
      return "Aktiv i dag";
    }

    // If it was yesterday
    if (difference.inDays == 1) {
      return "Sist aktiv i går";
    }

    // If it is between 2 days and 1 month
    if (difference.inDays < 30) {
      return "Sist aktiv ${difference.inDays} dager siden";
    }

    // If it is between 1 month and 1 year
    if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor(); // Approximate months
      return "Sist aktiv $months måneder siden";
    }

    // If it is over 1 year
    final years = (difference.inDays / 365).floor(); // Approximate years
    return "Sist aktiv $years år siden";
  }

  List<Message> _computeMessageFlags(List<Message> messages) {
    DateTime mostRecentTime = DateTime.fromMillisecondsSinceEpoch(0);
    Map<String, DateTime> mostRecentMessages =
        {}; // Track most recent messages per day

    // Find the most recent message for each day and the overall most recent message
    for (var msg in messages) {
      if (msg.me) {
        // Check if the message is sent by 'me'
        DateTime msgDate = DateTime.parse(msg.time);
        String dateKey = "${msgDate.year}-${msgDate.month}-${msgDate.day}";

        // Update the most recent message for this day
        if (!mostRecentMessages.containsKey(dateKey) ||
            msgDate.isAfter(mostRecentMessages[dateKey]!)) {
          mostRecentMessages[dateKey] = msgDate;
        }

        // Track the overall most recent message sent by 'me'
        if (msgDate.isAfter(mostRecentTime)) {
          mostRecentTime = msgDate;
        }
      }
    }

    // Now iterate over the messages and apply the flags
    return messages.map((message) {
      bool showDelivered = false;
      bool showLest = false;
      bool showTime = false;

      DateTime msgDate = DateTime.parse(message.time);
      String dateKey = "${msgDate.year}-${msgDate.month}-${msgDate.day}";

      // Show time only for the most recent message of the day
      if (message.me && mostRecentMessages[dateKey] == msgDate) {
        showTime = true;
      }

      // Check if this message is the most recent message sent by 'me'
      if (message.me && msgDate.isAtSameMomentAs(mostRecentTime)) {
        showDelivered = message.read == false; // Show delivered if unread
        showLest = message.read == true; // Show lest if read
      }

      // Flag for the most recent message
      bool isMostRecent = msgDate.isAtSameMomentAs(mostRecentTime);

      // Set the flags
      message.showDelivered = showDelivered;
      message.showLest = showLest;
      message.isMostRecent = isMostRecent;
      message.showTime = showTime;

      return message;
    }).toList();
  }

  @override
  void dispose() {
    FFAppState().removeListener(_onAppStateChanged);
    _model.dispose();
    super.dispose();
  }

  void _onAppStateChanged() {
    if (mounted) {
      setState(() {
        markRead();
        _webSocketService.markAllMessagesAsRead(conversation.user);
        final updatedConversation = FFAppState().conversations.firstWhere(
              (conv) => conv.user == conversation.user,
              orElse: () => conversation,
            );

        final newMessagesCount =
            updatedConversation.messages.length - _lastMessageCount;

        if (newMessagesCount > 0) {
          // Update the conversation and flags
          conversation = updatedConversation;
          _messageListWithFlags = _computeMessageFlags(conversation.messages);
          _lastMessageCount = conversation.messages.length;

          // Insert the new messages one by one
          for (int i = 0; i < newMessagesCount; i++) {
            _listKey.currentState
                ?.insertItem(0); // Animate the addition of each new message
          }
        }
        _messageListWithFlags = _computeMessageFlags(conversation.messages);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primary,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: SafeArea(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  scrolledUnderElevation: 0.0,
                  leading: null,
                  actions: const [],
                  flexibleSpace: FlexibleSpaceBar(
                    title: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(14, 5, 0, 0),
                      child: GestureDetector(
                        onTap: () {
                          try {
                            if (conversation.messages.isEmpty) {
                              final appState = FFAppState();

                              appState.conversations.removeWhere(
                                  (conv) => conv.user == conversation.user);
                              //appState.updateUI();
                            }
                            FFAppState().chatRoom = '';
                            Navigator.pop(context);
                          } on SocketException {
                            Toasts.showErrorToast(
                                context, 'Ingen internettforbindelse');
                          } catch (e) {
                            Toasts.showErrorToast(context, 'En feil oppstod');
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black,
                                  size: 28,
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      5.0, 0.0, 0.0, 0.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      context.pushNamed(
                                        'BrukerPage2',
                                        queryParameters: {
                                          'uid': serializeParam(
                                            conversation.user,
                                            ParamType.String,
                                          ),
                                          'username': serializeParam(
                                            conversation.username,
                                            ParamType.String,
                                          ),
                                          'fromChat': serializeParam(
                                            true,
                                            ParamType.bool,
                                          ),
                                        },
                                      );
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      10.0, 0.0, 0.0, 0.0),
                                              child: Container(
                                                width: 38.0,
                                                height: 38.0,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Image.network(
                                                  '${ApiConstants.baseUrl}${conversation.profilePic}',
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (BuildContext
                                                          context,
                                                      Object error,
                                                      StackTrace? stackTrace) {
                                                    return Image.asset(
                                                      'assets/images/profile_pic.png',
                                                      width: 38.0,
                                                      height: 38.0,
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          8.0, 0.0, 0.0, 0.0),
                                                  child: Text.rich(
                                                    TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: conversation
                                                              .username,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Nunito',
                                                                fontSize: 15.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              '\n${customTimeAgo(DateTime.parse(conversation.lastactive ?? ''))}',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Nunito',
                                                                fontSize: 13.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText, // Grey color
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 8, 0),
                              child: IconButton(
                                icon: Icon(
                                  CupertinoIcons.ellipsis,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 28.0,
                                ),
                                onPressed: () {
                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CupertinoActionSheet(
                                        title: const Text(
                                          'Velg en handling',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color:
                                                CupertinoColors.secondaryLabel,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        actions: <Widget>[
                                          CupertinoActionSheetAction(
                                            onPressed: () async {
                                              await showModalBottomSheet(
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                barrierColor:
                                                    const Color.fromARGB(
                                                        60, 17, 0, 0),
                                                useRootNavigator: true,
                                                context: context,
                                                builder: (context) {
                                                  return GestureDetector(
                                                    onTap: () =>
                                                        FocusScope.of(context)
                                                            .unfocus(),
                                                    child: Padding(
                                                      padding: MediaQuery
                                                          .viewInsetsOf(
                                                              context),
                                                      child: RapporterWidget(
                                                        username:
                                                            conversation.user,
                                                        chatUsername:
                                                            conversation
                                                                .username,
                                                        chat: true,
                                                        matId: null,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ).then(
                                                  (value) => setState(() {}));
                                              return;
                                            },
                                            child: const Text(
                                              'Rapporter chat',
                                              style: TextStyle(
                                                fontSize: 19,
                                                color: Colors
                                                    .red, // Red text for 'Slett annonse'
                                              ),
                                            ),
                                          ),
                                        ],
                                        cancelButton:
                                            CupertinoActionSheetAction(
                                          onPressed: () {
                                            Navigator.pop(
                                                context); // Close the action sheet
                                          },
                                          isDefaultAction: true,
                                          child: const Text(
                                            'Avbryt',
                                            style: TextStyle(
                                              fontSize: 19,
                                              color: CupertinoColors.systemBlue,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    centerTitle: true,
                    expandedTitleScale: 1.0,
                  ),
                  shape: const Border(
                      bottom: BorderSide(
                          color: Color.fromARGB(50, 87, 99, 108), width: 1)),
                  elevation: 0,
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: SizedBox(
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
                        child: AnimatedList(
                          key: _listKey,
                          reverse: true,
                          initialItemCount: _messageListWithFlags
                              .length, // Use precomputed list
                          itemBuilder: (context, index, animation) {
                            final message = _messageListWithFlags[
                                index]; // Precomputed message list

                            return SlideTransition(
                              position: animation.drive(
                                Tween<Offset>(
                                  begin: const Offset(0.0, 2.0),
                                  end: Offset.zero,
                                ).chain(CurveTween(curve: Curves.easeInOut)),
                              ),
                              child: MessageBubblesWidget(
                                key: ValueKey(message.time),
                                mesageText: message.content,
                                blueBubble: message.me,
                                showDelivered: message.showDelivered ?? false,
                                showTail: true,
                                showLest: message.showLest ?? false,
                                messageTime: message.showTime ?? false
                                    ? message.time
                                    : null, // Only show time if showTime is true
                              ),
                            );
                          },
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
                            decoration: const BoxDecoration(
                              color: Color(0xB3FFFFFF),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 5, 16, 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment
                                    .end, // Align items to bottom
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _model.textController,
                                      focusNode: _model.textFieldFocusNode,
                                      onChanged: (_) => EasyDebounce.debounce(
                                        '_model.textController',
                                        const Duration(milliseconds: 0),
                                        () => safeSetState(() {}),
                                      ),
                                      autofocus: false,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      obscureText: false,
                                      maxLines: 8,
                                      minLines: 1, // Start with 1 line
                                      maxLength: 200,
                                      textAlign: TextAlign.start,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: 'Melding',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Inter',
                                              fontSize: 14.0,
                                              color: Colors.black26,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.0,
                                              lineHeight: 1,
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black12,
                                            width: 1.2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black12,
                                            width: 1.2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                        filled: true,
                                        fillColor: const Color(0x7FFFFFFF),
                                        counterText: '',
                                        contentPadding:
                                            const EdgeInsetsDirectional
                                                .fromSTEB(14, 16, 45, 16),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.0,
                                            lineHeight: 1,
                                          ),
                                      validator: _model.textControllerValidator
                                          .asValidator(context),
                                      inputFormatters: [
                                        // Custom input formatter to limit lines in the text field
                                        LengthLimitingTextInputFormatter(400),
                                        // Add a formatter to restrict entering more lines
                                        TextInputFormatter.withFunction(
                                            (oldValue, newValue) {
                                          final lineCount = '\n'
                                                  .allMatches(newValue.text)
                                                  .length +
                                              1;
                                          if (lineCount > 10) {
                                            return oldValue;
                                          }
                                          return newValue;
                                        }),
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
                if (_model.textController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 4, 0),
                    child: Align(
                      alignment:
                          Alignment.bottomRight, // Center if only one line

                      child: FlutterFlowIconButton(
                        borderColor: Colors.transparent,
                        borderRadius: 50.0,
                        borderWidth: 1.0,
                        buttonSize: 68.0,
                        onPressed: () {
                          try {
                            if (_model.textController!.text.trim().isNotEmpty) {
                              _webSocketService.sendMessage(
                                  conversation.user,
                                  _model.textController!.text,
                                  conversation.username,
                                  conversation.lastactive);
                              setState(() {
                                _model.textController!.clear();
                              });
                            }
                          } on SocketException {
                            Toasts.showErrorToast(
                                context, 'Ingen internettforbindelse');
                          } catch (e) {
                            Toasts.showErrorToast(context, 'En feil oppstod');
                          }
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.arrowCircleUp,
                          color: Color(0xFF357BF7),
                          size: 28,
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
