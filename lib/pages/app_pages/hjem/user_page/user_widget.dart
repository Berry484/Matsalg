import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mat_salg/helper_components/functions/calculate_distance.dart';
import 'package:mat_salg/helper_components/widgets/shimmer_product.dart';
import 'package:mat_salg/models/user.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/logging.dart';
import 'package:mat_salg/my_ip.dart';
import 'package:mat_salg/pages/app_pages/hjem/user_page/follow_user/follow_user_widget.dart';
import 'package:mat_salg/pages/app_pages/hjem/user_ratings/ratings_widget.dart';
import 'package:mat_salg/pages/app_pages/hjem/report/report_widget.dart';
import 'package:mat_salg/services/follow_service.dart';
import 'package:mat_salg/services/food_service.dart';
import 'package:mat_salg/services/user_service.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'user_model.dart';
export 'user_model.dart';

class UserWidget extends StatefulWidget {
  const UserWidget(
      {this.bruker, this.uid, this.username, this.fromChat, super.key});

  final dynamic bruker;
  final String? uid;
  final String? username;
  final dynamic fromChat;

  @override
  State<UserWidget> createState() => _BrukerPageWidgetState();
}

class _BrukerPageWidgetState extends State<UserWidget>
    with TickerProviderStateMixin {
  late UserModel _model;
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController1 = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UserModel());
    _checkUser();

    getUserFood(true);
    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
    _scrollController1.addListener(_scrollListener);
  }

  Future<void> _checkUser() async {
    try {
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return;
      } else {
        if (widget.bruker != 1) {
          _model.brukerinfo =
              await UserInfoService.checkUser(token, widget.uid);
          if (_model.brukerinfo != null && _model.brukerinfo!.isNotEmpty) {
            _model.bruker = _model.brukerinfo![0]; // Get the first User object

            _model.isLoading = false;
          } else {
            // Fallback values
            _model.bruker = User(
              username: '',
              uid: '',
              firstname: '',
              lastname: '',
              profilepic: '', // Default image
              email: '',
              bio: '',
              phoneNumber: '',
              lat: null,
              lng: null,
              bonde: null,
              gardsnavn: '',
            );
          }
        } else {
          // Initialize bruker from passed parameter
          _model.bruker = User.fromJson(widget.bruker);
          _model.isLoading = false;
        }
        setState(() {
          _model.isLoading =
              false; // Update loading state after data is fetched
          _model.folger = _model.bruker!.isFollowing ?? false;
        });
      }
    } on SocketException {
      if (!mounted) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      if (!mounted) return;
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

  Future<void> unFolg() async {
    try {
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return;
      }
      await FollowService.unfolgBruker(token, widget.uid);
      safeSetState(() {
        _checkUser();
      });
    } on SocketException {
      if (!mounted) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      if (!mounted) return;
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

  Future<void> folgBruker() async {
    try {
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return;
      }
      await FollowService.folgbruker(token, widget.uid);
      safeSetState(() {
        _checkUser();
      });
    } on SocketException {
      if (!mounted) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      if (!mounted) return;
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

  Future<void> getUserFood(bool refresh) async {
    try {
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return;
      } else {
        if (refresh) {
          _model.matvarer =
              await ApiFoodService.getUserFood(token, widget.uid, _model.page);
        } else {
          List<Matvarer>? nyeMatvarer =
              await ApiFoodService.getAllFoods(token, _model.page);

          _model.matvarer ??= [];

          if (nyeMatvarer != null && nyeMatvarer.isNotEmpty) {
            _model.matvarer?.addAll(nyeMatvarer);
          } else {
            _model.end = true;
          }
        }
        setState(() {
          if (_model.matvarer != null && _model.matvarer!.isNotEmpty) {
            _model.matisLoading = false;
            return;
          } else {
            _model.empty = true;
            _model.matisLoading = false;
          }
        });
      }
    } on SocketException {
      if (!mounted) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      if (!mounted) return;
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

  void _scrollListener() async {
    if (_scrollController1.position.pixels >=
        _scrollController1.position.maxScrollExtent) {
      if (_isLoading || _model.end) return;
      _isLoading = true;
      _model.page += 1;
      await getUserFood(false);
      _isLoading = false;
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
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
            backgroundColor: FlutterFlowTheme.of(context)
                .primary, // Set to your primary color, e.g., Colors.white
            elevation: 0, // Removes shadow to keep it flat
            scrolledUnderElevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle
                .dark, // Adjusts status bar icons for light background
            leading: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(2, 0, 0, 0),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 28.0,
                ),
                onPressed: () {
                  context.safePop();
                },
              ),
            ),
            centerTitle: true,
            title: Text(
              '@${widget.username ?? 'Profil'}',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Nunito',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 18,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 2, 0),
                child: IconButton(
                  icon: Icon(
                    CupertinoIcons.ellipsis,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 28.0,
                  ),
                  onPressed: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoActionSheet(
                          actions: <Widget>[
                            CupertinoActionSheetAction(
                              onPressed: () async {
                                try {
                                  // Prevent multiple submissions while loading
                                  if (_model.messageIsLoading) return;
                                  _model.messageIsLoading = true;

                                  Conversation existingConversation =
                                      FFAppState().conversations.firstWhere(
                                    (conv) => conv.user == widget.uid,
                                    orElse: () {
                                      final newConversation = Conversation(
                                        username: widget.username ?? '',
                                        user: widget.uid ?? '',
                                        deleted: false,
                                        lastactive: _model.bruker?.lastactive,
                                        profilePic:
                                            _model.bruker!.profilepic ?? '',
                                        messages: [],
                                      );

                                      FFAppState()
                                          .conversations
                                          .add(newConversation);

                                      // Return the new conversation
                                      return newConversation;
                                    },
                                  );

                                  String? serializedConversation =
                                      serializeParam(
                                    existingConversation.toJson(),
                                    ParamType.JSON,
                                  );

                                  _model.messageIsLoading = false;
                                  if (serializedConversation != null) {
                                    Navigator.pop(context);
                                    context.pushNamed(
                                      'message',
                                      queryParameters: {
                                        'conversation': serializedConversation,
                                      },
                                    );
                                  }
                                } on SocketException {
                                  _model.messageIsLoading = false;

                                  Toasts.showErrorToast(
                                      context, 'Ingen internettforbindelse');
                                } catch (e) {
                                  _model.messageIsLoading = false;

                                  Toasts.showErrorToast(
                                      context, 'En feil oppstod');
                                }
                              },
                              child: const Text(
                                'Send melding',
                                style: TextStyle(
                                  fontSize: 19,
                                  color: CupertinoColors.systemBlue,
                                ),
                              ),
                            ),
                            CupertinoActionSheetAction(
                              onPressed: () async {
                                await showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  barrierColor:
                                      const Color.fromARGB(60, 17, 0, 0),
                                  useRootNavigator: true,
                                  context: context,
                                  builder: (context) {
                                    return GestureDetector(
                                      onTap: () =>
                                          FocusScope.of(context).unfocus(),
                                      child: Padding(
                                        padding:
                                            MediaQuery.viewInsetsOf(context),
                                        child: ReportWidget(
                                          username: widget.uid,
                                          matId: null,
                                        ),
                                      ),
                                    );
                                  },
                                ).then((value) => setState(() {}));
                                return;
                              },
                              child: const Text(
                                'Rapporter',
                                style: TextStyle(
                                  fontSize: 19,
                                  color: Colors
                                      .red, // Red text for 'Slett annonse'
                                ),
                              ),
                            ),
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.pop(context); // Close the action sheet
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
          body: SafeArea(
            top: true,
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: RefreshIndicator.adaptive(
                    color: FlutterFlowTheme.of(context).alternate,
                    onRefresh: () async {
                      HapticFeedback.lightImpact();
                      _checkUser();
                      getUserFood(true);
                    },
                    child: SingleChildScrollView(
                      controller: _scrollController1,
                      physics: AlwaysScrollableScrollPhysics(),
                      primary: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              SingleChildScrollView(
                                primary: false,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: widget.fromChat != true
                                            ? const EdgeInsetsDirectional
                                                .fromSTEB(0, 10, 0, 10)
                                            : const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 0, 0),
                                        child: SafeArea(
                                          child: Container(
                                            width: valueOrDefault<double>(
                                              MediaQuery.sizeOf(context).width,
                                              500.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (_model.isLoading != true)
                                      ListView(
                                        padding: EdgeInsets.zero,
                                        primary: false,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 0, 30),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0, 0),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            24, 0, 0, 5),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: 90,
                                                          height: 90,
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          decoration:
                                                              const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child:
                                                              CachedNetworkImage(
                                                            fadeInDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        0),
                                                            fadeOutDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        0),
                                                            imageUrl: _model
                                                                    .isLoading
                                                                ? ''
                                                                : '${ApiConstants.baseUrl}${_model.bruker?.profilepic}',
                                                            fit: BoxFit.cover,
                                                            errorWidget: (context,
                                                                    error,
                                                                    stackTrace) =>
                                                                Image.asset(
                                                              'assets/images/profile_pic.png',
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  7, 0, 0, 0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        10,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              5,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                70,
                                                                            height:
                                                                                50,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Text(
                                                                                  _model.matvarer?.length.toString() ?? '',
                                                                                  textAlign: TextAlign.center,
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Nunito',
                                                                                        fontSize: 16,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w600,
                                                                                      ),
                                                                                ),
                                                                                Text(
                                                                                  _model.matvarer?.length == 1 ? 'matvare' : 'matvarer',
                                                                                  textAlign: TextAlign.center,
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Nunito',
                                                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0.0,
                                                                                      ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              5,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                70,
                                                                            height:
                                                                                50,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child:
                                                                                InkWell(
                                                                              splashColor: Colors.transparent,
                                                                              focusColor: Colors.transparent,
                                                                              hoverColor: Colors.transparent,
                                                                              highlightColor: Colors.transparent,
                                                                              onTap: () async {
                                                                                try {
                                                                                  if ((_model.bruker?.followersCount) != 0) {
                                                                                    if (widget.fromChat != true) {
                                                                                      context.pushNamed(
                                                                                        'Folgere',
                                                                                        queryParameters: {
                                                                                          'username': serializeParam(widget.uid, ParamType.String),
                                                                                          'folger': serializeParam('Følgere', ParamType.String),
                                                                                        }.withoutNulls,
                                                                                      );
                                                                                    } else {
                                                                                      context.pushNamed(
                                                                                        'Folgere1',
                                                                                        queryParameters: {
                                                                                          'username': serializeParam(widget.uid, ParamType.String),
                                                                                          'folger': serializeParam('Følgere', ParamType.String),
                                                                                          'fromChat': serializeParam(true, ParamType.bool),
                                                                                        }.withoutNulls,
                                                                                      );
                                                                                    }
                                                                                  }
                                                                                } catch (e) {
                                                                                  Toasts.showErrorToast(context, 'En uforventet feil oppstod');
                                                                                  logger.d('Error navigating page');
                                                                                }
                                                                              },
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Text(
                                                                                    _model.bruker!.followersCount.toString(),
                                                                                    textAlign: TextAlign.center,
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: 'Nunito',
                                                                                          fontSize: 16,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                  ),
                                                                                  Text(
                                                                                    'følgere',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: 'Nunito',
                                                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                                                          fontSize: 13,
                                                                                          letterSpacing: 0.0,
                                                                                        ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              5,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                70,
                                                                            height:
                                                                                50,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child:
                                                                                InkWell(
                                                                              splashColor: Colors.transparent,
                                                                              focusColor: Colors.transparent,
                                                                              hoverColor: Colors.transparent,
                                                                              highlightColor: Colors.transparent,
                                                                              onTap: () async {
                                                                                try {
                                                                                  if (_model.bruker!.followingCount != 0) {
                                                                                    if (widget.fromChat != true) {
                                                                                      context.pushNamed(
                                                                                        'Folgere',
                                                                                        queryParameters: {
                                                                                          'username': serializeParam(widget.uid, ParamType.String),
                                                                                          'folger': serializeParam(
                                                                                            'Følger',
                                                                                            ParamType.String,
                                                                                          ),
                                                                                        }.withoutNulls,
                                                                                      );
                                                                                    } else {
                                                                                      context.pushNamed(
                                                                                        'Folgere1',
                                                                                        queryParameters: {
                                                                                          'username': serializeParam(widget.uid, ParamType.String),
                                                                                          'folger': serializeParam(
                                                                                            'Følger',
                                                                                            ParamType.String,
                                                                                          ),
                                                                                          'fromChat': serializeParam(true, ParamType.bool),
                                                                                        }.withoutNulls,
                                                                                      );
                                                                                    }
                                                                                  }
                                                                                } catch (e) {
                                                                                  Toasts.showErrorToast(context, 'En uforventet feil oppstod');
                                                                                  logger.d('Error navigating page');
                                                                                }
                                                                              },
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Text(
                                                                                    _model.bruker!.followingCount.toString(),
                                                                                    textAlign: TextAlign.center,
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: 'Nunito',
                                                                                          fontSize: 16,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                  ),
                                                                                  Text(
                                                                                    'følger',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: 'Nunito',
                                                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                                                          fontSize: 13,
                                                                                          letterSpacing: 0.0,
                                                                                        ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0,
                                                                        10,
                                                                        0,
                                                                        0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    if (_model
                                                                            .folger ==
                                                                        true)
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () async {
                                                                          if (_model
                                                                              .folgerLoading) {
                                                                            return;
                                                                          }
                                                                          _model.folgerLoading =
                                                                              true;
                                                                          await showModalBottomSheet(
                                                                            isScrollControlled:
                                                                                true,
                                                                            backgroundColor:
                                                                                Colors.transparent,
                                                                            barrierColor: const Color.fromARGB(
                                                                                60,
                                                                                17,
                                                                                0,
                                                                                0),
                                                                            useRootNavigator:
                                                                                true,
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (context) {
                                                                              return GestureDetector(
                                                                                onTap: () => FocusScope.of(context).unfocus(),
                                                                                child: Padding(
                                                                                  padding: MediaQuery.viewInsetsOf(context),
                                                                                  child: FollowUserWidget(
                                                                                    username: widget.username,
                                                                                    uid: widget.uid,
                                                                                    pushEnabled: _model.bruker?.getPush ?? false,
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                          ).then((value) =>
                                                                              setState(() {
                                                                                if (value == true) {
                                                                                  _model.folger = false;
                                                                                  safeSetState(() {});
                                                                                  unFolg();
                                                                                  _model.folgerLoading = false;
                                                                                }
                                                                                _model.folgerLoading = false;
                                                                              }));
                                                                          return;
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          width: ((_model.bruker!.ratingTotalCount ?? 0) != 0)
                                                                              ? 130
                                                                              : 215,
                                                                          height:
                                                                              35,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primary,
                                                                            borderRadius:
                                                                                BorderRadius.circular(9),
                                                                            border:
                                                                                Border.all(
                                                                              color: const Color.fromARGB(32, 87, 99, 108),
                                                                              width: 1.3,
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                'Følger',
                                                                                style: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                      fontFamily: 'Nunito',
                                                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                                                      fontSize: 14,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              Icon(
                                                                                CupertinoIcons.chevron_down,
                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                size: 17,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    if (_model
                                                                            .folger !=
                                                                        true)
                                                                      FFButtonWidget(
                                                                        onPressed:
                                                                            () async {
                                                                          if (_model
                                                                              .folgerLoading) {
                                                                            return;
                                                                          }
                                                                          _model.folgerLoading =
                                                                              true;
                                                                          HapticFeedback
                                                                              .mediumImpact();
                                                                          _model.folger =
                                                                              true;
                                                                          safeSetState(
                                                                              () {});
                                                                          folgBruker();
                                                                          _model.folgerLoading =
                                                                              false;
                                                                          await showModalBottomSheet(
                                                                            isScrollControlled:
                                                                                true,
                                                                            backgroundColor:
                                                                                Colors.transparent,
                                                                            barrierColor: const Color.fromARGB(
                                                                                153,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            useRootNavigator:
                                                                                true,
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (context) {
                                                                              return GestureDetector(
                                                                                onTap: () => FocusScope.of(context).unfocus(),
                                                                                child: Padding(
                                                                                  padding: MediaQuery.viewInsetsOf(context),
                                                                                  child: FollowUserWidget(
                                                                                    username: widget.username,
                                                                                    uid: widget.uid,
                                                                                    pushEnabled: _model.bruker?.getPush ?? false,
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                          ).then((value) =>
                                                                              setState(() {
                                                                                if (value == true) {
                                                                                  _model.folger = false;
                                                                                  safeSetState(() {});
                                                                                  unFolg();
                                                                                  _model.folgerLoading = false;
                                                                                }
                                                                                _model.folgerLoading = false;
                                                                              }));
                                                                          return;
                                                                        },
                                                                        text:
                                                                            'Følg',
                                                                        options:
                                                                            FFButtonOptions(
                                                                          width: ((_model.bruker!.ratingTotalCount ?? 0) != 0)
                                                                              ? 130
                                                                              : 215,
                                                                          height:
                                                                              35,
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              16,
                                                                              0,
                                                                              16,
                                                                              0),
                                                                          iconPadding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          color:
                                                                              FlutterFlowTheme.of(context).alternate,
                                                                          textStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .override(
                                                                                fontFamily: 'Nunito',
                                                                                color: Colors.white,
                                                                                letterSpacing: 0.0,
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                          elevation:
                                                                              0,
                                                                          borderRadius:
                                                                              BorderRadius.circular(9),
                                                                        ),
                                                                      ),
                                                                    if (((_model.bruker!.ratingTotalCount ??
                                                                            0) !=
                                                                        0))
                                                                      Padding(
                                                                        padding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            9,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            InkWell(
                                                                          splashColor:
                                                                              Colors.transparent,
                                                                          focusColor:
                                                                              Colors.transparent,
                                                                          hoverColor:
                                                                              Colors.transparent,
                                                                          highlightColor:
                                                                              Colors.transparent,
                                                                          onTap:
                                                                              () async {
                                                                            await showModalBottomSheet(
                                                                              isScrollControlled: true,
                                                                              backgroundColor: Colors.transparent,
                                                                              barrierColor: const Color.fromARGB(60, 17, 0, 0),
                                                                              useRootNavigator: true,
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return GestureDetector(
                                                                                  onTap: () => FocusScope.of(context).unfocus(),
                                                                                  child: Padding(
                                                                                    padding: MediaQuery.viewInsetsOf(context),
                                                                                    child: RatingsWidget(
                                                                                      uid: widget.uid,
                                                                                      username: widget.username,
                                                                                      mine: false,
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ).then((value) =>
                                                                                setState(() {}));
                                                                            return;
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                105,
                                                                            height:
                                                                                36,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                              borderRadius: BorderRadius.circular(8),
                                                                              border: Border.all(
                                                                                color: const Color.fromARGB(32, 87, 99, 108),
                                                                                width: 1.3,
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                FaIcon(
                                                                                  FontAwesomeIcons.solidStar,
                                                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                                                  size: 16,
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(1, 0, 0, 0),
                                                                                  child: Text(
                                                                                    _model.bruker!.ratingAverageValue.toString(),
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: 'Nunito',
                                                                                          fontSize: 14,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(1, 0, 0, 0),
                                                                                  child: Text(
                                                                                    ' (${_model.bruker!.ratingTotalCount.toString()})',
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: 'Nunito',
                                                                                          color: const Color(0xB0262C2D),
                                                                                          fontSize: 14,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.w500,
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
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(0, 5, 0, 0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                24, 0, 0, 0),
                                                        child: Text(
                                                          _model.isLoading
                                                              ? '' // Show an empty string while loading
                                                              : (_model.bruker
                                                                          ?.bonde ==
                                                                      true
                                                                  ? _model
                                                                      .bruker!
                                                                      .gardsnavn
                                                                      .toString()
                                                                  : '${_model.bruker?.firstname} ${_model.bruker?.lastname}'), // Show gardsnavn if bonde is true, otherwise show username
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .headlineLarge
                                                              .override(
                                                                fontFamily:
                                                                    'Nunito',
                                                                fontSize: 17,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if ((_model.bruker?.bio ?? '')
                                                    .isNotEmpty)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            24, 4, 40, 0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                          ),
                                                          child: Text(
                                                            _model.isLoading
                                                                ? ''
                                                                : _model.bruker
                                                                        ?.bio ??
                                                                    '',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  fontSize: 14,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                            maxLines: _model
                                                                    .isExpanded
                                                                ? null
                                                                : 2, // Show limited lines if not expanded
                                                            overflow: _model
                                                                    .isExpanded
                                                                ? TextOverflow
                                                                    .visible
                                                                : TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        if (FFAppState()
                                                                    .bio
                                                                    .length >
                                                                50 ||
                                                            '\n'
                                                                    .allMatches(
                                                                        FFAppState()
                                                                            .bio)
                                                                    .length >=
                                                                2)
                                                          const SizedBox(
                                                              height: 2),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              _model.isExpanded =
                                                                  !_model
                                                                      .isExpanded; // Toggle the expanded state
                                                            });
                                                          },
                                                          child: Text(
                                                            _model.isExpanded
                                                                ? 'Se mindre'
                                                                : 'Se mer',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodySmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: const Color
                                                                      .fromRGBO(
                                                                      113,
                                                                      113,
                                                                      113,
                                                                      1.0),
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 20, 0, 0),
                                              child: Column(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        const Alignment(0, 0),
                                                    child: TabBar(
                                                      labelColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      unselectedLabelColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      labelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Nunito',
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                      unselectedLabelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Nunito',
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                      indicatorColor:
                                                          const Color(
                                                              0x00F6F6F6),
                                                      dividerColor:
                                                          const Color.fromARGB(
                                                              10, 0, 0, 0),
                                                      indicatorWeight: 1,
                                                      tabs: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              CupertinoIcons
                                                                  .square_grid_2x2,
                                                              color: _model
                                                                          .tabBarCurrentIndex ==
                                                                      0
                                                                  ? FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText
                                                                  : Colors.grey,
                                                              size: 32,
                                                            ),
                                                            const Tab(
                                                              text: '',
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            FaIcon(
                                                              FontAwesomeIcons
                                                                  .bars,
                                                              color: _model
                                                                          .tabBarCurrentIndex ==
                                                                      1
                                                                  ? FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText
                                                                  : Colors.grey,
                                                              size: 27,
                                                            ),
                                                            const Tab(
                                                              text: '',
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                      controller: _model
                                                          .tabBarController,
                                                      onTap: (i) async {
                                                        [
                                                          () async {},
                                                          () async {}
                                                        ][i]();
                                                      },
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: TabBarView(
                                                      controller: _model
                                                          .tabBarController,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      children: [
                                                        Container(),
                                                        Container(),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (_model.isLoading != true &&
                                        _model.empty == true)
                                      SizedBox(
                                        width: MediaQuery.sizeOf(context).width,
                                        height:
                                            MediaQuery.sizeOf(context).height -
                                                550,
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize
                                                .min, // Use min to fit content
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                CupertinoIcons
                                                    .camera_on_rectangle,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                size: 56,
                                              ),
                                              const SizedBox(height: 16),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Ingen annonser ennå',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLarge
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 19,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    if (_model.isLoading != true)
                                      if (_model.tabBarCurrentIndex == 0)
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(5, 0, 5, 70),
                                          child: RefreshIndicator(
                                            onRefresh: () async {},
                                            child: GridView.builder(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                0,
                                                0,
                                                0,
                                                70,
                                              ),
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                childAspectRatio: 0.68,
                                              ),
                                              primary: false,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount: _model.matisLoading
                                                  ? 1
                                                  : _model.end
                                                      ? _model.matvarer
                                                              ?.length ??
                                                          1
                                                      : (_model.matvarer
                                                                  ?.length ??
                                                              1) +
                                                          1,
                                              itemBuilder: (context, index) {
                                                if (_model.matisLoading ||
                                                    _model.empty) {
                                                  return ShimmerLoadingWidget();
                                                }
                                                if (index <
                                                    (_model.matvarer?.length ??
                                                        0)) {
                                                  final matvarer =
                                                      _model.matvarer![index];

                                                  return Stack(
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            const AlignmentDirectional(
                                                                0, -1),
                                                        child: InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            try {
                                                              if (widget
                                                                      .fromChat !=
                                                                  true) {
                                                                context
                                                                    .pushNamed(
                                                                  'MatDetaljBondegard',
                                                                  queryParameters: {
                                                                    'matvare':
                                                                        serializeParam(
                                                                      matvarer
                                                                          .toJson(), // Convert to JSON before passing
                                                                      ParamType
                                                                          .JSON,
                                                                    ),
                                                                  },
                                                                );
                                                              } else {
                                                                context
                                                                    .pushNamed(
                                                                  'MatDetaljBondegard2',
                                                                  queryParameters: {
                                                                    'matvare':
                                                                        serializeParam(
                                                                      matvarer
                                                                          .toJson(), // Convert to JSON before passing
                                                                      ParamType
                                                                          .JSON,
                                                                    ),
                                                                    'fromChat':
                                                                        serializeParam(
                                                                      true,
                                                                      ParamType
                                                                          .bool,
                                                                    ),
                                                                  },
                                                                );
                                                              }
                                                            } catch (e) {
                                                              Toasts.showErrorToast(
                                                                  context,
                                                                  'En uforventet feil oppstod');
                                                              logger.d(
                                                                  'Error navigating page');
                                                            }
                                                          },
                                                          child: Material(
                                                            color: Colors
                                                                .transparent,
                                                            elevation: 0,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16),
                                                            ),
                                                            child: Container(
                                                              width: 235,
                                                              height: 290,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16),
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .transparent,
                                                                ),
                                                              ),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        const AlignmentDirectional(
                                                                            0,
                                                                            0),
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          3,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(17),
                                                                        child: Image
                                                                            .network(
                                                                          '${ApiConstants.baseUrl}${matvarer.imgUrls![0]}',
                                                                          width:
                                                                              200,
                                                                          height:
                                                                              229,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          errorBuilder: (BuildContext context,
                                                                              Object error,
                                                                              StackTrace? stackTrace) {
                                                                            return Image.asset(
                                                                              'assets/images/error_image.jpg',
                                                                              width: 200,
                                                                              height: 229,
                                                                              fit: BoxFit.cover,
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            5,
                                                                            0,
                                                                            5,
                                                                            0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        Align(
                                                                          alignment: const AlignmentDirectional(
                                                                              -1,
                                                                              0),
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                7,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            child:
                                                                                AutoSizeText(
                                                                              matvarer.name ?? '',
                                                                              textAlign: TextAlign.start,
                                                                              minFontSize: 11,
                                                                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                    fontFamily: 'Nunito',
                                                                                    fontSize: 14,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            4),
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Flexible(
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                const AlignmentDirectional(0, 0),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                                                                              child: Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: const EdgeInsetsDirectional.fromSTEB(7, 0, 0, 0),
                                                                                          child: Text(
                                                                                            '${matvarer.price} Kr',
                                                                                            textAlign: TextAlign.end,
                                                                                            style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                                  fontFamily: 'Nunito',
                                                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                  fontSize: 14,
                                                                                                  letterSpacing: 0.0,
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                ),
                                                                                          ),
                                                                                        ),
                                                                                        if (matvarer.kg == true)
                                                                                          Text(
                                                                                            '/kg',
                                                                                            textAlign: TextAlign.end,
                                                                                            style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                                  fontFamily: 'Nunito',
                                                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                  fontSize: 14,
                                                                                                  letterSpacing: 0.0,
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                ),
                                                                                          ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 7, 0),
                                                                                        child: Text(
                                                                                          (CalculateDistance.calculateDistance(FFAppState().brukerLat, FFAppState().brukerLng, matvarer.lat ?? 0.0, matvarer.lng ?? 0.0) < 1) ? '<1 Km' : '${CalculateDistance.calculateDistance(FFAppState().brukerLat, FFAppState().brukerLng, matvarer.lat ?? 0.0, matvarer.lng ?? 0.0).toStringAsFixed(0)} Km',
                                                                                          textAlign: TextAlign.start,
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                fontFamily: 'Nunito',
                                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                fontSize: 14,
                                                                                                letterSpacing: 0.0,
                                                                                                fontWeight: FontWeight.bold,
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
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      if (matvarer.kjopt ==
                                                          true)
                                                        Positioned(
                                                          top:
                                                              15, // Slight offset from the top edge
                                                          right:
                                                              -29, // Fine-tune the positioning (shift it to the right edge)
                                                          child:
                                                              Transform.rotate(
                                                            angle:
                                                                0.600, // 45-degree angle (approx.)
                                                            child: Container(
                                                              width:
                                                                  140, // Adjusted width to avoid overflow after rotation
                                                              height: 23,
                                                              color: Colors
                                                                  .redAccent,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: const Text(
                                                                'Utsolgt',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14, // Font size adjusted to fit the banner
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  );
                                                } else {
                                                  if (_model.matvarer!.length <
                                                      44) {
                                                    return Container();
                                                  } else {
                                                    return ShimmerLoadingWidget();
                                                  }
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (_model.tabBarCurrentIndex == 1)
                            ListView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                0,
                                0,
                                0,
                                170,
                              ),
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: _model.matisLoading
                                  ? 1
                                  : _model.matvarer?.length ?? 1,
                              itemBuilder: (context, index) {
                                if (_model.matisLoading || _model.empty) {
                                  return Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            17, 20, 0, 0),
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Row(
                                        children: [
                                          // Shimmer for Image
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: Container(
                                              width: 60,
                                              height: 60,
                                              color: const Color.fromARGB(
                                                  127,
                                                  255,
                                                  255,
                                                  255), // Background color
                                            ),
                                          ),
                                          const SizedBox(width: 16.0),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Shimmer.fromColors(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor:
                                                      Colors.grey[100]!,
                                                  child: Container(
                                                    width: 120,
                                                    height: 16.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              127,
                                                              255,
                                                              255,
                                                              255),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8.0),
                                                Shimmer.fromColors(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor:
                                                      Colors.grey[100]!,
                                                  child: Container(
                                                    width:
                                                        90.0, // Narrower width for second line
                                                    height: 16.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              127,
                                                              255,
                                                              255,
                                                              255),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                final matvarer = _model.matvarer![index];

                                return Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      10, 10, 10, 0),
                                  child: Stack(
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          try {
                                            if (widget.fromChat != true) {
                                              context.pushNamed(
                                                'MatDetaljBondegard',
                                                queryParameters: {
                                                  'matvare': serializeParam(
                                                    matvarer.toJson(),
                                                    ParamType.JSON,
                                                  ),
                                                },
                                              );
                                            } else {
                                              context.pushNamed(
                                                'MatDetaljBondegard2',
                                                queryParameters: {
                                                  'matvare': serializeParam(
                                                    matvarer.toJson(),
                                                    ParamType.JSON,
                                                  ),
                                                  'fromChat': serializeParam(
                                                    true,
                                                    ParamType.bool,
                                                  ),
                                                },
                                              );
                                            }
                                          } catch (e) {
                                            Toasts.showErrorToast(context,
                                                'En uforventet feil oppstod');
                                            logger.d('Error navigating page');
                                          }
                                        },
                                        child: Material(
                                          color: Colors.transparent,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(8, 0, 8, 8),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0, 1, 1, 1),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      child: Image.network(
                                                        '${ApiConstants.baseUrl}${matvarer.imgUrls![0].toString()}',
                                                        width: 64,
                                                        height: 64,
                                                        fit: BoxFit.cover,
                                                        errorBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Object error,
                                                                StackTrace?
                                                                    stackTrace) {
                                                          return Image.asset(
                                                            'assets/images/error_image.jpg', // Path to your local error image
                                                            height: 64,
                                                            width: 64,
                                                            fit: BoxFit.cover,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              12, 0, 4, 0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                child: Text(
                                                                  matvarer.name ??
                                                                      '',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineSmall
                                                                      .override(
                                                                        fontFamily:
                                                                            'Nunito',
                                                                        fontSize:
                                                                            16,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                      ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0,
                                                                        3,
                                                                        0,
                                                                        0),
                                                                child: Text(
                                                                  'Tilgjengelig: ${matvarer.antall!.toStringAsFixed(0)} Stk',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineSmall
                                                                      .override(
                                                                        fontFamily:
                                                                            'Nunito',
                                                                        fontSize:
                                                                            14,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    0, 0, 0, 0),
                                                            child: Text(
                                                              '${matvarer.price} Kr',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .headlineSmall
                                                                  .override(
                                                                    fontFamily:
                                                                        'Nunito',
                                                                    fontSize:
                                                                        15,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
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
                                      ),
                                      if (matvarer.kjopt == true)
                                        Positioned(
                                          top: 15,
                                          left: -29,
                                          child: Transform.rotate(
                                            angle: -0.600,
                                            child: Container(
                                              width: 140,
                                              height: 23,
                                              color: Colors.redAccent,
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'Utsolgt',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
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
