import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:mat_salg/helper_components/functions/calculate_distance.dart';
import 'package:mat_salg/my_ip.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/pages/app_pages/hjem/report/report_widget.dart';
import 'package:mat_salg/pages/map/kart_pop_up_widget.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/pages/app_pages/orders/order_product_details/product_services.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:flutter/material.dart';
import 'product_model.dart';
export 'product_model.dart';

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
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  late ProductModel _model;
  late OrdreInfo ordreInfo;
  late ProductServices productServices;

  @override
  void initState() {
    super.initState();

    _model = createModel(context, () => ProductModel());
    ordreInfo = widget.ordre;
    productServices = ProductServices(model: _model, ordreInfo: ordreInfo);
    productServices.getPoststed(context);
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
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) {
            return;
          }
        },
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
                  Toasts.showErrorToast(context, 'Ingen internettforbindelse');
                } catch (e) {
                  Toasts.showErrorToast(context, 'En feil oppstod');
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
                                splashFactory: InkRipple.splashFactory,
                                splashColor: Colors.grey[100],
                                onTap: () async {
                                  try {
                                    if (ordreInfo.deleted) return;
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
                                    Toasts.showErrorToast(
                                        context, 'Ingen internettforbindelse');
                                  } catch (e) {
                                    Toasts.showErrorToast(
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
                                            child: CachedNetworkImage(
                                              fadeInDuration: Duration.zero,
                                              imageUrl:
                                                  '${ApiConstants.baseUrl}${ordreInfo.foodDetails.profilepic}',
                                              fit: BoxFit.cover,
                                              imageBuilder:
                                                  (context, imageProvider) {
                                                return Container(
                                                  width: 44.0,
                                                  height: 44.0,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                );
                                              },
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Image.asset(
                                                'assets/images/profile_pic.png',
                                                width: 44.0,
                                                height: 44.0,
                                                fit: BoxFit.cover,
                                              ),
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
                                                      text: ordreInfo.deleted &&
                                                              ordreInfo
                                                                      .kjopte ==
                                                                  true
                                                          ? 'deleted_user'
                                                          : ordreInfo
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
                                                      text: ordreInfo.deleted &&
                                                              ordreInfo
                                                                      .kjopte ==
                                                                  true
                                                          ? 'deleted_user'
                                                          : (CalculateDistance.calculateDistance(
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
                                                              ? (_model.poststed !=
                                                                      null
                                                                  ? '\n${_model.poststed}, 1 Km'
                                                                  : '\n1 Km')
                                                              : (_model.poststed !=
                                                                      null
                                                                  ? '\n${_model.poststed ?? ''}, ${CalculateDistance.calculateDistance(FFAppState().brukerLat, FFAppState().brukerLng, ordreInfo.foodDetails.lat ?? 0.0, ordreInfo.foodDetails.lng ?? 0.0).toStringAsFixed(0)}Km'
                                                                  : '\n${CalculateDistance.calculateDistance(FFAppState().brukerLat, FFAppState().brukerLng, ordreInfo.foodDetails.lat ?? 0.0, ordreInfo.foodDetails.lng ?? 0.0).toStringAsFixed(0)}Km'),
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
                                                        Navigator.pop(context);
                                                        await productServices
                                                            .enterConversation(
                                                                context);
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
                                                                    ReportWidget(
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
                                                                            0),
                                                                child:
                                                                    CachedNetworkImage(
                                                                  fadeInDuration:
                                                                      Duration
                                                                          .zero,
                                                                  imageUrl:
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
                                                                  imageBuilder:
                                                                      (context,
                                                                          imageProvider) {
                                                                    return Container(
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          485,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        image:
                                                                            DecorationImage(
                                                                          image:
                                                                              imageProvider,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      Image
                                                                          .asset(
                                                                    'assets/images/error_image.jpg',
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
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
                                                                              0),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    fadeInDuration:
                                                                        Duration
                                                                            .zero,
                                                                    imageUrl:
                                                                        '${ApiConstants.baseUrl}${ordreInfo.foodDetails.imgUrls![1]}',
                                                                    width: double
                                                                        .infinity,
                                                                    height: 485,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    alignment:
                                                                        const Alignment(
                                                                            0.0,
                                                                            0.0),
                                                                    imageBuilder:
                                                                        (context,
                                                                            imageProvider) {
                                                                      return Container(
                                                                        width: double
                                                                            .infinity,
                                                                        height:
                                                                            485,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          image:
                                                                              DecorationImage(
                                                                            image:
                                                                                imageProvider,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Image
                                                                            .asset(
                                                                      'assets/images/error_image.jpg',
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
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
                                                                              0),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    fadeInDuration:
                                                                        Duration
                                                                            .zero,
                                                                    imageUrl:
                                                                        '${ApiConstants.baseUrl}${ordreInfo.foodDetails.imgUrls![2]}',
                                                                    width: double
                                                                        .infinity,
                                                                    height: 485,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    alignment:
                                                                        const Alignment(
                                                                            0.0,
                                                                            0.0),
                                                                    imageBuilder:
                                                                        (context,
                                                                            imageProvider) {
                                                                      return Container(
                                                                        width: double
                                                                            .infinity,
                                                                        height:
                                                                            485,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          image:
                                                                              DecorationImage(
                                                                            image:
                                                                                imageProvider,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Image
                                                                            .asset(
                                                                      'assets/images/error_image.jpg',
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
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
                                                          SizedBox(
                                                            height: 485,
                                                            child: Stack(
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              0),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    fadeInDuration:
                                                                        Duration
                                                                            .zero,
                                                                    imageUrl:
                                                                        '${ApiConstants.baseUrl}${ordreInfo.foodDetails.imgUrls![3]}',
                                                                    width: double
                                                                        .infinity,
                                                                    height: 485,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    alignment:
                                                                        const Alignment(
                                                                            0.0,
                                                                            0.0),
                                                                    imageBuilder:
                                                                        (context,
                                                                            imageProvider) {
                                                                      return Container(
                                                                        width: double
                                                                            .infinity,
                                                                        height:
                                                                            485,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          image:
                                                                              DecorationImage(
                                                                            image:
                                                                                imageProvider,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Image
                                                                            .asset(
                                                                      'assets/images/error_image.jpg',
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
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
                                                                              0),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    fadeInDuration:
                                                                        Duration
                                                                            .zero,
                                                                    imageUrl:
                                                                        '${ApiConstants.baseUrl}${ordreInfo.foodDetails.imgUrls![4]}',
                                                                    width: double
                                                                        .infinity,
                                                                    height: 485,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    alignment:
                                                                        const Alignment(
                                                                            0.0,
                                                                            0.0),
                                                                    imageBuilder:
                                                                        (context,
                                                                            imageProvider) {
                                                                      return Container(
                                                                        width: double
                                                                            .infinity,
                                                                        height:
                                                                            485,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          image:
                                                                              DecorationImage(
                                                                            image:
                                                                                imageProvider,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Image
                                                                            .asset(
                                                                      'assets/images/error_image.jpg',
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
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
                                                            if (!context
                                                                .mounted) {
                                                              return;
                                                            }
                                                            Toasts.showErrorToast(
                                                                context,
                                                                'Ingen internettforbindelse');
                                                          } catch (e) {
                                                            if (!context
                                                                .mounted) {
                                                              return;
                                                            }
                                                            Toasts.showErrorToast(
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
                                                          accuratePosition:
                                                              ordreInfo
                                                                  .foodDetails
                                                                  .accuratePosition,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ).then((value) =>
                                                    safeSetState(() {}));
                                              } on SocketException {
                                                if (!context.mounted) return;
                                                Toasts.showErrorToast(context,
                                                    'Ingen internettforbindelse');
                                              } catch (e) {
                                                if (!context.mounted) return;
                                                Toasts.showErrorToast(
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
                                                await productServices
                                                    .enterConversation(context);
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
                                          SizedBox(
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
                                                    text: _model.isExpanded
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
                                              softWrap: true,
                                              overflow: TextOverflow.visible,
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
                                            _model.isExpanded =
                                                !_model.isExpanded;
                                          });
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            _model.isExpanded
                                                ? 'Se mindre'
                                                : 'Se mer',
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
