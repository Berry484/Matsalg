import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mat_salg/ApiCalls.dart';
import 'package:mat_salg/MyIP.dart';
import 'package:mat_salg/SecureStorage.dart';
import 'package:mat_salg/app_main/vanlig_bruker/hjem/rapporter/rapporter_widget.dart';
import 'package:mat_salg/flutter_flow/flutter_flow_animations.dart';
import 'package:mat_salg/app_main/vanlig_bruker/kart/kart_pop_up/kart_pop_up_widget.dart';
import 'package:mat_salg/logging.dart';
import 'package:shimmer/shimmer.dart';

import '/app_main/vanlig_bruker/hjem/info/info_widget.dart';
import '/app_main/vanlig_bruker/kart/kart_pop_up_bondegard/kart_pop_up_bondegard_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'mat_detalj_bondegard_model.dart';
export 'mat_detalj_bondegard_model.dart';
import 'dart:math';

class MatDetaljBondegardWidget extends StatefulWidget {
  const MatDetaljBondegardWidget({
    super.key,
    required this.matvare,
  });

  final dynamic matvare;

  @override
  State<MatDetaljBondegardWidget> createState() =>
      _MatDetaljBondegardWidgetState();
}

class _MatDetaljBondegardWidgetState extends State<MatDetaljBondegardWidget> {
  late MatDetaljBondegardModel _model;
  List<Matvarer>? _nyematvarer;
  final ApiCalls apiCalls = ApiCalls();
  bool _isloading = true;
  late Matvarer matvare;
  final Securestorage securestorage = Securestorage();
  final ApiLike apiLike = ApiLike();
  bool? brukerFolger = false;
  bool _messageIsLoading = false;
  bool _showHeart = false;
  final animationsMap = <String, AnimationInfo>{};
  bool _isAnimating = false;
  bool _isExpanded = false;
  String? poststed;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    matvare = Matvarer.fromJson1(widget.matvare);
    getPoststed();
    _model = createModel(context, () => MatDetaljBondegardModel());
    getAllFoods();
    _model.liker = matvare.liked;

    // Adding the animation for the heart icon
    animationsMap.addAll({
      'iconOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.bounceOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: const Offset(1.2, 1.2),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
    });
  }

  // Trigger animation manually when the liker value changes
  void _triggerHeartAnimation() {
    if (_isAnimating)
      return; // Prevent triggering animation if it's already running

    setState(() {
      _isAnimating = true; // Set flag to indicate animation is running
      _showHeart = true; // Show the heart icon
    });

    // Start a timer to hide the heart after 1.5 seconds
    Timer(const Duration(seconds: 1, milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showHeart = false; // Hide the heart icon
          _isAnimating = false; // Reset the animation flag
        });
      }
    });
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
            ),
            child: Row(
              children: [
                const Icon(
                  // ignore: deprecated_member_use
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

  Future<void> getAllFoods() async {
    try {
      String? token = await Securestorage().readToken();
      if (token == null) {
        FFAppState().login = false;
        context.goNamed('registrer');
        return;
      } else {
        _nyematvarer = await ApiGetAllFoods.getAllFoods(token);
        setState(() {
          if (_nyematvarer != null && _nyematvarer!.isNotEmpty) {
            _isloading = false;
            return;
          } else {
            _isloading = true;
          }
        });
      }
    } on SocketException {
      HapticFeedback.lightImpact();
      showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      HapticFeedback.lightImpact();
      showErrorToast(context, 'En feil oppstod');
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

  Future<void> getPoststed() async {
    try {
      String? token = await Securestorage().readToken();

      if (token == null) {
        FFAppState().login = false;
        context.goNamed('registrer');
        return;
      } else {
        if (matvare.lat == 0 || matvare.lng == 0) {
          poststed = null;
        }
        if ((matvare.lat == null || matvare.lat == 0) ||
            (matvare.lng == null || matvare.lng == 0)) {
          poststed = null;
        }
        String? response = await apiCalls.leggutgetKommune(
            token, matvare.lat ?? 0, matvare.lng ?? 0);
        safeSetState(() {
          if (response.isNotEmpty) {
            String formattedResponse =
                response[0].toUpperCase() + response.substring(1).toLowerCase();
            poststed = formattedResponse;
            logger.d(formattedResponse);
          }
        });
      }
    } on SocketException {
      HapticFeedback.lightImpact();
      showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      HapticFeedback.lightImpact();
      showErrorToast(context, 'En feil oppstod');
    }
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
          backgroundColor: FlutterFlowTheme.of(context).primary,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).alternate),
            automaticallyImplyLeading: true,
            scrolledUnderElevation: 0.0,
            leading: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                context.safePop();
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 28.0,
              ),
            ),
            actions: const [],
            title: Text(
              matvare.name ?? '',
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
            elevation: 0.0,
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
                                  0.0, 5.0, 0.0, 0.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  setState(() {});
                                  context.pushNamed(
                                    'BrukerPage',
                                    queryParameters: {
                                      'username': serializeParam(
                                        matvare.username,
                                        ParamType.String,
                                      ),
                                    },
                                  );
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
                                              .fromSTEB(10.0, 0.0, 0.0, 15.0),
                                          child: Container(
                                            width: 44.0,
                                            height: 44.0,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: Image.network(
                                              '${ApiConstants.baseUrl}${matvare.profilepic}',
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
                                                      text: matvare.username ??
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
                                                                  matvare.lat ??
                                                                      0.0,
                                                                  matvare.lng ??
                                                                      0.0) <
                                                              1)
                                                          ? (poststed != null
                                                              ? '\n${poststed}, 1 Km'
                                                              : '\n1 Km')
                                                          : (poststed != null
                                                              ? '\n${poststed ?? ''}, ${calculateDistance(FFAppState().brukerLat, FFAppState().brukerLng, matvare.lat ?? 0.0, matvare.lng ?? 0.0).toStringAsFixed(0)}Km'
                                                              : '\n${calculateDistance(FFAppState().brukerLat, FFAppState().brukerLng, matvare.lat ?? 0.0, matvare.lng ?? 0.0).toStringAsFixed(0)}Km'),
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
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 8, 0),
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
                                                              matvare.username,
                                                          orElse: () {
                                                            final newConversation =
                                                                Conversation(
                                                              user: matvare
                                                                      .username ??
                                                                  '',
                                                              profilePic: matvare
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
                                                        HapticFeedback
                                                            .lightImpact();
                                                        showErrorToast(context,
                                                            'Ingen internettforbindelse');
                                                      } catch (e) {
                                                        _messageIsLoading =
                                                            false;
                                                        HapticFeedback
                                                            .lightImpact();
                                                        showErrorToast(context,
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
                                                            Colors.transparent,
                                                        barrierColor:
                                                            const Color
                                                                .fromARGB(
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
                                                              child:
                                                                  RapporterWidget(
                                                                username: matvare
                                                                    .username,
                                                                matId: matvare
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
                                      onDoubleTap: () async {
                                        try {
                                          _model.liker =
                                              !(_model.liker ?? true);
                                          HapticFeedback.lightImpact();
                                          apiLike.deleteLike(
                                              Securestorage.authToken,
                                              matvare.matId);
                                          safeSetState(() {});
                                          if (_model.liker == true) {
                                            HapticFeedback.lightImpact();
                                            _triggerHeartAnimation();
                                            apiLike.sendLike(
                                                Securestorage.authToken,
                                                matvare.matId);
                                          }
                                        } on SocketException {
                                          HapticFeedback.lightImpact();
                                          showErrorToast(context,
                                              'Ingen internettforbindelse');
                                        } catch (e) {
                                          HapticFeedback.lightImpact();
                                          showErrorToast(
                                              context, 'En feil oppstod');
                                        }
                                      },
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 485,
                                        child: Stack(
                                          children: [
                                            SizedBox(
                                              width: double.infinity,
                                              height: 485,
                                              child: Stack(
                                                children: [
                                                  Padding(
                                                    padding: matvare.kjopt ==
                                                            true
                                                        ? const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0.0, 0.0, 0.0, 40.0)
                                                        : const EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                            0.0, 40.0),
                                                    child: PageView(
                                                      controller: _model
                                                              .pageViewController ??=
                                                          PageController(
                                                              initialPage: 0),
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      children: [
                                                        SizedBox(
                                                          width:
                                                              double.infinity,
                                                          height: 485,
                                                          child: Stack(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            0.0),
                                                                child: Image
                                                                    .network(
                                                                  '${ApiConstants.baseUrl}${matvare.imgUrls![0]}',
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
                                                        if (matvare.imgUrls!
                                                                .length >
                                                            1)
                                                          SizedBox(
                                                            width:
                                                                double.infinity,
                                                            height: 485,
                                                            child: Stack(
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              0.0),
                                                                  child: Image
                                                                      .network(
                                                                    '${ApiConstants.baseUrl}${matvare.imgUrls![1]}',
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
                                                        if (matvare.imgUrls!
                                                                .length >
                                                            2)
                                                          SizedBox(
                                                            width:
                                                                double.infinity,
                                                            height: 485,
                                                            child: Stack(
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              0.0),
                                                                  child: Image
                                                                      .network(
                                                                    '${ApiConstants.baseUrl}${matvare.imgUrls![2]}',
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
                                                        if (matvare.imgUrls!
                                                                .length >
                                                            3)
                                                          SizedBox(
                                                            height: 485,
                                                            child: Stack(
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              0.0),
                                                                  child: Image
                                                                      .network(
                                                                    '${ApiConstants.baseUrl}${matvare.imgUrls![3]}',
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
                                                        if (matvare.imgUrls!
                                                                .length >
                                                            4)
                                                          SizedBox(
                                                            width:
                                                                double.infinity,
                                                            height: 485,
                                                            child: Stack(
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              0.0),
                                                                  child: Image
                                                                      .network(
                                                                    '${ApiConstants.baseUrl}${matvare.imgUrls![4]}',
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
                                                      ],
                                                    ),
                                                  ),
                                                  if (matvare.kjopt == true)
                                                    Positioned(
                                                      top:
                                                          18, // Slight offset from the top edge
                                                      right:
                                                          -25, // Fine-tune the positioning (shift it to the right edge)
                                                      child: Transform.rotate(
                                                        angle:
                                                            0.600, // 45-degree angle (approx.)
                                                        child: Container(
                                                          width:
                                                              140, // Adjusted width to avoid overflow after rotation
                                                          height: 25,
                                                          color:
                                                              Colors.redAccent,
                                                          alignment:
                                                              Alignment.center,
                                                          padding: const EdgeInsets
                                                              .only(
                                                              right:
                                                                  2), // Add padding inside the container to adjust text placement
                                                          child: const Text(
                                                            'Utsolgt',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  15, // Font size adjusted to fit the banner
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  Align(
                                                    alignment:
                                                        const AlignmentDirectional(
                                                            0.0, 1.0),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(16.0,
                                                              0.0, 0.0, 16.0),
                                                      child: smooth_page_indicator
                                                          .SmoothPageIndicator(
                                                        controller: _model
                                                                .pageViewController ??=
                                                            PageController(
                                                                initialPage: 0),
                                                        count: matvare
                                                            .imgUrls!.length,
                                                        axisDirection:
                                                            Axis.horizontal,
                                                        onDotClicked:
                                                            (i) async {
                                                          await _model
                                                              .pageViewController!
                                                              .animateToPage(
                                                            i,
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        500),
                                                            curve: Curves.ease,
                                                          );
                                                          safeSetState(() {});
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
                                            if (_showHeart)
                                              Align(
                                                alignment: Alignment
                                                    .center, // Center the heart icon
                                                child: Icon(
                                                  CupertinoIcons.heart_fill,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  size: 130.0,
                                                ).animateOnPageLoad(animationsMap[
                                                    'iconOnPageLoadAnimation']!),
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
                              5.0, 0.0, 15.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        ToggleIcon(
                                          onPressed: () async {
                                            HapticFeedback.lightImpact();
                                            safeSetState(() =>
                                                _model.liker = !_model.liker!);
                                            if (_model.liker!) {
                                              _triggerHeartAnimation();
                                              apiLike.sendLike(
                                                  Securestorage.authToken,
                                                  matvare.matId);
                                            } else {
                                              apiLike.deleteLike(
                                                  Securestorage.authToken,
                                                  matvare.matId);
                                            }
                                          },
                                          value: _model.liker!,
                                          onIcon: const Icon(
                                            CupertinoIcons.heart_fill,
                                            color: Color.fromARGB(
                                                255, 255, 42, 56),
                                            size: 32.0,
                                          ),
                                          offIcon: Icon(
                                            CupertinoIcons.heart,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            size: 32,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(3.0, 0.0, 0.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              double startLat =
                                                  matvare.lat ?? 59.9138688;
                                              double startLng =
                                                  matvare.lng ?? 10.7522454;
                                              if (matvare.bonde == true) {
                                                await showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  barrierColor:
                                                      const Color.fromARGB(
                                                          60, 17, 0, 0),
                                                  useRootNavigator: true,
                                                  enableDrag: true,
                                                  isDismissible: true,
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
                                                        child:
                                                            KartPopUpBondegardWidget(
                                                          startLat: startLat,
                                                          startLng: startLng,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ).then((value) =>
                                                    safeSetState(() {}));
                                              } else {
                                                await showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  useRootNavigator: true,
                                                  enableDrag: true,
                                                  context: context,
                                                  isDismissible: true,
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
                                              }
                                            },
                                            child: Icon(
                                              CupertinoIcons.map,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(9.0, 0.0, 0.0, 0.0),
                                          child: GestureDetector(
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
                                                      matvare.username,
                                                  orElse: () {
                                                    // If no conversation is found, create a new one and add it to the list
                                                    final newConversation =
                                                        Conversation(
                                                      user: matvare.username ??
                                                          '',
                                                      profilePic:
                                                          matvare.profilepic ??
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
                                                String? serializedConversation =
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
                                                  // GoRouter.of(context)
                                                  //     .pushNamed(
                                                  //   '/message',

                                                  //   queryParameters: {
                                                  //     'conversation':
                                                  //         serializedConversation, // Pass the serialized conversation
                                                  //   },
                                                  //   // extra: {
                                                  //   //   'parentNavigator': null
                                                  //   // }, // No navbar
                                                  // );
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
                                                showErrorToast(context,
                                                    'Ingen internettforbindelse');
                                              } catch (e) {
                                                _messageIsLoading = false;
                                                HapticFeedback.lightImpact();
                                                showErrorToast(
                                                    context, 'En feil oppstod');
                                              }
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(5, 0, 0, 0),
                                              child: Icon(
                                                CupertinoIcons.chat_bubble,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 0, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          if (matvare.kjopt == true ||
                                              matvare.antall == null ||
                                              matvare.antall == 0)
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {},
                                              child: Material(
                                                color: Colors.transparent,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                child: SafeArea(
                                                  child: Container(
                                                    width: 120,
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
                                                              0, 0, 0, 0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              'Få varsling',
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
                                                                        16,
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
                                          if (matvare.kjopt != true &&
                                              matvare.antall != null &&
                                              matvare.antall != 0)
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                await showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  useRootNavigator: true,
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
                                                        child: InfoWidget(
                                                          matinfo:
                                                              matvare.toJson(),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ).then((value) =>
                                                    safeSetState(() {}));
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
                                                    width: 85,
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
                                                              'Kjøp',
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
                                    10.0, 12.0, 0.0, 12.0),
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
                                                matvare.name ?? '',
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
                                            padding: matvare.kg == true
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
                                                  '${matvare.price ?? 0} Kr',
                                                  textAlign: TextAlign.center,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .headlineMedium
                                                      .override(
                                                        fontFamily: 'Nunito',
                                                        fontSize: 18.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                if (matvare.kg == true)
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
                                                        '${matvare.username}  ',
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
                                                        ? matvare
                                                            .description // Full text if expanded
                                                        : (matvare.description!
                                                                        .length >
                                                                    100 ||
                                                                '\n'
                                                                        .allMatches(matvare
                                                                            .description!)
                                                                        .length >=
                                                                    2
                                                            ? "${matvare.description!.substring(0, matvare.description!.length > 100 ? 100 : matvare.description!.indexOf('\n', matvare.description!.indexOf('\n') + 1) + 1)}..." // Truncate based on condition
                                                            : matvare
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
                                    if (matvare.description != null &&
                                        (matvare.description!.length > 100 ||
                                            '\n'
                                                    .allMatches(
                                                        matvare.description!)
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
                                                  '${matvare.price}Kr',
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
                                                      '${matvare.antall!.toStringAsFixed(0)} ${matvare.kg == true ? 'Kg' : 'stk'}',
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
                                                    'AVSTAND',
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
                                                          (calculateDistance(
                                                                      FFAppState()
                                                                          .brukerLat,
                                                                      FFAppState()
                                                                          .brukerLng,
                                                                      matvare.lat ??
                                                                          0.0,
                                                                      matvare.lng ??
                                                                          0.0) <
                                                                  1)
                                                              ? '<1 Km'
                                                              : '${calculateDistance(FFAppState().brukerLat, FFAppState().brukerLng, matvare.lat ?? 0.0, matvare.lng ?? 0.0).toStringAsFixed(0)}Km',
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
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 16.0, 0.0, 20.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Sist endret ${matvare.updatetime != null ? DateFormat("d. MMM", "nb_NO").format(matvare.updatetime!.toLocal()) : ""}',
                                            textAlign: TextAlign.start,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
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
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 16.0, 0.0, 20.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Lignende matvarer',
                                            textAlign: TextAlign.start,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Nunito',
                                                  fontSize: 22,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w800,
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
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              5.0, 0.0, 5.0, 0.0),
                          child: RefreshIndicator(
                            onRefresh: () async {
                              await getAllFoods();
                            },
                            child: GridView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                0,
                                0,
                                0,
                                63.0,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.68,
                              ),
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount:
                                  _isloading ? 1 : _nyematvarer?.length ?? 1,
                              itemBuilder: (context, index) {
                                if (_isloading) {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(5.0),
                                          width: 200.0,
                                          height: 230.0,
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                127, 255, 255, 255),
                                            borderRadius: BorderRadius.circular(
                                                16.0), // Rounded corners
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Container(
                                          width: 200,
                                          height: 15,
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                127, 255, 255, 255),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        // const SizedBox(height: 8.0),
                                        // Align(
                                        //   alignment: Alignment.centerLeft,
                                        //   child: Padding(
                                        //     padding: const EdgeInsets.only(
                                        //         left: 10.0),
                                        //     child: Container(
                                        //       width: 38,
                                        //       height: 15,
                                        //       decoration: BoxDecoration(
                                        //         color: const Color.fromARGB(
                                        //             127, 255, 255, 255),
                                        //         borderRadius:
                                        //             BorderRadius.circular(10.0),
                                        //       ),
                                        //     ),
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  );
                                }
                                final nyematvarer = _nyematvarer![index];

                                return Stack(
                                  children: [
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(0, -1),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed(
                                            'MatDetaljBondegard',
                                            queryParameters: {
                                              'matvare': serializeParam(
                                                nyematvarer
                                                    .toJson(), // Convert to JSON before passing
                                                ParamType.JSON,
                                              ),
                                            },
                                          );
                                        },
                                        child: Material(
                                          color: Colors.transparent,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Container(
                                            width: 235,
                                            height: 290,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              border: Border.all(
                                                color: Colors.transparent,
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0, 0),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            3, 0, 3, 0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              17),
                                                      child: Image.network(
                                                        '${ApiConstants.baseUrl}${nyematvarer.imgUrls![0]}',
                                                        width: 200,
                                                        height: 229,
                                                        fit: BoxFit.cover,
                                                        errorBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Object error,
                                                                StackTrace?
                                                                    stackTrace) {
                                                          return Image.asset(
                                                            'assets/images/error_image.jpg', // Path to your local error image
                                                            width: 200,
                                                            height: 229,
                                                            fit: BoxFit.cover,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(5, 0, 5, 0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            const AlignmentDirectional(
                                                                -1, 0),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  7, 0, 0, 0),
                                                          child: AutoSizeText(
                                                            nyematvarer.name ??
                                                                '',
                                                            textAlign:
                                                                TextAlign.start,
                                                            minFontSize: 11,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyLarge
                                                                .override(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  fontSize: 14,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(0, 0, 0, 4),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Flexible(
                                                        child: Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  0, 0),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    5, 0, 5, 0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            7,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            Text(
                                                                          '${nyematvarer.price} Kr',
                                                                          textAlign:
                                                                              TextAlign.end,
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .titleLarge
                                                                              .override(
                                                                                fontFamily: 'Nunito',
                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                fontSize: 14,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                      if (nyematvarer
                                                                              .kg ==
                                                                          true)
                                                                        Text(
                                                                          '/kg',
                                                                          textAlign:
                                                                              TextAlign.end,
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .titleLarge
                                                                              .override(
                                                                                fontFamily: 'Nunito',
                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                fontSize: 14,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                        ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0,
                                                                          0,
                                                                          7,
                                                                          0),
                                                                      child:
                                                                          Text(
                                                                        // Directly calculate the distance using the provided latitude and longitude
                                                                        (calculateDistance(FFAppState().brukerLat, FFAppState().brukerLng, nyematvarer.lat ?? 0.0, nyematvarer.lng ?? 0.0) <
                                                                                1)
                                                                            ? '<1 Km'
                                                                            : '${calculateDistance(FFAppState().brukerLat, FFAppState().brukerLng, nyematvarer.lat ?? 0.0, nyematvarer.lng ?? 0.0).toStringAsFixed(0)} Km',
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Nunito',
                                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                                              fontSize: 14,
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
                                );
                              },
                            ),
                          ),
                        ),
                      ].addToEnd(const SizedBox(height: 150.0)),
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
