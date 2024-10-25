import 'package:mat_salg/ApiCalls.dart';
import 'package:mat_salg/SecureStorage.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
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
  final Securestorage securestorage = Securestorage();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VelgPosisjonModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _model.textFieldFocusNode!.addListener(() => safeSetState(() {}));
    selectedLocation = functions.doubletillatlon(
        FFAppState().brukerLat ?? 59.9138688,
        FFAppState().brukerLng ?? 10.7522454)!;
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
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: FlutterFlowTheme.of(context).alternate,
                  size: 28.0,
                ),
              ),
            ),
            title: Text(
              'Velg en posisjon',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Montserrat',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 20.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
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
                              bottom: 230.0), // Adjust the padding as needed
                          width: 500.0,
                          height: MediaQuery.sizeOf(context).height,
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
                                center: functions.doubletillatlon(
                                    FFAppState().brukerLat ?? 59.9138688,
                                    FFAppState().brukerLng ?? 10.7522454)!,
                                matsted: functions.doubletillatlon(
                                    FFAppState().brukerLat ?? 59.9138688,
                                    FFAppState().brukerLng ?? 10.7522454)!,
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
                                    50.0, 40.0, 50.0, 20.0),
                                child: TextFormField(
                                  controller: _model.textController,
                                  focusNode: _model.textFieldFocusNode,
                                  autofocus: false,
                                  textInputAction: TextInputAction.done,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    alignLabelWithHint: false,
                                    hintText: 'Søk...',
                                    hintStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          fontFamily: 'Open Sans',
                                          color: const Color(0x8F101213),
                                          fontSize: 12.0,
                                          letterSpacing: 0.0,
                                        ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(13.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color(0x00000000),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(13.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(13.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(13.0),
                                    ),
                                    filled: true,
                                    fillColor:
                                        FlutterFlowTheme.of(context).primary,
                                    prefixIcon: const Icon(
                                      Icons.search_outlined,
                                    ),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Open Sans',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: 13.0,
                                        letterSpacing: 0.0,
                                      ),
                                  textAlign: TextAlign.start,
                                  cursorColor:
                                      FlutterFlowTheme.of(context).primaryText,
                                  validator: _model.textControllerValidator
                                      .asValidator(context),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 15.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    LatLng? location;

                                    // Await the result of getCurrentUserLocation
                                    location = await getCurrentUserLocation(
                                        defaultLocation:
                                            const LatLng(0.0, 0.0));

                                    // Check if the location was retrieved
                                    if (location != null) {
                                      selectedLocation = location;
                                    }
                                    if (selectedLocation != null) {
                                      location = selectedLocation;
                                      FFAppState().brukerLat =
                                          location?.latitude;
                                      FFAppState().brukerLng =
                                          location?.longitude;
                                      String? token =
                                          await Securestorage().readToken();
                                      if (token == null) {
                                        FFAppState().login = false;
                                        context.pushNamed('registrer');
                                        return;
                                      } else {
                                        final apiUserSQL = ApiUserSQL();
                                        final response = await apiUserSQL
                                            .updatePosisjon(token: token);
                                      }
                                    }

                                    // If location was not retrieved, exit
                                    if (location == null) {
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
                                      context.goNamed('Hjem');
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 0.0, 0.0, 10.0),
                                        child: Icon(
                                          Icons.location_on,
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          size: 25.0,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 0.0, 0.0, 10.0),
                                        child: Text(
                                          'Bruk min nåværende posisjon',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Open Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 55.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    LatLng? location;
                                    if (currentUserLocationValue != null) {
                                      selectedLocation = location;
                                    }
                                    if (selectedLocation != null) {
                                      location = selectedLocation;
                                      FFAppState().brukerLat =
                                          location?.latitude;
                                      FFAppState().brukerLng =
                                          location?.longitude;
                                      String? token =
                                          await Securestorage().readToken();
                                      if (token == null) {
                                        FFAppState().login = false;
                                        context.pushNamed('registrer');
                                        return;
                                      } else {
                                        final apiUserSQL = ApiUserSQL();
                                        final response = await apiUserSQL
                                            .updatePosisjon(token: token);
                                      }
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
                                      context.pushNamed('Hjem');
                                    }
                                  },
                                  text: 'Velg denne posisjonen',
                                  options: FFButtonOptions(
                                    width: 290.0,
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
                                          fontFamily: 'Open Sans',
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    elevation: 3.0,
                                    borderRadius: BorderRadius.circular(24.0),
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
