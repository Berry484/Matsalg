// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mat_salg/MyIP.dart';
import 'package:mat_salg/api/web_socket.dart';
import 'package:mat_salg/app_main/chat/message/message_model.dart';
import 'package:mat_salg/app_main/chat/messageBubble/message_bubbles_widget.dart';
import 'package:mat_salg/flutter_flow/flutter_flow_icon_button.dart';
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
  late WebSocketService _webSocketService;
  late Conversation conversation;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late MessageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _lastMessageCount = 0; // Track the number of messages
  late List<Message> _messageListWithFlags;

  @override
  void initState() {
    super.initState();
    _webSocketService = WebSocketService();
    // Directly assign the passed conversation to the _conversation variable
    conversation = Conversation.fromJson(widget.conversation);
    _lastMessageCount = conversation.messages.length; // Initialize count
    markRead();
    _model = createModel(context, () => MessageModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _messageListWithFlags = _computeMessageFlags(conversation.messages);
    FFAppState().addListener(_onAppStateChanged);
  }

  void markRead() {
    _webSocketService.markAllMessagesAsRead(conversation.user);
    return;
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
                    padding: const EdgeInsetsDirectional.fromSTEB(14, 0, 0, 0),
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
                            // ignore: invalid_use_of_protected_member
                            appState.notifyListeners();
                          }

                          Navigator.pop(context);
                        } on SocketException {
                          HapticFeedback.lightImpact();
                          showErrorToast(context, 'Ingen internettforbindelse');
                        } catch (e) {
                          HapticFeedback.lightImpact();
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
                      onTap: () {},
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
                                      0, 0, 0, 0),
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
                                        const Duration(milliseconds: 200),
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
                                            .bodySmall
                                            .override(
                                              fontFamily: 'Inter',
                                              letterSpacing: 0.0,
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            width: 1.0,
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
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 4, 0),
                  child: Align(
                    alignment: Alignment.bottomRight, // Center if only one line

                    child: FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 50.0,
                      borderWidth: 1.0,
                      buttonSize: 68.0,
                      onPressed: () {
                        try {
                          print("pressed");
                          if (_model.textController!.text.trim().isNotEmpty) {
                            _webSocketService.sendMessage(
                              conversation.user,
                              _model.textController!.text,
                            );
                            setState(() {
                              _model.textController!.clear();
                            });
                          }
                        } on SocketException {
                          HapticFeedback.lightImpact();
                          showErrorToast(context, 'Ingen internettforbindelse');
                        } catch (e) {
                          HapticFeedback.lightImpact();
                          showErrorToast(context, 'En feil oppstod');
                        }
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.arrowCircleUp,
                        color: Color(0xFF357BF7),
                        size: 32,
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
