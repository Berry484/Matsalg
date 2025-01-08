import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mat_salg/services/user_service.dart';
import 'package:mat_salg/services/web_socket.dart';
import 'package:mat_salg/pages/register/choose_create_or_login/velg_ny_widget.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/logging.dart';
import 'package:mat_salg/my_ip.dart';

import '../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../helper_components/flutter_flow/flutter_flow_util.dart';
import '../../../helper_components/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'register_model.dart';
import 'package:http/http.dart' as http;
export 'register_model.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  @override
  State<RegisterWidget> createState() => _RegistrerWidgetState();
}

class _RegistrerWidgetState extends State<RegisterWidget>
    with TickerProviderStateMixin {
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final _firebaseMessaging = FirebaseMessaging.instance;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final UserInfoService userInfoService = UserInfoService();
  late RegisterModel _model;
  late WebSocketService _webSocketService;
  static const String baseUrl = ApiConstants.baseUrl;

  bool _isloading = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RegisterModel());
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
  void dispose() {
    _model.dispose();

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
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primary,
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 100, 0, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/MatSalgLogo.png',
                        width: double.infinity,
                        height: 366,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: const AlignmentDirectional(0, 1),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 50),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20, 0, 20, 12),
                          child: FFButtonWidget(
                            onPressed: () async {
                              await showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                useSafeArea: true,
                                context: context,
                                builder: (context) {
                                  return GestureDetector(
                                    onTap: () =>
                                        FocusScope.of(context).unfocus(),
                                    child: Padding(
                                      padding: MediaQuery.viewInsetsOf(context),
                                      child: const VelgNyWidget(),
                                    ),
                                  );
                                },
                              ).then((value) => safeSetState(() {}));
                            },
                            text: 'Fortsett med telefonnummer',
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
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                        if (Platform.isIOS)
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 0, 20, 12),
                            child: FFButtonWidget(
                              onPressed: () async {
                                try {
                                  if (_isloading) return;
                                  _isloading = true;
                                  await firebaseAuthService.signInWithApple();
                                  if (!context.mounted) return;
                                  String? token = await firebaseAuthService
                                      .getToken(context);
                                  logger.d(token);

                                  if (token != null) {
                                    final response =
                                        await UserInfoService.checkUserInfo(
                                            token);

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
                                      _isloading = false;
                                      _webSocketService = WebSocketService();
                                      _webSocketService.connect(retrying: true);
                                      if (!context.mounted) return;
                                      userInfoService.getAll(context);
                                      sendToken();
                                      _isloading = false;
                                      if (!context.mounted) return;
                                      context.go('/explore');
                                      FFAppState().login = true;
                                      return;
                                    }
                                    if (response.statusCode == 404) {
                                      _isloading = false;
                                      if (!context.mounted) return;
                                      context.goNamed(
                                        'opprettProfil',
                                        queryParameters: {
                                          'phone': serializeParam(
                                            '0',
                                            ParamType.String,
                                          ),
                                        }.withoutNulls,
                                      );
                                    }
                                  } else {
                                    _isloading = false;
                                    throw (Exception);
                                  }
                                } on SocketException {
                                  HapticFeedback.lightImpact();
                                  _isloading = false;
                                  if (!context.mounted) return;
                                  feilInnlogging(
                                      context, 'Ingen internettforbindelse');
                                } catch (e) {
                                  HapticFeedback.lightImpact();
                                  _isloading = false;
                                  if (!context.mounted) return;
                                  feilInnlogging(
                                      context, 'Verifisering mislyktes');
                                }
                              },
                              text: 'Fortsett med apple',
                              icon: const FaIcon(
                                FontAwesomeIcons.apple,
                                size: 19,
                              ),
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 50,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 0, 16, 0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                color: Colors.white,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Nunito',
                                      fontSize: 17,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
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
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20, 0, 20, 12),
                          child: FFButtonWidget(
                            onPressed: () async {
                              try {
                                if (_isloading) return;
                                _isloading = true;
                                await firebaseAuthService.loginWithGoogle();
                                if (!context.mounted) return;
                                String? token =
                                    await firebaseAuthService.getToken(context);

                                if (token != null) {
                                  final response =
                                      await UserInfoService.checkUserInfo(
                                          token);

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
                                    _isloading = false;
                                    _webSocketService = WebSocketService();
                                    _webSocketService.connect(retrying: true);
                                    if (!context.mounted) return;
                                    userInfoService.getAll(context);
                                    sendToken();
                                    _isloading = false;
                                    if (!context.mounted) return;
                                    context.go('/explore');
                                    FFAppState().login = true;
                                    return;
                                  }
                                  if (response.statusCode == 404) {
                                    _isloading = false;
                                    if (!context.mounted) return;
                                    context.goNamed(
                                      'opprettProfil',
                                      queryParameters: {
                                        'phone': serializeParam(
                                          '0',
                                          ParamType.String,
                                        ),
                                      }.withoutNulls,
                                    );
                                  }
                                } else {
                                  _isloading = false;
                                  throw (Exception);
                                }
                              } on SocketException {
                                HapticFeedback.lightImpact();
                                _isloading = false;
                                if (!context.mounted) return;
                                feilInnlogging(
                                    context, 'Ingen internettforbindelse');
                              } catch (e) {
                                HapticFeedback.lightImpact();
                                _isloading = false;
                                if (!context.mounted) return;
                                feilInnlogging(
                                    context, 'Verifisering mislyktes');
                              }
                            },
                            text: 'Fortsett med google',
                            icon: const FaIcon(
                              FontAwesomeIcons.google,
                              size: 19,
                            ),
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 50,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 0, 16, 0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 0),
                              color: FlutterFlowTheme.of(context).primary,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Nunito',
                                    color: Colors.black,
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
            ],
          ),
        ),
      ),
    );
  }
}
