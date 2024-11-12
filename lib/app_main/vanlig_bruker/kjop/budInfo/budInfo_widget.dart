import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mat_salg/ApiCalls.dart';
import 'package:mat_salg/MyIP.dart';
import 'package:mat_salg/SecureStorage.dart';
import 'package:mat_salg/matvarer.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'budInfo_model.dart';
export 'budInfo_model.dart';

class BudInfoWidget extends StatefulWidget {
  const BudInfoWidget({
    super.key,
    this.info,
    this.ordre,
  });

  final dynamic info;
  final dynamic ordre;

  @override
  State<BudInfoWidget> createState() => _BudInfoWidgetState();
}

class _BudInfoWidgetState extends State<BudInfoWidget> {
  late BudInfoModel _model;
  late Matvarer matvare;
  late OrdreInfo ordreInfo;
  bool _trekkIsLoading = false;
  bool _bekreftIsLoading = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BudInfoModel());
    matvare = widget.info;
    ordreInfo = widget.ordre;
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
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 500,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primary,
        boxShadow: [
          const BoxShadow(
            blurRadius: 4,
            color: Color(0x25090F13),
            offset: Offset(
              0.0,
              2,
            ),
          )
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(15, 4, 5, 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                    child: FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 30,
                      borderWidth: 1,
                      buttonSize: 44,
                      icon: FaIcon(
                        FontAwesomeIcons.times,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 26,
                      ),
                      onPressed: () async {
                        try {
                          Navigator.pop(context);
                        } on SocketException {
                          showErrorToast(context, 'Ingen internettforbindelse');
                        } catch (e) {
                          showErrorToast(context, 'En feil oppstod');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {},
              child: Material(
                color: FlutterFlowTheme.of(context).primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Container(
                  height: 92,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                    borderRadius: BorderRadius.circular(13),
                    shape: BoxShape.rectangle,
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                    child: InkWell(
                      onTap: () async {
                        try {
                          context.pushNamed(
                            'KjopDetaljVentende',
                            queryParameters: {
                              'matinfo': serializeParam(
                                matvare,
                                ParamType.JSON,
                              ),
                            },
                          );
                        } on SocketException {
                          showErrorToast(context, 'Ingen internettforbindelse');
                        } catch (e) {
                          showErrorToast(context, 'En feil oppstod');
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    4, 3, 1, 1),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: Image.network(
                                    '${ApiConstants.baseUrl}${ordreInfo.foodDetails.imgUrls![0]}',
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
                                      return Image.asset(
                                        'assets/images/error_image.jpg',
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    8, 0, 4, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 10, 0, 0),
                                      child: Text(
                                        matvare.name ?? '',
                                        style: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .override(
                                              fontFamily: 'Open Sans',
                                              fontSize: 20,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                    if (ordreInfo.godkjent != true)
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 6),
                                        child: Text(
                                          'Venter svar fra selgeren',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Open Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 13,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                    if (ordreInfo.godkjent == true)
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 4),
                                        child: Text(
                                          'Budet er godkjent,\nkontakt selgeren',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Open Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 13,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                lineHeight: 1.2,
                                              ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 12, 4, 0),
                            child: Text(
                              '${ordreInfo.pris} Kr',
                              textAlign: TextAlign.end,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Open Sans',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize: 19,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
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
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: const AlignmentDirectional(-1, 1),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(5, 15, 0, 0),
                      child: Text(
                        'Informasjon',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Open Sans',
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 14,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 0, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                          child: Text(
                            '${matvare.price} Kr',
                            textAlign: TextAlign.end,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Open Sans',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 16,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        if (matvare.kg == true)
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 12, 0, 0),
                            child: Text(
                              '/kg',
                              textAlign: TextAlign.end,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Open Sans',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontSize: 16,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        if (matvare.kg != true)
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 12, 0, 0),
                            child: Text(
                              '/stk',
                              textAlign: TextAlign.end,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Open Sans',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontSize: 16,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(8, 14, 8, 0),
                                child: FaIcon(
                                  FontAwesomeIcons.solidCircle,
                                  color: Color.fromARGB(92, 87, 99, 108),
                                  size: 6,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 12, 4, 0),
                              child: Text(
                                '${ordreInfo.antall}',
                                textAlign: TextAlign.end,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Open Sans',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontSize: 15,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            if (matvare.kg == true)
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 12, 0, 0),
                                child: Text(
                                  'Kg',
                                  textAlign: TextAlign.end,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Open Sans',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: 15,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            if (matvare.kg != true)
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 12, 0, 0),
                                child: Text(
                                  'Stk',
                                  textAlign: TextAlign.end,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Open Sans',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: 15,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 40),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (ordreInfo.godkjent != true)
                    Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 50, 5, 0),
                        child: FFButtonWidget(
                          onPressed: () {},
                          text: 'Melding',
                          options: FFButtonOptions(
                            width: 200,
                            height: 40,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                11, 0, 0, 0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 0),
                            color: FlutterFlowTheme.of(context).alternate,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Open Sans',
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontSize: 19,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                            elevation: 0,
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  if (ordreInfo.godkjent != true)
                    Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 15, 5, 0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            try {
                              showCupertinoDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoAlertDialog(
                                    title: const Text("Bekreftelse"),
                                    content: const Text(
                                        "Er du sikker på at du ønsker å trekke budet ditt?"),
                                    actions: [
                                      CupertinoDialogAction(
                                        onPressed: () {
                                          if (_bekreftIsLoading) {
                                            return;
                                          }
                                          _bekreftIsLoading = true;
                                          Navigator.of(context).pop();
                                          _bekreftIsLoading = false;
                                        },
                                        isDefaultAction: true,
                                        child: const Text(
                                          "Nei, avbryt",
                                          style: TextStyle(
                                              color: Colors
                                                  .red), // Red text for 'No' button
                                        ),
                                      ),
                                      CupertinoDialogAction(
                                        onPressed: () async {
                                          if (_trekkIsLoading) {
                                            return;
                                          }
                                          _trekkIsLoading = true;
                                          String? token =
                                              Securestorage.authToken;
                                          if (token != null) {
                                            final response = await ApiKjop()
                                                .trekk(
                                                    id: ordreInfo.id,
                                                    trekt: true,
                                                    token: token);
                                            if (response.statusCode == 200) {
                                              HapticFeedback.mediumImpact();
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            }
                                            _trekkIsLoading = false;
                                          }
                                        },
                                        child: const Text("Ja, bekreft"),
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
                          text: 'Trekk bud',
                          icon: FaIcon(
                            FontAwesomeIcons.times,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 23,
                          ),
                          options: FFButtonOptions(
                            width: 200,
                            height: 40,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                11, 0, 0, 0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 0),
                            color: FlutterFlowTheme.of(context).error,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Open Sans',
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontSize: 18,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                            elevation: 0,
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  if (ordreInfo.godkjent == true)
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: FFButtonWidget(
                              onPressed: () {},
                              text: 'Melding',
                              options: FFButtonOptions(
                                width: 200,
                                height: 40,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    11, 0, 0, 0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                color: FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Open Sans',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontSize: 18,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                elevation: 0,
                                borderSide: const BorderSide(
                                  color: Color(0x5957636C),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 12, 0, 0),
                              child: FFButtonWidget(
                                onPressed: () {
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CupertinoAlertDialog(
                                        title: const Text("Bekreftelse"),
                                        content: const Text(
                                            "Bekrefter du at du har mottatt matvaren?"),
                                        actions: [
                                          CupertinoDialogAction(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            },
                                            isDefaultAction: true,
                                            child: const Text(
                                              "Nei, avbryt",
                                              style: TextStyle(
                                                  color: Colors
                                                      .red), // Red text for 'No' button
                                            ),
                                          ),
                                          CupertinoDialogAction(
                                            onPressed: () async {
                                              try {
                                                if (_bekreftIsLoading) {
                                                  return;
                                                }
                                                _bekreftIsLoading = true;
                                                String? token =
                                                    Securestorage.authToken;
                                                if (token != null) {
                                                  final response =
                                                      await ApiKjop().hentMat(
                                                          id: ordreInfo.id,
                                                          hentet: true,
                                                          token: token);
                                                  if (response.statusCode ==
                                                      200) {
                                                    _bekreftIsLoading = false;
                                                    HapticFeedback
                                                        .mediumImpact();
                                                    context.pushNamed(
                                                      'LeggIgjenRating',
                                                      queryParameters: {
                                                        'kjop': serializeParam(
                                                          true,
                                                          ParamType.bool,
                                                        ),
                                                        'username':
                                                            serializeParam(
                                                          matvare.username,
                                                          ParamType.String,
                                                        ),
                                                      },
                                                    );
                                                  }
                                                  _bekreftIsLoading = false;
                                                }
                                              } on SocketException {
                                                showErrorToast(context,
                                                    'Ingen internettforbindelse');
                                              } catch (e) {
                                                showErrorToast(
                                                    context, 'En feil oppstod');
                                              }
                                            },
                                            child: const Text("Ja, bekreft"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                text: 'Bekreft hentet',
                                icon: FaIcon(
                                  FontAwesomeIcons.check,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 23,
                                ),
                                options: FFButtonOptions(
                                  width: 203,
                                  height: 40,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      11, 0, 0, 0),
                                  iconPadding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 0),
                                  color: FlutterFlowTheme.of(context).alternate,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Open Sans',
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        fontSize: 17,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  elevation: 0,
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
