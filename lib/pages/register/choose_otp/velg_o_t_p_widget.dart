import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mat_salg/logging.dart';

import '../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../helper_components/flutter_flow/flutter_flow_util.dart';
import '../../../helper_components/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'velg_o_t_p_model.dart';
export 'velg_o_t_p_model.dart';

class VelgOTPWidget extends StatefulWidget {
  const VelgOTPWidget({
    super.key,
    this.phone,
    required this.verificationId,
  });

  final String? phone;
  final String verificationId;

  @override
  State<VelgOTPWidget> createState() => _VelgOTPWidgetState();
}

class _VelgOTPWidgetState extends State<VelgOTPWidget> {
  late VelgOTPModel _model;
  bool _isloading = false;
  String? _errorMessage;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VelgOTPModel());

    _model.emailTextController ??= TextEditingController();
    _model.emailFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
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
        borderRadius: BorderRadius.circular(13),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: const AlignmentDirectional(0, 0),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 20),
                            child: Text(
                              'Oppgi kode fra SMS',
                              textAlign: TextAlign.start,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Nunito',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize: 19,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: const AlignmentDirectional(0, 1),
                child: Form(
                  key: _model.formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(25, 0, 25, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    3, 0, 0, 0),
                                child: TextFormField(
                                    controller: _model.emailTextController,
                                    focusNode: _model.emailFocusNode,
                                    textInputAction: TextInputAction.done,
                                    autofocus: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: '6 siffer fra SMS',
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
                                            fontFamily: 'Nunito',
                                            letterSpacing: 0.0,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      filled: true,
                                      fillColor: FlutterFlowTheme.of(context)
                                          .secondary,
                                      errorText: _errorMessage,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Nunito',
                                          letterSpacing: 0.0,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    maxLength: 6,
                                    maxLengthEnforcement:
                                        MaxLengthEnforcement.enforced,
                                    buildCounter: (context,
                                            {required currentLength,
                                            required isFocused,
                                            maxLength}) =>
                                        null,
                                    keyboardType: TextInputType.number,
                                    validator: _model
                                        .emailTextControllerValidator
                                        .asValidator(context),
                                    onChanged: (number) {
                                      setState(() {
                                        _errorMessage = null;
                                      });
                                    }),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0, 12, 0, 35),
                          child: _isloading
                              ? const CupertinoActivityIndicator(radius: 10.5)
                              : FFButtonWidget(
                                  onPressed: () async {
                                    if (_isloading) {
                                      return;
                                    }
                                    if (_model.formKey.currentState == null ||
                                        !_model.formKey.currentState!
                                            .validate()) {
                                      return;
                                    }
                                    if (_model
                                        .emailTextController.text.isEmpty) {
                                      setState(() {
                                        _isloading = false;
                                        _errorMessage = "felt må fylles ut";
                                      });
                                      return;
                                    }
                                    if (_model
                                            .emailTextController.text.length !=
                                        6) {
                                      safeSetState(() {
                                        _isloading = false;
                                        _errorMessage = "feil kode";
                                      });
                                      return;
                                    }
                                    try {
                                      safeSetState(() {
                                        _isloading = true;
                                      });
                                      try {
                                        final cred =
                                            PhoneAuthProvider.credential(
                                                verificationId:
                                                    widget.verificationId,
                                                smsCode: _model
                                                    .emailTextController.text);
                                        await FirebaseAuth.instance
                                            .signInWithCredential(cred);
                                      } catch (e) {
                                        logger.d(e.toString());
                                        safeSetState(() {
                                          _isloading = false;

                                          _errorMessage = "feil kode";
                                        });
                                        return;
                                      }

                                      safeSetState(() {
                                        _isloading = false;
                                      });
                                      if (!context.mounted) return;
                                      context.goNamed(
                                        'opprettProfil',
                                        queryParameters: {
                                          'phone': serializeParam(
                                            widget.phone,
                                            ParamType.String,
                                          ),
                                        }.withoutNulls,
                                      );

                                      safeSetState(() {
                                        _isloading = false;
                                      });
                                    } catch (e) {
                                      safeSetState(() {
                                        _isloading = false;
                                      });
                                      showCupertinoDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CupertinoAlertDialog(
                                            title:
                                                const Text('En feil oppstod'),
                                            content: const Text(
                                                'Prøv på nytt senere eller ta kontakt hvis problemet vedvarer'),
                                            actions: <Widget>[
                                              CupertinoDialogAction(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'Ok',
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  text: 'Neste',
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 50,
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16, 0, 16, 0),
                                    iconPadding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Nunito',
                                          color: Colors.white,
                                          fontSize: 16,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                    elevation: 0,
                                    borderSide: const BorderSide(
                                      color: Color(0x5957636C),
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
