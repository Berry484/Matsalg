import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:mat_salg/helper_components/toasts.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/my_ip.dart';
import 'package:mat_salg/pages/app_pages/kjop/give_rating/give_rating_widget.dart';
import 'package:mat_salg/services/purchase_service.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
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
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  late BudInfoModel _model;
  late Matvarer matvare;
  late OrdreInfo ordreInfo;
  final Toasts toasts = Toasts();
  bool _trekkIsLoading = false;
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
    _model = createModel(context, () => BudInfoModel());
    matvare = widget.info;
    ordreInfo = widget.ordre;
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
        _bekreftIsLoading = false;
        _trekkIsLoading = false;
        _messageIsLoading = false;
      });
    });
  }

  // Function to close the loading dialog
  void _hideLoadingDialog() {
    if (_bekreftIsLoading || _trekkIsLoading || _messageIsLoading) {
      Navigator.of(context).pop(); // Close the dialog
    }
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
      height: 560,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primary,
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
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            try {
                              // Prevent multiple submissions while loading
                              if (_messageIsLoading) return;
                              _messageIsLoading = true;

                              Conversation existingConversation =
                                  FFAppState().conversations.firstWhere(
                                (conv) => conv.user == ordreInfo.selger,
                                orElse: () {
                                  // If no conversation is found, create a new one and add it to the list
                                  final newConversation = Conversation(
                                    username: ordreInfo.selgerUsername ?? '',
                                    user: ordreInfo.selger,
                                    lastactive:
                                        ordreInfo.foodDetails.lastactive,
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
                              toasts.showErrorToast(context, 'En feil oppstod');
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
                                    '${ApiConstants.baseUrl}${ordreInfo.foodDetails.profilepic}',
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
                                            text: ordreInfo.selgerUsername,
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
                                  toasts.showErrorToast(
                                      context, 'Ingen internettforbindelse');
                                } catch (e) {
                                  toasts.showErrorToast(
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
                            'KjopDetaljVentende1',
                            extra: {
                              'mine': false, // Example value
                              'ordre': ordreInfo, // Example order object
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
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
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
                                              0, 0, 0, 0),
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
                                    if (ordreInfo.godkjent != true)
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 6),
                                        child: Text(
                                          'Venter svar fra selgeren',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Nunito',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 14,
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
                                                fontFamily: 'Nunito',
                                                color:
                                                    FlutterFlowTheme.of(context)
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
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 12, 10, 0),
                            child: Text(
                              '${ordreInfo.prisBetalt} Kr',
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
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                                    '${ordreInfo.antall.toStringAsFixed(0)} ${matvare.kg == true ? 'Kg' : 'stk'}',
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
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      5, 0, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        ordreInfo.updatetime != null
                                            ? (DateFormat(
                                                    "d. MMM  HH:mm", "nb_NO")
                                                .format(ordreInfo.updatetime!
                                                    .toLocal()
                                                    .add(Duration(days: 3))))
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
                            const EdgeInsetsDirectional.fromSTEB(16, 50, 16, 0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            try {
                              // Prevent multiple submissions while loading
                              if (_messageIsLoading) return;
                              _messageIsLoading = true;

                              Conversation existingConversation =
                                  FFAppState().conversations.firstWhere(
                                (conv) => conv.user == ordreInfo.selger,
                                orElse: () {
                                  // If no conversation is found, create a new one and add it to the list
                                  final newConversation = Conversation(
                                    username: ordreInfo.selgerUsername ?? '',
                                    user: ordreInfo.selger,
                                    lastactive:
                                        ordreInfo.foodDetails.lastactive,
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
                              toasts.showErrorToast(context, 'En feil oppstod');
                            }
                          },
                          text: 'Melding',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 47,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                11, 0, 0, 0),
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
                  if (ordreInfo.godkjent != true)
                    Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(16, 15, 16, 0),
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
                                        child: const Text(
                                          "Nei",
                                          style: TextStyle(
                                            color: CupertinoColors.systemBlue,
                                          ),
                                        ),
                                      ),
                                      CupertinoDialogAction(
                                        onPressed: () async {
                                          try {
                                            if (_trekkIsLoading) return;
                                            _trekkIsLoading = true;
                                            _showLoadingDialog();
                                            String? token =
                                                await firebaseAuthService
                                                    .getToken(context);
                                            if (token != null) {
                                              final response =
                                                  await PurchaseService.trekk(
                                                      id: ordreInfo.id,
                                                      trekt: true,
                                                      token: token);
                                              if (response.statusCode == 200) {
                                                Navigator.of(context).pop();
                                                Navigator.pop(context);
                                                toasts.showAccepted(
                                                    context, 'Budet ble trekt');
                                                Navigator.pop(context);
                                              } else {
                                                _hideLoadingDialog();
                                                Navigator.pop(context);
                                                toasts.showErrorToast(context,
                                                    'En uforventet feil oppstod');
                                                return;
                                              }
                                            }
                                          } catch (e) {
                                            _hideLoadingDialog();
                                            Navigator.pop(context);
                                            toasts.showErrorToast(context,
                                                'En uforventet feil oppstod');
                                            return;
                                          }
                                        },
                                        child: const Text(
                                          "Ja",
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
                          text: 'Trekk bud',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 47,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                11, 0, 0, 0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Nunito',
                                  color: FlutterFlowTheme.of(context).error,
                                  fontSize: 16,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w800,
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
                    ),
                  if (ordreInfo.godkjent == true)
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 50, 16, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 0),
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
                                                if (_bekreftIsLoading) return;

                                                _bekreftIsLoading = true;
                                                _showLoadingDialog();
                                                String? token =
                                                    await firebaseAuthService
                                                        .getToken(context);
                                                if (token != null) {
                                                  final response =
                                                      await PurchaseService
                                                          .hentMat(
                                                              id: ordreInfo.id,
                                                              hentet: true,
                                                              token: token);
                                                  if (response.statusCode ==
                                                      200) {
                                                    toasts.showAccepted(context,
                                                        'Handelen er fullført');
                                                    _hideLoadingDialog();
                                                    Navigator.pop(context);
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      isDismissible: false,
                                                      enableDrag: false,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      barrierColor:
                                                          const Color.fromARGB(
                                                              60, 17, 0, 0),
                                                      useRootNavigator: true,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () =>
                                                              FocusScope.of(
                                                                      context)
                                                                  .unfocus(),
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child: GiveRatingWidget(
                                                                kjop: true,
                                                                username:
                                                                    ordreInfo
                                                                        .selger),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {
                                                          _bekreftIsLoading =
                                                              false;
                                                        }));
                                                  } else {
                                                    _hideLoadingDialog();
                                                    toasts.showErrorToast(
                                                        context,
                                                        'En uforventet feil oppstod');
                                                  }
                                                }
                                              } on SocketException {
                                                _hideLoadingDialog();
                                                toasts.showErrorToast(context,
                                                    'Ingen internettforbindelse');
                                              } catch (e) {
                                                _hideLoadingDialog();
                                                Navigator.pop(context);
                                                toasts.showErrorToast(
                                                    context, 'En feil oppstod');
                                              }
                                            },
                                            child: const Text(
                                              "Ja, bekreft",
                                              style: TextStyle(
                                                color:
                                                    CupertinoColors.systemBlue,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                text: 'Bekreft mottatt',
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 47,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      11, 0, 0, 0),
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
                                        fontSize: 16,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  elevation: 0,
                                  borderSide: BorderSide(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    width: 0.7,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 12, 0, 0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  try {
                                    // Prevent multiple submissions while loading
                                    if (_messageIsLoading) return;
                                    _messageIsLoading = true;

                                    Conversation existingConversation =
                                        FFAppState().conversations.firstWhere(
                                      (conv) => conv.user == ordreInfo.selger,
                                      orElse: () {
                                        // If no conversation is found, create a new one and add it to the list
                                        final newConversation = Conversation(
                                          username:
                                              ordreInfo.selgerUsername ?? '',
                                          user: ordreInfo.selger,
                                          lastactive:
                                              ordreInfo.foodDetails.lastactive,
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
                                  width: double.infinity,
                                  height: 47,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      11, 0, 0, 0),
                                  iconPadding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 0),
                                  color: FlutterFlowTheme.of(context).alternate,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Nunito',
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
