import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mat_salg/apiCalls.dart';
import 'package:mat_salg/app_main/vanlig_bruker/Utils.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:geolocator/geolocator.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'velg_posisjon_model.dart';
export 'velg_posisjon_model.dart';

class VelgPosisjonWidget extends StatefulWidget {
  const VelgPosisjonWidget({
    super.key,
    bool? bonde,
    bool? endrepos,
    this.email,
    this.password,
    this.phone,
  })  : bonde = bonde ?? true,
        endrepos = endrepos ?? false;

  final bool bonde;
  final bool endrepos;
  final String? email;
  final String? password;
  final String? phone;

  @override
  State<VelgPosisjonWidget> createState() => _VelgPosisjonWidgetState();
}

class _VelgPosisjonWidgetState extends State<VelgPosisjonWidget> {
  late VelgPosisjonModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;
  LatLng? selectedLocation; // State variable to store selected location
  final ApiUserSQL apiUserSQL = ApiUserSQL();
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final Toasts toasts = Toasts();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VelgPosisjonModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _model.textFieldFocusNode!.addListener(() => safeSetState(() {}));
    selectedLocation = LatLng(FFAppState().brukerLat, FFAppState().brukerLng);
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
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).alternate),
            automaticallyImplyLeading: true,
            leading: Visibility(
              visible: widget.endrepos == true,
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  try {
                    context.goNamed(
                      'Hjem',
                      extra: <String, dynamic>{
                        kTransitionInfoKey: const TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.fade,
                          duration: Duration(milliseconds: 0),
                        ),
                      },
                    );
                  } on SocketException {
                    toasts.showErrorToast(
                        context, 'Ingen internettforbindelse');
                  } catch (e) {
                    toasts.showErrorToast(context, 'En feil oppstod');
                  }
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 28.0,
                ),
              ),
            ),
            title: Text(
              textAlign: TextAlign.center,
              'Velg posisjon for å se lokalmat',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Nunito',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 17,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            actions: const [],
            centerTitle: true,
            elevation: 0.0,
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Align(
                  alignment: const AlignmentDirectional(0.0, 1.0),
                  child: Stack(
                    alignment: const AlignmentDirectional(0.0, 1.0),
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(0.0, -1.2),
                        child: Container(
                          padding: const EdgeInsets.only(
                              bottom: 160.0), // Adjust the padding as needed
                          width: 500.0,
                          height: MediaQuery.sizeOf(context).height + 160,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: Align(
                            alignment: const AlignmentDirectional(0.0, 1.0),
                            child: SizedBox(
                              width: 500.0,
                              height: double.infinity,
                              child: custom_widgets.Chooselocation(
                                width: 500.0,
                                height: double.infinity,
                                center: LatLng(FFAppState().brukerLat,
                                    FFAppState().brukerLng),
                                matsted: LatLng(FFAppState().brukerLat,
                                    FFAppState().brukerLng),
                                onLocationChanged: (newLocation) {
                                  setState(() {
                                    selectedLocation = newLocation;
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
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    20.0, 30.0, 20.0, 12.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    try {
                                      LatLng? location;
                                      // Check location permission status before attempting to get the location
                                      LocationPermission permission =
                                          await Geolocator.checkPermission();

                                      if (permission ==
                                              LocationPermission.denied ||
                                          permission ==
                                              LocationPermission
                                                  .deniedForever ||
                                          permission ==
                                              LocationPermission
                                                  .unableToDetermine) {
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
                                                    Navigator.of(context)
                                                        .pop(); // Lukk dialogen
                                                    // Åpne innstillinger for appen
                                                    await Geolocator
                                                        .openLocationSettings();
                                                  },
                                                  textStyle: const TextStyle(
                                                      color: CupertinoColors
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
                                      location = await getCurrentUserLocation(
                                          defaultLocation:
                                              const LatLng(0.0, 0.0));

                                      // Hvis plassering er null, vis en feil og avslutt
                                      if (location == const LatLng(0.0, 0.0)) {
                                        toasts.showErrorToast(context,
                                            'Stedtjenester er deaktivert i innstillinger');
                                        return;
                                      }
                                      // Await the result of getCurrentUserLocation
                                      location = await getCurrentUserLocation(
                                          defaultLocation:
                                              const LatLng(0.0, 0.0));

                                      // Check if the location was retrieved

                                      selectedLocation = location;

                                      if (selectedLocation != null &&
                                          selectedLocation !=
                                              const LatLng(0.0, 0.0)) {
                                        location = selectedLocation;
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
                                          final apiUserSQL = ApiUserSQL();
                                          await apiUserSQL.updatePosisjon(
                                              token: token);
                                        }
                                      }

                                      // If location was not retrieved, exit
                                      if (location == const LatLng(0.0, 0.0)) {
                                        toasts.showErrorToast(context,
                                            'posisjonstjenester er skrudd av i innstillinger');
                                        return;
                                      }
                                      if (widget.endrepos == false) {
                                        context.pushNamed(
                                          'OpprettProfil',
                                          queryParameters: {
                                            'bonde': serializeParam(
                                              widget.bonde,
                                              ParamType.bool,
                                            ),
                                            'email': serializeParam(
                                              widget.email,
                                              ParamType.String,
                                            ),
                                            'phone': serializeParam(
                                              widget.phone,
                                              ParamType.String,
                                            ),
                                            'password': serializeParam(
                                              widget.password,
                                              ParamType.String,
                                            ),
                                            'posisjon': serializeParam(
                                              location,
                                              ParamType.LatLng,
                                            ),
                                          }.withoutNulls,
                                        );
                                      } else {
                                        HapticFeedback.mediumImpact();
                                        context.goNamed('Hjem');
                                      }
                                    } on SocketException {
                                      toasts.showErrorToast(context,
                                          'Ingen internettforbindelse');
                                    } catch (e) {
                                      toasts.showErrorToast(
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
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            11, 0, 0, 0),
                                    iconPadding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                    color: FlutterFlowTheme.of(context).primary,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Nunito',
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          fontSize: 16,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w800,
                                        ),
                                    elevation: 0,
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    20.0, 0.0, 20.0, 55.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    try {
                                      LatLng? location;
                                      if (currentUserLocationValue != null) {
                                        selectedLocation = location;
                                      }
                                      if (selectedLocation != null) {
                                        location = selectedLocation;
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
                                          final apiUserSQL = ApiUserSQL();
                                          await apiUserSQL.updatePosisjon(
                                              token: token);
                                        }
                                      }
                                      context.pushNamed(
                                        'opprettProfil',
                                        queryParameters: {
                                          'bonde': serializeParam(
                                            widget.bonde,
                                            ParamType.bool,
                                          ),
                                          'email': serializeParam(
                                            widget.email,
                                            ParamType.String,
                                          ),
                                          'phone': serializeParam(
                                            widget.phone,
                                            ParamType.String,
                                          ),
                                          'password': serializeParam(
                                            widget.password,
                                            ParamType.String,
                                          ),
                                          'posisjon': serializeParam(
                                            location,
                                            ParamType.LatLng,
                                          ),
                                        }.withoutNulls,
                                      );
                                    } on SocketException {
                                      toasts.showErrorToast(context,
                                          'Ingen internettforbindelse');
                                    } catch (e) {
                                      toasts.showErrorToast(
                                          context, 'En feil oppstod');
                                    }
                                  },
                                  text: 'Velg posisjon',
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 50.0,
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                    iconPadding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Nunito',
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(14.0),
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
    );
  }
}
