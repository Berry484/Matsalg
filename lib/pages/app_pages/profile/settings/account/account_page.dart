import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/helper_components/widgets/loading_indicator.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/logging.dart';
import 'package:mat_salg/pages/app_pages/profile/settings/account/re_authenticate/re_authenticate_widget.dart';
import 'package:mat_salg/services/user_service.dart';
import 'package:mat_salg/services/web_socket.dart';

import '../../../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'account_model.dart';
export 'account_model.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _SettingsKontoWidgetState();
}

class _SettingsKontoWidgetState extends State<AccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final UserInfoService userInfoService = UserInfoService();
  late WebSocketService webSocketService;
  late AccountModel _model;
  bool loading = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    webSocketService = WebSocketService();
    _model = createModel(context, () => AccountModel());
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
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).alternate),
            automaticallyImplyLeading: true,
            scrolledUnderElevation: 0,
            leading: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                context.safePop();
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 28,
              ),
            ),
            title: Text(
              'Konto',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Nunito',
                    fontSize: 21,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            actions: [],
            centerTitle: true,
            elevation: 0,
          ),
          body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: const AlignmentDirectional(-1, 0),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 30, 0, 0),
                      child: Text(
                        'Min profil',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Nunito',
                              fontSize: 14,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 8, 0, 8),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed('ProfilRediger');
                              },
                              child: Material(
                                color: Colors.transparent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary,
                                    borderRadius: BorderRadius.circular(14),
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: Colors.transparent,
                                      width: 0,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed(
                                            'ProfilRediger',
                                            queryParameters: {
                                              'konto': serializeParam(
                                                'Profilbilde',
                                                ParamType.String,
                                              ),
                                            },
                                          );
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Icon(
                                              Icons.account_circle_outlined,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              size: 28,
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          12, 0, 0, 0),
                                                  child: Text(
                                                    'Profilbilde',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelLarge
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 16,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Expanded(
                                              child: Align(
                                                alignment: AlignmentDirectional(
                                                    0.9, 0),
                                                child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Color(0xA0262C2D),
                                                  size: 22,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Divider(
                            thickness: 1.2,
                            indent: 0,
                            endIndent: 0,
                            color: Color(0xE5EAEAEA),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 8, 0, 8),
                            child: Material(
                              color: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primary,
                                  borderRadius: BorderRadius.circular(14),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: Colors.transparent,
                                    width: 0,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        context.pushNamed(
                                          'ProfilRediger',
                                          queryParameters: {
                                            'konto': serializeParam(
                                              'Brukernavn',
                                              ParamType.String,
                                            ),
                                          },
                                        );
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            CupertinoIcons.at,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            size: 27,
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(12, 0, 0, 0),
                                                child: Text(
                                                  'Brukernavn',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .labelLarge
                                                      .override(
                                                        fontFamily: 'Nunito',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontSize: 16,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Expanded(
                                            child: Align(
                                              alignment:
                                                  AlignmentDirectional(0.9, 0),
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Color(0xA0262C2D),
                                                size: 22,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Divider(
                            thickness: 1.2,
                            indent: 0,
                            endIndent: 0,
                            color: Color(0xE5EAEAEA),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 8, 0, 8),
                            child: Material(
                              color: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primary,
                                  borderRadius: BorderRadius.circular(14),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: Colors.transparent,
                                    width: 0,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        context.pushNamed(
                                          'ProfilRediger',
                                          queryParameters: {
                                            'konto': serializeParam(
                                              'For- og etternavn',
                                              ParamType.String,
                                            ),
                                          },
                                        );
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            CupertinoIcons.person,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            size: 28,
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(12, 0, 0, 0),
                                                child: Text(
                                                  'For- og etternavn',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .labelLarge
                                                      .override(
                                                        fontFamily: 'Nunito',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontSize: 16,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Expanded(
                                            child: Align(
                                              alignment:
                                                  AlignmentDirectional(0.9, 0),
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Color(0xA0262C2D),
                                                size: 22,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Divider(
                            thickness: 1.2,
                            indent: 0,
                            endIndent: 0,
                            color: Color(0xE5EAEAEA),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 8, 0, 8),
                            child: Material(
                              color: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primary,
                                  borderRadius: BorderRadius.circular(14),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: Colors.transparent,
                                    width: 0,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        context.pushNamed(
                                          'ProfilRediger',
                                          queryParameters: {
                                            'konto': serializeParam(
                                              'Bio',
                                              ParamType.String,
                                            ),
                                          },
                                        );
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            CupertinoIcons.pen,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            size: 28,
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(12, 0, 0, 0),
                                                child: Text(
                                                  'Bio',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .labelLarge
                                                      .override(
                                                        fontFamily: 'Nunito',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontSize: 16,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Expanded(
                                            child: Align(
                                              alignment:
                                                  AlignmentDirectional(0.9, 0),
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Color(0xA0262C2D),
                                                size: 22,
                                              ),
                                            ),
                                          ),
                                        ],
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
                  Align(
                    alignment: const AlignmentDirectional(-1, 0),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 40, 0, 0),
                      child: Text(
                        'Personlig informasjon',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Nunito',
                              fontSize: 14,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 8, 0, 8),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed('ProfilRediger');
                              },
                              child: Material(
                                color: Colors.transparent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary,
                                    borderRadius: BorderRadius.circular(14),
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: Colors.transparent,
                                      width: 0,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed(
                                            'ProfilRediger',
                                            queryParameters: {
                                              'konto': serializeParam(
                                                'E-post',
                                                ParamType.String,
                                              ),
                                            },
                                          );
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Icon(
                                              CupertinoIcons.envelope,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              size: 28,
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          12, 0, 0, 0),
                                                  child: Text(
                                                    'E-post',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelLarge
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 16,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Expanded(
                                              child: Align(
                                                alignment: AlignmentDirectional(
                                                    0.9, 0),
                                                child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Color(0xA0262C2D),
                                                  size: 22,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (_auth.currentUser!.providerData[0].providerId ==
                              'phone')
                            const Divider(
                              thickness: 1.2,
                              indent: 0,
                              endIndent: 0,
                              color: Color(0xE5EAEAEA),
                            ),
                          if (_auth.currentUser!.providerData[0].providerId ==
                              'phone')
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 8, 0, 8),
                              child: Material(
                                color: Colors.transparent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary,
                                    borderRadius: BorderRadius.circular(14),
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: Colors.transparent,
                                      width: 0,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed(
                                            'ProfilRediger',
                                            queryParameters: {
                                              'konto': serializeParam(
                                                'Endre passord',
                                                ParamType.String,
                                              ),
                                            },
                                          );
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Icon(
                                              CupertinoIcons.padlock,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              size: 28,
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          12, 0, 0, 0),
                                                  child: Text(
                                                    'Endre passord',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelLarge
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 16,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Expanded(
                                              child: Align(
                                                alignment: AlignmentDirectional(
                                                    0.9, 0),
                                                child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Color(0xA0262C2D),
                                                  size: 22,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          const Divider(
                            thickness: 1.2,
                            indent: 0,
                            endIndent: 0,
                            color: Color(0xE5EAEAEA),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 8, 0, 8),
                            child: Material(
                              color: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primary,
                                  borderRadius: BorderRadius.circular(14),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: Colors.transparent,
                                    width: 0,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        try {
                                          await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              TextEditingController
                                                  usernameController =
                                                  TextEditingController();

                                              return AlertDialog(
                                                title: Text('Slett bruker'),
                                                backgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Skriv inn brukernavnet ditt for å bekrefte at du sletter brukeren.',
                                                    ),
                                                    SizedBox(height: 10),
                                                    TextField(
                                                      controller:
                                                          usernameController,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: 'Brukernavn',
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(14),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                          'Avbryt',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                CupertinoColors
                                                                    .activeBlue,
                                                          ),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          if (loading) return;
                                                          loading = true;
                                                          showLoadingDialog(
                                                              context);
                                                          String username =
                                                              usernameController
                                                                  .text
                                                                  .trim();

                                                          if (username
                                                                  .isEmpty ||
                                                              username !=
                                                                  FFAppState()
                                                                      .brukernavn) {
                                                            if (context
                                                                .mounted) {
                                                              Toasts.showErrorToast(
                                                                  context,
                                                                  'Brukernavn matcher ikke');
                                                            }
                                                            loading = false;
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            usernameController
                                                                .clear();
                                                            return;
                                                          }
                                                          if (_auth
                                                                  .currentUser!
                                                                  .providerData[
                                                                      0]
                                                                  .providerId ==
                                                              'google.com') {
                                                            bool success =
                                                                await firebaseAuthService
                                                                    .reauthenticateWithGoogle(
                                                                        context);
                                                            if (success) {
                                                              if (!context
                                                                  .mounted) {
                                                                return;
                                                              }
                                                              final response =
                                                                  await userInfoService
                                                                      .deleteUser(
                                                                          context,
                                                                          username);
                                                              if (response!
                                                                      .statusCode ==
                                                                  200) {
                                                                final appState =
                                                                    FFAppState();
                                                                FFAppState()
                                                                        .login =
                                                                    false;
                                                                FFAppState()
                                                                        .startet =
                                                                    false;
                                                                appState
                                                                    .conversations
                                                                    .clear();
                                                                appState
                                                                    .matvarer
                                                                    .clear();
                                                                webSocketService
                                                                    .close();
                                                                await _auth
                                                                    .currentUser
                                                                    ?.delete();
                                                                if (!context
                                                                    .mounted) {
                                                                  return;
                                                                }
                                                                Toasts.showAccepted(
                                                                    context,
                                                                    'Bruker slettet');
                                                                logger.d(
                                                                    'successs');
                                                                await _auth
                                                                    .signOut();
                                                                if (!context
                                                                    .mounted) {
                                                                  return;
                                                                }

                                                                loading = false;
                                                                context.go(
                                                                    '/registrer');
                                                              }
                                                            } else {
                                                              if (!context
                                                                  .mounted) {
                                                                return;
                                                              }
                                                              setState(() {
                                                                loading = false;
                                                                Navigator.pop(
                                                                    context);
                                                              });
                                                              loading = false;
                                                            }
                                                          }
                                                          if (_auth
                                                                  .currentUser!
                                                                  .providerData[
                                                                      0]
                                                                  .providerId ==
                                                              'apple.com') {
                                                            if (!context
                                                                .mounted) {
                                                              return;
                                                            }
                                                            bool success =
                                                                await firebaseAuthService
                                                                    .reauthenticateWithApple(
                                                                        context);
                                                            if (success) {
                                                              if (!context
                                                                  .mounted) {
                                                                return;
                                                              }
                                                              final response =
                                                                  await userInfoService
                                                                      .deleteUser(
                                                                          context,
                                                                          username);
                                                              if (response!
                                                                      .statusCode ==
                                                                  200) {
                                                                final appState =
                                                                    FFAppState();
                                                                FFAppState()
                                                                        .login =
                                                                    false;
                                                                FFAppState()
                                                                        .startet =
                                                                    false;
                                                                appState
                                                                    .conversations
                                                                    .clear();
                                                                appState
                                                                    .matvarer
                                                                    .clear();
                                                                webSocketService
                                                                    .close();
                                                                await _auth
                                                                    .currentUser
                                                                    ?.delete();
                                                                if (!context
                                                                    .mounted) {
                                                                  return;
                                                                }
                                                                Toasts.showAccepted(
                                                                    context,
                                                                    'Bruker slettet');
                                                                logger.d(
                                                                    'successs');
                                                                await _auth
                                                                    .signOut();
                                                                if (!context
                                                                    .mounted) {
                                                                  return;
                                                                }

                                                                loading = false;
                                                                context.go(
                                                                    '/registrer');
                                                              }
                                                            } else {
                                                              if (!context
                                                                  .mounted) {
                                                                return;
                                                              }
                                                              setState(() {
                                                                loading = false;
                                                                Navigator.pop(
                                                                    context);
                                                              });
                                                              loading = false;
                                                            }
                                                          } else {
                                                            setState(() {
                                                              loading = false;
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                            if (!context
                                                                .mounted) {
                                                              return;
                                                            }
                                                            await showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              barrierColor:
                                                                  const Color
                                                                      .fromARGB(
                                                                      60,
                                                                      17,
                                                                      0,
                                                                      0),
                                                              useRootNavigator:
                                                                  true,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return GestureDetector(
                                                                  onTap: () =>
                                                                      FocusScope.of(
                                                                              context)
                                                                          .unfocus(),
                                                                  child:
                                                                      Padding(
                                                                    padding: MediaQuery
                                                                        .viewInsetsOf(
                                                                            context),
                                                                    child:
                                                                        ReAuthenticateWidget(
                                                                      delete:
                                                                          true,
                                                                      username:
                                                                          username,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                            return;
                                                          }
                                                        },
                                                        child: Text(
                                                          'Ja, slett\n@${FFAppState().brukernavn}',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                CupertinoColors
                                                                    .systemRed,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } on SocketException {
                                          loading = false;
                                          if (!context.mounted) return;
                                          Navigator.of(context).pop();
                                          Toasts.showErrorToast(context,
                                              'Ingen internettforbindelse');
                                        } catch (e) {
                                          loading = false;
                                          if (!context.mounted) return;
                                          Navigator.of(context).pop();
                                          Toasts.showErrorToast(
                                              context, 'En feil oppstod');
                                        }
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            CupertinoIcons.delete_simple,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            size: 28,
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(12, 0, 0, 0),
                                                child: Text(
                                                  'Slett kontoen min',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .labelLarge
                                                      .override(
                                                        fontFamily: 'Nunito',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontSize: 16,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Expanded(
                                            child: Align(
                                              alignment:
                                                  AlignmentDirectional(0.9, 0),
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Color(0xA0262C2D),
                                                size: 22,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ].addToEnd(const SizedBox(height: 100)),
                      ),
                    ),
                  ),
                ].addToEnd(const SizedBox(height: 80)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
