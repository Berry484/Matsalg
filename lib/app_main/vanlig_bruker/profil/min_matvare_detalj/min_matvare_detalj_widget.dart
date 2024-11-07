import 'package:flutter/cupertino.dart';
import 'package:mat_salg/MyIP.dart';
import 'package:mat_salg/matvarer.dart';

import '/app_main/vanlig_bruker/kart/kart_pop_up/kart_pop_up_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'min_matvare_detalj_model.dart';
export 'min_matvare_detalj_model.dart';

class MinMatvareDetaljWidget extends StatefulWidget {
  const MinMatvareDetaljWidget({
    super.key,
    this.matvare,
  });

  final dynamic matvare;

  @override
  State<MinMatvareDetaljWidget> createState() => _MinMatvareDetaljWidgetState();
}

class _MinMatvareDetaljWidgetState extends State<MinMatvareDetaljWidget> {
  late MinMatvareDetaljModel _model;

  late Matvarer matvare;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MinMatvareDetaljModel());
    matvare = Matvarer.fromJson1(widget.matvare);
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
                context.safePop();
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: FlutterFlowTheme.of(context).alternate,
                size: 28.0,
              ),
            ),
            actions: const [],
            centerTitle: true,
            elevation: 0.0,
          ),
          body: SafeArea(
            top: true,
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
                                  context.pop();
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
                                                  'assets/images/error_image.jpg', // Path to your local error image
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(5.0, 0.0, 0.0, 13.0),
                                          child: Text(
                                            matvare.username ??
                                                FFAppState().brukernavn,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Open Sans',
                                                  fontSize: 15.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 8.0, 0.0),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        size: 24.0,
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
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 380.0,
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          height: 380.0,
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        10.0, 0.0, 10.0, 40.0),
                                                child: PageView(
                                                  controller: _model
                                                          .pageViewController ??=
                                                      PageController(
                                                          initialPage: 0),
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  children: [
                                                    SizedBox(
                                                      width: double.infinity,
                                                      height: 380.0,
                                                      child: Stack(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            child:
                                                                Image.network(
                                                              '${ApiConstants.baseUrl}${matvare.imgUrls![0]}',
                                                              width: double
                                                                  .infinity,
                                                              height: 380.0,
                                                              fit: BoxFit.cover,
                                                              alignment:
                                                                  const Alignment(
                                                                      0.0, 0.0),
                                                              errorBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      Object
                                                                          error,
                                                                      StackTrace?
                                                                          stackTrace) {
                                                                return Image
                                                                    .asset(
                                                                  'assets/images/error_image.jpg', // Path to your local error image
                                                                  fit: BoxFit
                                                                      .cover,
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    if (matvare
                                                            .imgUrls!.length >
                                                        1)
                                                      SizedBox(
                                                        width: double.infinity,
                                                        height: 380.0,
                                                        child: Stack(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              child:
                                                                  Image.network(
                                                                '${ApiConstants.baseUrl}${matvare.imgUrls![1]}',
                                                                width: double
                                                                    .infinity,
                                                                height: 380.0,
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
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    if (matvare
                                                            .imgUrls!.length >
                                                        2)
                                                      SizedBox(
                                                        width: double.infinity,
                                                        height: 380.0,
                                                        child: Stack(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              child:
                                                                  Image.network(
                                                                '${ApiConstants.baseUrl}${matvare.imgUrls![2]}',
                                                                width: double
                                                                    .infinity,
                                                                height: 380.0,
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
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    if (matvare
                                                            .imgUrls!.length >
                                                        3)
                                                      SizedBox(
                                                        height: 380.0,
                                                        child: Stack(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              child:
                                                                  Image.network(
                                                                '${ApiConstants.baseUrl}${matvare.imgUrls![3]}',
                                                                width: double
                                                                    .infinity,
                                                                height: 380.0,
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
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    if (matvare
                                                            .imgUrls!.length >
                                                        4)
                                                      SizedBox(
                                                        width: double.infinity,
                                                        height: 380.0,
                                                        child: Stack(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              child:
                                                                  Image.network(
                                                                '${ApiConstants.baseUrl}${matvare.imgUrls![4]}',
                                                                width: double
                                                                    .infinity,
                                                                height: 380.0,
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
                                                        0.0, 1.0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          16.0, 0.0, 0.0, 16.0),
                                                  child: smooth_page_indicator
                                                      .SmoothPageIndicator(
                                                    controller: _model
                                                            .pageViewController ??=
                                                        PageController(
                                                            initialPage: 0),
                                                    count:
                                                        matvare.imgUrls!.length,
                                                    axisDirection:
                                                        Axis.horizontal,
                                                    onDotClicked: (i) async {
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
                                                      expansionFactor: 3.0,
                                                      spacing: 8.0,
                                                      radius: 16.0,
                                                      dotWidth: 10.0,
                                                      dotHeight: 8.0,
                                                      dotColor: const Color(
                                                          0xCC616161),
                                                      activeDotColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                      paintStyle:
                                                          PaintingStyle.fill,
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
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              5.0, 0.0, 0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10.0, 0.0, 10.0, 30.0),
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
                                              .fromSTEB(10.0, 0.0, 0.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {},
                                            child: FaIcon(
                                              FontAwesomeIcons.solidHeart,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              size: 30.0,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(9.0, 0.0, 0.0, 0.0),
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
                                              await showModalBottomSheet(
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                enableDrag: false,
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
                                            },
                                            child: Icon(
                                              Icons.location_on_outlined,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              size: 36,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 10, 0),
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
                                              showCupertinoModalPopup(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return CupertinoActionSheet(
                                                    actions: <Widget>[
                                                      CupertinoActionSheetAction(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          context.pushNamed(
                                                            'LeggUtMatvare',
                                                            queryParameters: {
                                                              'rediger':
                                                                  serializeParam(
                                                                true,
                                                                ParamType.bool,
                                                              ),
                                                              'matinfo':
                                                                  serializeParam(
                                                                matvare
                                                                    .toJson(),
                                                                ParamType.JSON,
                                                              ),
                                                            }.withoutNulls,
                                                          );
                                                        },
                                                        child: const Text(
                                                          'Rediger annonse',
                                                          style: TextStyle(
                                                            fontSize: 20,
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
                                                          fontSize:
                                                              18, // Set the font size for the cancel button
                                                          fontWeight: FontWeight
                                                              .bold, // Make the text bold
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Material(
                                              color: Colors.transparent,
                                              elevation: 1,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                              child: SafeArea(
                                                child: Container(
                                                  width: 100,
                                                  height: 40,
                                                  constraints: BoxConstraints(
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
                                                        EdgeInsetsDirectional
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
                                                            'Rediger',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Open Sans',
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16,
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
                                    10.0, 0.0, 0.0, 0.0),
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
                                                          fontFamily:
                                                              'Open Sans',
                                                          fontSize: 19.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0.0, 0.0, 5.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0.0, 0.0, 5.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${matvare.price} Kr',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Open Sans',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .alternate,
                                                                  fontSize:
                                                                      22.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                      ),
                                                      if (matvare.kg == true)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  10.0,
                                                                  0.0),
                                                          child: Text(
                                                            '/kg',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Open Sans',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  fontSize:
                                                                      22.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                          ),
                                                        ),
                                                      if (matvare.kg != true)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  10.0,
                                                                  0.0),
                                                          child: Text(
                                                            '/stk',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Open Sans',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  fontSize:
                                                                      22.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
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
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 15.0, 0.0, 0.0),
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
                                              0.0, 10.0, 0.0, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                '0',
                                                textAlign: TextAlign.start,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .override(
                                                          fontFamily:
                                                              'Open Sans',
                                                          fontSize: 14.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        5.0, 0.0, 0.0, 0.0),
                                                child: Text(
                                                  'Km',
                                                  textAlign: TextAlign.start,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleMedium
                                                      .override(
                                                        fontFamily: 'Open Sans',
                                                        fontSize: 14.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.place,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                size: 19.0,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 15.0, 0.0, 0.0),
                                      child: Text(
                                        'Antall',
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
                                    Text(
                                      '${matvare.antall ?? 0} ${matvare.kg == true ? 'Kg' : 'stk'}',
                                      textAlign: TextAlign.start,
                                      style: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            fontFamily: 'Open Sans',
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Container(
                                      width: 332.0,
                                      height: 235.0,
                                      decoration: const BoxDecoration(),
                                      alignment:
                                          const AlignmentDirectional(-1.0, 0.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0.0, 15.0, 0.0, 0.0),
                                            child: Text(
                                              'Beskrivelse',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodySmall
                                                  .override(
                                                    fontFamily: 'Open Sans',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    fontSize: 14.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0.0, 10.0, 0.0, 0.0),
                                            child: Text(
                                              matvare.description ?? '',
                                              textAlign: TextAlign.start,
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .override(
                                                        fontFamily: 'Open Sans',
                                                        fontSize: 14.0,
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
                            ],
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
