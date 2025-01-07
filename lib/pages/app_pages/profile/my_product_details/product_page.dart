import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/my_ip.dart';
import 'package:mat_salg/services/food_service.dart';
import '../../../map/kart_pop_up_widget.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:flutter/material.dart';
import 'product_model.dart';
export 'product_model.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({
    super.key,
    this.matvare,
  });

  final dynamic matvare;

  @override
  State<ProductPage> createState() => _MinMatvareDetaljWidgetState();
}

class _MinMatvareDetaljWidgetState extends State<ProductPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final ApiFoodService apiFoodService = ApiFoodService();
  late ProductModel _model;
  late Matvarer matvare;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProductModel());
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
                                splashFactory: InkRipple.splashFactory,
                                splashColor: Colors.grey[100],
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
                                            child: CachedNetworkImage(
                                              fadeInDuration: Duration.zero,
                                              imageUrl:
                                                  '${ApiConstants.baseUrl}${matvare.profilepic}',
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
                                              0, 0, 8, 0),
                                      child: IconButton(
                                        icon: Icon(
                                          CupertinoIcons.ellipsis,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          size: 28.0,
                                        ),
                                        onPressed: () async {
                                          showCupertinoModalPopup(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CupertinoActionSheet(
                                                actions: <Widget>[
                                                  CupertinoActionSheetAction(
                                                    onPressed: () {
                                                      setState(() {});
                                                      Navigator.pop(context);
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
                                                        color: CupertinoColors
                                                            .systemBlue,
                                                      ),
                                                    ),
                                                  ),

                                                  // Third action: Slett annonse (Delete ad)
                                                  CupertinoActionSheetAction(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      // Show confirmation dialog for "Slett annonse"
                                                      showCupertinoDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return CupertinoAlertDialog(
                                                            title: const Text(
                                                                'Slett annonse'),
                                                            content: const Text(
                                                                'Er du sikker på at du vil slette denne annonsen?'),
                                                            actions: <Widget>[
                                                              // No action for 'Nei' (No) button
                                                              CupertinoDialogAction(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context); // Close the dialog
                                                                },
                                                                child:
                                                                    const Text(
                                                                  'Nei, avbryt',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blue), // Blue for 'Nei'
                                                                ),
                                                              ),
                                                              // Yes action for 'Ja' (Yes) button
                                                              CupertinoDialogAction(
                                                                onPressed:
                                                                    () async {
                                                                  try {
                                                                    if (_model
                                                                        .slettIsLoading) {
                                                                      return;
                                                                    } else {
                                                                      _model.slettIsLoading =
                                                                          true;
                                                                      String?
                                                                          token =
                                                                          await firebaseAuthService
                                                                              .getToken(context);
                                                                      if (token ==
                                                                          null) {
                                                                        return;
                                                                      } else {
                                                                        await apiFoodService.slettMatvare(
                                                                            token:
                                                                                token,
                                                                            id: matvare.matId);
                                                                        setState(
                                                                            () {});
                                                                        if (!context
                                                                            .mounted) {
                                                                          return;
                                                                        }
                                                                        Navigator.pop(
                                                                            context);
                                                                        context.pushNamed(
                                                                            'Profil');
                                                                        Toasts.showAccepted(
                                                                            context,
                                                                            'Slettet');
                                                                      }
                                                                      _model.slettIsLoading =
                                                                          false;
                                                                    }
                                                                  } on SocketException {
                                                                    _model.slettIsLoading =
                                                                        false;
                                                                    Toasts.showErrorToast(
                                                                        context,
                                                                        'Ingen internettforbindelse');
                                                                  } catch (e) {
                                                                    _model.slettIsLoading =
                                                                        false;
                                                                    Toasts.showErrorToast(
                                                                        context,
                                                                        'En feil oppstod');
                                                                  }
                                                                },
                                                                child:
                                                                    const Text(
                                                                  'Ja, slett',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Colors
                                                                          .red), // Red for 'Ja'
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
                                    height: 485.0,
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          height: 490.0,
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
                                                      height: 485,
                                                      child: Stack(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        0.0),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  '${ApiConstants.baseUrl}${matvare.imgUrls![0]}',
                                                              width: double
                                                                  .infinity,
                                                              height: 485,
                                                              fit: BoxFit.cover,
                                                              alignment:
                                                                  const Alignment(
                                                                      0.0, 0.0),
                                                              imageBuilder:
                                                                  (context,
                                                                      imageProvider) {
                                                                return Container(
                                                                  width: double
                                                                      .infinity,
                                                                  height: 485,
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
                                                                  Image.asset(
                                                                'assets/images/error_image.jpg',
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
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
                                                        height: 485,
                                                        child: Stack(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          0.0),
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl:
                                                                    '${ApiConstants.baseUrl}${matvare.imgUrls![1]}',
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
                                                                    height: 485,
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
                                                                    Image.asset(
                                                                  'assets/images/error_image.jpg',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
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
                                                        height: 485,
                                                        child: Stack(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          0.0),
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl:
                                                                    '${ApiConstants.baseUrl}${matvare.imgUrls![2]}',
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
                                                                    height: 485,
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
                                                                    Image.asset(
                                                                  'assets/images/error_image.jpg',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    if (matvare
                                                            .imgUrls!.length >
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
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl:
                                                                    '${ApiConstants.baseUrl}${matvare.imgUrls![3]}',
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
                                                                    height: 485,
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
                                                                    Image.asset(
                                                                  'assets/images/error_image.jpg',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
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
                                                        height: 485,
                                                        child: Stack(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          0.0),
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl:
                                                                    '${ApiConstants.baseUrl}${matvare.imgUrls![4]}',
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
                                                                    height: 485,
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
                                                                    Image.asset(
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
                                    5.0, 0.0, 0.0, 8.0),
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
                                              .fromSTEB(10.0, 0.0, 0.0, 0.0),
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
                                                        accuratePosition: matvare
                                                            .accuratePosition,
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
                                                                        if (_model
                                                                            .slettIsLoading) {
                                                                          return;
                                                                        } else {
                                                                          _model.slettIsLoading =
                                                                              true;
                                                                          String?
                                                                              token =
                                                                              await firebaseAuthService.getToken(context);
                                                                          if (token ==
                                                                              null) {
                                                                            return;
                                                                          } else {
                                                                            await apiFoodService.slettMatvare(
                                                                                token: token,
                                                                                id: matvare.matId);
                                                                            setState(() {});
                                                                            if (!context.mounted) {
                                                                              return;
                                                                            }
                                                                            Navigator.pop(context);
                                                                            context.pushNamed('Profil');
                                                                            Toasts.showAccepted(context,
                                                                                'Slettet');
                                                                          }
                                                                          _model.slettIsLoading =
                                                                              false;
                                                                        }
                                                                      } on SocketException {
                                                                        _model.slettIsLoading =
                                                                            false;
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
                                                                        _model.slettIsLoading =
                                                                            false;
                                                                        Toasts.showErrorToast(
                                                                            context,
                                                                            'En feil oppstod');
                                                                      }
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                      'Ja, slett',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight: FontWeight
                                                                              .w400,
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
                                                  width: 110,
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
                                    10.0, 8.0, 0.0, 12.0),
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
                                                        fontSize: 17.0,
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
                                          SizedBox(
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
                                                    text: _model.isExpanded
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
                                            _model.isExpanded = !_model
                                                .isExpanded; // Toggle expand/collapse
                                          });
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            _model.isExpanded
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
                                                  color: Colors.transparent,
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
                                                          color: Colors
                                                              .transparent,
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
                                                          '1 Km',
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
                                                                color: Colors
                                                                    .transparent,
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
