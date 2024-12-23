import 'dart:io';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/services/contact_us.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'contact_model.dart';
export 'contact_model.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _KontaktWidgetState();
}

class _KontaktWidgetState extends State<ContactPage> {
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final ContactUs contactUs = ContactUs();
  late ContactModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ContactModel());

    _model.emailTextController ??= TextEditingController();
    _model.emailFocusNode ??= FocusNode();
    _model.emailTextController.text = FFAppState().email;
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
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SizedBox(
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
                                      20, 12, 0, 0),
                                  child: Text(
                                    'Ta kontakt med oss',
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
                                      20, 10, 20, 0),
                                  child: Text(
                                    'Har du spørsmål, tilbakemeldinger eller noe du lurer på? Meldingen din vil bli sendt til vår supportavdeling på support@matsalg.no',
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
                                      20, 13, 20, 0),
                                  child: Column(children: [
                                    TextFormField(
                                      controller: _model.emailTextController,
                                      focusNode: _model.emailFocusNode,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'E-post',
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Nunito',
                                              color: const Color.fromRGBO(
                                                  113, 113, 113, 1.0),
                                              fontSize: 17.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w700,
                                            ),
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'Open Sans',
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
                                            color: FlutterFlowTheme.of(context)
                                                .secondary,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        filled: true,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .secondary,
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
                                      validator: _model
                                          .emailTextControllerValidator
                                          .asValidator(context),
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(50),
                                        TextInputFormatter.withFunction(
                                            (oldValue, newValue) {
                                          final lineCount = '\n'
                                                  .allMatches(newValue.text)
                                                  .length +
                                              1;
                                          if (lineCount > 1) {
                                            return oldValue;
                                          }
                                          return newValue;
                                        }),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    TextFormField(
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
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        filled: true,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .secondary,
                                        contentPadding:
                                            const EdgeInsetsDirectional
                                                .fromSTEB(20, 24, 0, 24),
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
                                      minLines: 3,
                                      maxLines: 3,
                                      validator: _model
                                          .bioTextControllerValidator
                                          .asValidator(context),
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(800),
                                        TextInputFormatter.withFunction(
                                            (oldValue, newValue) {
                                          return newValue;
                                        }),
                                      ],
                                    ),
                                  ]),
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
                                      if (_model.loading) return;
                                      _model.loading = true;
                                      String? token = await firebaseAuthService
                                          .getToken(context);
                                      if (token == null) {
                                        _model.loading = false;
                                        return;
                                      } else {
                                        if (_model.bioTextController!.text
                                            .trim()
                                            .isNotEmpty) {
                                          final response =
                                              await contactUs.contactUs(
                                                  token: token,
                                                  description: _model
                                                      .bioTextController.text,
                                                  email: _model
                                                      .emailTextController
                                                      .text);
                                          if (response.statusCode == 200) {
                                            if (!context.mounted) return;
                                            Navigator.pop(context);
                                            if (!context.mounted) return;
                                            Toasts.showAccepted(
                                                context, 'Melding sendt');
                                          } else {
                                            _model.loading = false;
                                            throw Exception();
                                          }
                                          _model.loading = false;
                                        }
                                      }
                                    } on SocketException {
                                      _model.loading = false;
                                      if (!context.mounted) return;
                                      Toasts.showErrorToast(context,
                                          'Ingen internettforbindelse');
                                    } on Error {
                                      _model.loading = false;
                                      if (!context.mounted) return;
                                      Toasts.showErrorToast(
                                          context, 'En feil oppstod');
                                    } catch (e) {
                                      _model.loading = false;
                                      if (!context.mounted) return;
                                      Toasts.showErrorToast(
                                          context, 'En feil oppstod');
                                    }
                                  },
                                  text: 'Send',
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 47.0,
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
                                              .secondary,
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
