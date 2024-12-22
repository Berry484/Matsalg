import 'dart:io';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:mat_salg/helper_components/Toasts.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/services/contact_us.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'rapporter_model.dart';
export 'rapporter_model.dart';

class RapporterWidget extends StatefulWidget {
  const RapporterWidget({
    super.key,
    this.username,
    this.matId,
    this.chat,
    this.chatUsername,
  });

  final dynamic username;
  final dynamic matId;
  final dynamic chat;
  final dynamic chatUsername;

  @override
  State<RapporterWidget> createState() => _RapporterWidgetState();
}

class _RapporterWidgetState extends State<RapporterWidget> {
  late RapporterModel _model;
  ContactUs contactUs = ContactUs();
  bool _loading = false;
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RapporterModel());

    _model.bioTextController ??= TextEditingController();
    _model.bioFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                height: 100,
                child: Stack(
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
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(13, 0, 0, 0),
                                          child: Text(
                                            'Lukk',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Nunito',
                                                  color:
                                                      const Color(0x00262C2D),
                                                  fontSize: 16,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 0, 13, 0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              Navigator.pop(context);
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
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      20, 10, 0, 0),
                                  child: Text(
                                    widget.matId != null
                                        ? 'Hvorfor ønsker du å rapportere\ndenne annonsen?'
                                        : 'Hvorfor ønsker du å rapportere\ndenne brukeren?',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Nunito',
                                          fontSize: 20,
                                          letterSpacing: 0.0,
                                          lineHeight: 1.1,
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      20, 16, 20, 0),
                                  child: Text(
                                    'Skriv så utfyllende som mulig\nslik at vi kan behandle saken raskest mulig',
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
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      20, 12, 20, 0),
                                  child: TextFormField(
                                    controller: _model.bioTextController,
                                    focusNode: _model.bioFocusNode,
                                    onChanged: (_) => EasyDebounce.debounce(
                                      '_model.textController',
                                      const Duration(milliseconds: 0),
                                      () => safeSetState(() {}),
                                    ),
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            fontFamily: 'Open Sans',
                                            fontSize: 13,
                                            letterSpacing: 0.0,
                                          ),
                                      hintText: 'Skriv her',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Nunito',
                                            color: const Color.fromRGBO(
                                                113, 113, 113, 1.0),
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w700,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0x00000000),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      filled: true,
                                      fillColor: FlutterFlowTheme.of(context)
                                          .secondary,
                                      contentPadding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              20, 24, 0, 24),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Nunito',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 16,
                                          letterSpacing: 0.0,
                                        ),
                                    textAlign: TextAlign.start,
                                    maxLength: 800,
                                    maxLengthEnforcement:
                                        MaxLengthEnforcement.enforced,
                                    minLines: 4,
                                    maxLines: 4,
                                    validator: _model.bioTextControllerValidator
                                        .asValidator(context),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(800),
                                      TextInputFormatter.withFunction(
                                          (oldValue, newValue) {
                                        return newValue;
                                      }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: const AlignmentDirectional(0, 0),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    20, 0, 20, 30),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    try {
                                      if (_loading) return;
                                      _loading = true;
                                      String? token = await firebaseAuthService
                                          .getToken(context);
                                      if (token == null) {
                                        _loading = false;
                                        return;
                                      } else {
                                        if (_model.bioTextController!.text
                                            .trim()
                                            .isNotEmpty) {
                                          final response =
                                              await contactUs.reportUser(
                                                  token: token,
                                                  to: widget.username,
                                                  description: widget.chat ==
                                                          true
                                                      ? 'Chat med ${widget.chatUsername}\nBeskrivelse: ${_model.bioTextController.text}'
                                                      : _model.bioTextController
                                                          .text,
                                                  matId: widget.matId);
                                          if (response.statusCode == 200) {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Toasts.showAccepted(
                                                context, 'Rapport sendt');
                                          } else {
                                            _loading = false;
                                            throw Exception();
                                          }
                                        }
                                        _loading = false;
                                      }
                                    } on SocketException {
                                      _loading = false;

                                      Toasts.showErrorToast(context,
                                          'Ingen internettforbindelse');
                                    } on Error {
                                      _loading = false;

                                      Toasts.showErrorToast(
                                          context, 'En feil oppstod');
                                    } catch (e) {
                                      _loading = false;

                                      Toasts.showErrorToast(
                                          context, 'En feil oppstod');
                                    }
                                  },
                                  text: 'Rapporter',
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 50.0,
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                    iconPadding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                    color: _model
                                            .bioTextController.text.isNotEmpty
                                        ? FlutterFlowTheme.of(context).alternate
                                        : FlutterFlowTheme.of(context)
                                            .unSelected,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily: 'Nunito',
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          fontSize: 17.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w800,
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
