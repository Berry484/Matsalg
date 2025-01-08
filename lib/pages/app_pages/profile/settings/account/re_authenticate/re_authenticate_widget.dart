import 'package:easy_debounce/easy_debounce.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_theme.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/logging.dart';
import 'package:mat_salg/services/user_service.dart';
import 'package:mat_salg/services/web_socket.dart';
import 're_authenticate_model.dart';
export 're_authenticate_model.dart';

class ReAuthenticateWidget extends StatefulWidget {
  const ReAuthenticateWidget(
      {super.key, this.newPassword, this.username, this.delete});
  final String? newPassword;
  final bool? delete;
  final String? username;

  @override
  State<ReAuthenticateWidget> createState() => _ReAuthenticateWidgetState();
}

class _ReAuthenticateWidgetState extends State<ReAuthenticateWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final UserInfoService userInfoService = UserInfoService();
  late WebSocketService webSocketService;
  late ReAuthenticateModel _model;
  bool isLoading = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReAuthenticateModel());
    webSocketService = WebSocketService();
    _model.passwordChangeController ??= TextEditingController();
    _model.passwordChangeNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 60, 0, 0),
      child: Container(
        width: 500,
        height: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primary,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SizedBox(
                height: 100,
                child: Stack(
                  alignment: AlignmentDirectional(0, 1),
                  children: [
                    Material(
                      color: Colors.transparent,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
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
                          borderRadius: BorderRadius.only(
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
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Divider(
                                      height: 22,
                                      thickness: 4,
                                      indent:
                                          MediaQuery.of(context).size.width *
                                              0.4,
                                      endIndent:
                                          MediaQuery.of(context).size.width *
                                              0.4,
                                      color: Colors.black12,
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  13, 0, 0, 0),
                                          child: Text(
                                            'Lukk',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Nunito',
                                                  color: Color(0x00262C2D),
                                                  fontSize: 16,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 13, 0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'Avbryt',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily: 'Nunito',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                    fontSize: 16,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16, 12, 0, 0),
                                  child: Text(
                                    'Autentisering kreves',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Nunito',
                                          fontSize: 20,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16, 3, 20, 0),
                                  child: Text(
                                    'For å endre personlig informasjon må du\nskrive ditt nåværende passord.',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Nunito',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 15.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(16, 16, 16, 0),
                                        child: TextFormField(
                                          controller:
                                              _model.passwordChangeController,
                                          focusNode: _model.passwordChangeNode,
                                          textInputAction: TextInputAction.done,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          autofillHints: null,
                                          keyboardType: TextInputType.text,
                                          obscureText:
                                              !_model.passordVisibility,
                                          onChanged: (_) =>
                                              EasyDebounce.debounce(
                                            '_model.textController',
                                            const Duration(milliseconds: 0),
                                            () => safeSetState(() {}),
                                          ),
                                          decoration: InputDecoration(
                                            labelText: 'Nåværende passord',
                                            labelStyle: FlutterFlowTheme.of(
                                                    context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Nunito',
                                                  color: const Color.fromRGBO(
                                                      113, 113, 113, 1.0),
                                                  fontSize: 16.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                      fontFamily: 'Nunito',
                                                      letterSpacing: 0.0,
                                                    ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Colors.transparent,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            filled: true,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondary,
                                            suffixIcon: InkWell(
                                              onTap: () => safeSetState(
                                                () => _model.passordVisibility =
                                                    !_model.passordVisibility,
                                              ),
                                              focusNode: FocusNode(
                                                  skipTraversal: true),
                                              child: Icon(
                                                _model.passordVisibility
                                                    ? Icons.visibility_outlined
                                                    : Icons
                                                        .visibility_off_outlined,
                                                color: const Color(0xFF757575),
                                                size: 22,
                                              ),
                                            ),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Nunito',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontSize: 15,
                                                letterSpacing: 0.0,
                                              ),
                                          textAlign: TextAlign.start,
                                          validator: _model
                                              .passwordChangeControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20, 0, 20, 35),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    try {
                                      if (isLoading) return;
                                      setState(() {
                                        isLoading = true;
                                      });
                                      if (widget.delete == true) {
                                        bool success = await firebaseAuthService
                                            .reAuthenticate(
                                                context,
                                                _model.passwordChangeController
                                                    .text);
                                        if (success) {
                                          if (!context.mounted) return;
                                          final response =
                                              await userInfoService.deleteUser(
                                                  context,
                                                  widget.username ?? '');
                                          if (response!.statusCode == 200) {
                                            final appState = FFAppState();
                                            FFAppState().login = false;
                                            FFAppState().startet = false;
                                            appState.conversations.clear();
                                            appState.matvarer.clear();
                                            webSocketService.close();
                                            await _auth.currentUser?.delete();
                                            if (!context.mounted) return;
                                            Toasts.showAccepted(
                                                context, 'Bruker slettet');
                                            logger.d('successs');
                                            await _auth.signOut();
                                            if (!context.mounted) return;
                                            isLoading = false;
                                            context.go('/registrer');
                                          }
                                        } else {
                                          if (!context.mounted) return;
                                          isLoading = false;
                                        }
                                      } else {
                                        bool success = await firebaseAuthService
                                            .reAuthenticate(
                                                context,
                                                _model.passwordChangeController
                                                    .text);

                                        if (success) {
                                          success = await firebaseAuthService
                                              .updatePassword(
                                                  widget.newPassword ?? '');

                                          if (success) {
                                            if (!context.mounted) return;

                                            Toasts.showAccepted(
                                                context, 'Passord endret');
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          } else {
                                            if (!context.mounted) return;

                                            Toasts.showErrorToast(context,
                                                'En uforventet feil oppstod');
                                            isLoading = false;
                                          }
                                        } else {
                                          if (!context.mounted) return;
                                          isLoading = false;
                                        }
                                      }
                                    } catch (e) {
                                      if (!context.mounted) return;
                                      isLoading = false;
                                      logger.d(e);
                                      Toasts.showErrorToast(context,
                                          'En uforventet feil oppstod');
                                    } finally {
                                      if (context.mounted) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    }
                                  },
                                  text: widget.delete ?? false
                                      ? 'slett'
                                      : 'Lagre',
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 50,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        11, 0, 0, 0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Nunito',
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          fontSize: 16,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    elevation: 0,
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 0,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
