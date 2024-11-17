import 'dart:io';
import 'dart:math';

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
  bool _bekreftIsLoading = false;
  bool _messageIsLoading = false;

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

// Haversine formula to calculate distance between two lat/lng points
  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const earthRadius = 6371.0; // Earth's radius in kilometers
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLng = _degreesToRadians(lng2 - lng1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
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
      height: 510,
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
              onTap: () async {
                try {
                  context.pushNamed(
                    'BrukerPage',
                    queryParameters: {
                      'username': serializeParam(
                        matvare.username,
                        ParamType.String,
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
                                salgInfo.kjopte == true
                                    ? salgInfo.selger
                                    : salgInfo.kjoper,
                                ParamType.String,
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
                                    '${ApiConstants.baseUrl}${salgInfo.kjopte == true ? matvare.profilepic : salgInfo.kjoperProfilePic}',
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
                                  salgInfo.kjopte == true
                                      ? salgInfo.selger
                                      : salgInfo.kjoper,
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
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(5, 0, 4, 0),
                        child: Text(
                          matvare.name ?? '',
                          textAlign: TextAlign.end,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
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
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 4, 0),
                        child: Text(
                          '${salgInfo.pris} Kr',
                          textAlign: TextAlign.end,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Open Sans',
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 19,
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
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        5.0, 2.0, 0.0, 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${matvare.price}Kr',
                          textAlign: TextAlign.start,
                          style: FlutterFlowTheme.of(context)
                              .titleMedium
                              .override(
                                fontFamily: 'Open Sans',
                                fontSize: 14.0,
                                letterSpacing: 0.0,
                                color: const Color.fromARGB(211, 87, 99, 108),
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                          child: Text(
                            matvare.kg == true ? '/Kg' : '/Stk',
                            textAlign: TextAlign.start,
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: 'Open Sans',
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  color: const Color.fromARGB(211, 87, 99, 108),
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                          child: VerticalDivider(
                            thickness: 1.4,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                          child: Text(
                            '${matvare.antall ?? 0} ${matvare.kg == true ? 'Kg' : 'stk'}',
                            textAlign: TextAlign.start,
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: 'Open Sans',
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(211, 87, 99, 108),
                                ),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                          child: VerticalDivider(
                            thickness: 1.4,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ),
                        // Padding(
                        //   padding:
                        //       const EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                        //   child: Row(
                        //     mainAxisSize: MainAxisSize.min,
                        //     children: [
                        //       Text(
                        //         (calculateDistance(
                        //                     FFAppState().brukerLat ?? 0.0,
                        //                     FFAppState().brukerLng ?? 0.0,
                        //                     matvare.lat ?? 0.0,
                        //                     matvare.lng ?? 0.0) <
                        //                 1)
                        //             ? '<1 Km'
                        //             : '${calculateDistance(FFAppState().brukerLat ?? 0.0, FFAppState().brukerLng ?? 0.0, matvare.lat ?? 0.0, matvare.lng ?? 0.0).toStringAsFixed(0)}Km',
                        //         textAlign: TextAlign.start,
                        //         style: FlutterFlowTheme.of(context)
                        //             .titleMedium
                        //             .override(
                        //               fontFamily: 'Open Sans',
                        //               fontSize: 14.0,
                        //               letterSpacing: 0.0,
                        //               color: const Color.fromARGB(
                        //                   211, 87, 99, 108),
                        //               fontWeight: FontWeight.bold,
                        //             ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                salgInfo.updatetime != null
                                    ? (DateFormat("HH:mm  d. MMM", "nb_NO")
                                        .format(salgInfo.updatetime!.toLocal()))
                                    : "",
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      fontFamily: 'Open Sans',
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      color: const Color.fromARGB(
                                          211, 87, 99, 108),
                                      fontWeight: FontWeight.bold,
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
            if (salgInfo.rated != true &&
                salgInfo.kjopte != true &&
                salgInfo.hentet == true)
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                      child: FFButtonWidget(
                        onPressed: () async {
                          try {
                            if (_bekreftIsLoading) {
                              return;
                            }
                            _bekreftIsLoading = true;
                            String? token = Securestorage.authToken;
                            if (token != null) {
                              final response = await ApiKjop()
                                  .giveRating(id: salgInfo.id, token: token);
                              if (response.statusCode == 200) {
                                _bekreftIsLoading = false;
                                HapticFeedback.mediumImpact();
                                context.pushNamed(
                                  'LeggIgjenRating',
                                  queryParameters: {
                                    'kjop': serializeParam(
                                      false,
                                      ParamType.bool,
                                    ),
                                    'username': serializeParam(
                                      salgInfo.kjoper,
                                      ParamType.String,
                                    ),
                                  },
                                );
                              }
                              _bekreftIsLoading = false;
                            }
                          } on SocketException {
                            showErrorToast(
                                context, 'Ingen internettforbindelse');
                          } catch (e) {
                            showErrorToast(context, 'En feil oppstod');
                          }
                        },
                        text: 'Gi en rating',
                        options: FFButtonOptions(
                          width: 190,
                          height: 40,
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(11, 0, 0, 0),
                          iconPadding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle: FlutterFlowTheme.of(context)
                              .titleSmall
                              .override(
                                fontFamily: 'Open Sans',
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 17,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                          elevation: 0,
                          borderSide: const BorderSide(
                            color: Color(0x5957636C),
                            width: 0.8,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 35),
                    child: FFButtonWidget(
                      onPressed: () async {
                        try {
                          // Prevent multiple submissions while loading
                          if (_messageIsLoading) return;
                          _messageIsLoading = true;

                          Conversation existingConversation =
                              FFAppState().conversations.firstWhere(
                            (conv) =>
                                conv.user ==
                                (salgInfo.kjopte == false
                                    ? salgInfo.kjoper
                                    : salgInfo.selger),
                            orElse: () {
                              // If no conversation is found, create a new one and add it to the list
                              final newConversation = Conversation(
                                user: salgInfo.kjopte == false
                                    ? salgInfo.kjoper
                                    : salgInfo.selger,
                                profilePic: salgInfo.kjopte == false
                                    ? salgInfo.kjoperProfilePic ?? ''
                                    : matvare.profilepic ?? '',
                                messages: [],
                              );

                              // Add the new conversation to the list
                              FFAppState().conversations.add(newConversation);

                              // Return the new conversation
                              return newConversation;
                            },
                          );

                          // Step 3: Serialize the conversation object to JSON
                          String? serializedConversation = serializeParam(
                            existingConversation
                                .toJson(), // Convert the conversation to JSON
                            ParamType.JSON,
                          );

                          // Step 4: Stop loading and navigate to message screen
                          _messageIsLoading = false;
                          if (serializedConversation != null) {
                            // Step 5: Navigate to 'message' screen with the conversation
                            context.pushNamed(
                              'message',
                              queryParameters: {
                                'conversation':
                                    serializedConversation, // Pass the serialized conversation
                              },
                            );
                          }
                        } on SocketException {
                          _messageIsLoading = false;
                          showErrorToast(context, 'Ingen internettforbindelse');
                        } catch (e) {
                          _messageIsLoading = false;
                          showErrorToast(context, 'En feil oppstod');
                        }
                      },
                      text: 'Melding',
                      options: FFButtonOptions(
                        width: 190,
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
                // if (salgInfo.hentet != true && salgInfo.godkjent == true)
                //   Padding(
                //     padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 40),
                //     child: Text(
                //       'Husk å be kjøperen bekrefte at \nmatvaren er mottatt',
                //       style: FlutterFlowTheme.of(context).bodyMedium.override(
                //             fontFamily: 'Open Sans',
                //             letterSpacing: 0.0,
                //             fontWeight: FontWeight.w500,
                //           ),
                //     ),
                //   ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
