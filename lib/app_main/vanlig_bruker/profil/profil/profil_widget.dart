import 'package:mat_salg/MyIP.dart';
import 'package:mat_salg/matvarer.dart';
import 'package:shimmer/shimmer.dart';

import '/app_main/tom_place_holders/ingen_favoritt/ingen_favoritt_widget.dart';
import '/app_main/tom_place_holders/ingen_vare_lagt_ut/ingen_vare_lagt_ut_widget.dart';
import '/app_main/vanlig_bruker/custom_nav_bar_user/profil_nav_bar/profil_nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math' as math;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'profil_model.dart';
export 'profil_model.dart';
import 'package:mat_salg/ApiCalls.dart';
import 'package:mat_salg/SecureStorage.dart';

import 'package:provider/provider.dart';

class ProfilWidget extends StatefulWidget {
  const ProfilWidget({super.key});

  @override
  State<ProfilWidget> createState() => _ProfilWidgetState();
}

class _ProfilWidgetState extends State<ProfilWidget>
    with TickerProviderStateMixin {
  late ProfilModel _model;
  List<Matvarer>? _matvarer;
  List<Matvarer>? _likesmatvarer;
  bool _isloading = true;
  bool _isempty = true;
  bool _likesisloading = true;
  bool _likesisempty = true;
  final ApiCalls apicalls = ApiCalls();
  final Securestorage securestorage = Securestorage();
  String? folger;
  String? folgere;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, dynamic>? userInfo;

  @override
  void initState() {
    super.initState();
    getMyFoods();
    getAllLikes();
    tellMineFolger();
    tellMineFolgere();
    updateUserStats();

    _model = createModel(context, () => ProfilModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      try {} catch (e) {
        // Check if the widget is still mounted
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Oopps, noe gikk galt'),
              content: const Text(
                  'Sjekk internettforbindelsen din og prøv igjen.\nHvis problemet vedvarer, vennligst kontakt oss for hjelp.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          },
        );
      }
    });

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
  }

  Future<void> getMyFoods() async {
    String? token = await Securestorage().readToken();
    if (token == null) {
      FFAppState().login = false;
      context.pushNamed('registrer');
      return;
    } else {
      _matvarer = await ApiGetMyFoods.getMyFoods(token);
      setState(() {
        if (_matvarer != null && _matvarer!.isEmpty) {
          _isempty = true;
          return;
        }
        _isloading = false;
        _isempty = false;
      });
    }
  }

  Future<void> updateUserStats() async {
    String? token = await Securestorage().readToken();
    if (token == null) {
      FFAppState().login = false;
      context.pushNamed('registrer');
      return;
    } else {
      await apicalls.updateUserStats(token);
      setState(() {});
    }
  }

  Future<void> getAllLikes() async {
    String? token = await Securestorage().readToken();
    if (token == null) {
      FFAppState().login = false;
      context.pushNamed('registrer');
      return;
    } else {
      _likesmatvarer = await ApiGetAllLikes.getAllLikes(token);
      setState(() {
        if (_likesmatvarer != null && _likesmatvarer!.isEmpty) {
          _likesisempty = true;
          return;
        }
        _likesisloading = false;
        _likesisempty = false;
      });
    }
  }

  Future<void> tellMineFolger() async {
    String? token = await Securestorage().readToken();
    if (token == null) {
      FFAppState().login = false;
      context.pushNamed('registrer');
      return;
    } else {
      folger = await ApiFolg.tellMineFolger(token);
      setState(() {});
    }
  }

  Future<void> tellMineFolgere() async {
    String? token = await Securestorage().readToken();
    if (token == null) {
      FFAppState().login = false;
      context.pushNamed('registrer');
      return;
    } else {
      folgere = await ApiFolg.tellMineFolgere(token);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primary,
          body: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    primary: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 10, 0, 17),
                                child: SafeArea(
                                  child: Container(
                                    width: valueOrDefault<double>(
                                      MediaQuery.sizeOf(context).width,
                                      500.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                    ),
                                    child: Stack(
                                      alignment: AlignmentDirectional(0, 0),
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10, 0, 10, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Align(
                                                alignment:
                                                    AlignmentDirectional(1, 0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 20, 0),
                                                  child: InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      context.pushNamed(
                                                          'innstillinger');
                                                    },
                                                    child: FaIcon(
                                                      FontAwesomeIcons.cog,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      size: 24,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Text(
                                            'Profil',
                                            style: FlutterFlowTheme.of(context)
                                                .headlineMedium
                                                .override(
                                                  fontFamily: 'Open Sans',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  fontSize: 27,
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
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 55, 0, 0),
                              child: SingleChildScrollView(
                                primary: false,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ListView(
                                      padding: EdgeInsets.zero,
                                      primary: false,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 30, 0, 0),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0, 0),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
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
                                                          width: 85,
                                                          height: 85,
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child:
                                                              CachedNetworkImage(
                                                            fadeInDuration:
                                                                Duration(
                                                                    milliseconds:
                                                                        0),
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
                                                              fit: BoxFit.cover,
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
                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Text(
                                                                                  '43',
                                                                                  textAlign: TextAlign.center,
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Open Sans',
                                                                                        fontSize: 16,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w600,
                                                                                      ),
                                                                                ),
                                                                                Text(
                                                                                  'matvarer',
                                                                                  textAlign: TextAlign.center,
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Open Sans',
                                                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                                                        fontSize: 12,
                                                                                        letterSpacing: 0.0,
                                                                                      ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
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
                                                                                if (folgere != '0') {
                                                                                  context.pushNamed(
                                                                                    'Folgere',
                                                                                    queryParameters: {
                                                                                      'username': serializeParam(FFAppState().brukernavn, ParamType.String),
                                                                                      'folger': serializeParam(
                                                                                        'Følgere',
                                                                                        ParamType.String,
                                                                                      ),
                                                                                    }.withoutNulls,
                                                                                  );
                                                                                }
                                                                              },
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Text(
                                                                                    folgere ?? '',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: 'Open Sans',
                                                                                          fontSize: 16,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                  ),
                                                                                  Text(
                                                                                    'følgere',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: 'Open Sans',
                                                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                                                          fontSize: 12,
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
                                                                                if (folger != '0') {
                                                                                  context.pushNamed(
                                                                                    'Folgere',
                                                                                    queryParameters: {
                                                                                      'username': serializeParam(FFAppState().brukernavn, ParamType.String),
                                                                                      'folger': serializeParam(
                                                                                        'Følger',
                                                                                        ParamType.String,
                                                                                      ),
                                                                                    }.withoutNulls,
                                                                                  );
                                                                                }
                                                                              },
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Text(
                                                                                    folger ?? '',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: 'Open Sans',
                                                                                          fontSize: 16,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                  ),
                                                                                  Text(
                                                                                    'følger',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: 'Open Sans',
                                                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                                                          fontSize: 12,
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
                                                                    EdgeInsetsDirectional
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
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional
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
                                                                          context
                                                                              .pushNamed('BrukerRating');
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              200,
                                                                          height:
                                                                              30,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primary,
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                            border:
                                                                                Border.all(
                                                                              color: Color(0x4A57636C),
                                                                              width: 1.3,
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                1,
                                                                                0,
                                                                                0),
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
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(1, 0, 0, 0),
                                                                                  child: Text(
                                                                                    '4.3',
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: 'Open Sans',
                                                                                          fontSize: 14,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(1, 0, 0, 0),
                                                                                  child: Text(
                                                                                    ' (15)',
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: 'Open Sans',
                                                                                          color: Color(0xB0262C2D),
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

                                                              // Row(
                                                              //   mainAxisSize:
                                                              //       MainAxisSize
                                                              //           .max,
                                                              //   children: [
                                                              //     Padding(
                                                              //       padding: EdgeInsetsDirectional
                                                              //           .fromSTEB(
                                                              //               5,
                                                              //               7,
                                                              //               0,
                                                              //               0),
                                                              //       child:
                                                              //           FFButtonWidget(
                                                              //         onPressed:
                                                              //             () async {
                                                              //           context.pushNamed(
                                                              //               'BrukerRating');
                                                              //         },
                                                              //         text:
                                                              //             '4.3 (15)',
                                                              //         icon:
                                                              //             FaIcon(
                                                              //           FontAwesomeIcons
                                                              //               .solidStar,
                                                              //           color: FlutterFlowTheme.of(context)
                                                              //               .alternate,
                                                              //           size:
                                                              //               17,
                                                              //         ),
                                                              //         options:
                                                              //             FFButtonOptions(
                                                              //           width:
                                                              //               225,
                                                              //           height:
                                                              //               30,
                                                              //           padding: EdgeInsetsDirectional.fromSTEB(
                                                              //               16,
                                                              //               0,
                                                              //               16,
                                                              //               0),
                                                              //           iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                              //               0,
                                                              //               0,
                                                              //               0,
                                                              //               0),
                                                              //           color: FlutterFlowTheme.of(context)
                                                              //               .primary,
                                                              //           textStyle: FlutterFlowTheme.of(context)
                                                              //               .titleSmall
                                                              //               .override(
                                                              //                 fontFamily: 'Open Sans',
                                                              //                 color: FlutterFlowTheme.of(context).alternate,
                                                              //                 fontSize: 15,
                                                              //                 letterSpacing: 0.0,
                                                              //                 fontWeight: FontWeight.w600,
                                                              //               ),
                                                              //           elevation:
                                                              //               1,
                                                              //           borderRadius:
                                                              //               BorderRadius.circular(8),
                                                              //         ),
                                                              //       ),
                                                              //     ),
                                                              //   ],
                                                              // ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 5, 0, 0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(24, 0,
                                                                    0, 0),
                                                        child: Text(
                                                          '${FFAppState().firstname} ${FFAppState().lastname}',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .headlineLarge
                                                              .override(
                                                                fontFamily:
                                                                    'Open Sans',
                                                                fontSize: 18,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(24, 4, 40, 0),
                                                  child: Container(
                                                    constraints: BoxConstraints(
                                                      maxHeight: 90,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                    ),
                                                    child: Text(
                                                      FFAppState().bio,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                'Open Sans',
                                                            fontSize: 14,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 30, 0, 0),
                                                    child: Column(
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              Alignment(0, 0),
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
                                                                          'Open Sans',
                                                                      letterSpacing:
                                                                          0.0,
                                                                    ),
                                                            unselectedLabelStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Open Sans',
                                                                      letterSpacing:
                                                                          0.0,
                                                                    ),
                                                            indicatorColor:
                                                                Color(
                                                                    0x00F6F6F6),
                                                            indicatorWeight: 1,
                                                            tabs: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  FaIcon(
                                                                    FontAwesomeIcons
                                                                        .bars,
                                                                    color: _model.tabBarCurrentIndex ==
                                                                            0
                                                                        ? FlutterFlowTheme.of(context)
                                                                            .alternate
                                                                        : FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                    size: 25,
                                                                  ),
                                                                  Tab(
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
                                                                        .solidHeart,
                                                                    color: _model.tabBarCurrentIndex ==
                                                                            1
                                                                        ? FlutterFlowTheme.of(context)
                                                                            .alternate
                                                                        : FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                    size: 25,
                                                                  ),
                                                                  Tab(
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
                                      if (FFAppState().lagtUt != true &&
                                          _model.tabBarCurrentIndex == 0)
                                        Container(
                                          width:
                                              MediaQuery.sizeOf(context).width,
                                          height: MediaQuery.sizeOf(context)
                                                  .height -
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
                                                  Icons.add,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  size: 53,
                                                ),
                                                const SizedBox(height: 16),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Trykk på',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyLarge
                                                          .override(
                                                            fontFamily:
                                                                'Open Sans',
                                                            fontSize: 16,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                    Icon(
                                                      Icons.add,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      size: 20,
                                                    ),
                                                    Text(
                                                      'for å lage din første annonse',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyLarge
                                                          .override(
                                                            fontFamily:
                                                                'Open Sans',
                                                            fontSize: 16,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                    if (FFAppState().lagtUt &&
                                        _model.tabBarCurrentIndex == 0)
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(5, 15, 5, 0),
                                        child: RefreshIndicator(
                                          onRefresh: () async {
                                            await getMyFoods();
                                          },
                                          child: GridView.builder(
                                            padding: const EdgeInsets.fromLTRB(
                                              0,
                                              0,
                                              0,
                                              70,
                                            ),
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 0.64,
                                            ),
                                            primary: false,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount: _isloading
                                                ? 1
                                                : _matvarer?.length ?? 1,
                                            itemBuilder: (context, index) {
                                              if (_isloading) {
                                                return Shimmer.fromColors(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor:
                                                      Colors.grey[100]!,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .all(5.0),
                                                        width: 200.0,
                                                        height: 230.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color
                                                              .fromARGB(127,
                                                              255, 255, 255),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  16.0), // Rounded corners
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 8.0),
                                                      Container(
                                                        width: 200,
                                                        height: 15,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color
                                                              .fromARGB(127,
                                                              255, 255, 255),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 8.0),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10.0),
                                                          child: Container(
                                                            width: 38,
                                                            height: 15,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color
                                                                  .fromARGB(
                                                                  127,
                                                                  255,
                                                                  255,
                                                                  255),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                              // if (_isempty) {
                                              //   return IngenVareLagtUtWidget();
                                              // }

                                              final matvare = _matvarer![index];
                                              return Stack(
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
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
                                                            context.pushNamed(
                                                              'MinMatvareDetalj',
                                                              queryParameters: {
                                                                'matvare':
                                                                    serializeParam(
                                                                  matvare
                                                                      .toJson(), // Convert to JSON before passing
                                                                  ParamType
                                                                      .JSON,
                                                                ),
                                                              },
                                                            );
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
                                                                        AlignmentDirectional(
                                                                            0,
                                                                            0),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              3,
                                                                              0,
                                                                              3,
                                                                              0),
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(17),
                                                                        child: Image
                                                                            .network(
                                                                          '${ApiConstants.baseUrl}${matvare.imgUrls![0]}',
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
                                                                              'assets/images/error_image.jpg', // Path to your local error image
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
                                                                    padding: EdgeInsetsDirectional
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
                                                                          alignment: AlignmentDirectional(
                                                                              -1,
                                                                              0),
                                                                          child:
                                                                              Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                7,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            child:
                                                                                AutoSizeText(
                                                                              matvare.name ?? '',
                                                                              textAlign: TextAlign.start,
                                                                              minFontSize: 11,
                                                                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                    fontFamily: 'Open Sans',
                                                                                    fontSize: 15,
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
                                                                    padding: EdgeInsetsDirectional
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
                                                                                AlignmentDirectional(0, 0),
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                                                                              child: Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: EdgeInsetsDirectional.fromSTEB(7, 0, 0, 0),
                                                                                          child: Text(
                                                                                            '${matvare.price} Kr',
                                                                                            textAlign: TextAlign.end,
                                                                                            style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                                  fontFamily: 'Open Sans',
                                                                                                  color: FlutterFlowTheme.of(context).alternate,
                                                                                                  fontSize: 15,
                                                                                                  letterSpacing: 0.0,
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                ),
                                                                                          ),
                                                                                        ),
                                                                                        if (matvare.kg == true)
                                                                                          Text(
                                                                                            '/kg',
                                                                                            textAlign: TextAlign.end,
                                                                                            style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                                  fontFamily: 'Open Sans',
                                                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                  fontSize: 15,
                                                                                                  letterSpacing: 0.0,
                                                                                                  fontWeight: FontWeight.w600,
                                                                                                ),
                                                                                          ),
                                                                                        if (matvare.kg != true)
                                                                                          Text(
                                                                                            '/stk',
                                                                                            textAlign: TextAlign.end,
                                                                                            style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                                  fontFamily: 'Open Sans',
                                                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                  fontSize: 15,
                                                                                                  letterSpacing: 0.0,
                                                                                                  fontWeight: FontWeight.w600,
                                                                                                ),
                                                                                          ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 7, 0),
                                                                                        child: Text(
                                                                                          '(3Km)',
                                                                                          textAlign: TextAlign.start,
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                fontFamily: 'Open Sans',
                                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                                fontSize: 14,
                                                                                                letterSpacing: 0.0,
                                                                                                fontWeight: FontWeight.w600,
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
                                                      if (matvare.kjopt == true)
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0, -1),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        3,
                                                                        0,
                                                                        3,
                                                                        0),
                                                            child: Material(
                                                              color: Colors
                                                                  .transparent,
                                                              elevation: 0.3,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16),
                                                              ),
                                                              child: Container(
                                                                height: 230,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Color(
                                                                      0xA7FFFFFF),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16),
                                                                ),
                                                                child: Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          1,
                                                                          -1),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            15,
                                                                            15,
                                                                            0),
                                                                    child: Transform
                                                                        .rotate(
                                                                      angle: 27 *
                                                                          (math.pi /
                                                                              180),
                                                                      child:
                                                                          Text(
                                                                        'Solgt',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Open Sans',
                                                                              color: FlutterFlowTheme.of(context).alternate,
                                                                              fontSize: 21,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    if (_model.tabBarCurrentIndex == 1)
                                      if (FFAppState().liked != true &&
                                          _model.tabBarCurrentIndex == 1)
                                        Container(
                                          width:
                                              MediaQuery.sizeOf(context).width,
                                          height: MediaQuery.sizeOf(context)
                                                  .height -
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
                                                  FontAwesomeIcons.heart,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  size: 50,
                                                ),
                                                const SizedBox(height: 16),
                                                Text(
                                                  'Du kan se mat du har likt her. Bare du kan se disse',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyLarge
                                                      .override(
                                                        fontFamily: 'Open Sans',
                                                        fontSize: 16,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    if (FFAppState().liked &&
                                        _model.tabBarCurrentIndex == 1)
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            5, 15, 5, 0),
                                        child: RefreshIndicator(
                                          onRefresh: () async {
                                            getAllLikes();
                                          },
                                          child: GridView.builder(
                                            padding: EdgeInsets.fromLTRB(
                                              0,
                                              0,
                                              0,
                                              70,
                                            ),
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 0.64,
                                            ),
                                            primary: false,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount: _likesisloading
                                                ? 1
                                                : _likesmatvarer?.length ?? 1,
                                            itemBuilder: (context, index) {
                                              if (_likesisloading) {
                                                return Shimmer.fromColors(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor:
                                                      Colors.grey[100]!,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .all(5.0),
                                                        width: 200.0,
                                                        height: 230.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color
                                                              .fromARGB(127,
                                                              255, 255, 255),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  16.0), // Rounded corners
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 8.0),
                                                      Container(
                                                        width: 200,
                                                        height: 15,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color
                                                              .fromARGB(127,
                                                              255, 255, 255),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 8.0),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10.0),
                                                          child: Container(
                                                            width: 38,
                                                            height: 15,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color
                                                                  .fromARGB(
                                                                  127,
                                                                  255,
                                                                  255,
                                                                  255),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }

                                              final likesmatvare =
                                                  _likesmatvarer![index];

                                              return Stack(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0, -1),
                                                    child: InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        context.pushNamed(
                                                          'MatDetaljBondegard',
                                                          queryParameters: {
                                                            'matvare':
                                                                serializeParam(
                                                              likesmatvare
                                                                  .toJson(), // Convert to JSON before passing
                                                              ParamType.JSON,
                                                            ),
                                                          },
                                                        );
                                                      },
                                                      child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        elevation: 0,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
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
                                                            border: Border.all(
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
                                                                    AlignmentDirectional(
                                                                        0, 0),
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          3,
                                                                          0,
                                                                          3,
                                                                          0),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            17),
                                                                    child: Image
                                                                        .network(
                                                                      '${ApiConstants.baseUrl}${likesmatvare.imgUrls![0]}',
                                                                      width:
                                                                          200,
                                                                      height:
                                                                          229,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      errorBuilder: (BuildContext context,
                                                                          Object
                                                                              error,
                                                                          StackTrace?
                                                                              stackTrace) {
                                                                        return Image
                                                                            .asset(
                                                                          'assets/images/error_image.jpg',
                                                                          width:
                                                                              200,
                                                                          height:
                                                                              229,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            5,
                                                                            0,
                                                                            5,
                                                                            0),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Align(
                                                                      alignment:
                                                                          AlignmentDirectional(
                                                                              -1,
                                                                              0),
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            7,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            AutoSizeText(
                                                                          likesmatvare.name ??
                                                                              '',
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                          minFontSize:
                                                                              11,
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyLarge
                                                                              .override(
                                                                                fontFamily: 'Open Sans',
                                                                                fontSize: 15,
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
                                                                    EdgeInsetsDirectional
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
                                                                        alignment: AlignmentDirectional(
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              5,
                                                                              0,
                                                                              5,
                                                                              0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.end,
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                                                                                child: Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(7, 0, 0, 0),
                                                                                      child: Text(
                                                                                        '${likesmatvare.price} Kr',
                                                                                        textAlign: TextAlign.end,
                                                                                        style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                              fontFamily: 'Open Sans',
                                                                                              color: FlutterFlowTheme.of(context).alternate,
                                                                                              fontSize: 15,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.bold,
                                                                                            ),
                                                                                      ),
                                                                                    ),
                                                                                    if (likesmatvare.kg == true)
                                                                                      Text(
                                                                                        '/kg',
                                                                                        textAlign: TextAlign.end,
                                                                                        style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                              fontFamily: 'Open Sans',
                                                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                                                              fontSize: 15,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.w600,
                                                                                            ),
                                                                                      ),
                                                                                    if (likesmatvare.kg != true)
                                                                                      Text(
                                                                                        '/stk',
                                                                                        textAlign: TextAlign.end,
                                                                                        style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                              fontFamily: 'Open Sans',
                                                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                                                              fontSize: 15,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.w600,
                                                                                            ),
                                                                                      ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 7, 0),
                                                                                    child: Text(
                                                                                      '(3Km)',
                                                                                      textAlign: TextAlign.start,
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: 'Open Sans',
                                                                                            color: FlutterFlowTheme.of(context).primaryText,
                                                                                            fontSize: 14,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.w600,
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
                                                ],
                                              );
                                            },
                                          ),
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
                  ),
                ),
                wrapWithModel(
                  model: _model.profilNavBarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: ProfilNavBarWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
