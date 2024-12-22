import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:mat_salg/helper_components/widgets/loading_indicator.dart';
import 'package:mat_salg/helper_components/Toasts.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/my_ip.dart';
import 'package:mat_salg/services/purchase_service.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
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
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  late SalgBrukerInfoModel _model;
  late Matvarer matvare;
  late OrdreInfo salgInfo;
  bool godkjennIsLoading = false;
  bool messageIsLoading = false;

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
        padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
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
                  Divider(
                    height: 22,
                    thickness: 4,
                    indent: MediaQuery.of(context).size.width * 0.4,
                    endIndent: MediaQuery.of(context).size.width * 0.4,
                    color: Colors.black12,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 0, 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            try {
                              // Prevent multiple submissions while loading
                              if (messageIsLoading) return;
                              messageIsLoading = true;

                              Conversation existingConversation =
                                  FFAppState().conversations.firstWhere(
                                (conv) => conv.user == salgInfo.kjoper,
                                orElse: () {
                                  // If no conversation is found, create a new one and add it to the list
                                  final newConversation = Conversation(
                                    username: salgInfo.kjoperUsername ?? '',
                                    user: salgInfo.kjoper,
                                    lastactive: salgInfo.lastactive,
                                    profilePic: matvare.profilepic ?? '',
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
                              String? serializedConversation = serializeParam(
                                existingConversation
                                    .toJson(), // Convert the conversation to JSON
                                ParamType.JSON,
                              );

                              // Step 4: Stop loading and navigate to message screen
                              messageIsLoading = false;
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
                              messageIsLoading = false;
                              Toasts.showErrorToast(
                                  context, 'Ingen internettforbindelse');
                            } catch (e) {
                              messageIsLoading = false;
                              Toasts.showErrorToast(context, 'En feil oppstod');
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    6.0, 0.0, 0.0, 0.0),
                                child: Container(
                                  width: 34.0,
                                  height: 34.0,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.network(
                                    '${ApiConstants.baseUrl}${salgInfo.kjoperProfilePic}',
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
                                      return Image.asset(
                                        'assets/images/profile_pic.png',
                                        width: 34.0,
                                        height: 34.0,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            8.0, 0.0, 0.0, 0.0),
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: salgInfo.kjoperUsername,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Nunito',
                                                  fontSize: 15.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
                                  Toasts.showErrorToast(
                                      context, 'Ingen internettforbindelse');
                                } catch (e) {
                                  Toasts.showErrorToast(
                                      context, 'En feil oppstod');
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 11, 0),
                                child: Text(
                                  'Lukk',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Nunito',
                                        fontSize: 16,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
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
                  try {
                    context.pushNamed(
                      'KjopDetaljVentende1',
                      extra: {
                        'mine': true, // Example value
                        'ordre': salgInfo, // Example order object
                      },
                    );
                  } on SocketException {
                    Toasts.showErrorToast(
                        context, 'Ingen internettforbindelse');
                  } catch (e) {
                    Toasts.showErrorToast(context, 'En feil oppstod');
                  }
                } on SocketException {
                  Toasts.showErrorToast(context, 'Ingen internettforbindelse');
                } catch (e) {
                  Toasts.showErrorToast(context, 'En feil oppstod');
                }
              },
              child: Material(
                color: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                    borderRadius: BorderRadius.circular(13),
                    shape: BoxShape.rectangle,
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
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
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            4, 3, 1, 1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(13),
                                      child: Image.network(
                                        '${ApiConstants.baseUrl}${salgInfo.foodDetails.imgUrls![0]}',
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                        errorBuilder: (BuildContext context,
                                            Object error,
                                            StackTrace? stackTrace) {
                                          return Image.asset(
                                            'assets/images/error_image.jpg',
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            8, 0, 4, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 0, 0, 0),
                                          child: Text(
                                            matvare.name ?? '',
                                            style: FlutterFlowTheme.of(context)
                                                .headlineSmall
                                                .override(
                                                  fontFamily: 'Nunito',
                                                  fontSize: 16,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                        ),
                                        if (salgInfo.godkjent != true)
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 0, 6),
                                            child: Text(
                                              'Svar på budet',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily: 'Nunito',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    fontSize: 14,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                        if (salgInfo.godkjent == true)
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 0, 4),
                                            child: Text(
                                              'Budet er godkjent,\nkontakt kjøperen',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily: 'Nunito',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    fontSize: 14,
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
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 8, 10, 0),
                                    child: Text(
                                      '${salgInfo.kjopte == true ? salgInfo.prisBetalt : salgInfo.pris} Kr',
                                      textAlign: TextAlign.end,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Nunito',
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            fontSize: 17,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 16.0, 5.0),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 0),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'UTLØPER',
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
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(5, 0, 0, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              salgInfo.updatetime != null
                                                  ? (DateFormat("d. MMM  HH:mm",
                                                          "nb_NO")
                                                      .format(salgInfo
                                                          .updatetime!
                                                          .toLocal()
                                                          .add(Duration(
                                                              days: 3))))
                                                  : "",
                                              textAlign: TextAlign.start,
                                              style: FlutterFlowTheme.of(
                                                      context)
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
                ),
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
                                      child: const Text(
                                        "Nei, avbryt",
                                        style: TextStyle(
                                          color: CupertinoColors.systemBlue,
                                        ),
                                      ),
                                    ),
                                    CupertinoDialogAction(
                                      onPressed: () async {
                                        try {
                                          if (godkjennIsLoading) return;

                                          godkjennIsLoading = true;
                                          showLoadingDialog(context);
                                          String? token =
                                              await firebaseAuthService
                                                  .getToken(context);
                                          if (token != null) {
                                            final response =
                                                await PurchaseService.avvis(
                                                    id: salgInfo.id,
                                                    avvist: true,
                                                    godkjent: false,
                                                    token: token);

                                            if (response.statusCode == 200) {
                                              Navigator.of(context).pop();
                                              Navigator.pop(context);
                                              Toasts.showAccepted(
                                                  context, 'Budet ble avslått');
                                              Navigator.pop(context);
                                            } else {
                                              if (godkjennIsLoading ||
                                                  messageIsLoading) {
                                                Navigator.of(context).pop();
                                              }
                                              Toasts.showErrorToast(context,
                                                  'En uforventet feil oppstod');
                                              return;
                                            }
                                          }
                                        } on SocketException {
                                          if (godkjennIsLoading ||
                                              messageIsLoading) {
                                            godkjennIsLoading = false;
                                            messageIsLoading = false;
                                            Navigator.of(context).pop();
                                          }
                                          Toasts.showErrorToast(context,
                                              'Ingen internettforbindelse');
                                        } catch (e) {
                                          if (godkjennIsLoading ||
                                              messageIsLoading) {
                                            godkjennIsLoading = false;

                                            Navigator.of(context).pop();
                                          }
                                          Toasts.showErrorToast(
                                              context, 'En feil oppstod');
                                        }
                                      },
                                      child: const Text(
                                        "Ja, avslå",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } on SocketException {
                            Toasts.showErrorToast(
                                context, 'Ingen internettforbindelse');
                          } catch (e) {
                            Toasts.showErrorToast(context, 'En feil oppstod');
                          }
                        },
                        text: 'Avslå',
                        options: FFButtonOptions(
                          width: 155,
                          height: 47,
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          iconPadding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: Colors.white,
                          textStyle: FlutterFlowTheme.of(context)
                              .titleSmall
                              .override(
                                fontFamily: 'Nunito',
                                color: FlutterFlowTheme.of(context).alternate,
                                fontSize: 16,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w800,
                              ),
                          elevation: 0,
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 0.6,
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
                                  bool godkjennIsLoading = false;
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
                                        child: const Text(
                                          "Nei, avbryt",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      CupertinoDialogAction(
                                        onPressed: () async {
                                          try {
                                            if (godkjennIsLoading) return;

                                            godkjennIsLoading = true;
                                            showLoadingDialog(context);
                                            String? token =
                                                await firebaseAuthService
                                                    .getToken(context);
                                            if (token != null) {
                                              final response =
                                                  await PurchaseService.svarBud(
                                                      id: salgInfo.id,
                                                      godkjent: true,
                                                      token: token);
                                              if (response.statusCode == 200) {
                                                Navigator.of(context).pop();
                                                Navigator.pop(context);
                                                Toasts.showAccepted(context,
                                                    'Budet ble godkjent');
                                                Navigator.pop(context);
                                              } else {
                                                if (messageIsLoading) {
                                                  godkjennIsLoading = false;
                                                  messageIsLoading = false;
                                                  Navigator.of(context).pop();
                                                }
                                                Toasts.showErrorToast(context,
                                                    'En uforventet feil oppstod');
                                                return;
                                              }
                                            }
                                          } on SocketException {
                                            if (messageIsLoading) {
                                              godkjennIsLoading = false;
                                              messageIsLoading = false;
                                              Navigator.of(context).pop();
                                            }
                                            Toasts.showErrorToast(context,
                                                'Ingen internettforbindelse');
                                          } catch (e) {
                                            if (messageIsLoading) {
                                              godkjennIsLoading = false;
                                              messageIsLoading = false;
                                              Navigator.of(context).pop();
                                            }
                                            Toasts.showErrorToast(
                                                context, 'En feil oppstod');
                                          }
                                        },
                                        child: const Text("Ja, godta",
                                            style: TextStyle(
                                              color: CupertinoColors.systemBlue,
                                            )),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } on SocketException {
                              Toasts.showErrorToast(
                                  context, 'Ingen internettforbindelse');
                            } catch (e) {
                              Toasts.showErrorToast(context, 'En feil oppstod');
                            }
                          },
                          text: 'Godkjenn',
                          options: FFButtonOptions(
                            width: 155,
                            height: 47,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 0),
                            color: FlutterFlowTheme.of(context).alternate,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Nunito',
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontSize: 16,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w800,
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
