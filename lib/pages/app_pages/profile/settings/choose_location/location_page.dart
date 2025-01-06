import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/services/user_service.dart';
import '../../../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import '../../../../../helper_components/flutter_flow/flutter_flow_widgets.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../../helper_components/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'location_model.dart';
export 'location_model.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({
    super.key,
    this.where,
  });

  final String? where;

  @override
  State<LocationPage> createState() => _VelgPosisjonWidgetState();
}

class _VelgPosisjonWidgetState extends State<LocationPage> {
  late LocationModel _model;
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final UserInfoService userInfoService = UserInfoService();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LocationModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _model.textFieldFocusNode!.addListener(() => safeSetState(() {}));
    _model.selectedLocation =
        LatLng(FFAppState().brukerLat, FFAppState().brukerLng);
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
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 60, 0, 0),
          child: Container(
            width: 500,
            height: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: ClipRect(
              key: scaffoldKey,
              child: SafeArea(
                top: true,
                bottom: false,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                            height: 22,
                            thickness: 4,
                            indent: MediaQuery.of(context).size.width * 0.4,
                            endIndent: MediaQuery.of(context).size.width * 0.4,
                            color: Colors.black12,
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 16),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Align(
                                  alignment: AlignmentDirectional(0, 0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        7, 0, 0, 0),
                                    child: Icon(
                                      CupertinoIcons.xmark,
                                      color: Colors.transparent,
                                      size: 25,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  child: Text(
                                    'Velg posisjon for å se lokalmat',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Nunito',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 17,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 16, 0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      try {
                                        Navigator.pop(context);
                                      } on SocketException {
                                        Toasts.showErrorToast(context,
                                            'Ingen internettforbindelse');
                                      } catch (e) {
                                        Toasts.showErrorToast(
                                            context, 'En feil oppstod');
                                      }
                                    },
                                    child: Icon(
                                      CupertinoIcons.xmark,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: const AlignmentDirectional(0.0, 1.0),
                        child: Stack(
                          alignment: const AlignmentDirectional(0.0, 1.0),
                          children: [
                            Align(
                              alignment: const AlignmentDirectional(0.0, -1.2),
                              child: Container(
                                padding: const EdgeInsets.only(bottom: 160.0),
                                width: 500.0,
                                height: MediaQuery.sizeOf(context).height + 160,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Align(
                                  alignment:
                                      const AlignmentDirectional(0.0, 1.0),
                                  child: SizedBox(
                                    width: 500.0,
                                    height: double.infinity,
                                    child: custom_widgets.Chooselocation(
                                      width: 500.0,
                                      height: double.infinity,
                                      zoom: 5,
                                      center: LatLng(
                                          FFAppState().brukerLat == 0
                                              ? 59.9138688
                                              : FFAppState().brukerLat,
                                          FFAppState().brukerLng == 0
                                              ? 10.7522454
                                              : FFAppState().brukerLng),
                                      matsted: LatLng(FFAppState().brukerLat,
                                          FFAppState().brukerLng),
                                      onLocationChanged: (newLocation) {
                                        setState(() {
                                          _model.selectedLocation = newLocation;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              elevation: 10.0,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(0.0),
                                  bottomRight: Radius.circular(0.0),
                                  topLeft: Radius.circular(40.0),
                                  topRight: Radius.circular(40.0),
                                ),
                              ),
                              child: Container(
                                width: MediaQuery.sizeOf(context).width,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primary,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(0.0),
                                    bottomRight: Radius.circular(0.0),
                                    topLeft: Radius.circular(40.0),
                                    topRight: Radius.circular(40.0),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              20.0, 27.0, 20.0, 12.0),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          try {
                                            LatLng? location;
                                            // Check location permission status before attempting to get the location
                                            LocationPermission permission =
                                                await Geolocator
                                                    .requestPermission();

                                            if (permission ==
                                                    LocationPermission.denied ||
                                                permission ==
                                                    LocationPermission
                                                        .deniedForever ||
                                                permission ==
                                                    LocationPermission
                                                        .unableToDetermine) {
                                              if (!context.mounted) return;
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return CupertinoAlertDialog(
                                                    title: const Text(
                                                        'Stedstjenester er deaktivert for MatSalg.no'),
                                                    content: const Text(
                                                        'Aktiver stedstjenester for MatSalg.no i innstillinger for å bruke din nåværende posisjon.'),
                                                    actions: [
                                                      CupertinoDialogAction(
                                                        onPressed: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                          await Geolocator
                                                              .openLocationSettings();
                                                        },
                                                        textStyle: const TextStyle(
                                                            color:
                                                                CupertinoColors
                                                                    .systemBlue),
                                                        child: const Text(
                                                            'Innstillinger'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                              return; // Avslutt logikken i onPressed hvis tillatelsen er nektet
                                            }

                                            // Hvis tillatelsen er gitt, hent plasseringen
                                            location =
                                                await getCurrentUserLocation(
                                                    defaultLocation:
                                                        const LatLng(0.0, 0.0));

                                            // Hvis plassering er null, vis en feil og avslutt
                                            if (location ==
                                                const LatLng(0.0, 0.0)) {
                                              if (!context.mounted) return;
                                              Toasts.showErrorToast(context,
                                                  'Stedtjenester er deaktivert i innstillinger');
                                              return;
                                            }
                                            // Await the result of getCurrentUserLocation
                                            location =
                                                await getCurrentUserLocation(
                                                    defaultLocation:
                                                        const LatLng(0.0, 0.0));

                                            // Check if the location was retrieved

                                            _model.selectedLocation = location;

                                            if (_model.selectedLocation !=
                                                    null &&
                                                _model.selectedLocation !=
                                                    const LatLng(0.0, 0.0)) {
                                              location =
                                                  _model.selectedLocation;
                                              FFAppState().brukerLat =
                                                  location!.latitude;
                                              FFAppState().brukerLng =
                                                  location.longitude;
                                              if (!context.mounted) return;
                                              String? token =
                                                  await firebaseAuthService
                                                      .getToken(context);
                                              if (token == null) {
                                                return;
                                              } else {
                                                await userInfoService
                                                    .updatePosisjon(
                                                        token: token);
                                              }
                                            }

                                            if (!context.mounted) return;
                                            if (location ==
                                                const LatLng(0.0, 0.0)) {
                                              Toasts.showErrorToast(context,
                                                  'posisjonstjenester er skrudd av i innstillinger');
                                              return;
                                            } else {
                                              HapticFeedback.selectionClick();
                                              if (widget.where == 'velg') {
                                                context.goNamed('Hjem');
                                              } else {
                                                Navigator.pop(context);
                                              }
                                            }
                                          } on SocketException {
                                            Toasts.showErrorToast(context,
                                                'Ingen internettforbindelse');
                                          } catch (e) {
                                            Toasts.showErrorToast(
                                                context, 'En feil oppstod');
                                          }
                                        },
                                        text: 'Bruk min nåværende posisjon',
                                        icon: Icon(CupertinoIcons.location_fill,
                                            size: 20,
                                            color: FlutterFlowTheme.of(context)
                                                .alternate),
                                        options: FFButtonOptions(
                                          width: double.infinity,
                                          height: 50.0,
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(11, 0, 0, 0),
                                          iconPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 0, 0),
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                fontFamily: 'Nunito',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                fontSize: 16,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w800,
                                              ),
                                          elevation: 0,
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 0.69,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              20.0, 0.0, 20.0, 55.0),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          try {
                                            LatLng? location;
                                            if (_model
                                                    .currentUserLocationValue !=
                                                null) {
                                              _model.selectedLocation =
                                                  location;
                                            }
                                            if (_model.selectedLocation !=
                                                null) {
                                              location =
                                                  _model.selectedLocation;
                                              FFAppState().brukerLat =
                                                  location!.latitude;
                                              FFAppState().brukerLng =
                                                  location.longitude;
                                              String? token =
                                                  await firebaseAuthService
                                                      .getToken(context);
                                              if (token == null) {
                                                return;
                                              } else {
                                                await userInfoService
                                                    .updatePosisjon(
                                                        token: token);
                                              }
                                            }
                                            if (!context.mounted) return;
                                            HapticFeedback.selectionClick();
                                            if (widget.where == 'velg') {
                                              context.goNamed('Hjem');
                                            } else {
                                              Navigator.pop(context);
                                            }
                                          } on SocketException {
                                            Toasts.showErrorToast(context,
                                                'Ingen internettforbindelse');
                                          } catch (e) {
                                            Toasts.showErrorToast(
                                                context, 'En feil oppstod');
                                          }
                                        },
                                        text: 'Velg posisjon',
                                        options: FFButtonOptions(
                                          width: double.infinity,
                                          height: 50.0,
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(16.0, 0.0, 16.0, 0.0),
                                          iconPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          textStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .override(
                                                    fontFamily: 'Nunito',
                                                    color: Colors.white,
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                          elevation: 0.0,
                                          borderRadius:
                                              BorderRadius.circular(14.0),
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
