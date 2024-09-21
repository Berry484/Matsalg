import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/permissions_util.dart';
import 'package:flutter/material.dart';
import 'velg_posisjon_model.dart';
export 'velg_posisjon_model.dart';

class VelgPosisjonWidget extends StatefulWidget {
  const VelgPosisjonWidget({
    super.key,
    bool? bonde,
    bool? endrepos,
  })  : bonde = bonde ?? true,
        endrepos = endrepos ?? false;

  final bool bonde;
  final bool endrepos;

  @override
  State<VelgPosisjonWidget> createState() => _VelgPosisjonWidgetState();
}

class _VelgPosisjonWidgetState extends State<VelgPosisjonWidget> {
  late VelgPosisjonModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VelgPosisjonModel());
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
                  context.pop();
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
          body: SafeArea(
            top: true,
            child: Column(
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
                                      59.913868, 10.752245)!,
                                  matsted: functions.doubletillatlon(
                                      59.913868, 10.752245)!,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0.0, 1.0),
                          child: Material(
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
                                        0.0, 30.0, 0.0, 15.0),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        await requestPermission(
                                            locationPermission);
                                        if (currentUserLocationValue != null) {
                                          context.pushNamed('Hjem');
                                        }
                                      },
                                      text: 'Bruk min nåværende posisjon',
                                      icon: const Icon(
                                        Icons.location_pin,
                                        size: 22.0,
                                      ),
                                      options: FFButtonOptions(
                                        width: 290.0,
                                        height: 40.0,
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                        iconPadding:
                                            const EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily: 'Open Sans',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              fontSize: 15.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                        elevation: 3.0,
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 30.0),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        if (widget.endrepos == false) {
                                          context.pushNamed(
                                            'OpprettProfil',
                                            queryParameters: {
                                              'bonde': serializeParam(
                                                widget.bonde,
                                                ParamType.bool,
                                              ),
                                            }.withoutNulls,
                                          );
                                        } else {
                                          context.goNamed('Hjem');
                                        }
                                      },
                                      text: 'Velg denne posisjonen',
                                      options: FFButtonOptions(
                                        width: 290.0,
                                        height: 40.0,
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                        iconPadding:
                                            const EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
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
                                        borderRadius:
                                            BorderRadius.circular(24.0),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
