import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mat_salg/models/user_info.dart';
import 'package:mat_salg/pages/app_pages/Utils.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/logging.dart';
import 'package:mat_salg/myIP.dart';
import 'package:mat_salg/services/follow_service.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'folgere_model.dart';
export 'folgere_model.dart';

class FolgereWidget extends StatefulWidget {
  const FolgereWidget({
    super.key,
    String? username,
    this.fromChat,
    String? folger,
  })  : username = username ?? '',
        folger = folger ?? 'Følgere';

  final String folger;
  final String username;
  final dynamic fromChat;

  @override
  State<FolgereWidget> createState() => _FolgereWidgetState();
}

class _FolgereWidgetState extends State<FolgereWidget> {
  late FolgereModel _model;
  bool _isloading = true;
  List<UserInfo>? _brukere;
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final Toasts toasts = Toasts();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    listFolgere();
    _model = createModel(context, () => FolgereModel());
  }

  Future<void> listFolgere() async {
    try {
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return;
      } else {
        if (widget.folger == 'Følgere') {
          _brukere = await FollowService.listFolger(token, widget.username);
        } else {
          _brukere = await FollowService.listFolgere(token, widget.username);
        }
        setState(() {
          if (_brukere != null && _brukere!.isNotEmpty) {
            _isloading = false;
            return;
          } else {
            _isloading = true;
          }
        });
      }
    } on SocketException {
      toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      toasts.showErrorToast(context, 'En feil oppstod');
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
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primary,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            iconTheme: IconThemeData(
                color: FlutterFlowTheme.of(context).secondaryText),
            automaticallyImplyLeading: true,
            leading: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                context.safePop();
              },
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 28.0,
              ),
            ),
            title: Text(
              valueOrDefault<String>(
                widget.folger,
                'Følgere',
              ),
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Nunito',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 18,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            actions: const [],
            centerTitle: true,
            elevation: 0.0,
          ),
          body: SafeArea(
            top: true,
            child: Stack(
              alignment: const AlignmentDirectional(1.0, -1.0),
              children: [
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 0.0),
                  child: RefreshIndicator.adaptive(
                    color: FlutterFlowTheme.of(context).alternate,
                    onRefresh: () async {
                      HapticFeedback.lightImpact();
                      listFolgere();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        0,
                        10,
                        0,
                        0,
                      ),
                      scrollDirection: Axis.vertical,
                      itemCount: _isloading ? 3 : _brukere?.length ?? 1,
                      itemBuilder: (context, index) {
                        if (_isloading) {
                          return Container(
                            margin: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(0, 255, 255,
                                  255), // Background color of the shimmer box
                              borderRadius: BorderRadius.circular(
                                  16.0), // Rounded corners
                            ),
                          );
                        }
                        final brukere = _brukere![index];
                        return Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10.0, 0.0, 10.0, 0.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              try {
                                if (widget.fromChat != true) {
                                  context.pushNamed(
                                    'BrukerPage',
                                    queryParameters: {
                                      'uid': serializeParam(
                                        brukere.uid,
                                        ParamType.String,
                                      ),
                                      'username': serializeParam(
                                        brukere.username,
                                        ParamType.String,
                                      ),
                                      'bruker': serializeParam(
                                        null,
                                        ParamType.JSON,
                                      ),
                                    },
                                  );
                                } else {
                                  context.pushNamed(
                                    'BrukerPage2',
                                    queryParameters: {
                                      'uid': serializeParam(
                                        brukere.uid,
                                        ParamType.String,
                                      ),
                                      'username': serializeParam(
                                        brukere.username,
                                        ParamType.String,
                                      ),
                                      'fromChat': serializeParam(
                                        true,
                                        ParamType.bool,
                                      ),
                                    },
                                  );
                                }
                              } catch (e) {
                                toasts.showErrorToast(
                                    context, 'En uforventet feil oppstod');
                                logger.d('Error navigating page');
                              }
                            },
                            child: Material(
                              color: Colors.transparent,
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13.0),
                              ),
                              child: Container(
                                height: 80.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primary,
                                  borderRadius: BorderRadius.circular(13.0),
                                  shape: BoxShape.rectangle,
                                ),
                                child: Align(
                                  alignment:
                                      const AlignmentDirectional(0.0, 0.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      0.0, 1.0, 1.0, 1.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                                child: Image.network(
                                                  '${ApiConstants.baseUrl}${brukere.profilepic}',
                                                  width: 50.0,
                                                  height: 50.0,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (BuildContext
                                                          context,
                                                      Object error,
                                                      StackTrace? stackTrace) {
                                                    return Image.asset(
                                                      'assets/images/profile_pic.png',
                                                      width: 50.0,
                                                      height: 50.0,
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      8.0, 0.0, 0.0, 0.0),
                                              child: Container(
                                                width: 179.0,
                                                height: 103.0,
                                                decoration:
                                                    const BoxDecoration(),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          const AlignmentDirectional(
                                                              -1.0, 1.0),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(0.0,
                                                                0.0, 0.0, 10.0),
                                                        child: Text(
                                                          brukere.username,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .headlineSmall
                                                              .override(
                                                                fontFamily:
                                                                    'Nunito',
                                                                fontSize: 17.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (brukere.following == true)
                                          FFButtonWidget(
                                            onPressed: () async {
                                              try {
                                                HapticFeedback.lightImpact();
                                                brukere.following = false;
                                                safeSetState(() {});
                                                String? token =
                                                    await firebaseAuthService
                                                        .getToken(context);
                                                if (token == null) {
                                                  return;
                                                }
                                                FollowService.unfolgBruker(
                                                    token, brukere.uid);
                                              } on SocketException {
                                                toasts.showErrorToast(context,
                                                    'Ingen internettforbindelse');
                                              } catch (e) {
                                                toasts.showErrorToast(
                                                    context, 'En feil oppstod');
                                              }
                                            },
                                            text: 'Følger',
                                            options: FFButtonOptions(
                                              width: 80,
                                              height: 35,
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(16, 0, 16, 0),
                                              iconPadding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 0),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              textStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .titleSmall
                                                  .override(
                                                    fontFamily: 'Nunito',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    fontSize: 15,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                              elevation: 0,
                                              borderSide: const BorderSide(
                                                color: Color(0x5957636C),
                                                width: 0.8,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        if (brukere.following != true)
                                          FFButtonWidget(
                                            onPressed: () async {
                                              try {
                                                HapticFeedback.mediumImpact();
                                                brukere.following = true;
                                                safeSetState(() {});
                                                String? token =
                                                    await firebaseAuthService
                                                        .getToken(context);
                                                if (token == null) {
                                                  return;
                                                }
                                                FollowService.folgbruker(
                                                    token, brukere.uid);
                                              } on SocketException {
                                                toasts.showErrorToast(context,
                                                    'Ingen internettforbindelse');
                                              } catch (e) {
                                                toasts.showErrorToast(
                                                    context, 'En feil oppstod');
                                              }
                                            },
                                            text: 'Følg',
                                            options: FFButtonOptions(
                                              width: 80.0,
                                              height: 35.0,
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      16.0, 0.0, 16.0, 0.0),
                                              iconPadding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      0.0, 0.0, 0.0, 0.0),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              textStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .titleSmall
                                                  .override(
                                                    fontFamily: 'Nunito',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    fontSize: 15,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                              elevation: 0.0,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ].divide(const SizedBox(height: 20.0)),
            ),
          ),
        ),
      ),
    );
  }
}
