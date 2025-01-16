import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mat_salg/my_ip.dart';
import 'package:mat_salg/services/user_service.dart';
import 'package:mat_salg/services/web_socket.dart';
import 'package:mat_salg/pages/chat/message/message_model.dart';
import 'package:mat_salg/pages/chat/messageBubble/message_bubbles_widget.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/pages/app_pages/home/report/report_widget.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_icon_button.dart';
import '../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../helper_components/flutter_flow/flutter_flow_util.dart';
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
    isDeleted();
  }

  void markRead() {
    _webSocketService.markAllMessagesAsRead(
        conversation.user, conversation.matId);
    return;
  }

  Future<void> isDeleted() async {
    // Ensure conversation is not null and conversation.deleted is not null
    if (conversation.deleted == true) {
      HapticFeedback.selectionClick();

      // Schedule the overlay insertion after the current frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final overlay = Overlay.of(context);
        late OverlayEntry overlayEntry;

        overlayEntry = OverlayEntry(
          builder: (context) => Positioned(
            top: 55.0,
            left: 16.0,
            right: 16.0,
            child: Material(
              color: Colors.transparent,
              child: Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.up, // Allow dismissing upwards
                onDismissed: (_) =>
                    overlayEntry.remove(), // Remove overlay on dismiss
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(70, 0, 0, 0),
                        blurRadius: 1.0,
                        offset: Offset(0, 0.5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(height: 30),
                      const Icon(
                        FontAwesomeIcons.solidCircleXmark,
                        color: Colors.black,
                        size: 30.0,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          'fant ikke brukeren', // "Could not find user"
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        overlay.insert(overlayEntry);

        Future.delayed(const Duration(seconds: 2), () {
          if (overlayEntry.mounted) {
            overlayEntry.remove();
          }
        });
      });
    }
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
      if (!mounted) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      if (!mounted) return;
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
        _webSocketService.markAllMessagesAsRead(
            conversation.user, conversation.matId);
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

          for (int i = 0; i < newMessagesCount; i++) {
            _listKey.currentState?.insertItem(0);
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
                    title: Column(children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(14, 5, 0, 0),
                        child: GestureDetector(
                          onTap: () {
                            try {
                              if (conversation.messages.isEmpty) {
                                final appState = FFAppState();

                                appState.conversations.removeWhere((conv) =>
                                    conv.user == conversation.user &&
                                    conv.matId == conversation.matId);
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
                                  if (conversation.deleted == false)
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
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
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: CachedNetworkImage(
                                                      fadeInDuration:
                                                          Duration.zero,
                                                      imageUrl:
                                                          '${ApiConstants.baseUrl}${conversation.profilePic}',
                                                      fit: BoxFit.cover,
                                                      imageBuilder: (context,
                                                          imageProvider) {
                                                        return Container(
                                                          width: 38.0,
                                                          height: 38.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Image.asset(
                                                        'assets/images/profile_pic.png',
                                                        width: 38.0,
                                                        height: 38.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(8.0,
                                                              0.0, 0.0, 0.0),
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
                                                                    fontSize:
                                                                        15.0,
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
                                                                    fontSize:
                                                                        13.0,
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
                                child: Row(
                                  children: [
                                    if (conversation.productImage != null)
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          if (conversation.isOwner != true) {
                                            context.pushNamed(
                                              'MatDetaljBondegard2',
                                              queryParameters: {
                                                'fromChat': serializeParam(
                                                  true,
                                                  ParamType.bool,
                                                ),
                                                'matId': serializeParam(
                                                  conversation.matId,
                                                  ParamType.int,
                                                ),
                                              },
                                            );
                                          } else {
                                            context.pushNamed(
                                              'ProductStatsChat',
                                              queryParameters: {
                                                'matId': serializeParam(
                                                  conversation.matId,
                                                  ParamType.int,
                                                ),
                                                'otherUid': serializeParam(
                                                  conversation.user,
                                                  ParamType.String,
                                                ),
                                              },
                                            );
                                          }
                                        },
                                        child: conversation.slettet != true
                                            ? CachedNetworkImage(
                                                fadeInDuration: Duration.zero,
                                                imageUrl:
                                                    '${ApiConstants.baseUrl}${conversation.productImage}',
                                                width: 35.0,
                                                height: 35.0,
                                                fit: BoxFit.cover,
                                                imageBuilder:
                                                    (context, imageProvider) {
                                                  return Container(
                                                    width: 35.0,
                                                    height: 35.0,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                placeholder: (context, url) =>
                                                    const SizedBox(),
                                              )
                                            : Container(
                                                width: 35.0,
                                                height: 35.0,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                      ),
                                    if (conversation.productImage != null)
                                      const SizedBox(
                                        width: 8,
                                      ),
                                    IconButton(
                                      icon: Icon(
                                        CupertinoIcons.ellipsis,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
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
                                                  color: CupertinoColors
                                                      .secondaryLabel,
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
                                                              FocusScope.of(
                                                                      context)
                                                                  .unfocus(),
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child: ReportWidget(
                                                              username:
                                                                  conversation
                                                                      .user,
                                                              chatUsername:
                                                                  conversation
                                                                      .username,
                                                              chat: true,
                                                              matId: null,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        setState(() {}));
                                                    return;
                                                  },
                                                  child: const Text(
                                                    'Rapporter chat',
                                                    style: TextStyle(
                                                      fontSize: 18,
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
                                                    fontSize: 18,
                                                    color: CupertinoColors
                                                        .systemBlue,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
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
          child: Stack(
            alignment: const AlignmentDirectional(0, 1),
            children: [
              Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                      child: _messageListWithFlags.isEmpty
                          ? SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 12, 16, 12),
                                child: Container(
                                  height: 140,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary,
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color:
                                          const Color.fromARGB(32, 87, 99, 108),
                                      width: 1.3,
                                    ),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16, 12, 16, 0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                                width: 35,
                                                height: 35,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Image.asset(
                                                  'assets/images/MatSalg_logo.png',
                                                  fit: BoxFit.fitHeight,
                                                )),
                                            SizedBox(width: 8),
                                            Expanded(
                                              // Added Expanded to make the Text wrap properly
                                              child: Text(
                                                'Er du klar for å handle? Send en melding til selgeren!', // Title text for the empty state
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .copyWith(
                                                          fontFamily: 'Nunito',
                                                          color: Colors.black87,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                softWrap:
                                                    true, // Ensures wrapping happens automatically
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12),
                                        GestureDetector(
                                          onTap: () async {
                                            var url = Uri.https(
                                                'matsalg.no', '/how-it-works');
                                            if (await canLaunchUrl(url)) {
                                              await launchUrl(url);
                                            }
                                          },
                                          child: Container(
                                            height: 37,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              border: Border.all(
                                                color: const Color.fromARGB(
                                                    32, 87, 99, 108),
                                                width: 1.3,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Les mer',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleSmall
                                                      .copyWith(
                                                        fontFamily: 'Nunito',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                            )
                          : AnimatedList(
                              key: _listKey,
                              reverse: true,
                              initialItemCount: _messageListWithFlags.isEmpty
                                  ? 1
                                  : _messageListWithFlags.length,
                              itemBuilder: (context, index, animation) {
                                final message = _messageListWithFlags[index];
                                return SlideTransition(
                                  position: animation.drive(
                                    Tween<Offset>(
                                      begin: const Offset(0.0, 2.0),
                                      end: Offset.zero,
                                    ).chain(
                                        CurveTween(curve: Curves.easeInOut)),
                                  ),
                                  child: MessageBubblesWidget(
                                    key: ValueKey(message.time),
                                    mesageText: message.content,
                                    blueBubble: message.me,
                                    showDelivered:
                                        message.showDelivered ?? false,
                                    showTail: true,
                                    showLest: message.showLest ?? false,
                                    messageTime: message.showTime ?? false
                                        ? message.time
                                        : null,
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xB3FFFFFF),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(16, 5, 16, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
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
                                  hintText: 'Skriv melding ...',
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
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black12,
                                      width: 1.2,
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0x7FFFFFFF),
                                  counterText: '',
                                  contentPadding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          14, 16, 45, 16),
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
                                  LengthLimitingTextInputFormatter(400),
                                  TextInputFormatter.withFunction(
                                      (oldValue, newValue) {
                                    final lineCount =
                                        '\n'.allMatches(newValue.text).length +
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
                ],
              ),
              if (_model.textController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 4, 0),
                  child: Align(
                    alignment: Alignment.bottomRight,
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
                                conversation.lastactive,
                                conversation.matId);
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
                        FontAwesomeIcons.circleArrowUp,
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
    );
  }
}
