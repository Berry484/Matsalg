import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_theme.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_widgets.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/services/user_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'request_terms_model.dart';
export 'request_terms_model.dart';

class RequestTermsWidget extends StatefulWidget {
  const RequestTermsWidget({
    super.key,
  });

  @override
  State<RequestTermsWidget> createState() => _RequestLocationWidgetState();
}

class _RequestLocationWidgetState extends State<RequestTermsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final UserInfoService userInfoService = UserInfoService();
  late RequestTermsModel _model;

  bool _isloading = false;
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RequestTermsModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
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
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0.0,
            actions: [],
            centerTitle: true,
            elevation: 0.0,
          ),
          body: SafeArea(
            top: true,
            bottom: false,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  15, 0, 35, 50),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Velkommen til MatSalg.no',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Nunito',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 24,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 70,
                                    child: Text(
                                      'MatSalg.no oppfyller gjeldende forskrifter for lagring of bruk av personopplysninger og legger stor innsats i å sikre dine data.\n\nVed å bruke MatSalg.no godtar du våre brukervilkår og personvernerklæring som du kan lese gjennom før du fortsetter.',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Nunito',
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 210,
                              child: ListView(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 0, 12, 0),
                                scrollDirection: Axis.horizontal,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: SizedBox(
                                      width: 170,
                                      height: 205,
                                      child: Image.asset(
                                        'assets/images/MatSalg_transp_2.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: SizedBox(
                                      width: 170,
                                      height: 205,
                                      child: Image.asset(
                                        'assets/images/MatSalg_transp_3.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: SizedBox(
                                      width: 170,
                                      height: 205,
                                      child: Image.asset(
                                        'assets/images/MatSalg_transp_4.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 35,
                        width: 150,
                        child: TextButton(
                          onPressed: () async {
                            var url =
                                Uri.https('matsalg.no', '/terms-of-service');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            }
                          },
                          child: Text(
                            'Brukervilkår',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Nunito',
                                  color: FlutterFlowTheme.of(context).alternate,
                                  fontSize: 15,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 36,
                        width: 150,
                        child: TextButton(
                          onPressed: () async {
                            var url =
                                Uri.https('matsalg.no', '/privacy-policy');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            }
                          },
                          child: Text(
                            'Personvernregler',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Nunito',
                                  color: FlutterFlowTheme.of(context).alternate,
                                  fontSize: 15,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20, 0, 20, 40),
                          child: FFButtonWidget(
                            onPressed: () async {
                              try {
                                if (_isloading) {
                                  return;
                                }
                                _isloading = true;
                                String? token =
                                    await firebaseAuthService.getToken(context);
                                if (token == null) {
                                  if (!context.mounted) return;
                                  FFAppState().login = false;
                                  context.goNamed('registrer');
                                  return;
                                } else {
                                  final response =
                                      await userInfoService.updateUserInfo(
                                    token: token,
                                    username: null,
                                    firstname: null,
                                    lastname: null,
                                    email: null,
                                    bio: null,
                                    profilepic: null,
                                    termsService: true,
                                  );
                                  if (response.statusCode == 200) {
                                    final decodedBody =
                                        utf8.decode(response.bodyBytes);
                                    final decodedResponse =
                                        jsonDecode(decodedBody);
                                    FFAppState().brukernavn =
                                        decodedResponse['username'] ?? '';
                                    FFAppState().email =
                                        decodedResponse['email'] ?? '';
                                    FFAppState().firstname =
                                        decodedResponse['firstname'] ?? '';
                                    FFAppState().lastname =
                                        decodedResponse['lastname'] ?? '';
                                    FFAppState().bio =
                                        decodedResponse['bio'] ?? '';
                                    FFAppState().profilepic =
                                        decodedResponse['profilepic'] ?? '';

                                    _isloading = false;
                                    setState(() {});
                                    if (!context.mounted) return;
                                    if (FFAppState().brukerLat == 59.9138688 &&
                                        FFAppState().brukerLng == 10.7522454) {
                                      context.goNamed('RequestLocation');
                                    } else {
                                      context.goNamed('Home');
                                    }
                                    return;
                                  } else if (response.statusCode == 401) {
                                    _isloading = false;
                                    FFAppState().login = false;
                                    if (!context.mounted) return;
                                    Toasts.showErrorToast(
                                        context, 'En feil oppstod');
                                    context.goNamed('registrer');
                                    return;
                                  }
                                }
                                _isloading = false;
                              } on SocketException {
                                _isloading = false;
                                if (!context.mounted) return;
                                if (!mounted) return;
                                Toasts.showErrorToast(
                                    context, 'Ingen internettforbindelse');
                              } catch (e) {
                                _isloading = false;
                                if (!context.mounted) return;
                                if (!mounted) return;
                                Toasts.showErrorToast(
                                    context, 'En feil oppstod');
                              }
                            },
                            text: 'Godkjenn',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 50.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).alternate,
                              textStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Nunito',
                                    color: Colors.white,
                                    fontSize: 16,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w700,
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
                ]),
          ),
        ),
      ),
    );
  }
}
