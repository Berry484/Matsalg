import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/my_ip.dart';
import 'package:mat_salg/services/user_service.dart';
import 'package:mat_salg/services/web_socket.dart';
import 'package:mat_salg/logging.dart';
import '../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../helper_components/flutter_flow/flutter_flow_util.dart';
import '../../../helper_components/flutter_flow/flutter_flow_widgets.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'logginn_model.dart';
export 'logginn_model.dart';

class LogginnWidget extends StatefulWidget {
  const LogginnWidget({
    super.key,
    this.matinfo,
  });

  final dynamic matinfo;

  @override
  State<LogginnWidget> createState() => _LogginnWidgetState();
}

class _LogginnWidgetState extends State<LogginnWidget> {
  late LogginnModel _model;
  late WebSocketService _webSocketService;
  final UserInfoService userInfoService = UserInfoService();
  final _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  static const String baseUrl = ApiConstants.baseUrl;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LogginnModel());
    _webSocketService = WebSocketService();
    _model.telefonnummerTextController ??= TextEditingController();
    _model.telefonnummerFocusNode ??= FocusNode();

    _model.passordTextController ??= TextEditingController();
    _model.passordFocusNode ??= FocusNode();
    _model.landskodeTextController ??= TextEditingController();
    _model.landskodeFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {
          _model.landskodeTextController?.text = '+47';
        }));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  void feilInnlogging(BuildContext context, String message) {
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

  Future<http.Response?> sendToken() async {
    try {
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return null;
      } else {
        await _firebaseMessaging.requestPermission();
        final fCMToken = await _firebaseMessaging.getToken();
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo? androidInfo;
        IosDeviceInfo? iosInfo;

        // Fetch device information for Android or iOS
        if (Platform.isAndroid) {
          androidInfo = await deviceInfo.androidInfo;
        } else if (Platform.isIOS) {
          iosInfo = await deviceInfo.iosInfo;
        }
        // Handle the case where deviceInfo may be null
        if ((Platform.isAndroid && androidInfo == null) ||
            (Platform.isIOS && iosInfo == null)) {
          logger.d('Failed to fetch device information');
          return null;
        }
        final Map<String, dynamic> userData = {
          "token": fCMToken,
          "device": Platform.isAndroid
              ? androidInfo!.model
              : iosInfo!.utsname.machine,
        };
        // Convert the Map to JSON
        final String jsonBody = jsonEncode(userData);
        final uri = Uri.parse('$baseUrl/push');
        final headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Add Bearer token if present
        };

        final response = await http.post(
          uri,
          headers: headers,
          body: jsonBody,
        );
        return response; // Return the response
      }
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400,
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
                              'Logg inn',
                              textAlign: TextAlign.center,
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
                alignment: const AlignmentDirectional(0, -1),
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
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                          child: TextFormField(
                            controller: _model.passordTextController,
                            focusNode: _model.passordFocusNode,
                            textInputAction: TextInputAction.go,
                            obscureText: !_model.passordVisibility,
                            onFieldSubmitted: (_) async {
                              if (_model.isloading) {
                                return; // Prevent multiple presses while loading
                              }

                              // Validate the form
                              if (_model.formKey.currentState == null ||
                                  !_model.formKey.currentState!.validate()) {
                                return; // If the form is invalid, return early
                              }

                              _model.isloading = true;

                              try {
                                // Await the sign-in operation to ensure it's completed before proceeding
                                final response = await firebaseAuthService
                                    .signInWithEmailAndPassword(
                                  '${_model.telefonnummerTextController.text}@gmail.com',
                                  _model.passordTextController.text,
                                );

                                if (response == null) {
                                  _model.isloading = false;
                                  HapticFeedback.mediumImpact();
                                  if (!context.mounted) return;
                                  feilInnlogging(
                                      context, 'Feil innlogging eller passord');
                                  return;
                                }

                                final user = _firebaseAuth.currentUser;

                                if (user == null) {
                                  return;
                                }
                                final idToken = await user.getIdToken();
                                if (idToken != null) {
                                  final response =
                                      await UserInfoService.checkUserInfo(
                                          idToken);

                                  if (response.statusCode == 200) {
                                    final decodedResponse =
                                        jsonDecode(response.body);
                                    FFAppState().brukernavn =
                                        decodedResponse['brukernavn'] ?? '';
                                    FFAppState().firstname =
                                        decodedResponse['firstname'] ?? '';
                                    FFAppState().lastname =
                                        decodedResponse['lastname'] ?? '';
                                    FFAppState().bio =
                                        decodedResponse['bio'] ?? '';
                                    FFAppState().profilepic =
                                        decodedResponse['profile_picture'] ??
                                            '';
                                    try {
                                      _webSocketService.connect();
                                      setState(() {});
                                    } catch (e) {
                                      logger.d("errror $e");
                                    }
                                    _model.isloading = false;
                                    _webSocketService = WebSocketService();
                                    _webSocketService.connect(retrying: true);
                                    if (!context.mounted) return;
                                    userInfoService.getAll(context);
                                    sendToken();
                                    if (!context.mounted) return;
                                    context.go('/hjem');
                                    FFAppState().login = true;
                                    return;
                                  }

                                  _model.isloading = false;
                                  return;
                                } else {
                                  _model.isloading = false;
                                  if (!context.mounted) return;
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CupertinoAlertDialog(
                                        title: const Text(
                                            'Feil innlogging eller passord'),
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
                                  _model.isloading = false;
                                  _model.passordTextController!.clear();
                                  return;
                                }
                              } catch (e) {
                                _model.isloading = false;
                                if (!context.mounted) return;
                                showCupertinoDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CupertinoAlertDialog(
                                      title: const Text('Oopps. Noe gikk galt'),
                                      content: const Text(
                                          'Sjekk internettforbindelsen din og prøv igjen.\nHvis problemet vedvarer, vennligst kontakt oss for hjelp.'),
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
                            decoration: InputDecoration(
                              labelText: 'Passord',
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
                                  color: FlutterFlowTheme.of(context).secondary,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              filled: true,
                              fillColor: FlutterFlowTheme.of(context).secondary,
                              suffixIcon: InkWell(
                                onTap: () => safeSetState(
                                  () => _model.passordVisibility =
                                      !_model.passordVisibility,
                                ),
                                focusNode: FocusNode(skipTraversal: true),
                                child: Icon(
                                  _model.passordVisibility
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: const Color(0xFF757575),
                                  size: 22,
                                ),
                              ),
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Nunito',
                                  letterSpacing: 0.0,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                            validator: _model.passordTextControllerValidator
                                .asValidator(context),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0, 25, 0, 20),
                          child: FFButtonWidget(
                            onPressed: () async {
                              if (_model.isloading) {
                                return; // Prevent multiple presses while loading
                              }

                              // Validate the form
                              if (_model.formKey.currentState == null ||
                                  !_model.formKey.currentState!.validate()) {
                                return; // If the form is invalid, return early
                              }

                              _model.isloading = true;

                              try {
                                final response = await firebaseAuthService
                                    .signInWithEmailAndPassword(
                                  '${_model.telefonnummerTextController.text}@gmail.com',
                                  _model.passordTextController.text,
                                );

                                if (response == null) {
                                  _model.isloading = false;
                                  HapticFeedback.mediumImpact();
                                  if (!context.mounted) return;
                                  feilInnlogging(
                                      context, 'Feil innlogging eller passord');
                                  return;
                                }

                                // After sign-in, check the current user
                                final user = _firebaseAuth.currentUser;

                                if (user == null) {
                                  return;
                                }
                                final idToken = await user.getIdToken();
                                if (idToken != null) {
                                  final response =
                                      await UserInfoService.checkUserInfo(
                                          idToken);

                                  if (response.statusCode == 200) {
                                    final decodedResponse =
                                        jsonDecode(response.body);
                                    FFAppState().brukernavn =
                                        decodedResponse['brukernavn'] ?? '';
                                    FFAppState().firstname =
                                        decodedResponse['firstname'] ?? '';
                                    FFAppState().lastname =
                                        decodedResponse['lastname'] ?? '';
                                    FFAppState().bio =
                                        decodedResponse['bio'] ?? '';
                                    FFAppState().profilepic =
                                        decodedResponse['profile_picture'] ??
                                            '';
                                    try {
                                      _webSocketService.connect();
                                      setState(() {});
                                    } catch (e) {
                                      logger.d("errror $e");
                                    }
                                    _model.isloading = false;
                                    _webSocketService = WebSocketService();
                                    _webSocketService.connect(retrying: true);
                                    if (!context.mounted) return;
                                    userInfoService.getAll(context);
                                    sendToken();
                                    if (!context.mounted) return;
                                    context.go('/hjem');
                                    FFAppState().login = true;
                                    return;
                                  }

                                  _model.isloading = false;
                                  return;
                                } else {
                                  _model.isloading = false;
                                  if (!context.mounted) return;
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CupertinoAlertDialog(
                                        title: const Text(
                                            'Feil innlogging eller passord'),
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
                                  _model.isloading = false;
                                  _model.passordTextController!.clear();
                                  return;
                                }
                              } catch (e) {
                                _model.isloading = false;
                                if (!context.mounted) return;
                                showCupertinoDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CupertinoAlertDialog(
                                      title: const Text('Oopps. Noe gikk galt'),
                                      content: const Text(
                                          'Sjekk internettforbindelsen din og prøv igjen.\nHvis problemet vedvarer, vennligst kontakt oss for hjelp.'),
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
                            text: _model.isloading
                                ? '' // Change button text to "Loading..." when loading
                                : 'Logg inn', // Normal text when not loading
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 50,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 0, 16, 0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 0),
                              color: FlutterFlowTheme.of(context).alternate,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Nunito',
                                    color: FlutterFlowTheme.of(context).primary,
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
                                    color: FlutterFlowTheme.of(context).primary,
                                  )
                                : null, // If not loading, no icon is shown
                          ),
                        ),
                        Text(
                          'Har du glemt passordet?',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Nunito',
                                    color: Colors.black,
                                    fontSize: 16,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
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
