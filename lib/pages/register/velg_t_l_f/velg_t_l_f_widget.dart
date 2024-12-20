import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mat_salg/pages/register/logginn/logginn_widget.dart';
import 'package:mat_salg/pages/register/velg_o_t_p/velg_o_t_p_widget.dart';
import 'package:mat_salg/logging.dart';
import 'package:mat_salg/services/check_taken_service.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';

import 'velg_t_l_f_model.dart';
export 'velg_t_l_f_model.dart';

class VelgTLFWidget extends StatefulWidget {
  const VelgTLFWidget({
    super.key,
    this.matinfo,
  });

  final dynamic matinfo;

  @override
  State<VelgTLFWidget> createState() => _VelgTLFWidgetState();
}

class _VelgTLFWidgetState extends State<VelgTLFWidget> {
  String? _errorMessage;
  bool _isloading = false;
  late VelgTLFModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  void errorToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 56.0,
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
                  Icon(
                    CupertinoIcons.xmark_circle_fill,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 35.0,
                  ),
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

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VelgTLFModel());

    _model.landskodeTextController ??= TextEditingController();
    _model.landskodeFocusNode ??= FocusNode();

    _model.telefonnummerTextController ??= TextEditingController();
    _model.telefonnummerFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {
          _model.landskodeTextController?.text = '+47';
        }));
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(-1, -1),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 20),
                            child: Text(
                              'Ny bruker',
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
                        const Icon(
                          Icons.arrow_back,
                          color: Color(0x00262C2D),
                          size: 24,
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
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(25, 15, 25, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 0),
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
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    filled: true,
                                    fillColor:
                                        FlutterFlowTheme.of(context).secondary,
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
                                    10, 0, 0, 0),
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
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    filled: true,
                                    fillColor:
                                        FlutterFlowTheme.of(context).secondary,
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
                                      _errorMessage = null;
                                    });
                                  },
                                ),
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
                                    if (_isloading) return;
                                    if (_model.formKey.currentState == null ||
                                        !_model.formKey.currentState!
                                            .validate()) {
                                      return;
                                    }
                                    setState(() {
                                      _isloading = true;
                                    });
                                    try {
                                      if (_model.telefonnummerTextController
                                          .text.isEmpty) {
                                        safeSetState(() {
                                          _isloading = false;
                                          _errorMessage = "felt må fylles ut";
                                        });
                                        return;
                                      }
                                      if (_model.telefonnummerTextController
                                                  .text.length !=
                                              8 ||
                                          (_model.telefonnummerTextController
                                                      .text
                                                      .startsWith('4') !=
                                                  true &&
                                              _model.telefonnummerTextController
                                                      .text
                                                      .startsWith('9') !=
                                                  true)) {
                                        safeSetState(() {
                                          _isloading = false;
                                          _errorMessage =
                                              "fant ikke telefonnummeret";
                                        });
                                        return;
                                      }

                                      final response = await CheckTakenService
                                          .checkPhoneTaken(_model
                                              .telefonnummerTextController
                                              .text);

                                      if (response.statusCode != 200) {
                                        safeSetState(() {
                                          _isloading = false;
                                        });
                                        HapticFeedback.mediumImpact();
                                        errorToast(context,
                                            'En bruker med dette nummeret finnes allerede');
                                        if (mounted) {
                                          Navigator.pop(context);
                                          showModalBottomSheet(
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            enableDrag: false,
                                            context: context,
                                            builder: (context) {
                                              return Padding(
                                                padding:
                                                    MediaQuery.viewInsetsOf(
                                                        context),
                                                child: LogginnWidget(),
                                              );
                                            },
                                          ).then((value) {
                                            safeSetState(() {});
                                          });
                                        }
                                        return;
                                      }

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
                                            logger
                                                .d("Error Code: ${error.code}");
                                            logger.d(
                                                "Error Message: ${error.message}");
                                            if (error.code ==
                                                'too-many-requests') {
                                              if (mounted) {}
                                              safeSetState(() {
                                                _isloading = false;
                                                _errorMessage =
                                                    "For mange forsøk";
                                              });
                                            } else {
                                              safeSetState(() {
                                                _isloading = false;
                                                HapticFeedback.mediumImpact();
                                                errorToast(context,
                                                    'En feil oppstod. Ta kontakt \nhvis problemet vedvarer');
                                              });
                                            }
                                          },
                                          codeSent: (verificationId,
                                              forceResendingToken) {
                                            logger.d("sent code");
                                            logger.d(
                                                "The code is: ${verificationId}");

                                            FFAppState().storeTimestamp();
                                            if (mounted) {
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                enableDrag: false,
                                                context: context,
                                                builder: (context) {
                                                  return Padding(
                                                    padding:
                                                        MediaQuery.viewInsetsOf(
                                                            context),
                                                    child: VelgOTPWidget(
                                                      phone: _model
                                                          .telefonnummerTextController
                                                          .text,
                                                      verificationId:
                                                          verificationId,
                                                    ),
                                                  );
                                                },
                                              ).then((value) {
                                                safeSetState(() {
                                                  _isloading = false;
                                                });
                                              });
                                            }
                                          },
                                          codeAutoRetrievalTimeout:
                                              (verificationId) {
                                            logger.d("Auto Retireval timeout");
                                          },
                                        );
                                      } else {
                                        safeSetState(() {
                                          _isloading = false;
                                          HapticFeedback.mediumImpact();
                                          errorToast(context,
                                              'Vent minst 2 minutter før \ndu ber om ny kode');
                                        });
                                      }
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
                                  text: 'Send',
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
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Nunito',
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
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
