import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:mat_salg/apiCalls.dart';
import 'package:mat_salg/app_main/vanlig_bruker/Utils.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/myIP.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final Toasts toasts = Toasts();

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

  // Function to show the loading dialog
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black26,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Disable the back button
          child: Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoActivityIndicator(
                    radius: 12,
                    color: FlutterFlowTheme.of(context).alternate,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((_) {
      // Clean up state when dialog is dismissed
      safeSetState(() {
        godkjennIsLoading = false;
        _messageIsLoading = false;
      });
    });
  }

  // Function to close the loading dialog
  void _hideLoadingDialog() {
    if (godkjennIsLoading || _messageIsLoading) {
      Navigator.of(context).pop(); // Close the dialog
    }
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
                  Divider(
                    height: 22,
                    thickness: 4,
                    indent: MediaQuery.of(context).size.width * 0.4,
                    endIndent: MediaQuery.of(context).size.width * 0.4,
                    color: Colors.black12,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  toasts.showErrorToast(
                                      context, 'Ingen internettforbindelse');
                                } catch (e) {
                                  toasts.showErrorToast(
                                      context, 'En feil oppstod');
                                }
                              },
                              child: Icon(
                                CupertinoIcons.xmark,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 25,
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
                              Navigator.pop(context);
                              context.pushNamed(
                                'BrukerPage1',
                                queryParameters: {
                                  'uid': serializeParam(
                                    salgInfo.kjoper,
                                    ParamType.String,
                                  ),
                                  'username': serializeParam(
                                    salgInfo.kjoperUsername,
                                    ParamType.String,
                                  ),
                                },
                              );
                            } on SocketException {
                              toasts.showErrorToast(
                                  context, 'Ingen internettforbindelse');
                            } catch (e) {
                              toasts.showErrorToast(context, 'En feil oppstod');
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
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
                                      return Image.asset(
                                        'assets/images/profile_pic.png',
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
                                    13, 0, 7, 0),
                                child: Text(
                                  salgInfo.kjoperUsername ?? '',
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
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 5, 0, 0),
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
                                          username:
                                              salgInfo.kjoperUsername ?? '',
                                          user: salgInfo.kjoper,
                                          lastactive: salgInfo.lastactive,
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
                                    toasts.showErrorToast(
                                        context, 'Ingen internettforbindelse');
                                  } catch (e) {
                                    _messageIsLoading = false;
                                    toasts.showErrorToast(
                                        context, 'En feil oppstod');
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
                                        fontFamily: 'Nunito',
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        fontSize: 15,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  elevation: 0,
                                  borderSide: const BorderSide(
                                    // color: Colors.transparent,
                                    color: Colors.transparent,
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
                    padding: const EdgeInsetsDirectional.fromSTEB(5, 12, 5, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
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
                        Text(
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
                      ],
                    ),
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
                                          color: CupertinoColors.systemBlue,
                                        ),
                                      ),
                                    ),
                                    CupertinoDialogAction(
                                      onPressed: () async {
                                        try {
                                          if (godkjennIsLoading) return;

                                          godkjennIsLoading = true;
                                          _showLoadingDialog();
                                          String? token =
                                              await firebaseAuthService
                                                  .getToken(context);
                                          if (token != null) {
                                            final response = await ApiKjop()
                                                .avvis(
                                                    id: salgInfo.id,
                                                    avvist: true,
                                                    godkjent: false,
                                                    token: token);

                                            if (response.statusCode == 200) {
                                              Navigator.of(context).pop();
                                              Navigator.pop(context);
                                              toasts.showAccepted(
                                                  context, 'Budet ble avslått');
                                              Navigator.pop(context);
                                            } else {
                                              _hideLoadingDialog();
                                              toasts.showErrorToast(context,
                                                  'En uforventet feil oppstod');
                                              return;
                                            }
                                          }
                                        } on SocketException {
                                          _hideLoadingDialog();
                                          toasts.showErrorToast(context,
                                              'Ingen internettforbindelse');
                                        } catch (e) {
                                          _hideLoadingDialog();
                                          toasts.showErrorToast(
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
                            toasts.showErrorToast(
                                context, 'Ingen internettforbindelse');
                          } catch (e) {
                            toasts.showErrorToast(context, 'En feil oppstod');
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
                                        isDefaultAction: true,
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
                                            _showLoadingDialog();
                                            String? token =
                                                await firebaseAuthService
                                                    .getToken(context);
                                            if (token != null) {
                                              final response = await ApiKjop()
                                                  .svarBud(
                                                      id: salgInfo.id,
                                                      godkjent: true,
                                                      token: token);
                                              if (response.statusCode == 200) {
                                                Navigator.of(context).pop();
                                                Navigator.pop(context);
                                                toasts.showAccepted(context,
                                                    'Budet ble godkjent');
                                                Navigator.pop(context);
                                              } else {
                                                _hideLoadingDialog();
                                                toasts.showErrorToast(context,
                                                    'En uforventet feil oppstod');
                                                return;
                                              }
                                            }
                                          } on SocketException {
                                            _hideLoadingDialog();
                                            toasts.showErrorToast(context,
                                                'Ingen internettforbindelse');
                                          } catch (e) {
                                            _hideLoadingDialog();
                                            toasts.showErrorToast(
                                                context, 'En feil oppstod');
                                          }
                                        },
                                        child: const Text(
                                          "Ja, godta",
                                          style: TextStyle(
                                              color: CupertinoColors.systemBlue,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } on SocketException {
                              toasts.showErrorToast(
                                  context, 'Ingen internettforbindelse');
                            } catch (e) {
                              toasts.showErrorToast(context, 'En feil oppstod');
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
