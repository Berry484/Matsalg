import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/logging.dart';
import 'package:mat_salg/services/push_notification_service.dart';

import '../../../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import '../../../../../helper_components/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'follow_user_model.dart';
export 'follow_user_model.dart';

class FollowUserWidget extends StatefulWidget {
  const FollowUserWidget(
      {super.key, this.uid, this.username, this.pushEnabled});
  final dynamic username;
  final dynamic uid;
  final dynamic pushEnabled;

  @override
  State<FollowUserWidget> createState() => _FolgBrukerWidgetState();
}

class _FolgBrukerWidgetState extends State<FollowUserWidget> {
  late FollowUserModel _model;
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FollowUserModel());

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

  Future<void> getVarsling() async {
    try {
      if (_model.isLoading) return;
      _model.isLoading = true;
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return;
      }
      await PushNotificationService.varslingBruker(
          token, widget.uid, _model.switchValue ?? false);
      _model.isLoading = false;
    } on SocketException {
      _model.isLoading = false;
      if (!mounted) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      _model.isLoading = false;
      logger.d('En feil oppstod');
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
                                  thickness: 4,
                                  indent:
                                      MediaQuery.of(context).size.width * 0.4,
                                  endIndent:
                                      MediaQuery.of(context).size.width * 0.4,
                                  color: Colors.black12,
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
                                                        color: Colors.grey[700],
                                                        fontSize: 15,
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
                                          HapticFeedback.selectionClick();
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
