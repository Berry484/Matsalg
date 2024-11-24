import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:mat_salg/ApiCalls.dart';
import 'package:mat_salg/MyIP.dart';
import 'package:mat_salg/SecureStorage.dart';
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
  bool _slettIsLoading = false;
  bool _merSolgtIsLoading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ApiUpdateFood apiUpdateFood = ApiUpdateFood();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MinMatvareDetaljModel());
    matvare = Matvarer.fromJson1(widget.matvare);
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
                color: FlutterFlowTheme.of(context).secondaryText,
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
                                              .fromSTEB(8.0, 0.0, 0.0, 13.0),
                                          child: Text(
                                            matvare.username ??
                                                FFAppState().brukernavn,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Nunito',
                                                  fontSize: 16.0,
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
                                            .secondaryText,
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
                                    height: 525.0,
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          height: 525.0,
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding: matvare.kjopt == true
                                                    ? const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 0.0, 0.0, 40.0)
                                                    : const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 0.0, 0.0, 40.0),
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
                                                      height: 525.0,
                                                      child: Stack(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        0.0),
                                                            child:
                                                                Image.network(
                                                              '${ApiConstants.baseUrl}${matvare.imgUrls![0]}',
                                                              width: double
                                                                  .infinity,
                                                              height: 525.0,
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
                                                        height: 525.0,
                                                        child: Stack(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          0.0),
                                                              child:
                                                                  Image.network(
                                                                '${ApiConstants.baseUrl}${matvare.imgUrls![1]}',
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
                                                        height: 525.0,
                                                        child: Stack(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          0.0),
                                                              child:
                                                                  Image.network(
                                                                '${ApiConstants.baseUrl}${matvare.imgUrls![2]}',
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
                                                        height: 525.0,
                                                        child: Stack(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          0.0),
                                                              child:
                                                                  Image.network(
                                                                '${ApiConstants.baseUrl}${matvare.imgUrls![3]}',
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
                                                        height: 525.0,
                                                        child: Stack(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          0.0),
                                                              child:
                                                                  Image.network(
                                                                '${ApiConstants.baseUrl}${matvare.imgUrls![4]}',
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
                                                      color: Colors.redAccent,
                                                      alignment:
                                                          Alignment.center,
                                                      child: const Text(
                                                        'Utsolgt',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                    effect:
                                                        const smooth_page_indicator
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
                                              .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {},
                                            child: const Icon(
                                              CupertinoIcons.heart_fill,
                                              color: Color.fromARGB(
                                                  1000, 1000, 0, 0),
                                              size: 34.0,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(12.0, 0.0, 0.0, 0.0),
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
                                                barrierColor:
                                                    const Color.fromARGB(
                                                        60, 17, 0, 0),
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
                                              showCupertinoModalPopup(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return CupertinoActionSheet(
                                                    actions: <Widget>[
                                                      CupertinoActionSheetAction(
                                                        onPressed: () {
                                                          setState(() {});
                                                          Navigator.pop(
                                                              context);
                                                          context.pushNamed(
                                                            'LeggUtMatvare',
                                                            queryParameters: {
                                                              'rediger':
                                                                  serializeParam(
                                                                      true,
                                                                      ParamType
                                                                          .bool),
                                                              'matinfo':
                                                                  serializeParam(
                                                                      matvare
                                                                          .toJson(),
                                                                      ParamType
                                                                          .JSON),
                                                            }.withoutNulls,
                                                          );
                                                        },
                                                        child: const Text(
                                                          'Rediger annonse',
                                                          style: TextStyle(
                                                            fontSize: 19,
                                                            color:
                                                                CupertinoColors
                                                                    .systemBlue,
                                                          ),
                                                        ),
                                                      ),

                                                      // Second action: Marker solgt (Mark as sold)
                                                      CupertinoActionSheetAction(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          // Show confirmation dialog for "Marker solgt"
                                                          if (matvare.kjopt !=
                                                              true) {
                                                            showCupertinoDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return CupertinoAlertDialog(
                                                                  title: const Text(
                                                                      'Marker solgt'),
                                                                  content:
                                                                      const Text(
                                                                          'Er du sikker på at du vil markere denne annonsen som solgt? Dette vil automatisk avslå alle bud'),
                                                                  actions: <Widget>[
                                                                    CupertinoDialogAction(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context); // Close the dialog
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        'Nei, avbryt',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.blue), // Blue for 'Nei'
                                                                      ),
                                                                    ),
                                                                    // Yes action for 'Ja' (Yes) button
                                                                    CupertinoDialogAction(
                                                                      onPressed:
                                                                          () async {
                                                                        try {
                                                                          if (_merSolgtIsLoading) {
                                                                            return;
                                                                          } else {
                                                                            _merSolgtIsLoading =
                                                                                true;
                                                                            String?
                                                                                token =
                                                                                await Securestorage().readToken();
                                                                            if (token ==
                                                                                null) {
                                                                              FFAppState().login = false;
                                                                              context.pushNamed('registrer');
                                                                              return;
                                                                            } else {
                                                                              await apiUpdateFood.merkSolgt(token: token, id: matvare.matId, solgt: true);
                                                                              setState(() {});
                                                                              Navigator.pop(context);
                                                                              context.pushNamed('Profil');
                                                                            }
                                                                            _merSolgtIsLoading =
                                                                                false;
                                                                          }
                                                                        } on SocketException {
                                                                          _merSolgtIsLoading =
                                                                              false;
                                                                          showErrorToast(
                                                                              context,
                                                                              'Ingen internettforbindelse');
                                                                        } catch (e) {
                                                                          _merSolgtIsLoading =
                                                                              false;
                                                                          showErrorToast(
                                                                              context,
                                                                              'En feil oppstod');
                                                                        }
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        'Ja, marker solgt',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.red), // Red for 'Ja'
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          }
                                                          if (matvare.kjopt ==
                                                              true) {
                                                            showCupertinoDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return CupertinoAlertDialog(
                                                                  title: const Text(
                                                                      'Fjern solgt markering'),
                                                                  content:
                                                                      const Text(
                                                                          'Er du sikker på å du vil gjøre denne annonsen tilgjengelig igjen'),
                                                                  actions: <Widget>[
                                                                    CupertinoDialogAction(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context); // Close the dialog
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        'Nei, avbryt',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.blue), // Blue for 'Nei'
                                                                      ),
                                                                    ),
                                                                    // Yes action for 'Ja' (Yes) button
                                                                    CupertinoDialogAction(
                                                                      onPressed:
                                                                          () async {
                                                                        try {
                                                                          if (_merSolgtIsLoading) {
                                                                            return;
                                                                          } else {
                                                                            _merSolgtIsLoading =
                                                                                true;
                                                                            String?
                                                                                token =
                                                                                await Securestorage().readToken();
                                                                            if (token ==
                                                                                null) {
                                                                              FFAppState().login = false;
                                                                              context.pushNamed('registrer');
                                                                              return;
                                                                            } else {
                                                                              await apiUpdateFood.merkSolgt(token: token, id: matvare.matId, solgt: false);
                                                                              setState(() {});
                                                                              Navigator.pop(context);
                                                                              context.pushNamed('Profil');
                                                                            }
                                                                            _merSolgtIsLoading =
                                                                                false;
                                                                          }
                                                                        } on SocketException {
                                                                          _merSolgtIsLoading =
                                                                              false;
                                                                          showErrorToast(
                                                                              context,
                                                                              'Ingen internettforbindelse');
                                                                        } catch (e) {
                                                                          _merSolgtIsLoading =
                                                                              false;
                                                                          showErrorToast(
                                                                              context,
                                                                              'En feil oppstod');
                                                                        }
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        'Ja',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.red), // Red for 'Ja'
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          }
                                                        },
                                                        child: Text(
                                                          matvare.kjopt == true
                                                              ? 'Fjern solgt markering'
                                                              : 'Marker solgt',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 19,
                                                            color:
                                                                CupertinoColors
                                                                    .systemBlue,
                                                          ),
                                                        ),
                                                      ),

                                                      // Third action: Slett annonse (Delete ad)
                                                      CupertinoActionSheetAction(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          // Show confirmation dialog for "Slett annonse"
                                                          showCupertinoDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return CupertinoAlertDialog(
                                                                title: const Text(
                                                                    'Slett annonse'),
                                                                content: const Text(
                                                                    'Er du sikker på at du vil slette denne annonsen?'),
                                                                actions: <Widget>[
                                                                  // No action for 'Nei' (No) button
                                                                  CupertinoDialogAction(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context); // Close the dialog
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                      'Nei, avbryt',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.blue), // Blue for 'Nei'
                                                                    ),
                                                                  ),
                                                                  // Yes action for 'Ja' (Yes) button
                                                                  CupertinoDialogAction(
                                                                    onPressed:
                                                                        () async {
                                                                      try {
                                                                        if (_slettIsLoading) {
                                                                          return;
                                                                        } else {
                                                                          _slettIsLoading =
                                                                              true;
                                                                          String?
                                                                              token =
                                                                              await Securestorage().readToken();
                                                                          if (token ==
                                                                              null) {
                                                                            FFAppState().login =
                                                                                false;
                                                                            context.pushNamed('registrer');
                                                                            return;
                                                                          } else {
                                                                            await apiUpdateFood.slettMatvare(
                                                                                token: token,
                                                                                id: matvare.matId);
                                                                            setState(() {});
                                                                            Navigator.pop(context);
                                                                            context.pushNamed('Profil');
                                                                          }
                                                                          _slettIsLoading =
                                                                              false;
                                                                        }
                                                                      } on SocketException {
                                                                        _slettIsLoading =
                                                                            false;
                                                                        showErrorToast(
                                                                            context,
                                                                            'Ingen internettforbindelse');
                                                                      } catch (e) {
                                                                        _slettIsLoading =
                                                                            false;
                                                                        showErrorToast(
                                                                            context,
                                                                            'En feil oppstod');
                                                                      }
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                      'Ja, slett',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red), // Red for 'Ja'
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: const Text(
                                                          'Slett annonse',
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
                                            child: Material(
                                              color: Colors.transparent,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                              child: SafeArea(
                                                child: Container(
                                                  width: 100,
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
                                                            'Rediger',
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
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 40.0, 0.0, 20.0),
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
                                                      235, 17, 18, 19),
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
