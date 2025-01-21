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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) {
            return;
          }
        },
        child: Scaffold(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            elevation: 0,
            scrolledUnderElevation: 0.0,
            leading: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 28.0,
                ),
                onPressed: () {
                  context.safePop();
                },
              ),
            ),
            centerTitle: true,
            title: Text(
              'Support',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Nunito',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 18,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            actions: [],
          ),
          body: SafeArea(
            top: true,
            bottom: false,
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
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
                                  20, 0, 0, 0),
                              child: Text(
                                'Ta kontakt med oss',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Nunito',
                                      fontSize: 21,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  20, 10, 20, 0),
                              child: Text(
                                'Har du spørsmål eller tilbakemeldinger? Skriv til oss her, så svarer vi på e-posten som er registrert på kontoen din.',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Nunito',
                                      color: Colors.grey[700],
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  20, 25, 20, 0),
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
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor:
                                      FlutterFlowTheme.of(context).secondary,
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
                                              description:
                                                  _model.bioTextController.text,
                                              email: FFAppState().email);
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
                                  Toasts.showErrorToast(
                                      context, 'Ingen internettforbindelse');
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
                                height: 50.0,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                color: _model.bioTextController.text.isNotEmpty
                                    ? FlutterFlowTheme.of(context).alternate
                                    : FlutterFlowTheme.of(context).unSelected,
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
