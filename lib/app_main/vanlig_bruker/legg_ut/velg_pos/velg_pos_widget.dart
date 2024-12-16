import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mat_salg/app_main/vanlig_bruker/Utils.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'velg_pos_model.dart';
export 'velg_pos_model.dart';

class VelgPosWidget extends StatefulWidget {
  const VelgPosWidget({
    super.key,
    this.currentLocation,
  });

  final dynamic currentLocation;

  @override
  State<VelgPosWidget> createState() => _VelgPosWidgetState();
}

class _VelgPosWidgetState extends State<VelgPosWidget> {
  late VelgPosModel _model;

  LatLng? currentUserLocationValue;
  LatLng? selectedLocation; // State variable to store selected location
  final Toasts toasts = Toasts();

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VelgPosModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _model.textFieldFocusNode!.addListener(() => safeSetState(() {}));
    selectedLocation = widget.currentLocation ?? LatLng(59.913868, 10.752245);
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
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
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(
                        height: 22,
                        thickness: 4,
                        indent: 168,
                        endIndent: 168,
                        color: Color.fromRGBO(197, 197, 199, 1),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: const AlignmentDirectional(0, 0),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    7, 0, 0, 0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    try {
                                      // Unfocus the text field to ensure the keyboard is dismissed
                                      FocusScope.of(context).unfocus();
                                      Navigator.pop(
                                          context,
                                          widget.currentLocation ??
                                              const LatLng(0, 0));
                                    } on SocketException {
                                      toasts.showErrorToast(context,
                                          'Ingen internettforbindelse');
                                    } catch (e) {
                                      toasts.showErrorToast(
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
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 0),
                              child: Text(
                                'Velg posisjon',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Nunito',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontSize: 18,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                            ),
                            const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 7, 0),
                              child: Icon(
                                CupertinoIcons.xmark,
                                color: Colors.transparent,
                                size: 25,
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
                              alignment: const AlignmentDirectional(0.0, 1.0),
                              child: SizedBox(
                                width: 500.0,
                                height: double.infinity,
                                child: custom_widgets.Chooselocation(
                                  width: 500.0,
                                  height: double.infinity,
                                  center: widget.currentLocation ??
                                      LatLng(59.12681775541445,
                                          11.386219119466823),
                                  matsted: widget.currentLocation ??
                                      LatLng(59.12681775541445,
                                          11.386219119466823),
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
                                      20.0, 27.0, 20.0, 12.0),
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      try {
                                        LatLng? location;
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

                                        location = await getCurrentUserLocation(
                                            defaultLocation:
                                                const LatLng(0.0, 0.0));

                                        selectedLocation = location;
                                        if (location !=
                                            const LatLng(0.0, 0.0)) {
                                          HapticFeedback.heavyImpact();
                                          FocusScope.of(context).unfocus();
                                          Navigator.pop(context, location);
                                        }

                                        if (location ==
                                            const LatLng(0.0, 0.0)) {
                                          toasts.showErrorToast(context,
                                              'Stedtjenester er deaktivert i innstillinger');
                                          return;
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
                                      color:
                                          FlutterFlowTheme.of(context).primary,
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
                                // Padding(
                                //   padding: const EdgeInsetsDirectional.fromSTEB(
                                //       0.0, 30.0, 0.0, 30.0),
                                //   child: GestureDetector(
                                //     onTap: () async {
                                //       try {
                                //         LatLng? location;

                                //         location = await getCurrentUserLocation(
                                //             defaultLocation:
                                //                 const LatLng(0.0, 0.0));

                                //         selectedLocation = location;
                                //         if (location !=
                                //             const LatLng(0.0, 0.0)) {
                                //           HapticFeedback.heavyImpact();
                                //           FocusScope.of(context).unfocus();
                                //           Navigator.pop(context, location);
                                //         }
                                //       } on SocketException {
                                //               HapticFeedback.lightImpact();
                                //             'Ingen internettforbindelse');
                                //       } catch (e) {
                                //               HapticFeedback.lightImpact();
                                //             context, 'En feil oppstod');
                                //       }
                                //     },
                                //     child: Row(
                                //       mainAxisSize: MainAxisSize.min,
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.center,
                                //       crossAxisAlignment:
                                //           CrossAxisAlignment.end,
                                //       children: [
                                //         FaIcon(
                                //           FontAwesomeIcons.locationArrow,
                                //           color: FlutterFlowTheme.of(context)
                                //               .alternate,
                                //           size: 19.0,
                                //         ),
                                //         const SizedBox(width: 8.0),
                                //         Text(
                                //           'Bruk min nåværende posisjon',
                                //           style: FlutterFlowTheme.of(context)
                                //               .bodyMedium
                                //               .override(
                                //                 fontFamily: 'Open Sans',
                                //                 color:
                                //                     FlutterFlowTheme.of(context)
                                //                         .alternate,
                                //                 fontSize: 17.0,
                                //                 fontWeight: FontWeight.bold,
                                //               ),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      20.0, 0.0, 20.0, 55.0),
                                  child: FFButtonWidget(
                                    onPressed: () {
                                      HapticFeedback.heavyImpact();
                                      // Unfocus the text field to ensure the keyboard is dismissed
                                      FocusScope.of(context).unfocus();
                                      LatLng? location;
                                      if (currentUserLocationValue != null) {
                                        selectedLocation = location;
                                      }
                                      if (selectedLocation != null) {
                                        location = selectedLocation;
                                      }
                                      // Return the selected position when the button is pressed
                                      if (selectedLocation != null) {
                                        Navigator.pop(
                                            context, selectedLocation);
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
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
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
      ),
    );
  }
}
