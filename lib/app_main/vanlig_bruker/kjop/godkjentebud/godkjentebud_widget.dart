import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:mat_salg/MyIP.dart';
import 'package:mat_salg/app_main/vanlig_bruker/kjop/give_rating/give_rating_widget.dart';
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
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
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
        padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    height: 22,
                    thickness: 4,
                    indent: 168,
                    endIndent: 168,
                    color: Color.fromRGBO(197, 197, 199, 1),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                try {
                                  Navigator.pop(context);
                                } on SocketException {
                                  HapticFeedback.lightImpact();
                                  showErrorToast(
                                      context, 'Ingen internettforbindelse');
                                } catch (e) {
                                  HapticFeedback.lightImpact();
                                  showErrorToast(context, 'En feil oppstod');
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 15, 0),
                                child: Text(
                                  'Lukk',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Nunito',
                                        fontSize: 17,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
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
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                try {
                  Navigator.pop(context);
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
                  HapticFeedback.lightImpact();
                  showErrorToast(context, 'Ingen internettforbindelse');
                } catch (e) {
                  HapticFeedback.lightImpact();
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
                          Navigator.pop(context);
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
                          HapticFeedback.lightImpact();
                          showErrorToast(context, 'Ingen internettforbindelse');
                        } catch (e) {
                          HapticFeedback.lightImpact();
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
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
                                      return Image.asset(
                                        'assets/images/profile_pic.png', // Path to your local error image
                                        width: 50,
                                        height: 50,
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
                                        fontFamily: 'Nunito',
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
                              .headlineSmall
                              .override(
                                fontFamily: 'Nunito',
                                fontSize: 17,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 15, 4, 0),
                        child: Text(
                          '${salgInfo.pris} Kr',
                          textAlign: TextAlign.end,
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                fontFamily: 'Nunito',
                                fontSize: 17,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 16.0, 16.0, 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(children: [
                          const SizedBox(
                            height: 40,
                            child: VerticalDivider(
                              thickness: 1,
                              color: Color.fromARGB(48, 113, 113, 113),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PRIS',
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      fontFamily: 'Nunito',
                                      fontSize: 13.0,
                                      letterSpacing: 0.0,
                                      color: const Color.fromARGB(
                                          255, 113, 113, 113),
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                '${matvare.price}Kr',
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      fontFamily: 'Nunito',
                                      fontSize: 13.0,
                                      letterSpacing: 0.0,
                                      color: const Color.fromARGB(
                                          255, 113, 113, 113),
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ]),
                        Row(
                          children: [
                            const SizedBox(
                              height: 40,
                              child: VerticalDivider(
                                thickness: 1,
                                color: Color.fromARGB(48, 113, 113, 113),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ANTALL',
                                  textAlign: TextAlign.start,
                                  style: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        fontFamily: 'Nunito',
                                        fontSize: 13.0,
                                        letterSpacing: 0.0,
                                        color: const Color.fromARGB(
                                            255, 113, 113, 113),
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  child: Text(
                                    '${salgInfo.antall.toStringAsFixed(0)} ${matvare.kg == true ? 'Kg' : 'stk'}',
                                    textAlign: TextAlign.start,
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily: 'Nunito',
                                          fontSize: 13.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromARGB(
                                              255, 113, 113, 113),
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              height: 40,
                              child: VerticalDivider(
                                thickness: 1,
                                color: Color.fromARGB(48, 113, 113, 113),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'TID',
                                  textAlign: TextAlign.start,
                                  style: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        fontFamily: 'Nunito',
                                        fontSize: 13.0,
                                        letterSpacing: 0.0,
                                        color: const Color.fromARGB(
                                            255, 113, 113, 113),
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
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
                                              fontFamily: 'Nunito',
                                              fontSize: 13.0,
                                              letterSpacing: 0.0,
                                              color: const Color.fromARGB(
                                                  255, 113, 113, 113),
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
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
                          const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 2),
                      child: FFButtonWidget(
                        onPressed: () async {
                          try {
                            if (_bekreftIsLoading) {
                              return;
                            }
                            _bekreftIsLoading = true;
                            await showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              barrierColor: const Color.fromARGB(60, 17, 0, 0),
                              useRootNavigator: true,
                              context: context,
                              builder: (context) {
                                return GestureDetector(
                                  onTap: () => FocusScope.of(context).unfocus(),
                                  child: Padding(
                                    padding: MediaQuery.viewInsetsOf(context),
                                    child: GiveRatingWidget(
                                      kjop: false,
                                      username: salgInfo.kjoper,
                                      salgInfoId: salgInfo.id,
                                    ),
                                  ),
                                );
                              },
                            ).then((value) => setState(() {
                                  _bekreftIsLoading = false;
                                }));
                            return;
                          } on SocketException {
                            HapticFeedback.lightImpact();
                            showErrorToast(
                                context, 'Ingen internettforbindelse');
                          } catch (e) {
                            HapticFeedback.lightImpact();
                            showErrorToast(context, 'En feil oppstod');
                          }
                        },
                        text: 'Vurder kjøperen',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 47,
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(11, 0, 0, 0),
                          iconPadding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle: FlutterFlowTheme.of(context)
                              .titleSmall
                              .override(
                                fontFamily: 'Nunito',
                                color: FlutterFlowTheme.of(context).alternate,
                                fontSize: 16,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                          elevation: 0,
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 0.7,
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
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 35),
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
                          HapticFeedback.lightImpact();
                          showErrorToast(context, 'Ingen internettforbindelse');
                        } catch (e) {
                          _messageIsLoading = false;
                          HapticFeedback.lightImpact();
                          showErrorToast(context, 'En feil oppstod');
                        }
                      },
                      text: 'Melding',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 47,
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(11, 0, 0, 0),
                        iconPadding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: FlutterFlowTheme.of(context).alternate,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Nunito',
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
          ],
        ),
      ),
    );
  }
}
