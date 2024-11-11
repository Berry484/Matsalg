import 'dart:io';

import 'package:flutter/cupertino.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'innstillinger_model.dart';
export 'innstillinger_model.dart';

class InnstillingerWidget extends StatefulWidget {
  const InnstillingerWidget({super.key});

  @override
  State<InnstillingerWidget> createState() => _InnstillingerWidgetState();
}

class _InnstillingerWidgetState extends State<InnstillingerWidget> {
  late InnstillingerModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InnstillingerModel());
  }

  void showErrorToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        left: 16.0,
        right: 16.0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8)
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  FontAwesomeIcons.solidTimesCircle,
                  color: Colors.black,
                  size: 30.0,
                ),
                const SizedBox(width: 15),
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
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
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
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).secondary,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondary,
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).alternate),
            automaticallyImplyLeading: true,
            leading: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                try {
                  context.safePop();
                } on SocketException {
                  showErrorToast(context, 'Ingen internettforbindelse');
                } catch (e) {
                  showErrorToast(context, 'En feil oppstod');
                }
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 28.0,
              ),
            ),
            title: Text(
              'innstillinger',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Montserrat',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 20.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            actions: const [],
            centerTitle: true,
            elevation: 0.0,
          ),
          body: SafeArea(
            top: true,
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 60.0, 0.0, 0.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: const AlignmentDirectional(-0.9, 0.0),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 10.0, 0.0, 0.0),
                        child: Text(
                          'MIn Bruker',
                          style: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                fontFamily: 'Open Sans',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 13.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          10.0, 12.0, 10.0, 0.0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          try {
                            context.pushNamed('ProfilRediger');
                          } on SocketException {
                            showErrorToast(
                                context, 'Ingen internettforbindelse');
                          } catch (e) {
                            showErrorToast(context, 'En feil oppstod');
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 60.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary,
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 3.0,
                                color: Color(0x33000000),
                                offset: Offset(
                                  0.0,
                                  1.0,
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.circular(8.0),
                            shape: BoxShape.rectangle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                try {
                                  context.pushNamed('ProfilRediger');
                                } on SocketException {
                                  showErrorToast(
                                      context, 'Ingen internettforbindelse');
                                } catch (e) {
                                  showErrorToast(context, 'En feil oppstod');
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.account_circle_outlined,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    size: 22.0,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            12.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      'Rediger Profil',
                                      style: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .override(
                                            fontFamily: 'Open Sans',
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment:
                                          const AlignmentDirectional(0.9, 0.0),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 18.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          10.0, 15.0, 10.0, 0.0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          try {
                            context.pushNamed('Utbetalingsinfo1');
                          } on SocketException {
                            showErrorToast(
                                context, 'Ingen internettforbindelse');
                          } catch (e) {
                            showErrorToast(context, 'En feil oppstod');
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 60.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary,
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 3.0,
                                color: Color(0x33000000),
                                offset: Offset(
                                  0.0,
                                  1.0,
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.circular(8.0),
                            shape: BoxShape.rectangle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.solidCreditCard,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    size: 22.0,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            12.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      'Utbetalingsinformasjon',
                                      style: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .override(
                                            fontFamily: 'Open Sans',
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment:
                                          const AlignmentDirectional(0.9, 0.0),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 18.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(-0.9, 0.0),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 16.0, 0.0, 0.0),
                        child: Text(
                          'Informasjon',
                          style: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                fontFamily: 'Open Sans',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 13.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          10.0, 12.0, 10.0, 0.0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          try {
                            context.pushNamed('SolgteMatvarer');
                          } on SocketException {
                            showErrorToast(
                                context, 'Ingen internettforbindelse');
                          } catch (e) {
                            showErrorToast(context, 'En feil oppstod');
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 60.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary,
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 3.0,
                                color: Color(0x33000000),
                                offset: Offset(
                                  0.0,
                                  1.0,
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.circular(8.0),
                            shape: BoxShape.rectangle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.shoppingBasket,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 19.0,
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      12.0, 0.0, 0.0, 0.0),
                                  child: Text(
                                    'Mine salg',
                                    style: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .override(
                                          fontFamily: 'Open Sans',
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment:
                                        const AlignmentDirectional(0.9, 0.0),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      size: 18.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          10.0, 12.0, 10.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primary,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 3.0,
                              color: Color(0x33000000),
                              offset: Offset(
                                0.0,
                                1.0,
                              ),
                            )
                          ],
                          borderRadius: BorderRadius.circular(8.0),
                          shape: BoxShape.rectangle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                Icons.gavel_rounded,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 22.0,
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    12.0, 0.0, 0.0, 0.0),
                                child: Text(
                                  'juridisk',
                                  style: FlutterFlowTheme.of(context)
                                      .labelLarge
                                      .override(
                                        fontFamily: 'Open Sans',
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment:
                                      const AlignmentDirectional(0.9, 0.0),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    size: 18.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          10.0, 12.0, 10.0, 0.0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {},
                        child: Container(
                          width: double.infinity,
                          height: 60.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary,
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 3.0,
                                color: Color(0x33000000),
                                offset: Offset(
                                  0.0,
                                  1.0,
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.circular(8.0),
                            shape: BoxShape.rectangle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.help_outline_rounded,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 21.0,
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      12.0, 0.0, 0.0, 0.0),
                                  child: Text(
                                    'Hjelpesenter',
                                    style: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .override(
                                          fontFamily: 'Open Sans',
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment:
                                        const AlignmentDirectional(0.9, 0.0),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      size: 18.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0, 0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            try {
                              showCupertinoDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoAlertDialog(
                                    title: const Text('Logg ut?'),
                                    actions: <Widget>[
                                      CupertinoDialogAction(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Nei, avbryt',
                                          style: TextStyle(
                                              color: Colors
                                                  .blue), // Blue for 'Nei'
                                        ),
                                      ),
                                      CupertinoDialogAction(
                                        onPressed: () async {
                                          try {
                                            FFAppState().login = false;
                                            FFAppState().startet = false;
                                            context.pushNamed('registrer');
                                          } on SocketException {
                                            showErrorToast(context,
                                                'Ingen internettforbindelse');
                                          } catch (e) {
                                            showErrorToast(
                                                context, 'En feil oppstod');
                                          }
                                        },
                                        child: const Text(
                                          'Ja, logg ut',
                                          style: TextStyle(
                                              color:
                                                  Colors.red), // Red for 'Ja'
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } on SocketException {
                              showErrorToast(
                                  context, 'Ingen internettforbindelse');
                            } catch (e) {
                              showErrorToast(context, 'En feil oppstod');
                            }
                          },
                          text: 'Logg ut',
                          options: FFButtonOptions(
                            width: 200,
                            height: 40,
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            iconPadding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Open Sans',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 16,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                            elevation: 0,
                            borderSide: BorderSide(
                              color: Color(0x5957636C),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(38),
                          ),
                        ),
                      ),
                    ),
                  ].addToEnd(const SizedBox(height: 100.0)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
