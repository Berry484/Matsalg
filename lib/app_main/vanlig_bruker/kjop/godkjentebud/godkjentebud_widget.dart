import 'dart:io';

import 'package:mat_salg/ApiCalls.dart';
import 'package:mat_salg/MyIP.dart';
import 'package:mat_salg/matvarer.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'godkjentebud_model.dart';
export 'godkjentebud_model.dart';

class GodkjentebudWidget extends StatefulWidget {
  const GodkjentebudWidget({
    super.key,
    this.info,
    this.ordre,
  });

  final dynamic info;
  final dynamic ordre;

  @override
  State<GodkjentebudWidget> createState() => _GodkjentebudWidgetState();
}

class _GodkjentebudWidgetState extends State<GodkjentebudWidget> {
  late GodkjentebudModel _model;
  late Matvarer matvare;
  late OrdreInfo salgInfo;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GodkjentebudModel());
    matvare = widget.info;
    salgInfo = widget.ordre;
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
      height: 580,
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
                        color: FlutterFlowTheme.of(context).alternate,
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
              onTap: () async {
                try {
                  context.pushNamed(
                    'BrukerPage',
                    queryParameters: {
                      'username': serializeParam(
                        matvare.username,
                        ParamType.String,
                      ),
                      'bruker': serializeParam(
                        null,
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
              child: Material(
                color: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                    borderRadius: BorderRadius.circular(13),
                    shape: BoxShape.rectangle,
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        try {
                          context.pushNamed(
                            'BrukerPage',
                            queryParameters: {
                              'username': serializeParam(
                                salgInfo.kjoper,
                                ParamType.String,
                              ),
                              'bruker': serializeParam(
                                null,
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    4, 3, 1, 1),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(200),
                                  child: Image.network(
                                    '${ApiConstants.baseUrl}${salgInfo.kjoperProfilePic}',
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
                                      return Image.asset(
                                        'assets/images/profile_pic.png', // Path to your local error image
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    9, 0, 0, 0),
                                child: Text(
                                  salgInfo.kjoper,
                                  textAlign: TextAlign.start,
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .override(
                                        fontFamily: 'Open Sans',
                                        fontSize: 18,
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
                  ),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: const AlignmentDirectional(-1, 1),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(5, 15, 0, 0),
                    child: Text(
                      'Matvare',
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
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(5, 7, 4, 0),
                      child: Text(
                        matvare.name ?? '',
                        textAlign: TextAlign.end,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Open Sans',
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 21,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 12, 4, 0),
                      child: Text(
                        '${salgInfo.pris} Kr',
                        textAlign: TextAlign.end,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Open Sans',
                              color: FlutterFlowTheme.of(context).alternate,
                              fontSize: 21,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: const AlignmentDirectional(-1, 1),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(5, 15, 0, 0),
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
                            const EdgeInsetsDirectional.fromSTEB(0, 12, 4, 0),
                        child: Text(
                          '${matvare.price} Kr',
                          textAlign: TextAlign.end,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Open Sans',
                                color: FlutterFlowTheme.of(context).alternate,
                                fontSize: 16,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      if (matvare.kg == true)
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
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
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 12, 4, 0),
                            child: Text(
                              '(${salgInfo.antall}',
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
                                'Kg)',
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
                                'Stk)',
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
                if (salgInfo.godkjent == true)
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(-1, 1),
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(5, 15, 0, 0),
                          child: Text(
                            'Godkjent tid',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Open Sans',
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  fontSize: 14,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(5, 12, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${salgInfo.godkjenttid != null ? DateFormat("HH:mm  EEEE", "nb_NO").format(salgInfo.godkjenttid!.toLocal()) : ""}',
                            textAlign: TextAlign.end,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Open Sans',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 16,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 25, 5, 0),
                    child: FFButtonWidget(
                      onPressed: () {},
                      text: 'Melding',
                      icon: Icon(
                        Icons.chat,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 23,
                      ),
                      options: FFButtonOptions(
                        width: 203,
                        height: 40,
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(11, 0, 0, 0),
                        iconPadding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: FlutterFlowTheme.of(context).alternate,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Open Sans',
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontSize: 18,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                        elevation: 3,
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                if (salgInfo.hentet != true && salgInfo.godkjent == true)
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                    child: Text(
                      'Husk å be kjøperen bekrefte at \nmatvaren er mottatt',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Open Sans',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
