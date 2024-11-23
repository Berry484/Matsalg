import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mat_salg/ApiCalls.dart';
import 'package:mat_salg/MyIP.dart';
import 'package:mat_salg/SecureStorage.dart';
import 'package:mat_salg/app_main/vanlig_bruker/kart/kart_pop_up/kart_pop_up_widget.dart';
import 'package:mat_salg/flutter_flow/flutter_flow_animations.dart';
import 'package:mat_salg/matvarer.dart';
import '/app_main/vanlig_bruker/kart/kart_pop_up_bondegard/kart_pop_up_bondegard_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'kjop_detalj_ventende_model.dart';
export 'kjop_detalj_ventende_model.dart';

class KjopDetaljVentendeWidget extends StatefulWidget {
  const KjopDetaljVentendeWidget({
    super.key,
    this.matinfo,
  });

  final dynamic matinfo;

  @override
  State<KjopDetaljVentendeWidget> createState() =>
      _KjopDetaljVentendeWidgetState();
}

class _KjopDetaljVentendeWidgetState extends State<KjopDetaljVentendeWidget> {
  late KjopDetaljVentendeModel _model;
  late Matvarer matvare;
  ApiLike apiLike = ApiLike();
  bool _messageIsLoading = false;
  bool _showHeart = false;
  final animationsMap = <String, AnimationInfo>{};
  bool _isAnimating = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => KjopDetaljVentendeModel());
    matvare = Matvarer.fromJson1(widget.matinfo);
    getChecklike();
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

  Future<void> getChecklike() async {
    try {
      String? token = await Securestorage().readToken();
      if (token == null) {
        FFAppState().login = false;
        context.pushNamed('registrer');
        return;
      } else {
        _model.liker = await ApiCheckLiked.getChecklike(token, matvare.matId);
        setState(() {
          return;
        });
      }
    } on SocketException {
      showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
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
            leading: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                try {
                  context.safePop();
                } on SocketException {
                  showErrorToast(context, 'Ingen internettforbindelse');
                } catch (e) {
                  showErrorToast(context, 'En feil oppstod');
                }
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 28,
              ),
            ),
            actions: [],
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
                                    showErrorToast(
                                        context, 'Ingen internettforbindelse');
                                  } catch (e) {
                                    showErrorToast(context, 'En feil oppstod');
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
                                              '${ApiConstants.baseUrl}${matvare.profilepic}',
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object error,
                                                      StackTrace? stackTrace) {
                                                return Image.asset(
                                                  'assets/images/error_image.jpg', // Path to your local error image
                                                  width: 44,
                                                  height: 44,
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(8, 0, 0, 13),
                                          child: Text(
                                            matvare.username ?? '',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Nunito',
                                                  fontSize: 16.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 8, 0),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 24,
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
                                          HapticFeedback.lightImpact();
                                          _model.liker =
                                              !(_model.liker ?? true);
                                          apiLike.deleteLike(
                                              Securestorage.authToken,
                                              matvare.matId);
                                          safeSetState(() {});
                                          if (_model.liker == true) {
                                            _triggerHeartAnimation();
                                            apiLike.sendLike(
                                                Securestorage.authToken,
                                                matvare.matId);
                                          }
                                        } on SocketException {
                                          showErrorToast(context,
                                              'Ingen internettforbindelse');
                                        } catch (e) {
                                          showErrorToast(
                                              context, 'En feil oppstod');
                                        }
                                      },
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
                                                                  '${ApiConstants.baseUrl}${matvare.imgUrls![0]}',
                                                                  width: double
                                                                      .infinity,
                                                                  height: 525.0,
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
                                                        count: matvare
                                                            .imgUrls!.length,
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
                                                            showErrorToast(
                                                                context,
                                                                'Ingen internettforbindelse');
                                                          } catch (e) {
                                                            showErrorToast(
                                                                context,
                                                                'En feil oppstod');
                                                          }
                                                        },
                                                        effect: const smooth_page_indicator
                                                            .ExpandingDotsEffect(
                                                          expansionFactor: 1.1,
                                                          spacing: 8.0,
                                                          radius: 16.0,
                                                          dotWidth: 8.5,
                                                          dotHeight: 8.5,
                                                          dotColor:
                                                              Color(0xFFE6E6E6),
                                                          activeDotColor:
                                                              Color(0xFFB0B0B0),
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
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        ToggleIcon(
                                          onPressed: () async {
                                            try {
                                              HapticFeedback.lightImpact();
                                              // Toggle the current like state
                                              safeSetState(() => _model.liker =
                                                  !_model.liker!);
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
                                            } on SocketException {
                                              showErrorToast(context,
                                                  'Ingen internettforbindelse');
                                            } catch (e) {
                                              showErrorToast(
                                                  context, 'En feil oppstod');
                                            }
                                          },
                                          value: _model.liker!,
                                          onIcon: const Icon(
                                            CupertinoIcons.heart_fill,
                                            color: Color.fromARGB(
                                                1000, 1000, 0, 0),
                                            size: 34.0,
                                          ),
                                          offIcon: Icon(
                                            CupertinoIcons.heart,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            size: 34,
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
                                              try {
                                                double startLat =
                                                    matvare.lat ?? 59.9138688;
                                                double startLng =
                                                    matvare.lng ?? 10.7522454;
                                                if (matvare.bonde == true) {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    enableDrag: false,
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
                                                    barrierColor:
                                                        const Color.fromARGB(
                                                            60, 17, 0, 0),
                                                    enableDrag: false,
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
                                                              KartPopUpWidget(
                                                            startLat: startLat,
                                                            startLng: startLng,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                }
                                              } on SocketException {
                                                showErrorToast(context,
                                                    'Ingen internettforbindelse');
                                              } catch (e) {
                                                showErrorToast(
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
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 0, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
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
                                                showErrorToast(context,
                                                    'Ingen internettforbindelse');
                                              } catch (e) {
                                                _messageIsLoading = false;
                                                showErrorToast(
                                                    context, 'En feil oppstod');
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
                                                  width: 120,
                                                  height: 40,
                                                  constraints:
                                                      const BoxConstraints(
                                                    maxWidth: 174,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
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
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 17,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
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
                                    10, 0, 0, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 8.0),
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
                                                          fontSize: 19.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
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
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Nunito',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontSize: 20.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w700,
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
                                    Container(
                                      width:
                                          332.0, // Maximum width for the container
                                      decoration: const BoxDecoration(),
                                      alignment: const AlignmentDirectional(
                                          -1.0, -1.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0.0, 0.0, 0.0, 0.0),
                                                  child: Container(
                                                    width:
                                                        332.0, // Width constraint to enable wrapping
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                '${matvare.username}  ',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .titleSmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  fontSize:
                                                                      15.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                '${matvare.description}',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .titleSmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  fontSize:
                                                                      15.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                      textAlign:
                                                          TextAlign.start,
                                                      softWrap:
                                                          true, // Enable text wrapping
                                                      overflow: TextOverflow
                                                          .visible, // Allow the text to be visible when wrapped
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
                                              0.0, 30.0, 0.0, 0.0),
                                      child: Text(
                                        'Informasjon',
                                        style: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .override(
                                              fontFamily: 'Montserrat',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 14.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 2.0, 0.0, 5.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${matvare.price}Kr',
                                            textAlign: TextAlign.start,
                                            style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  fontFamily: 'Nunito',
                                                  fontSize: 14.0,
                                                  letterSpacing: 0.0,
                                                  color: const Color.fromARGB(
                                                      211, 87, 99, 108),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 5, 0),
                                            child: Text(
                                              matvare.kg == true ? '/Kg' : '',
                                              textAlign: TextAlign.start,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .titleMedium
                                                  .override(
                                                    fontFamily: 'Nunito',
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
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(5, 0, 5, 0),
                                            child: Text(
                                              '${matvare.antall!.toStringAsFixed(0)} ${matvare.kg == true ? 'Kg' : 'stk'}',
                                              textAlign: TextAlign.start,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .titleMedium
                                                  .override(
                                                    fontFamily: 'Nunito',
                                                    fontSize: 14.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color.fromARGB(
                                                        211, 87, 99, 108),
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
