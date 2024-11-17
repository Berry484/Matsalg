import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:mat_salg/ApiCalls.dart';
import 'package:mat_salg/MyIP.dart';
import 'package:mat_salg/SecureStorage.dart';
import 'package:mat_salg/app_main/vanlig_bruker/kjop/avbryt_ikon/avbryt_ikon_widget.dart';
import 'package:mat_salg/matvarer.dart';

import '../godkjent_ikon/godkjent_ikon_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'salg_bruker_info_model.dart';
export 'salg_bruker_info_model.dart';

class SalgBrukerInfoWidget extends StatefulWidget {
  const SalgBrukerInfoWidget({
    super.key,
    this.info,
    this.ordre,
  });

  final dynamic info;
  final dynamic ordre;

  @override
  State<SalgBrukerInfoWidget> createState() => _SalgBrukerInfoWidgetState();
}

class _SalgBrukerInfoWidgetState extends State<SalgBrukerInfoWidget> {
  late SalgBrukerInfoModel _model;
  late Matvarer matvare;
  late OrdreInfo salgInfo;
  bool godkjennIsLoading = false;
  bool _messageIsLoading = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SalgBrukerInfoModel());
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
      height: 500,
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
        padding: const EdgeInsetsDirectional.fromSTEB(10, 4, 10, 16),
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
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                                    salgInfo.kjoper,
                                    ParamType.String,
                                  ),
                                },
                              );
                            } on SocketException {
                              showErrorToast(
                                  context, 'Ingen internettforbindelse');
                            } catch (e) {
                              showErrorToast(context, 'En feil oppstod');
                            }
                          },
                          child: Row(
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
                                        'assets/images/profile_pic.png',
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
                                    13, 0, 7, 0),
                                child: Text(
                                  salgInfo.selger,
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
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 5, 5, 0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  try {
                                    // Prevent multiple submissions while loading
                                    if (_messageIsLoading) return;
                                    _messageIsLoading = true;

                                    Conversation existingConversation =
                                        FFAppState().conversations.firstWhere(
                                      (conv) => conv.user == salgInfo.kjoper,
                                      orElse: () {
                                        // If no conversation is found, create a new one and add it to the list
                                        final newConversation = Conversation(
                                          user: salgInfo.kjoper,
                                          profilePic:
                                              salgInfo.kjoperProfilePic ?? '',
                                          messages: [],
                                        );

                                        // Add the new conversation to the list
                                        FFAppState()
                                            .conversations
                                            .add(newConversation);

                                        // Return the new conversation
                                        return newConversation;
                                      },
                                    );

                                    // Step 3: Serialize the conversation object to JSON
                                    String? serializedConversation =
                                        serializeParam(
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
                                    showErrorToast(
                                        context, 'Ingen internettforbindelse');
                                  } catch (e) {
                                    _messageIsLoading = false;
                                    showErrorToast(context, 'En feil oppstod');
                                  }
                                },
                                text: 'Melding',
                                options: FFButtonOptions(
                                  height: 30,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16, 0, 16, 0),
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
                                        fontSize: 16,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  elevation: 0,
                                  borderSide: const BorderSide(
                                    color: Color(0x5957636C),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(5, 32, 5, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
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
                        Text(
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(-1, 1),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                5, 15, 0, 0),
                            child: Text(
                              'Informasjon',
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
                                      color: const Color.fromARGB(
                                          211, 87, 99, 108),
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 5, 0),
                                child: Text(
                                  matvare.kg == true ? '/Kg' : '/Stk',
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
                              ),
                              SizedBox(
                                height: 12,
                                child: VerticalDivider(
                                  thickness: 1.4,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    5, 0, 5, 0),
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
                                        color: const Color.fromARGB(
                                            211, 87, 99, 108),
                                      ),
                                ),
                              ),
                              SizedBox(
                                height: 12,
                                child: VerticalDivider(
                                  thickness: 1.4,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsetsDirectional.fromSTEB(
                              //       5, 0, 0, 0),
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
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    5, 0, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      salgInfo.updatetime != null
                                          ? (DateFormat(
                                                  "HH:mm  d. MMM", "nb_NO")
                                              .format(salgInfo.updatetime!
                                                  .toLocal()))
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
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 50, 0, 40),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          try {
                            showCupertinoDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CupertinoAlertDialog(
                                  title: const Text("Bekreftelse"),
                                  content: const Text(
                                      "Er du sikker på at du ønsker å avslå budet?"),
                                  actions: [
                                    CupertinoDialogAction(
                                      onPressed: () {
                                        godkjennIsLoading = false;
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
                                        if (godkjennIsLoading) {
                                          return;
                                        }
                                        godkjennIsLoading = true;
                                        String? token = Securestorage.authToken;
                                        if (token != null) {
                                          final response = await ApiKjop()
                                              .avvis(
                                                  id: salgInfo.id,
                                                  avvist: true,
                                                  godkjent: false,
                                                  token: token);
                                          // Perform action for 'Yes'
                                          if (response.statusCode == 200) {
                                            godkjennIsLoading = false;
                                            Navigator.of(context).pop();
                                            Navigator.pop(context);
                                            HapticFeedback.mediumImpact();
                                            showDialog(
                                              barrierColor: Colors.transparent,
                                              context: context,
                                              builder: (dialogContext) {
                                                return Dialog(
                                                  elevation: 0,
                                                  insetPadding: EdgeInsets.zero,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  alignment:
                                                      const AlignmentDirectional(
                                                              0, 0)
                                                          .resolve(
                                                              Directionality.of(
                                                                  context)),
                                                  child:
                                                      const AvbrytIkonWidget(),
                                                );
                                              },
                                            );
                                          }
                                          godkjennIsLoading = false;
                                        }
                                      },
                                      child: const Text("Ja, avslå"),
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
                        text: 'Avslå',
                        options: FFButtonOptions(
                          width: 145,
                          height: 40,
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(11, 0, 0, 0),
                          iconPadding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: FlutterFlowTheme.of(context).error,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Open Sans',
                                    color: FlutterFlowTheme.of(context).primary,
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
                    Builder(
                      builder: (context) => Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            try {
                              showCupertinoDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoAlertDialog(
                                    title: const Text("Bekreftelse"),
                                    content: const Text(
                                        "Er du sikker på at du ønsker å godta budet?"),
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
                                          if (godkjennIsLoading) {
                                            return;
                                          }
                                          godkjennIsLoading = true;
                                          String? token =
                                              Securestorage.authToken;
                                          if (token != null) {
                                            final response = await ApiKjop()
                                                .svarBud(
                                                    id: salgInfo.id,
                                                    godkjent: true,
                                                    token: token);
                                            // Perform action for 'Yes'
                                            if (response.statusCode == 200) {
                                              godkjennIsLoading = false;
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                              Navigator.pop(context);
                                              HapticFeedback.mediumImpact();
                                              showDialog(
                                                barrierColor:
                                                    Colors.transparent,
                                                context: context,
                                                builder: (dialogContext) {
                                                  return Dialog(
                                                    elevation: 0,
                                                    insetPadding:
                                                        EdgeInsets.zero,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    alignment:
                                                        const AlignmentDirectional(
                                                                0, 0)
                                                            .resolve(
                                                                Directionality.of(
                                                                    context)),
                                                    child:
                                                        const GodkjentIkonWidget(),
                                                  );
                                                },
                                              );
                                            }
                                            godkjennIsLoading = false;
                                          }
                                        },
                                        child: const Text("Ja, godta"),
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
                          text: 'Godkjenn',
                          options: FFButtonOptions(
                            width: 145,
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
            ),
          ],
        ),
      ),
    );
  }
}
