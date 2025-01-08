import 'package:easy_debounce/easy_debounce.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_theme.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/logging.dart';
import 'package:mat_salg/services/check_taken_service.dart';
import 'forgot_password_model.dart';
export 'forgot_password_model.dart';

class ForgotPasswordWidget extends StatefulWidget {
  const ForgotPasswordWidget({super.key});

  @override
  State<ForgotPasswordWidget> createState() => _ReAuthenticateWidgetState();
}

class _ReAuthenticateWidgetState extends State<ForgotPasswordWidget> {
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  late ForgotPasswordModel _model;
  bool isLoading = false;
  bool hasPressed = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ForgotPasswordModel());
    _model.telefonnummerTextController ??= TextEditingController();
    _model.telefonnummerFocusNode ??= FocusNode();

    _model.landskodeTextController ??= TextEditingController();
    _model.landskodeFocusNode ??= FocusNode();

    _model.otpCodeTextController ??= TextEditingController();
    _model.otpCodeFocusNode ??= FocusNode();

    _model.passwordChangeController ??= TextEditingController();
    _model.passwordChangeNode ??= FocusNode();

    _model.passwordChangeConfirmController ??= TextEditingController();
    _model.passwordChangeConfirmNode ??= FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {
          _model.landskodeTextController?.text = '+47';
        }));
  }

  bool isPasswordGood() {
    if (_model.passwordChangeController.text.length >= 7 &&
        _model.passwordChangeConfirmController.text.length >= 7 &&
        (_model.passwordChangeController.text ==
            _model.passwordChangeConfirmController.text)) {
      return true;
    }
    return false;
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
              child: Align(
                alignment: const AlignmentDirectional(0, -1),
                child: Form(
                  key: _model.formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(25, 0, 25, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Divider(
                              height: 22,
                              thickness: 4,
                              indent: MediaQuery.of(context).size.width * 0.4,
                              endIndent:
                                  MediaQuery.of(context).size.width * 0.4,
                              color: Colors.black12,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
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
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      13, 0, 0, 0),
                                  child: Text(
                                    'Glemt passord',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Nunito',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 17,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
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
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Nunito',
                                            color: FlutterFlowTheme.of(context)
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
                          padding: EdgeInsetsDirectional.fromSTEB(16, 30, 0, 0),
                          child: Text(
                            _model.changPassword
                                ? 'Endre passord'
                                : (_model.otpCodeSent
                                    ? 'Fyll inn kode fra sms'
                                    : 'Glemt passord'),
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
                            _model.changPassword
                                ? 'Fyll inn det nye passordet ditt. Minst 7 tegn'
                                : (_model.otpCodeSent
                                    ? 'Fyll inn den 6-sifrede koden vi sendte deg via SMS.'
                                    : 'Fyll inn telefonnummeret ditt, så sender vi deg en bekreftelseskode for å tilbakestille passordet.'),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Nunito',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 15.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                        if (!_model.otpCodeSent &&
                            _model.changPassword == false)
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 23, 0, 0),
                                child: Container(
                                  width: 60,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: TextFormField(
                                    controller: _model.landskodeTextController,
                                    focusNode: _model.landskodeFocusNode,
                                    readOnly: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            fontFamily: 'Nunito',
                                            fontSize: 16,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
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
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
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
                                          fontSize: 17,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                    textAlign: TextAlign.center,
                                    validator: _model
                                        .landskodeTextControllerValidator
                                        .asValidator(context),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      10, 23, 0, 0),
                                  child: TextFormField(
                                    controller:
                                        _model.telefonnummerTextController,
                                    focusNode: _model.telefonnummerFocusNode,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'Telefonnummer',
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
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      filled: true,
                                      fillColor: FlutterFlowTheme.of(context)
                                          .secondary,
                                      errorText: _model.errorMessage,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Nunito',
                                          letterSpacing: 0.0,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    textAlign: TextAlign.start,
                                    maxLength: 8,
                                    buildCounter: (context,
                                            {required currentLength,
                                            required isFocused,
                                            maxLength}) =>
                                        null,
                                    keyboardType: TextInputType.phone,
                                    validator: _model
                                        .telefonnummerTextControllerValidator
                                        .asValidator(context),
                                    onChanged: (phone) {
                                      setState(() {
                                        _model.errorMessage = null;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (_model.otpCodeSent && _model.changPassword == false)
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 23, 0, 0),
                                  child: TextFormField(
                                      controller: _model.otpCodeTextController,
                                      focusNode: _model.otpCodeFocusNode,
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .secondary,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        filled: true,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .secondary,
                                        errorText: _model.errorMessage,
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
                                          .otpCodeTextControllerValidator
                                          .asValidator(context),
                                      onChanged: (number) {
                                        setState(() {
                                          _model.errorMessage = null;
                                        });
                                      }),
                                ),
                              ),
                            ],
                          ),
                        if (!_model.otpCodeSent &&
                            _model.changPassword == false)
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 25, 0, 20),
                            child: FFButtonWidget(
                              onPressed: () async {
                                if (_model.isloading) return;
                                if (_model.formKey.currentState == null ||
                                    !_model.formKey.currentState!.validate()) {
                                  return;
                                }
                                setState(() {
                                  _model.isloading = true;
                                });
                                try {
                                  if (_model.telefonnummerTextController.text
                                      .isEmpty) {
                                    safeSetState(() {
                                      _model.isloading = false;
                                      _model.errorMessage = "felt må fylles ut";
                                    });
                                    return;
                                  }
                                  if (_model.telefonnummerTextController.text
                                              .length !=
                                          8 ||
                                      (_model.telefonnummerTextController.text
                                                  .startsWith('4') !=
                                              true &&
                                          _model.telefonnummerTextController
                                                  .text
                                                  .startsWith('9') !=
                                              true)) {
                                    safeSetState(() {
                                      _model.isloading = false;
                                      _model.errorMessage =
                                          "fant ikke telefonnummeret";
                                    });
                                    return;
                                  }
                                  final response =
                                      await CheckTakenService.checkPhoneTaken(
                                          _model.telefonnummerTextController
                                              .text);

                                  if (response.statusCode == 200) {
                                    safeSetState(() {
                                      _model.isloading = false;
                                    });
                                    HapticFeedback.selectionClick();
                                    if (!context.mounted) return;
                                    Toasts.showErrorToast(context,
                                        'Det finnes ingen brukere med dette telefonnummeret');
                                    if (mounted) {
                                      Navigator.pop(context);
                                      return;
                                    }
                                  } else {
                                    bool canRequest =
                                        await FFAppState().canRequestCode();
                                    if (canRequest) {
                                      await FirebaseAuth.instance
                                          .verifyPhoneNumber(
                                        phoneNumber:
                                            '+47${_model.telefonnummerTextController.text}',
                                        verificationCompleted:
                                            (phoneAuthCredential) {},
                                        verificationFailed: (error) {
                                          logger.d(error.toString());
                                          logger.d(
                                              "Verification Failed: ${error.toString()}");
                                          logger.d("Error Code: ${error.code}");
                                          logger.d(
                                              "Error Message: ${error.message}");
                                          if (error.code ==
                                              'too-many-requests') {
                                            if (mounted) {}
                                            safeSetState(() {
                                              _model.isloading = false;
                                              _model.errorMessage =
                                                  "For mange forsøk";
                                            });
                                          } else {
                                            safeSetState(() {
                                              _model.isloading = false;
                                              HapticFeedback.selectionClick();
                                              Toasts.showErrorToast(context,
                                                  'En feil oppstod. Ta kontakt \nhvis problemet vedvarer');
                                            });
                                          }
                                        },
                                        codeSent: (verificationId,
                                            forceResendingToken) {
                                          logger.d("sent code");
                                          logger.d(
                                              "The code is: $verificationId");
                                          _model.verificationId =
                                              verificationId;
                                          safeSetState(() {
                                            _model.isloading = false;
                                            _model.otpCodeSent = true;
                                          });
                                          FFAppState().storeTimestamp();
                                        },
                                        codeAutoRetrievalTimeout:
                                            (verificationId) {
                                          logger.d("Auto Retireval timeout");
                                        },
                                      );
                                    } else {
                                      safeSetState(() {
                                        _model.isloading = false;
                                        HapticFeedback.selectionClick();
                                        Toasts.showErrorToast(context,
                                            'Vent minst 2 minutter før \ndu ber om ny kode');
                                      });
                                    }
                                  }
                                } catch (e) {
                                  safeSetState(() {
                                    _model.isloading = false;
                                  });
                                  if (!context.mounted) return;
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CupertinoAlertDialog(
                                        title: const Text('En feil oppstod'),
                                        content: const Text(
                                            'Prøv på nytt senere eller ta kontakt hvis problemet vedvarer'),
                                        actions: <Widget>[
                                          CupertinoDialogAction(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Ok',
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              text: _model.isloading ? '' : 'Send',
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 50,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 0, 16, 0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                color: FlutterFlowTheme.of(context).alternate,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Nunito',
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      fontSize: 17,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                elevation: 0,
                                borderSide: const BorderSide(
                                  color: Color(0x5957636C),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              icon: _model.isloading
                                  ? CircularProgressIndicator(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                    )
                                  : null,
                            ),
                          ),
                        if (_model.otpCodeSent && _model.changPassword == false)
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 25, 0, 20),
                            child: FFButtonWidget(
                              onPressed: () async {
                                if (_model.isloading) {
                                  return;
                                }
                                if (_model.formKey.currentState == null ||
                                    !_model.formKey.currentState!.validate()) {
                                  return;
                                }
                                if (_model.otpCodeTextController.text.isEmpty) {
                                  setState(() {
                                    _model.isloading = false;
                                    _model.errorMessage = "felt må fylles ut";
                                  });
                                  return;
                                }
                                if (_model.otpCodeTextController.text.length !=
                                    6) {
                                  safeSetState(() {
                                    _model.isloading = false;
                                    _model.errorMessage = "feil kode";
                                  });
                                  return;
                                }
                                try {
                                  safeSetState(() {
                                    _model.isloading = true;
                                  });
                                  try {
                                    final cred = PhoneAuthProvider.credential(
                                        verificationId:
                                            _model.verificationId ?? '',
                                        smsCode:
                                            _model.otpCodeTextController.text);
                                    await FirebaseAuth.instance
                                        .signInWithCredential(cred);
                                  } catch (e) {
                                    logger.d(e.toString());
                                    safeSetState(() {
                                      _model.isloading = false;

                                      _model.errorMessage = "feil kode";
                                    });
                                    return;
                                  }

                                  safeSetState(() {
                                    _model.isloading = false;
                                    _model.changPassword = true;
                                  });
                                } catch (e) {
                                  safeSetState(() {
                                    _model.isloading = false;
                                  });
                                  if (!context.mounted) return;
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CupertinoAlertDialog(
                                        title: const Text('En feil oppstod'),
                                        content: const Text(
                                            'Prøv på nytt senere eller ta kontakt hvis problemet vedvarer'),
                                        actions: <Widget>[
                                          CupertinoDialogAction(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Ok',
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              text: _model.isloading ? '' : 'Bekreft',
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 50,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 0, 16, 0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                color: FlutterFlowTheme.of(context).alternate,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Nunito',
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      fontSize: 17,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                elevation: 0,
                                borderSide: const BorderSide(
                                  color: Color(0x5957636C),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              icon: _model.isloading
                                  ? CircularProgressIndicator(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                    )
                                  : null,
                            ),
                          ),
                        if (_model.changPassword)
                          Form(
                            key: _model.formKey2,
                            autovalidateMode: AutovalidateMode.disabled,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 20, 0, 16),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 16, 0, 0),
                                          child: TextFormField(
                                            controller:
                                                _model.passwordChangeController,
                                            focusNode:
                                                _model.passwordChangeNode,
                                            textInputAction:
                                                TextInputAction.done,
                                            enableSuggestions: false,
                                            autocorrect: false,
                                            autovalidateMode: hasPressed
                                                ? AutovalidateMode
                                                    .onUserInteraction
                                                : AutovalidateMode.disabled,
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
                                              labelText: 'Nytt passord',
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
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondary,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
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
                                                  () => _model
                                                          .passordVisibility =
                                                      !_model.passordVisibility,
                                                ),
                                                focusNode: FocusNode(
                                                    skipTraversal: true),
                                                child: Icon(
                                                  _model.passordVisibility
                                                      ? Icons
                                                          .visibility_outlined
                                                      : Icons
                                                          .visibility_off_outlined,
                                                  color:
                                                      const Color(0xFF757575),
                                                  size: 22,
                                                ),
                                              ),
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Nunito',
                                                  color: FlutterFlowTheme.of(
                                                          context)
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
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 16, 0, 0),
                                          child: TextFormField(
                                            controller: _model
                                                .passwordChangeConfirmController,
                                            focusNode: _model
                                                .passwordChangeConfirmNode,
                                            textInputAction:
                                                TextInputAction.done,
                                            enableSuggestions: false,
                                            autocorrect: false,
                                            autofillHints: null,
                                            autovalidateMode: hasPressed
                                                ? AutovalidateMode
                                                    .onUserInteraction
                                                : AutovalidateMode.disabled,
                                            keyboardType: TextInputType.text,
                                            obscureText: !_model
                                                .passordConfirmVisibility,
                                            onChanged: (_) =>
                                                EasyDebounce.debounce(
                                              '_model.textController',
                                              const Duration(milliseconds: 0),
                                              () => safeSetState(() {}),
                                            ),
                                            decoration: InputDecoration(
                                              labelText: 'Bekreft passord',
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
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondary,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
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
                                                  () => _model
                                                          .passordConfirmVisibility =
                                                      !_model
                                                          .passordConfirmVisibility,
                                                ),
                                                focusNode: FocusNode(
                                                    skipTraversal: true),
                                                child: Icon(
                                                  _model.passordConfirmVisibility
                                                      ? Icons
                                                          .visibility_outlined
                                                      : Icons
                                                          .visibility_off_outlined,
                                                  color:
                                                      const Color(0xFF757575),
                                                  size: 22,
                                                ),
                                              ),
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Nunito',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  fontSize: 15,
                                                  letterSpacing: 0.0,
                                                ),
                                            textAlign: TextAlign.start,
                                            validator: _model
                                                .passwordChangeControllerConfirmValidator
                                                .asValidator(context),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: const AlignmentDirectional(0, 0),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 20, 0, 0),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          if (!isPasswordGood()) return;
                                          hasPressed = true;
                                          if (_model.formKey2.currentState ==
                                                  null ||
                                              !_model.formKey2.currentState!
                                                  .validate()) {
                                            return;
                                          }
                                          _model.newPassword = _model
                                              .passwordChangeController.text;
                                          if (_model.newPassword != null) {
                                            bool success =
                                                await firebaseAuthService
                                                    .updatePassword(
                                                        _model.newPassword ??
                                                            '');
                                            if (success) {
                                              if (!context.mounted) return;
                                              Toasts.showAccepted(
                                                  context, 'Passord endret');
                                              try {
                                                context.goNamed('Explore');
                                              } catch (e) {
                                                Navigator.of(context).pop();
                                              }
                                            } else {
                                              logger.d(
                                                  "Did not work to change password");
                                              if (!context.mounted) return;
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              Toasts.showErrorToast(context,
                                                  'En uforventet feil oppstod');
                                            }
                                          }
                                        },
                                        text: 'Oppdater',
                                        options: FFButtonOptions(
                                          width: double.infinity,
                                          height: 50.0,
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          iconPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          color: isPasswordGood()
                                              ? FlutterFlowTheme.of(context)
                                                  .alternate
                                              : FlutterFlowTheme.of(context)
                                                  .unSelected,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleMedium
                                              .override(
                                                fontFamily: 'Nunito',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                fontSize: 15.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w800,
                                              ),
                                          elevation: 0.0,
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(14.0),
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
            ),
          ],
        ),
      ),
    );
  }
}
