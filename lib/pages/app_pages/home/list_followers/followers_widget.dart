import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/logging.dart';
import 'package:mat_salg/my_ip.dart';
import 'package:mat_salg/services/follow_service.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'followers_model.dart';
export 'followers_model.dart';

class FollowersWidget extends StatefulWidget {
  const FollowersWidget({
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
  State<FollowersWidget> createState() => _FolgereWidgetState();
}

class _FolgereWidgetState extends State<FollowersWidget> {
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  late FollowersModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    listFolgere();
    _model = createModel(context, () => FollowersModel());
  }

  Future<void> listFolgere() async {
    try {
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return;
      } else {
        if (widget.folger == 'Følgere') {
          _model.brukere =
              await FollowService.listFolger(token, widget.username);
        } else {
          _model.brukere =
              await FollowService.listFolgere(token, widget.username);
        }
        setState(() {
          if (_model.brukere != null && _model.brukere!.isNotEmpty) {
            _model.isloading = false;
            return;
          } else {
            _model.isloading = true;
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
            backgroundColor: FlutterFlowTheme.of(context).primary,
            iconTheme: IconThemeData(
                color: FlutterFlowTheme.of(context).secondaryText),
            scrolledUnderElevation: 0,
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
                      HapticFeedback.selectionClick();
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
                      itemCount:
                          _model.isloading ? 3 : _model.brukere?.length ?? 1,
                      itemBuilder: (context, index) {
                        if (_model.isloading) {
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
                        final brukere = _model.brukere![index];
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
                                if (FirebaseAuth.instance.currentUser!.uid ==
                                    brukere.uid) return;
                                if (widget.fromChat != true) {
                                  context.pushNamed(
                                    GoRouterState.of(context)
                                            .uri
                                            .toString()
                                            .startsWith('/home')
                                        ? 'BrukerPageHome'
                                        : 'BrukerPage',
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
                                Toasts.showErrorToast(
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
                                                child: CachedNetworkImage(
                                                  fadeInDuration: Duration.zero,
                                                  imageUrl:
                                                      '${ApiConstants.baseUrl}${brukere.profilepic}',
                                                  width: 50.0,
                                                  height: 50.0,
                                                  fit: BoxFit.cover,
                                                  imageBuilder:
                                                      (context, imageProvider) {
                                                    return Container(
                                                      width: 50.0,
                                                      height: 50.0,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Image.asset(
                                                    'assets/images/profile_pic.png',
                                                    width: 50.0,
                                                    height: 50.0,
                                                    fit: BoxFit.cover,
                                                  ),
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
                                        if (brukere.following == true &&
                                            FirebaseAuth.instance.currentUser!
                                                    .uid !=
                                                brukere.uid)
                                          FFButtonWidget(
                                            onPressed: () async {
                                              try {
                                                HapticFeedback.selectionClick();
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
                                                if (!context.mounted) return;
                                                Toasts.showErrorToast(context,
                                                    'Ingen internettforbindelse');
                                              } catch (e) {
                                                if (!context.mounted) return;
                                                Toasts.showErrorToast(
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
                                        if (brukere.following != true &&
                                            FirebaseAuth.instance.currentUser!
                                                    .uid !=
                                                brukere.uid)
                                          FFButtonWidget(
                                            onPressed: () async {
                                              try {
                                                HapticFeedback.selectionClick();
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
                                                if (!context.mounted) return;
                                                Toasts.showErrorToast(context,
                                                    'Ingen internettforbindelse');
                                              } catch (e) {
                                                if (!context.mounted) return;
                                                Toasts.showErrorToast(
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
