import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_theme.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:mat_salg/helper_components/widgets/shimmer_widgets/shimmer_profiles.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/logging.dart';
import 'package:mat_salg/my_ip.dart';
import 'package:flutter/material.dart';
import 'package:mat_salg/services/user_service.dart';
import 'blocked_model.dart';
export 'blocked_model.dart';

class BlockedWidget extends StatefulWidget {
  const BlockedWidget({super.key});

  @override
  State<BlockedWidget> createState() => _BlockedWidgetState();
}

class _BlockedWidgetState extends State<BlockedWidget> {
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  late BlockedModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    listFolgere();
    _model = createModel(context, () => BlockedModel());
  }

  Future<void> listFolgere() async {
    try {
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return;
      } else {
        _model.brukere = await UserInfoService.listBlocked(token);

        setState(() {
          if (_model.brukere != null && _model.brukere!.isNotEmpty) {
            _model.isloading = false;
            return;
          } else {
            _model.isloading = false;
          }
        });
      }
    } on SocketException {
      if (!mounted) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      logger.d('En feil oppstod, $e');
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
              'Blokkerte brukere',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Nunito',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 18,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w700,
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
                    child: (_model.brukere?.isEmpty ??
                            true && _model.isloading != true)
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  20, 0, 20, 0),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .override(
                                        fontFamily: 'Nunito',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: 23,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w800,
                                      ),
                                  children: [
                                    TextSpan(
                                      text: 'Du har ikke blokkert noen',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 23,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          '\nNår du blokkerer noen, vil de ikke kunne sende deg meldinger, og du vil ikke lenger kunne se annonsene deres eller få dem foreslått.',
                                      style: FlutterFlowTheme.of(context)
                                          .headlineSmall
                                          .override(
                                            fontFamily: 'Nunito',
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            fontSize: 16,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(
                              0,
                              10,
                              0,
                              0,
                            ),
                            scrollDirection: Axis.vertical,
                            itemCount: _model.isloading
                                ? 1
                                : _model.brukere?.length ?? 1,
                            itemBuilder: (context, index) {
                              if (_model.isloading) {
                                return const ShimmerProfiles();
                              }
                              final brukere = _model.brukere![index];
                              return Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10.0, 0.0, 10.0, 0.0),
                                child: InkWell(
                                  splashFactory: InkRipple.splashFactory,
                                  splashColor: Colors.grey[100],
                                  onTap: () async {
                                    context.pushNamed(
                                      'BrukerPage3',
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
                                  },
                                  child: Material(
                                    color: Colors.transparent,
                                    elevation: 0.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13.0),
                                    ),
                                    child: Container(
                                      height: 70.0,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(13.0),
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: Align(
                                        alignment: const AlignmentDirectional(
                                            0.0, 0.0),
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
                                                        fadeInDuration:
                                                            Duration.zero,
                                                        imageUrl:
                                                            '${ApiConstants.baseUrl}${brukere.profilepic}',
                                                        width: 50.0,
                                                        height: 50.0,
                                                        fit: BoxFit.cover,
                                                        imageBuilder: (context,
                                                            imageProvider) {
                                                          return Container(
                                                            width: 50.0,
                                                            height: 50.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        errorWidget: (context,
                                                                url, error) =>
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
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    -1.0, 1.0),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      0.0,
                                                                      10.0),
                                                              child: Text(
                                                                brukere
                                                                    .username,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineSmall
                                                                    .override(
                                                                      fontFamily:
                                                                          'Nunito',
                                                                      fontSize:
                                                                          17.0,
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
