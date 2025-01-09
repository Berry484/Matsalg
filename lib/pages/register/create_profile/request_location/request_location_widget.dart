import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_theme.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_widgets.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/pages/app_pages/profile/settings/choose_location/location_page.dart';
import 'package:mat_salg/services/user_service.dart';
import 'request_location_model.dart';
export 'request_location_model.dart';

class RequestLocationWidget extends StatefulWidget {
  const RequestLocationWidget({
    super.key,
  });

  @override
  State<RequestLocationWidget> createState() => _RequestLocationWidgetState();
}

class _RequestLocationWidgetState extends State<RequestLocationWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final UserInfoService userInfoService = UserInfoService();
  late RequestLocationModel _model;

  bool _isloading = false;
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RequestLocationModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
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
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0.0,
            actions: [],
            centerTitle: true,
            elevation: 0.0,
          ),
          body: SafeArea(
            top: true,
            bottom: false,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  15, 0, 35, 50),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Hvor befinner du deg?',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Nunito',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 23,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 70,
                                    child: Text(
                                      'MatSalg.no bruker posisjonen din til å vise varer som er i nærheten av deg og for å vise dine varer til kjøpere som er i ditt område',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Nunito',
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 320,
                              height: 320,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: SizedBox(
                                      width: 320,
                                      height: 320,
                                      child: Image.asset(
                                        'assets/images/MatSalg_Location.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              25, 0, 25, 0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              try {
                                if (_isloading) return;
                                _isloading = true;
                                LatLng? location;

                                LocationPermission permission =
                                    await Geolocator.requestPermission();

                                if (permission == LocationPermission.denied ||
                                    permission ==
                                        LocationPermission.deniedForever ||
                                    permission ==
                                        LocationPermission.unableToDetermine) {
                                  if (!context.mounted) {
                                    _isloading = false;
                                    return;
                                  }
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CupertinoAlertDialog(
                                        title: const Text(
                                            'Stedstjenester er deaktivert for MatSalg.no'),
                                        content: const Text(
                                            'Aktiver stedstjenester for MatSalg.no i innstillinger for å bruke din nåværende posisjon.'),
                                        actions: [
                                          CupertinoDialogAction(
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              await Geolocator
                                                  .openLocationSettings();
                                            },
                                            textStyle: const TextStyle(
                                                color:
                                                    CupertinoColors.systemBlue),
                                            child: const Text('Innstillinger'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  _isloading = false;
                                  return;
                                }

                                location = await getCurrentUserLocation(
                                    defaultLocation: const LatLng(0.0, 0.0));

                                if (location == const LatLng(0.0, 0.0)) {
                                  if (!context.mounted) {
                                    _isloading = false;
                                    return;
                                  }
                                  Toasts.showErrorToast(context,
                                      'Stedtjenester er deaktivert i innstillinger');
                                  _isloading = false;
                                  return;
                                }
                                location = await getCurrentUserLocation(
                                    defaultLocation: const LatLng(0.0, 0.0));

                                if (location != const LatLng(0.0, 0.0)) {
                                  FFAppState().brukerLat = location.latitude;
                                  FFAppState().brukerLng = location.longitude;
                                  if (!context.mounted) {
                                    _isloading = false;
                                    return;
                                  }
                                  String? token = await firebaseAuthService
                                      .getToken(context);
                                  if (token == null) {
                                    _isloading = false;
                                    return;
                                  } else {
                                    await userInfoService.updatePosisjon(
                                        token: token);
                                  }
                                }

                                if (!context.mounted) {
                                  _isloading = false;
                                  return;
                                }
                                if (location == const LatLng(0.0, 0.0)) {
                                  _isloading = false;
                                  Toasts.showErrorToast(context,
                                      'posisjonstjenester er skrudd av i innstillinger');
                                  return;
                                } else {
                                  _isloading = false;
                                  context.goNamed('Explore');
                                }
                              } on SocketException {
                                _isloading = false;
                                Toasts.showErrorToast(
                                    context, 'Ingen internettforbindelse');
                              } catch (e) {
                                _isloading = false;
                                Toasts.showErrorToast(
                                    context, 'En feil oppstod');
                              }
                            },
                            text: 'Finn automatisk',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 50.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).alternate,
                              textStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Nunito',
                                    color: Colors.white,
                                    fontSize: 16,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                              elevation: 0.0,
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              25, 16, 25, 40),
                          child: FFButtonWidget(
                            onPressed: () async {
                              if (_isloading == true) return;
                              _isloading = true;
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
                                      padding: MediaQuery.viewInsetsOf(context),
                                      child: const LocationPage(
                                        where: 'velg',
                                      ),
                                    ),
                                  );
                                },
                              ).then((value) => setState(() {}));
                              _isloading = false;
                              return;
                            },
                            text: 'Velg manuelt',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 50.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).primary,
                              textStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Nunito',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize: 16,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                              elevation: 0.0,
                              borderSide: const BorderSide(
                                color: Colors.black12,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
