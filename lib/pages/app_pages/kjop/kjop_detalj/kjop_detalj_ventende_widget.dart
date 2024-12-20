import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:mat_salg/my_ip.dart';
import 'package:mat_salg/helper_components/toasts.dart';
import 'package:mat_salg/pages/app_pages/hjem/rapporter/rapporter_widget.dart';
import 'package:mat_salg/pages/app_pages/kart/kart_pop_up/kart_pop_up_widget.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/services/kommune_service.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:flutter/material.dart';
import 'kjop_detalj_ventende_model.dart';
export 'kjop_detalj_ventende_model.dart';

class KjopDetaljVentendeWidget extends StatefulWidget {
  const KjopDetaljVentendeWidget({
    super.key,
    this.ordre,
    this.mine,
  });

  final dynamic ordre;
  final dynamic mine;

  @override
  State<KjopDetaljVentendeWidget> createState() =>
      _KjopDetaljVentendeWidgetState();
}

class _KjopDetaljVentendeWidgetState extends State<KjopDetaljVentendeWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final KommuneService kommuneService = KommuneService();
  final Toasts toasts = Toasts();
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  late KjopDetaljVentendeModel _model;
  late OrdreInfo ordreInfo;

  bool _messageIsLoading = false;
  bool _isExpanded = false;
  String? poststed;

  @override
  void initState() {
    super.initState();
    getPoststed();
    _model = createModel(context, () => KjopDetaljVentendeModel());
    ordreInfo = widget.ordre;
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

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

  Future<void> getPoststed() async {
    try {
      String? token = await firebaseAuthService.getToken(context);

      if (token == null) {
        return;
      } else {
        if (ordreInfo.foodDetails.lat == 0 || ordreInfo.foodDetails.lng == 0) {
          poststed = null;
        }
        if ((ordreInfo.foodDetails.lat == null ||
                ordreInfo.foodDetails.lat == 0) ||
            (ordreInfo.foodDetails.lng == null ||
                ordreInfo.foodDetails.lng == 0)) {
          poststed = null;
        }

        String? response = await kommuneService.getKommune(token,
            ordreInfo.foodDetails.lat ?? 0, ordreInfo.foodDetails.lng ?? 0);
        safeSetState(() {
          if (response.isNotEmpty) {
            String formattedResponse =
                response[0].toUpperCase() + response.substring(1).toLowerCase();
            poststed = formattedResponse;
          }
        });
      }
    } on SocketException {
      toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async => false,
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
                try {
                  context.safePop();
                } on SocketException {
                  toasts.showErrorToast(context, 'Ingen internettforbindelse');
                } catch (e) {
                  toasts.showErrorToast(context, 'En feil oppstod');
                }
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 28,
              ),
            ),
            actions: [],
            title: Text(
              ordreInfo.foodDetails.name ?? '',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Nunito',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 17,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: SafeArea(
            top: true,
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    primary: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 5, 0, 0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  try {
                                    if (widget.mine != true) {
                                      context.pushNamed(
                                        'BrukerPage2',
                                        queryParameters: {
                                          'uid': serializeParam(
                                            ordreInfo.selger,
                                            ParamType.String,
                                          ),
                                          'username': serializeParam(
                                            ordreInfo.selgerUsername,
                                            ParamType.String,
                                          ),
                                          'fromChat': serializeParam(
                                            true,
                                            ParamType.bool,
                                          ),
                                        },
                                      );
                                    }
                                  } on SocketException {
                                    toasts.showErrorToast(
                                        context, 'Ingen internettforbindelse');
                                  } catch (e) {
                                    toasts.showErrorToast(
                                        context, 'En feil oppstod');
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 0, 0, 15),
                                          child: Container(
                                            width: 44,
                                            height: 44,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: Image.network(
                                              '${ApiConstants.baseUrl}${ordreInfo.foodDetails.profilepic}',
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object error,
                                                      StackTrace? stackTrace) {
                                                return Image.asset(
                                                  'assets/images/profile_pic.png',
                                                  width: 44.0,
                                                  height: 44.0,
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      8.0, 0.0, 0.0, 15.0),
                                              child: Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: ordreInfo
                                                              .foodDetails
                                                              .username ??
                                                          '',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'Nunito',
                                                            fontSize: 17.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                    TextSpan(
                                                      text: (calculateDistance(
                                                                  FFAppState()
                                                                      .brukerLat,
                                                                  FFAppState()
                                                                      .brukerLng,
                                                                  ordreInfo
                                                                          .foodDetails
                                                                          .lat ??
                                                                      0.0,
                                                                  ordreInfo
                                                                          .foodDetails
                                                                          .lng ??
                                                                      0.0) <
                                                              1)
                                                          ? (poststed != null
                                                              ? '\n${poststed}, 1 Km'
                                                              : '\n1 Km')
                                                          : (poststed != null
                                                              ? '\n${poststed ?? ''}, ${calculateDistance(FFAppState().brukerLat, FFAppState().brukerLng, ordreInfo.foodDetails.lat ?? 0.0, ordreInfo.foodDetails.lng ?? 0.0).toStringAsFixed(0)}Km'
                                                              : '\n${calculateDistance(FFAppState().brukerLat, FFAppState().brukerLng, ordreInfo.foodDetails.lat ?? 0.0, ordreInfo.foodDetails.lng ?? 0.0).toStringAsFixed(0)}Km'),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'Nunito',
                                                            fontSize: 14.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText, // Grey color
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
                                    if (widget.mine != true)
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 8, 0),
                                        child: IconButton(
                                          icon: Icon(
                                            CupertinoIcons.ellipsis,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            size: 28.0,
                                          ),
                                          onPressed: () {
                                            showCupertinoModalPopup(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return CupertinoActionSheet(
                                                  actions: <Widget>[
                                                    CupertinoActionSheetAction(
                                                      onPressed: () async {
                                                        try {
                                                          // Prevent multiple submissions while loading
                                                          if (_messageIsLoading)
                                                            return;
                                                          _messageIsLoading =
                                                              true;

                                                          Conversation
                                                              existingConversation =
                                                              FFAppState()
                                                                  .conversations
                                                                  .firstWhere(
                                                            (conv) =>
                                                                conv.user ==
                                                                ordreInfo
                                                                    .foodDetails
                                                                    .uid,
                                                            orElse: () {
                                                              final newConversation =
                                                                  Conversation(
                                                                username: ordreInfo
                                                                        .foodDetails
                                                                        .username ??
                                                                    '',
                                                                user: ordreInfo
                                                                        .foodDetails
                                                                        .uid ??
                                                                    '',
                                                                lastactive: ordreInfo
                                                                    .foodDetails
                                                                    .lastactive,
                                                                profilePic: ordreInfo
                                                                        .foodDetails
                                                                        .profilepic ??
                                                                    '',
                                                                messages: [],
                                                              );

                                                              FFAppState()
                                                                  .conversations
                                                                  .add(
                                                                      newConversation);

                                                              // Return the new conversation
                                                              return newConversation;
                                                            },
                                                          );

                                                          String?
                                                              serializedConversation =
                                                              serializeParam(
                                                            existingConversation
                                                                .toJson(),
                                                            ParamType.JSON,
                                                          );

                                                          _messageIsLoading =
                                                              false;
                                                          if (serializedConversation !=
                                                              null) {
                                                            Navigator.pop(
                                                                context);
                                                            context.pushNamed(
                                                              'message',
                                                              queryParameters: {
                                                                'conversation':
                                                                    serializedConversation,
                                                              },
                                                            );
                                                          }
                                                        } on SocketException {
                                                          _messageIsLoading =
                                                              false;
                                                          toasts.showErrorToast(
                                                              context,
                                                              'Ingen internettforbindelse');
                                                        } catch (e) {
                                                          _messageIsLoading =
                                                              false;
                                                          toasts.showErrorToast(
                                                              context,
                                                              'En feil oppstod');
                                                        }
                                                      },
                                                      child: const Text(
                                                        'Send melding',
                                                        style: TextStyle(
                                                          fontSize: 19,
                                                          color: CupertinoColors
                                                              .systemBlue,
                                                        ),
                                                      ),
                                                    ),
                                                    CupertinoActionSheetAction(
                                                      onPressed: () async {
                                                        await showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          barrierColor:
                                                              const Color
                                                                  .fromARGB(
                                                                  60, 17, 0, 0),
                                                          useRootNavigator:
                                                              true,
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
                                                                child:
                                                                    RapporterWidget(
                                                                  username:
                                                                      ordreInfo
                                                                          .foodDetails
                                                                          .uid,
                                                                  matId: ordreInfo
                                                                      .foodDetails
                                                                      .matId,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ).then((value) =>
                                                            setState(() {}));
                                                        return;
                                                      },
                                                      child: const Text(
                                                        'Rapporter',
                                                        style: TextStyle(
                                                          fontSize: 19,
                                                          color: Colors
                                                              .red, // Red text for 'Slett annonse'
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                  cancelButton:
                                                      CupertinoActionSheetAction(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context); // Close the action sheet
                                                    },
                                                    isDefaultAction: true,
                                                    child: const Text(
                                                      'Avbryt',
                                                      style: TextStyle(
                                                        fontSize: 19,
                                                        color: CupertinoColors
                                                            .systemBlue,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Builder(
                                    builder: (context) => InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onDoubleTap: () async {},
                                      child: Container(
                                        width: double.infinity,
                                        height: 485,
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: 485,
                                              child: Stack(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0, 0, 0, 40),
                                                    child: PageView(
                                                      controller: _model
                                                              .pageViewController ??=
                                                          PageController(
                                                              initialPage: 0),
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      children: [
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          height: 485,
                                                          child: Stack(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            0),
                                                                child: Image
                                                                    .network(
                                                                  '${ApiConstants.baseUrl}${ordreInfo.foodDetails.imgUrls![0]}',
                                                                  width: double
                                                                      .infinity,
                                                                  height: 485,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  alignment:
                                                                      const Alignment(
                                                                          0.0,
                                                                          0.0),
                                                                  errorBuilder: (BuildContext
                                                                          context,
                                                                      Object
                                                                          error,
                                                                      StackTrace?
                                                                          stackTrace) {
                                                                    return Image
                                                                        .asset(
                                                                      'assets/images/error_image.jpg', // Path to your local error image
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          485.0,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        if (ordreInfo
                                                                .foodDetails
                                                                .imgUrls!
                                                                .length >
                                                            1)
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            height: 485,
                                                            child: Stack(
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              0),
                                                                  child: Image
                                                                      .network(
                                                                    '${ApiConstants.baseUrl}${ordreInfo.foodDetails.imgUrls![1]}',
                                                                    width: double
                                                                        .infinity,
                                                                    height:
                                                                        485.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    alignment:
                                                                        const Alignment(
                                                                            0.0,
                                                                            0.0),
                                                                    errorBuilder: (BuildContext
                                                                            context,
                                                                        Object
                                                                            error,
                                                                        StackTrace?
                                                                            stackTrace) {
                                                                      return Image
                                                                          .asset(
                                                                        'assets/images/error_image.jpg',
                                                                        width: double
                                                                            .infinity,
                                                                        height:
                                                                            485.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        if (ordreInfo
                                                                .foodDetails
                                                                .imgUrls!
                                                                .length >
                                                            2)
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            height: 485,
                                                            child: Stack(
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              0),
                                                                  child: Image
                                                                      .network(
                                                                    '${ApiConstants.baseUrl}${ordreInfo.foodDetails.imgUrls![2]}',
                                                                    width: double
                                                                        .infinity,
                                                                    height:
                                                                        485.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    alignment:
                                                                        const Alignment(
                                                                            0.0,
                                                                            0.0),
                                                                    errorBuilder: (BuildContext
                                                                            context,
                                                                        Object
                                                                            error,
                                                                        StackTrace?
                                                                            stackTrace) {
                                                                      return Image
                                                                          .asset(
                                                                        'assets/images/error_image.jpg',
                                                                        width: double
                                                                            .infinity,
                                                                        height:
                                                                            485.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        if (ordreInfo
                                                                .foodDetails
                                                                .imgUrls!
                                                                .length >
                                                            3)
                                                          Container(
                                                            height: 485,
                                                            child: Stack(
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              0),
                                                                  child: Image
                                                                      .network(
                                                                    '${ApiConstants.baseUrl}${ordreInfo.foodDetails.imgUrls![3]}',
                                                                    width: double
                                                                        .infinity,
                                                                    height:
                                                                        485.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    alignment:
                                                                        const Alignment(
                                                                            0.0,
                                                                            0.0),
                                                                    errorBuilder: (BuildContext
                                                                            context,
                                                                        Object
                                                                            error,
                                                                        StackTrace?
                                                                            stackTrace) {
                                                                      return Image
                                                                          .asset(
                                                                        'assets/images/error_image.jpg',
                                                                        width: double
                                                                            .infinity,
                                                                        height:
                                                                            485.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        if (ordreInfo
                                                                .foodDetails
                                                                .imgUrls!
                                                                .length >
                                                            4)
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            height: 485,
                                                            child: Stack(
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              0),
                                                                  child: Image
                                                                      .network(
                                                                    '${ApiConstants.baseUrl}${ordreInfo.foodDetails.imgUrls![4]}',
                                                                    width: double
                                                                        .infinity,
                                                                    height:
                                                                        485.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    alignment:
                                                                        const Alignment(
                                                                            0.0,
                                                                            0.0),
                                                                    errorBuilder: (BuildContext
                                                                            context,
                                                                        Object
                                                                            error,
                                                                        StackTrace?
                                                                            stackTrace) {
                                                                      return Image
                                                                          .asset(
                                                                        'assets/images/error_image.jpg',
                                                                        width: double
                                                                            .infinity,
                                                                        height:
                                                                            485.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        const AlignmentDirectional(
                                                            0, 1),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              16, 0, 0, 16),
                                                      child: smooth_page_indicator
                                                          .SmoothPageIndicator(
                                                        controller: _model
                                                                .pageViewController ??=
                                                            PageController(
                                                                initialPage: 0),
                                                        count: ordreInfo
                                                            .foodDetails
                                                            .imgUrls!
                                                            .length,
                                                        axisDirection:
                                                            Axis.horizontal,
                                                        onDotClicked:
                                                            (i) async {
                                                          try {
                                                            await _model
                                                                .pageViewController!
                                                                .animateToPage(
                                                              i,
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          500),
                                                              curve:
                                                                  Curves.ease,
                                                            );
                                                            safeSetState(() {});
                                                          } on SocketException {
                                                            toasts.showErrorToast(
                                                                context,
                                                                'Ingen internettforbindelse');
                                                          } catch (e) {
                                                            toasts.showErrorToast(
                                                                context,
                                                                'En feil oppstod');
                                                          }
                                                        },
                                                        effect: smooth_page_indicator
                                                            .ExpandingDotsEffect(
                                                          expansionFactor: 1.1,
                                                          spacing: 8.0,
                                                          radius: 16.0,
                                                          dotWidth: 7,
                                                          dotHeight: 7,
                                                          dotColor: const Color(
                                                              0xFFE6E6E6),
                                                          activeDotColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .alternate,
                                                          paintStyle:
                                                              PaintingStyle
                                                                  .fill,
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
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              5.0, 00.0, 15.0, .0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10.0, 0.0, 0.0, 8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(3.0, 0.0, 0.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              try {
                                                double startLat =
                                                    ordreInfo.foodDetails.lat ??
                                                        59.9138688;
                                                double startLng =
                                                    ordreInfo.foodDetails.lng ??
                                                        10.7522454;
                                                await showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  barrierColor:
                                                      const Color.fromARGB(
                                                          60, 17, 0, 0),
                                                  useRootNavigator: true,
                                                  enableDrag: true,
                                                  context: context,
                                                  builder: (context) {
                                                    return GestureDetector(
                                                      onTap: () =>
                                                          FocusScope.of(context)
                                                              .unfocus(),
                                                      child: Padding(
                                                        padding: MediaQuery
                                                            .viewInsetsOf(
                                                                context),
                                                        child: KartPopUpWidget(
                                                          startLat: startLat,
                                                          startLng: startLng,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ).then((value) =>
                                                    safeSetState(() {}));
                                              } on SocketException {
                                                toasts.showErrorToast(context,
                                                    'Ingen internettforbindelse');
                                              } catch (e) {
                                                toasts.showErrorToast(
                                                    context, 'En feil oppstod');
                                              }
                                            },
                                            child: Icon(
                                              CupertinoIcons.map,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              size: 32,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (widget.mine != true)
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                try {
                                                  // Prevent multiple submissions while loading
                                                  if (_messageIsLoading) return;
                                                  _messageIsLoading = true;

                                                  Conversation
                                                      existingConversation =
                                                      FFAppState()
                                                          .conversations
                                                          .firstWhere(
                                                    (conv) =>
                                                        conv.user ==
                                                        ordreInfo.selger,
                                                    orElse: () {
                                                      // If no conversation is found, create a new one and add it to the list
                                                      final newConversation =
                                                          Conversation(
                                                        username: ordreInfo
                                                                .selgerUsername ??
                                                            '',
                                                        user: ordreInfo.selger,
                                                        lastactive: ordreInfo
                                                            .lastactive,
                                                        profilePic: ordreInfo
                                                                .foodDetails
                                                                .profilepic ??
                                                            '',
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
                                                  String?
                                                      serializedConversation =
                                                      serializeParam(
                                                    existingConversation
                                                        .toJson(), // Convert the conversation to JSON
                                                    ParamType.JSON,
                                                  );

                                                  // Step 4: Stop loading and navigate to message screen
                                                  _messageIsLoading = false;
                                                  if (serializedConversation !=
                                                      null) {
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
                                                  toasts.showErrorToast(context,
                                                      'Ingen internettforbindelse');
                                                } catch (e) {
                                                  _messageIsLoading = false;
                                                  toasts.showErrorToast(context,
                                                      'En feil oppstod');
                                                }
                                              },
                                              child: Material(
                                                color: Colors.transparent,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                child: SafeArea(
                                                  child: Container(
                                                    width: 105,
                                                    height: 40,
                                                    constraints:
                                                        const BoxConstraints(
                                                      maxWidth: 174,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              10, 0, 10, 0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              'Melding',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Nunito',
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        15,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
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
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 8, 0, 12),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 12.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ordreInfo.foodDetails.name ??
                                                    '',
                                                textAlign: TextAlign.start,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 17.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: ordreInfo.foodDetails.kg ==
                                                    true
                                                ? const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                    0.0, 0.0, 5.0, 0.0)
                                                : const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                    0.0, 0.0, 10.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${ordreInfo.foodDetails.price ?? 0} Kr',
                                                  textAlign: TextAlign.center,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .headlineMedium
                                                      .override(
                                                        fontFamily: 'Nunito',
                                                        fontSize: 17.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                if (ordreInfo.foodDetails.kg ==
                                                    true)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                            10.0, 0.0),
                                                    child: Text(
                                                      '/kg',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'Nunito',
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText,
                                                            fontSize: 20.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width:
                                                332.0, // Width constraint to enable wrapping
                                            child: Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '${ordreInfo.foodDetails.username}  ',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 15.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                  TextSpan(
                                                    text: _isExpanded
                                                        ? ordreInfo.foodDetails
                                                            .description // Full text if expanded
                                                        : (ordreInfo
                                                                        .foodDetails
                                                                        .description!
                                                                        .length >
                                                                    100 ||
                                                                '\n'
                                                                        .allMatches(ordreInfo
                                                                            .foodDetails
                                                                            .description!)
                                                                        .length >=
                                                                    2
                                                            ? "${ordreInfo.foodDetails.description!.substring(0, ordreInfo.foodDetails.description!.length > 100 ? 100 : ordreInfo.foodDetails.description!.indexOf('\n', ordreInfo.foodDetails.description!.indexOf('\n') + 1) + 1)}..." // Truncate based on condition
                                                            : ordreInfo
                                                                .foodDetails
                                                                .description), // Use full text if it doesn't meet truncation conditions
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 15.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              textAlign: TextAlign.start,
                                              softWrap:
                                                  true, // Enable text wrapping
                                              overflow: TextOverflow
                                                  .visible, // Visible overflow when expanded
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (ordreInfo.foodDetails.description !=
                                            null &&
                                        (ordreInfo.foodDetails.description!
                                                    .length >
                                                100 ||
                                            '\n'
                                                    .allMatches(ordreInfo
                                                        .foodDetails
                                                        .description!)
                                                    .length >=
                                                2))
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isExpanded =
                                                !_isExpanded; // Toggle expand/collapse
                                          });
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            _isExpanded
                                                ? 'Se mindre'
                                                : 'Se mer', // Dynamic toggle text
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  fontFamily: 'Nunito',
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.w700,
                                                  color: const Color.fromRGBO(
                                                      113, 113, 113, 1.0),
                                                ),
                                          ),
                                        ),
                                      ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 16.0, 16.0, 5.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(children: [
                                            const SizedBox(
                                              height: 40,
                                              child: VerticalDivider(
                                                thickness: 1,
                                                color: Color.fromARGB(
                                                    48, 113, 113, 113),
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'PRIS',
                                                  textAlign: TextAlign.start,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleMedium
                                                      .override(
                                                        fontFamily: 'Nunito',
                                                        fontSize: 13.0,
                                                        letterSpacing: 0.0,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 113, 113, 113),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                Text(
                                                  '${ordreInfo.foodDetails.price}Kr',
                                                  textAlign: TextAlign.start,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleMedium
                                                      .override(
                                                        fontFamily: 'Nunito',
                                                        fontSize: 13.0,
                                                        letterSpacing: 0.0,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 113, 113, 113),
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                  color: Color.fromARGB(
                                                      48, 113, 113, 113),
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'ANTALL',
                                                    textAlign: TextAlign.start,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .titleMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 13.0,
                                                          letterSpacing: 0.0,
                                                          color: const Color
                                                              .fromARGB(255,
                                                              113, 113, 113),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0, 0, 0, 0),
                                                    child: Text(
                                                      '${ordreInfo.antall.toStringAsFixed(0)} ${ordreInfo.foodDetails.kg == true ? 'Kg' : 'stk'}',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .titleMedium
                                                          .override(
                                                            fontFamily:
                                                                'Nunito',
                                                            fontSize: 13.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: const Color
                                                                .fromARGB(255,
                                                                113, 113, 113),
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
                                                  color: Color.fromARGB(
                                                      48, 113, 113, 113),
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'UTLØPER',
                                                    textAlign: TextAlign.start,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .titleMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 13.0,
                                                          letterSpacing: 0.0,
                                                          color: const Color
                                                              .fromARGB(255,
                                                              113, 113, 113),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            5, 0, 0, 0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          ordreInfo.updatetime !=
                                                                  null
                                                              ? (DateFormat(
                                                                      "d. MMM  HH:mm",
                                                                      "nb_NO")
                                                                  .format(ordreInfo
                                                                      .updatetime!
                                                                      .toLocal()
                                                                      .add(Duration(
                                                                          days:
                                                                              3))))
                                                              : "",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .titleMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Nunito',
                                                                fontSize: 13.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    113,
                                                                    113,
                                                                    113),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                            ],
                          ),
                        ),
                      ].addToEnd(const SizedBox(height: 150)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
