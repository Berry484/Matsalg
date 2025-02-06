import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/services/user_service.dart';
import 'package:mat_salg/services/web_socket.dart';
import 'package:mat_salg/pages/register/choose_create_or_login/velg_ny_widget.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/logging.dart';
import '../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../helper_components/flutter_flow/flutter_flow_util.dart';
import '../../../helper_components/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'register_model.dart';
export 'register_model.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  @override
  State<RegisterWidget> createState() => _RegistrerWidgetState();
}

class _RegistrerWidgetState extends State<RegisterWidget>
    with TickerProviderStateMixin {
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final UserInfoService userInfoService = UserInfoService();
  late RegisterModel _model;
  late WebSocketService _webSocketService;

  bool _isloading = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RegisterModel());
    FirebaseAuth.instance.signOut();
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
              Center(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 110, 0, 23),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/MatSalgLogo.png',
                      width: 107,
                      height: 107,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Text(
                'Rett fra kilden.',
                textAlign: TextAlign.start,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Nunito',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 22.2,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
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
                                      _isloading = false;
                                      if (!context.mounted) return;
                                      FFAppState().login = true;
                                      context.go('/home');
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
                                  Toasts.showErrorToast(
                                      context, 'Ingen internettforbindelse');
                                } catch (e) {
                                  HapticFeedback.lightImpact();
                                  _isloading = false;
                                  if (!context.mounted) return;
                                  Toasts.showErrorToast(
                                      context, 'Verifisering mislyktes');
                                }
                              },
                              text: 'Fortsett med Apple',
                              icon: const FaIcon(
                                FontAwesomeIcons.apple,
                                size: 19,
                              ),
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 48,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 0, 16, 0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                color: Colors.black,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Nunito',
                                      fontSize: 16,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                elevation: 0,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20, 0, 20, 12),
                          child: Material(
                            color: Colors
                                .transparent, // Makes the Material widget background transparent
                            borderRadius: BorderRadius.circular(
                                15), // Sets the border radius for splash
                            child: InkWell(
                              onTap: () async {
                                try {
                                  if (_isloading) return;
                                  setState(() {
                                    _isloading = true;
                                  });

                                  await firebaseAuthService.loginWithGoogle();
                                  if (!context.mounted) return;

                                  String? token = await firebaseAuthService
                                      .getToken(context);

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
                                      _webSocketService = WebSocketService();
                                      _webSocketService.connect(retrying: true);

                                      setState(() {
                                        _isloading = false;
                                      });

                                      if (!context.mounted) return;
                                      FFAppState().login = true;
                                      context.go('/home');
                                      return;
                                    }
                                    if (response.statusCode == 404) {
                                      setState(() {
                                        _isloading = false;
                                      });

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
                                    setState(() {
                                      _isloading = false;
                                    });
                                    throw Exception();
                                  }
                                } on SocketException {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    _isloading = false;
                                  });
                                  if (!context.mounted) return;
                                  Toasts.showErrorToast(
                                      context, 'Ingen internettforbindelse');
                                } catch (e) {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    _isloading = false;
                                  });
                                  if (!context.mounted) return;
                                  Toasts.showErrorToast(
                                      context, 'Verifisering mislyktes');
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0x5957636C),
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (!_isloading) ...[
                                      Image.asset(
                                        "assets/images/g-logo.png",
                                        height: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "Fortsett med Google",
                                        style: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily: 'Nunito',
                                              color: Colors.black,
                                              fontSize: 16,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ] else ...[
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.black,
                                          strokeWidth: 2.0,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
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
                            text: 'Fortsett med telefon',
                            icon: const FaIcon(
                              FontAwesomeIcons.phone,
                              size: 19,
                            ),
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 48,
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
                                    fontSize: 16,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                              elevation: 0,
                              borderSide: const BorderSide(
                                color: Color(0x5957636C),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(15),
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
