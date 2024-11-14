import 'dart:io';

import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
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
    selectedLocation = widget.currentLocation ??
        functions.doubletillatlon(59.913868, 10.752245);
  }

  void showErrorToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        left: 16.0,
        right: 16.0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8)
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  FontAwesomeIcons.solidTimesCircle,
                  color: Colors.black,
                  size: 30.0,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primary,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x25090F13),
            offset: Offset(
              0.0,
              2,
            ),
          )
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 35, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
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
                                  showErrorToast(
                                      context, 'Ingen internettforbindelse');
                                } catch (e) {
                                  showErrorToast(context, 'En feil oppstod');
                                }
                              },
                              child: Text(
                                'Avbryt',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Open Sans',
                                      color: FlutterFlowTheme.of(context).info,
                                      fontSize: 14,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 24.0,
                    thickness: 2.0,
                    color: FlutterFlowTheme.of(context).primaryBackground,
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
                        padding: const EdgeInsets.only(bottom: 220.0),
                        width: 500.0,
                        height: MediaQuery.sizeOf(context).height,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
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
                                  functions.doubletillatlon(
                                      59.12681775541445, 11.386219119466823)!,
                              matsted: widget.currentLocation ??
                                  functions.doubletillatlon(
                                      59.12681775541445, 11.386219119466823)!,
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
                                  30.0, 40.0, 30.0, 20.0),
                              child: TextFormField(
                                controller: _model.textController,
                                focusNode: _model.textFieldFocusNode,
                                autofocus: false,
                                obscureText: false,
                                onTap: () {},
                                onFieldSubmitted: (value) {
                                  if (_model.textController.text.isNotEmpty) {
                                    context.pushNamed(
                                      'BondeGardPage',
                                      queryParameters: {
                                        'kategori': serializeParam(
                                            'Søk', ParamType.String),
                                        'query': serializeParam(
                                            _model.textController.text,
                                            ParamType.String),
                                      }.withoutNulls,
                                    );
                                  }
                                },
                                textInputAction: TextInputAction.search,
                                decoration: InputDecoration(
                                  isDense: true,
                                  alignLabelWithHint: false,
                                  hintText: 'Søk etter en by',
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: 'Open Sans',
                                        color: const Color(0x8F101213),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(0, 85, 85, 85),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(22.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(22.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(22.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(22.0),
                                  ),
                                  filled: true,
                                  fillColor:
                                      const Color.fromARGB(246, 243, 243, 243),
                                  prefixIcon: const Icon(
                                    Icons.search_outlined,
                                    size: 20,
                                  ),
                                  suffixIcon: _model
                                          .textController.text.isNotEmpty
                                      ? IconButton(
                                          icon: Icon(
                                            FontAwesomeIcons.solidTimesCircle,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                          ),
                                          onPressed: () {
                                            _model.textController!.clear();
                                            setState(() {});
                                          },
                                        )
                                      : null,
                                  contentPadding: const EdgeInsets.only(
                                    top: 6.0,
                                    bottom: 6.0,
                                    left: 10.0,
                                    right: 10.0,
                                  ),
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: 'Open Sans',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontSize: 15.0,
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
                                  0.0, 0.0, 0.0, 25.0),
                              child: GestureDetector(
                                onTap: () async {
                                  try {
                                    LatLng? location;

                                    location = await getCurrentUserLocation(
                                        defaultLocation:
                                            const LatLng(0.0, 0.0));

                                    selectedLocation = location;
                                    if (location != const LatLng(0.0, 0.0)) {
                                      HapticFeedback.heavyImpact();
                                      FocusScope.of(context).unfocus();
                                      Navigator.pop(context, location);
                                    }
                                  } on SocketException {
                                    showErrorToast(
                                        context, 'Ingen internettforbindelse');
                                  } catch (e) {
                                    showErrorToast(context, 'En feil oppstod');
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.locationArrow,
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      size: 19.0,
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      'Bruk min nåværende posisjon',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Open Sans',
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
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
                                    Navigator.pop(context, selectedLocation);
                                  }
                                },
                                text: 'Velg denne posisjonen',
                                options: FFButtonOptions(
                                  width: 320,
                                  height: 50.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  iconPadding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).alternate,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Open Sans',
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  elevation: 0.0,
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
    );
  }
}
