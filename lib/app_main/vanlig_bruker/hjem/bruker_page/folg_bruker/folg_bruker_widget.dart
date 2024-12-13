import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mat_salg/apiCalls.dart';
import 'package:mat_salg/secureStorage.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'folg_bruker_model.dart';
export 'folg_bruker_model.dart';

class FolgBrukerWidget extends StatefulWidget {
  const FolgBrukerWidget({super.key, this.username, this.pushEnabled});
  final dynamic username;
  final dynamic pushEnabled;

  @override
  State<FolgBrukerWidget> createState() => _FolgBrukerWidgetState();
}

class _FolgBrukerWidgetState extends State<FolgBrukerWidget> {
  late FolgBrukerModel _model;
  final ApiFolg apiFolg = ApiFolg();
  bool _isLoading = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FolgBrukerModel());

    if (FFAppState().wantPush.contains(widget.username)) {
      _model.switchValue = true;
    } else {
      if (FFAppState().noPush.contains(widget.username)) {
        _model.switchValue = false;
      } else {
        _model.switchValue = widget.pushEnabled ?? false;
      }
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  void showErrorToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        left: 16.0,
        right: 16.0,
        child: Material(
          color: Colors.transparent,
          child: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.up, // Allow dismissing upwards
            onDismissed: (_) =>
                overlayEntry.remove(), // Remove overlay on dismiss
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    offset: Offset(0, 2),
                  ),
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
      ),
    );

    overlay.insert(overlayEntry);

    // Auto-remove the toast after 3 seconds if not dismissed
    Future.delayed(const Duration(seconds: 3), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  Future<void> getVarsling() async {
    try {
      if (_isLoading) return;
      _isLoading = true;
      await apiFolg.varslingBruker(Securestorage.authToken, widget.username,
          _model.switchValue ?? false);
      _isLoading = false;
    } on SocketException {
      _isLoading = false;
      HapticFeedback.lightImpact();
      showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      _isLoading = false;
      HapticFeedback.lightImpact();
      showErrorToast(context, 'En feil oppstod');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: const AlignmentDirectional(0, 1),
            children: [
              Material(
                color: Colors.transparent,
                elevation: 10,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 40),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Divider(
                                  height: 22,
                                  thickness: 3,
                                  indent: 190,
                                  endIndent: 190,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      8, 0, 8, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(
                                        Icons.close,
                                        color: Color(0x00262C2D),
                                        size: 29,
                                      ),
                                      Text(
                                        '@${widget.username}',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Nunito',
                                              fontSize: 17,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Icon(
                                          Icons.close,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          size: 29,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      20, 30, 20, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            CupertinoIcons.bell,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            size: 33,
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(10, 0, 0, 0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Varsle meg',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Nunito',
                                                        fontSize: 16,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                ),
                                                Text(
                                                  'Få varsling når ${widget.username} legger\nut en ny annonse',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Nunito',
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Switch.adaptive(
                                        value: _model.switchValue!,
                                        onChanged: (newValue) async {
                                          HapticFeedback.lightImpact();
                                          safeSetState(() =>
                                              _model.switchValue = newValue);
                                          if (newValue == false) {
                                            FFAppState()
                                                .wantPush
                                                .remove(widget.username);
                                            if (!FFAppState()
                                                .noPush
                                                .contains(widget.username)) {
                                              FFAppState()
                                                  .noPush
                                                  .add(widget.username);
                                            }
                                          }
                                          if (newValue == true) {
                                            FFAppState()
                                                .noPush
                                                .remove(widget.username);
                                            if (!FFAppState()
                                                .wantPush
                                                .contains(widget.username)) {
                                              FFAppState()
                                                  .wantPush
                                                  .add(widget.username);
                                            }
                                            if (newValue == true) {}
                                          }
                                          getVarsling();
                                        },
                                        activeColor:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                        activeTrackColor:
                                            FlutterFlowTheme.of(context)
                                                .alternate,
                                        inactiveTrackColor:
                                            FlutterFlowTheme.of(context)
                                                .secondary,
                                        inactiveThumbColor:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20, 0, 20, 40),
                          child: FFButtonWidget(
                            onPressed: () async {
                              FFAppState().wantPush.remove(widget.username);
                              if (!FFAppState()
                                  .noPush
                                  .contains(widget.username)) {
                                FFAppState().noPush.add(widget.username);
                              }
                              Navigator.pop(context, true);
                            },
                            text: 'Slutt å følge',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 50,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  11, 0, 0, 0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 0),
                              color: FlutterFlowTheme.of(context).primary,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Nunito',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize: 16,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                              elevation: 0,
                              borderSide: const BorderSide(
                                color: Color(0x4A57636C),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(14),
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
    );
  }
}
