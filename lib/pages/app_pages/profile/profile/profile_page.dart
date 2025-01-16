import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mat_salg/models/matvarer.dart';
import 'package:mat_salg/helper_components/widgets/shimmer_widgets/shimmer_product.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/helper_components/widgets/product_grid.dart';
import 'package:mat_salg/my_ip.dart';
import 'package:mat_salg/pages/app_pages/home/user_ratings/ratings_widget.dart';
import 'package:mat_salg/pages/app_pages/profile/profile/profile_services.dart';
import 'package:mat_salg/services/firebase_service.dart';
import 'package:mat_salg/services/food_service.dart';
import 'package:mat_salg/services/user_service.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'profile_model.dart';
export 'profile_model.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilWidgetState();
}

class _ProfilWidgetState extends State<ProfilePage>
    with TickerProviderStateMixin {
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final UserInfoService userInfoService = UserInfoService();
  final ScrollController _scrollController1 = ScrollController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late ProfileModel _model;
  late ProfileServices profileServices;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileModel());
    profileServices = ProfileServices(model: _model);

    refreshPage();
    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
    _scrollController1.addListener(_scrollListener);
    FFAppState().addListener(_onRouteChanged);
    checkPushPermission();
  }

  Future<void> checkPushPermission() async {
    final settings = await _firebaseMessaging.getNotificationSettings();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseApi().initNotifications();
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return;
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.notDetermined) {
      if (!mounted) return;
      context.pushNamed('RequestPush');
    }
  }

  Future<void> getMyFoods(bool refresh) async {
    try {
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return;
      } else {
        if (refresh == true) {
          _model.page = 0;
          _model.end = false;
          _model.matvarer = await ApiFoodService.getMyFoods(token, 0);
        } else {
          List<Matvarer>? nyeMatvarer =
              await ApiFoodService.getMyFoods(token, _model.page);

          _model.matvarer ??= [];

          if (nyeMatvarer != null && nyeMatvarer.isNotEmpty) {
            _model.matvarer?.addAll(nyeMatvarer);
          } else {
            _model.end = true;
          }
        }

        if (mounted) {
          setState(() {
            if (_model.matvarer != null && _model.matvarer!.isEmpty) {
              _model.isloading = false;
              return;
            } else {
              _model.isloading = false;
            }
          });
        }
      }
    } on SocketException {
      setState(() {
        _model.isloading = false;
      });
      if (!mounted) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      if (!mounted) return;
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

  Future<void> refreshPage() async {
    try {
      _model.isloading = true;
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        _model.isloading = false;
        return;
      } else {
        if (!mounted) return;
        getMyFoods(true);
        profileServices.getAllLikes(context, token);

        userInfoService.fetchData(context);
        await userInfoService.updateUserStats(context, true);
        _model.isloading = false;
        if (_model.matvarer != null && _model.matvarer!.isEmpty) {
          safeSetState(() {});
        }
      }
    } on SocketException {
      _model.isloading = false;
      if (!mounted) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      _model.isloading = false;
      if (!mounted) return;
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

  void _scrollListener() async {
    if (_scrollController1.position.pixels >=
        _scrollController1.position.maxScrollExtent) {
      if (_isLoading ||
          _model.end ||
          _model.matvarer == null ||
          _model.matvarer!.length < 44 ||
          _model.tabBarCurrentIndex == 1) return;
      _isLoading = true;
      _model.page += 1;
      await getMyFoods(false);
      safeSetState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _onRouteChanged() async {
    if (!mounted) return;
    await getMyFoods(true);
    await refreshPage();
    setState(() {});
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
    FFAppState().removeListener(_onRouteChanged);
    _scrollController1.removeListener(_scrollListener);
    _scrollController1.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = 2;
    final itemHeight = 290.0;
    final childAspectRatio = (screenWidth / crossAxisCount) / itemHeight;
    context.watch<FFAppState>();

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
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0.0,
            title: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              child: Align(
                alignment: const AlignmentDirectional(0, 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: SafeArea(
                    child: Container(
                      width: valueOrDefault<double>(
                        MediaQuery.sizeOf(context).width,
                        500.0,
                      ),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                      child: Stack(
                        alignment: const AlignmentDirectional(0, 0),
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 0, 8, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Align(
                                  alignment: const AlignmentDirectional(1, 0),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        try {
                                          context.pushNamed('innstillinger');
                                        } on SocketException {
                                          Toasts.showErrorToast(context,
                                              'Ingen internettforbindelse');
                                        } catch (e) {
                                          Toasts.showErrorToast(
                                              context, 'En feil oppstod');
                                        }
                                      },
                                      child: Icon(
                                        CupertinoIcons.gear,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        size: 29,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Text(
                              '@${FFAppState().brukernavn}',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Nunito',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize: 19,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            actions: const [],
            centerTitle: true,
            elevation: 0.0,
          ),
          body: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: RefreshIndicator.adaptive(
                    color: FlutterFlowTheme.of(context).alternate,
                    onRefresh: () async {
                      refreshPage();
                      HapticFeedback.selectionClick();
                    },
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                      child: CustomScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: _scrollController1,
                        slivers: [
                          SliverToBoxAdapter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListView(
                                  padding: EdgeInsets.zero,
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 0, 0),
                                      child: SingleChildScrollView(
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
                                                        .fromSTEB(24, 0, 0, 5),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () async {
                                                        showCupertinoModalPopup(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return CupertinoActionSheet(
                                                              title: const Text(
                                                                'Velg en handling',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: CupertinoColors
                                                                      .secondaryLabel,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                              actions: <Widget>[
                                                                CupertinoActionSheetAction(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    context
                                                                        .pushNamed(
                                                                      'ProfilRediger',
                                                                      queryParameters: {
                                                                        'konto':
                                                                            serializeParam(
                                                                          'Profilbilde',
                                                                          ParamType
                                                                              .String,
                                                                        ),
                                                                      },
                                                                    );
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'Oppdater',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          19,
                                                                      color: CupertinoColors
                                                                          .systemBlue,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                              cancelButton:
                                                                  CupertinoActionSheetAction(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                isDefaultAction:
                                                                    true,
                                                                child:
                                                                    const Text(
                                                                  'Avbryt',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        19,
                                                                    color: CupertinoColors
                                                                        .systemBlue,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Container(
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
                                                              Duration.zero,
                                                          fadeOutDuration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      0),
                                                          imageUrl:
                                                              '${ApiConstants.baseUrl}${FFAppState().profilepic}',
                                                          fit: BoxFit.cover,
                                                          errorWidget: (context,
                                                                  error,
                                                                  stackTrace) =>
                                                              Image.asset(
                                                            'assets/images/profile_pic.png',
                                                            width: 90,
                                                            height: 90,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              7, 0, 0, 20),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    10,
                                                                    15,
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
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primary,
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
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
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primary,
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                        ),
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
                                                                            try {
                                                                              if (FFAppState().followersCount != 0) {
                                                                                context.pushNamed(
                                                                                  'FolgereProfile',
                                                                                  queryParameters: {
                                                                                    'username': serializeParam(FirebaseAuth.instance.currentUser!.uid, ParamType.String),
                                                                                    'folger': serializeParam(
                                                                                      'Følgere',
                                                                                      ParamType.String,
                                                                                    ),
                                                                                  }.withoutNulls,
                                                                                );
                                                                              }
                                                                            } on SocketException {
                                                                              Toasts.showErrorToast(context, 'Ingen internettforbindelse');
                                                                            } catch (e) {
                                                                              Toasts.showErrorToast(context, 'En feil oppstod');
                                                                            }
                                                                          },
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                FFAppState().followersCount.toString(),
                                                                                textAlign: TextAlign.center,
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: 'Nunito',
                                                                                      fontSize: 17,
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
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primary,
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                        ),
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
                                                                            try {
                                                                              if (FFAppState().followingCount != 0) {
                                                                                context.pushNamed(
                                                                                  'FolgereProfile',
                                                                                  queryParameters: {
                                                                                    'username': serializeParam(FirebaseAuth.instance.currentUser!.uid, ParamType.String),
                                                                                    'folger': serializeParam(
                                                                                      'Følger',
                                                                                      ParamType.String,
                                                                                    ),
                                                                                  }.withoutNulls,
                                                                                );
                                                                              }
                                                                            } on SocketException {
                                                                              Toasts.showErrorToast(context, 'Ingen internettforbindelse');
                                                                            } catch (e) {
                                                                              Toasts.showErrorToast(context, 'En feil oppstod');
                                                                            }
                                                                          },
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                FFAppState().followingCount.toString(),
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
                                                                    .fromSTEB(0,
                                                                    10, 0, 0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          9,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child:
                                                                      InkWell(
                                                                    splashColor:
                                                                        Colors
                                                                            .transparent,
                                                                    focusColor:
                                                                        Colors
                                                                            .transparent,
                                                                    hoverColor:
                                                                        Colors
                                                                            .transparent,
                                                                    highlightColor:
                                                                        Colors
                                                                            .transparent,
                                                                    onTap:
                                                                        () async {
                                                                      try {
                                                                        await showModalBottomSheet(
                                                                          isScrollControlled:
                                                                              true,
                                                                          backgroundColor:
                                                                              Colors.transparent,
                                                                          barrierColor: const Color
                                                                              .fromARGB(
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
                                                                                child: RatingsWidget(
                                                                                  uid: FirebaseAuth.instance.currentUser!.uid,
                                                                                  username: FFAppState().brukernavn,
                                                                                  mine: true,
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ).then((value) =>
                                                                            setState(() {}));
                                                                        return;
                                                                      } on SocketException {
                                                                        if (!context
                                                                            .mounted) {
                                                                          return;
                                                                        }
                                                                        Toasts.showErrorToast(
                                                                            context,
                                                                            'Ingen internettforbindelse');
                                                                      } catch (e) {
                                                                        if (!context
                                                                            .mounted) {
                                                                          return;
                                                                        }
                                                                        Toasts.showErrorToast(
                                                                            context,
                                                                            'En feil oppstod');
                                                                      }
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          200,
                                                                      height:
                                                                          30,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              const Color(0x4A57636C),
                                                                          width:
                                                                              1.3,
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            0,
                                                                            1,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            if (FFAppState().ratingTotalCount ==
                                                                                0)
                                                                              Padding(
                                                                                padding: const EdgeInsetsDirectional.fromSTEB(1, 0, 0, 0),
                                                                                child: Text(
                                                                                  'Ingen vurderinger',
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Nunito',
                                                                                        fontSize: 14,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w600,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            if (FFAppState().ratingTotalCount !=
                                                                                0)
                                                                              FaIcon(
                                                                                FontAwesomeIcons.solidStar,
                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                size: 16,
                                                                              ),
                                                                            if (FFAppState().ratingTotalCount !=
                                                                                0)
                                                                              Padding(
                                                                                padding: const EdgeInsetsDirectional.fromSTEB(1, 0, 0, 0),
                                                                                child: Text(
                                                                                  FFAppState().ratingAverageValue.toString(),
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Nunito',
                                                                                        fontSize: 14,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w600,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            if (FFAppState().ratingTotalCount !=
                                                                                0)
                                                                              Padding(
                                                                                padding: const EdgeInsetsDirectional.fromSTEB(1, 0, 0, 0),
                                                                                child: Text(
                                                                                  ' (${FFAppState().ratingTotalCount.toString()})',
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
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            24, 0, 0, 0),
                                                    child: Text(
                                                      '${FFAppState().firstname} ${FFAppState().lastname}',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .headlineLarge
                                                          .override(
                                                            fontFamily:
                                                                'Nunito',
                                                            fontSize: 18,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(24, 0, 40, 0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  {
                                                    context.pushNamed(
                                                      'ProfilRediger',
                                                      queryParameters: {
                                                        'konto': serializeParam(
                                                          'Bio',
                                                          ParamType.String,
                                                        ),
                                                      },
                                                    );
                                                  }
                                                },
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                      ),
                                                      child: Text(
                                                        FFAppState().bio.isEmpty
                                                            ? 'Trykk for å legge til bio...'
                                                            : FFAppState().bio,
                                                        maxLines: _model
                                                                .isExpanded
                                                            ? null
                                                            : 2, // Expand or limit lines
                                                        overflow:
                                                            _model.isExpanded
                                                                ? TextOverflow
                                                                    .visible
                                                                : TextOverflow
                                                                    .ellipsis,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  fontSize: FFAppState()
                                                                          .bio
                                                                          .isEmpty
                                                                      ? 15
                                                                      : 14,
                                                                  color: FFAppState()
                                                                          .bio
                                                                          .isEmpty
                                                                      ? const Color
                                                                          .fromRGBO(
                                                                          113,
                                                                          113,
                                                                          113,
                                                                          1.0)
                                                                      : FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
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
                                                      if (FFAppState()
                                                          .bio
                                                          .isNotEmpty)
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              _model.isExpanded =
                                                                  !_model
                                                                      .isExpanded; // Toggle expanded state
                                                            });
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 2),
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
                                                                    fontSize:
                                                                        13,
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
                                                        ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              height: 90,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 30, 0, 0),
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
                                                            const Color
                                                                .fromARGB(
                                                                0, 0, 0, 0),
                                                        dividerColor:
                                                            const Color
                                                                .fromARGB(
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
                                                                    : Colors
                                                                        .grey,
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
                                                              Icon(
                                                                CupertinoIcons
                                                                    .heart,
                                                                color: _model
                                                                            .tabBarCurrentIndex ==
                                                                        1
                                                                    ? FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryText
                                                                    : Colors
                                                                        .grey,
                                                                size: 32,
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
                                      ),
                                    ),
                                  ],
                                ),
                                if (_model.tabBarCurrentIndex == 0)
                                  if (((FFAppState().lagtUt != true &&
                                          _model.tabBarCurrentIndex == 0)) &&
                                      (_model.matvarer?.isEmpty ?? true) &&
                                      (_model.matvarer == null
                                          ? _model.isloading
                                          : true))
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context).width,
                                      height:
                                          MediaQuery.sizeOf(context).height -
                                              550,
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              CupertinoIcons.add,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 53,
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
                                                  'Trykk på ',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyLarge
                                                      .override(
                                                        fontFamily: 'Nunito',
                                                        fontSize: 16,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                Icon(
                                                  CupertinoIcons.add,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  size: 22,
                                                ),
                                                Text(
                                                  ' for å lage din første annonse',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyLarge
                                                      .override(
                                                        fontFamily: 'Nunito',
                                                        fontSize: 16,
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
                                if ((FFAppState().liked != true &&
                                        _model.tabBarCurrentIndex == 1 &&
                                        _model.tabBarCurrentIndex == 1) &&
                                    (_model.likesmatvarer == null ||
                                        _model.likesmatvarer!.isEmpty))
                                  SizedBox(
                                    width: MediaQuery.sizeOf(context).width,
                                    height:
                                        MediaQuery.sizeOf(context).height - 550,
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
                                            CupertinoIcons.heart,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 50,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Du kan se varer du har likt her.',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyLarge
                                                .override(
                                                  fontFamily: 'Nunito',
                                                  fontSize: 16,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if ((FFAppState().lagtUt ||
                                  _model.matvarer != null &&
                                      _model.matvarer!.isNotEmpty) &&
                              _model.tabBarCurrentIndex == 0)
                            SliverPadding(
                              padding: const EdgeInsets.fromLTRB(
                                5,
                                15,
                                5,
                                10,
                              ),
                              sliver: SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: childAspectRatio,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    if (_model.isloading) {
                                      return const ShimmerLoadingWidget();
                                    }

                                    if (index <
                                        (_model.matvarer?.length ?? 0)) {
                                      final matvare = _model.matvarer![index];
                                      return ProductList(
                                        matvare: matvare,
                                        onTap: () async {
                                          try {
                                            context.pushNamed(
                                              'MinMatvareDetalj',
                                              queryParameters: {
                                                'matvare': serializeParam(
                                                  matvare.toJson(),
                                                  ParamType.JSON,
                                                ),
                                              },
                                            );
                                          } on SocketException {
                                            Toasts.showErrorToast(context,
                                                'Ingen internettforbindelse');
                                          } catch (e) {
                                            Toasts.showErrorToast(
                                                context, 'En feil oppstod');
                                          }
                                        },
                                      );
                                    } else {
                                      if (_model.matvarer == null ||
                                          _model.matvarer!.length < 44) {
                                        return Container();
                                      } else {
                                        return const ShimmerLoadingWidget();
                                      }
                                    }
                                  },
                                  childCount: _model.isloading
                                      ? 1
                                      : _model.end ||
                                              (_model.matvarer == null ||
                                                  _model.matvarer!.length < 44)
                                          ? _model.matvarer?.length ?? 0
                                          : (_model.matvarer?.length ?? 0) + 1,
                                ),
                              ),
                            ),
                          if (_model.tabBarCurrentIndex == 1)
                            if ((FFAppState().liked &&
                                    _model.tabBarCurrentIndex == 1) ||
                                (_model.likesisloading == false &&
                                    _model.likesmatvarer!.isNotEmpty))
                              SliverPadding(
                                padding: const EdgeInsets.fromLTRB(
                                  5,
                                  15,
                                  5,
                                  10,
                                ),
                                sliver: SliverGrid(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: childAspectRatio,
                                  ),
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      if (_model.likesisloading) {
                                        return const ShimmerLoadingWidget();
                                      }
                                      final likesmatvare =
                                          _model.likesmatvarer![index];

                                      return ProductList(
                                        matvare: likesmatvare,
                                        onTap: () async {
                                          try {
                                            context.pushNamed(
                                              'MatDetaljBondegard1',
                                              queryParameters: {
                                                'matvare': serializeParam(
                                                  likesmatvare.toJson(),
                                                  ParamType.JSON,
                                                ),
                                                'liked': serializeParam(
                                                  true,
                                                  ParamType.bool,
                                                ),
                                              },
                                            );
                                          } on SocketException {
                                            Toasts.showErrorToast(context,
                                                'Ingen internettforbindelse');
                                          } catch (e) {
                                            Toasts.showErrorToast(
                                                context, 'En feil oppstod');
                                          }
                                        },
                                      );
                                    },
                                    childCount: _model.likesisloading
                                        ? 1
                                        : _model.likesmatvarer?.length ?? 1,
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
