import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mat_salg/helper_components/functions/calculate_distance.dart';
import 'package:mat_salg/helper_components/widgets/custom_page_indicator.dart';
import 'package:mat_salg/helper_components/widgets/pageview_images.dart';
import 'package:mat_salg/helper_components/widgets/product_grid.dart';
import 'package:mat_salg/helper_components/widgets/shimmer_widgets/shimmer_product.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/logging.dart';
import 'package:mat_salg/models/matvarer.dart';
import 'package:mat_salg/my_ip.dart';
import 'package:mat_salg/pages/app_pages/home/product_details/details_services.dart';
import 'package:mat_salg/pages/app_pages/home/product_details/get_updates/get_updates_widget.dart';
import 'package:mat_salg/pages/app_pages/home/report/report_widget.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_animations.dart';
import 'package:mat_salg/services/food_service.dart';
import 'package:mat_salg/services/location_service.dart';
import 'package:mat_salg/services/like_service.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_toggle_icon.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'details_model.dart';
export 'details_model.dart';

class DetailsWidget extends StatefulWidget {
  const DetailsWidget({
    super.key,
    required this.matvare,
    this.fromChat,
    this.liked,
    this.matId,
  });

  final dynamic matvare;
  final dynamic fromChat;
  final dynamic liked;
  final dynamic matId;

  @override
  State<DetailsWidget> createState() => _MatDetaljBondegardWidgetState();
}

class _MatDetaljBondegardWidgetState extends State<DetailsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = <String, AnimationInfo>{};
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final LocationService locationService = LocationService();
  late DetailsModel _model;
  late Matvarer matvare;
  late DetailsServices detailsServices;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DetailsModel());
    matvare = Matvarer(name: '');
    if (widget.matvare != null) {
      matvare = Matvarer.fromJson1(widget.matvare);
      _model.fetchingProductLoading = false;
      detailsServices = DetailsServices(model: _model, matvare: matvare);
      getPoststed();
      getSimilarFoods();
      if (FFAppState().likedFoods.contains(matvare.matId)) {
        _model.liker = true;
      } else {
        if (FFAppState().unlikedFoods.contains(matvare.matId)) {
          _model.liker = false;
        } else {
          _model.liker = matvare.liked;
        }
      }
    }
    if (widget.matvare == null) {
      _fetchMatvare();
    }
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

  Future<void> _fetchMatvare() async {
    try {
      _model.fetchingProductLoading = true;
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return;
      } else {
        Matvarer? product =
            await ApiFoodService.getProductDetails(token, widget.matId);
        if (product != null) {
          matvare = product;
          safeSetState(() {
            _model.fetchingProductLoading = false;
            detailsServices = DetailsServices(model: _model, matvare: matvare);
            getPoststed();
            getSimilarFoods();
            if (FFAppState().likedFoods.contains(matvare.matId)) {
              _model.liker = true;
            } else {
              if (FFAppState().unlikedFoods.contains(matvare.matId)) {
                _model.liker = false;
              } else {
                _model.liker = matvare.liked;
              }
            }
          });
        }
      }
    } on SocketException {
      if (!mounted) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      logger.d(e);
      if (e.toString().contains('product-deleted')) {
        safeSetState(() {
          _model.isDeleted = true;
        });
        if (!mounted) return;
        Toasts.showErrorToast(context, 'Annonsen er slettet');
      } else {
        if (!mounted) return;
        Toasts.showErrorToast(context, 'En feil oppstod');
      }
    }
  }

  Future<void> getPoststed() async {
    try {
      await detailsServices.getPoststed(context);
      safeSetState(() {});
      return;
    } on SocketException catch (e) {
      logger.d(e);
      if (!mounted) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } on TimeoutException {
      if (!mounted) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      logger.e('Unexpected exception: $e');
      if (!mounted) return;
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

  Future<void> getSimilarFoods() async {
    try {
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return;
      } else {
        await Future.delayed(Duration(milliseconds: 500));
        _model.nyematvarer = await ApiFoodService.getSimilarFoods(
            token, matvare.kategorier!.first, matvare.matId ?? 0);

        safeSetState(() {
          if (_model.nyematvarer != null && _model.nyematvarer!.isNotEmpty) {
            _model.isloading = false;
            return;
          } else {
            _model.isloading = true;
          }
        });
      }
    } on SocketException catch (e) {
      logger.d(e);
      if (!mounted) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } on TimeoutException {
      if (!mounted) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      logger.e('Unexpected exception: $e');
      if (!mounted) return;
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

  void _triggerHeartAnimation() {
    if (_model.isAnimating) return;

    safeSetState(() {
      _model.isAnimating = true;
      _model.showHeart = true;
    });

    Timer(const Duration(seconds: 1, milliseconds: 500), () {
      if (mounted) {
        safeSetState(() {
          _model.showHeart = false;
          _model.isAnimating = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = 2;
    final itemHeight = 290.0;
    final childAspectRatio = (screenWidth / crossAxisCount) / itemHeight;
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
                  Navigator.pop(context);
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
              child: _model.fetchingProductLoading
                  ? Center(
                      child: !_model.isDeleted
                          ? CupertinoActivityIndicator(
                              radius: 12.0,
                              color: FlutterFlowTheme.of(context).alternate,
                            )
                          : const SizedBox.shrink())
                  : CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 5.0, 0.0, 0.0),
                                child: InkWell(
                                  splashFactory: InkRipple.splashFactory,
                                  splashColor: Colors.grey[100],
                                  onTap: () async {
                                    if (widget.liked == true &&
                                        widget.fromChat != true) {
                                      context.pushNamed(
                                        'BrukerPage3',
                                        queryParameters: {
                                          'uid': serializeParam(
                                            matvare.uid,
                                            ParamType.String,
                                          ),
                                          'username': serializeParam(
                                            matvare.username,
                                            ParamType.String,
                                          ),
                                        },
                                      );
                                      return;
                                    }
                                    if (widget.fromChat == true) {
                                      context.pushNamed(
                                        'BrukerPage2',
                                        queryParameters: {
                                          'uid': serializeParam(
                                            matvare.uid,
                                            ParamType.String,
                                          ),
                                          'username': serializeParam(
                                            matvare.username,
                                            ParamType.String,
                                          ),
                                          'fromChat': serializeParam(
                                            true,
                                            ParamType.bool,
                                          ),
                                        },
                                      );
                                      return;
                                    } else {
                                      context.pushNamed(
                                        GoRouterState.of(context)
                                                .uri
                                                .toString()
                                                .startsWith('/profil')
                                            ? 'BrukerPage3'
                                            : GoRouterState.of(context)
                                                    .uri
                                                    .toString()
                                                    .startsWith(
                                                        '/notifications')
                                                ? 'BrukerPageNotification'
                                                : 'BrukerPage',
                                        queryParameters: {
                                          'uid': serializeParam(
                                            matvare.uid,
                                            ParamType.String,
                                          ),
                                          'username': serializeParam(
                                            matvare.username,
                                            ParamType.String,
                                          ),
                                        },
                                      );
                                      return;
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
                                                        text:
                                                            matvare.username ??
                                                                '',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Nunito',
                                                              fontSize: 17.0,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                      TextSpan(
                                                        text: (CalculateDistance.calculateDistance(
                                                                    FFAppState()
                                                                        .brukerLat,
                                                                    FFAppState()
                                                                        .brukerLng,
                                                                    matvare.lat ??
                                                                        0.0,
                                                                    matvare.lng ??
                                                                        0.0) <
                                                                1)
                                                            ? (_model.poststed !=
                                                                    null
                                                                ? '\n${_model.poststed}, 1 Km'
                                                                : '\n1 Km')
                                                            : (_model.poststed !=
                                                                    null
                                                                ? '\n${_model.poststed ?? ''}, ${CalculateDistance.calculateDistance(FFAppState().brukerLat, FFAppState().brukerLng, matvare.lat ?? 0.0, matvare.lng ?? 0.0).toStringAsFixed(0)}Km'
                                                                : '\n${CalculateDistance.calculateDistance(FFAppState().brukerLat, FFAppState().brukerLng, matvare.lat ?? 0.0, matvare.lng ?? 0.0).toStringAsFixed(0)}Km'),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  fontSize:
                                                                      14.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
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
                                                        await detailsServices
                                                            .enterConversation(
                                                                context);
                                                      },
                                                      child: const Text(
                                                        'Send melding',
                                                        style: TextStyle(
                                                          fontSize: 18,
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
                                                                      matvare
                                                                          .uid,
                                                                  matId: matvare
                                                                      .matId,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ).then((value) =>
                                                            safeSetState(
                                                                () {}));
                                                        return;
                                                      },
                                                      child: const Text(
                                                        'Rapporter',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                  cancelButton:
                                                      CupertinoActionSheetAction(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    isDefaultAction: true,
                                                    child: const Text(
                                                      'Avbryt',
                                                      style: TextStyle(
                                                        fontSize: 18,
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
                                            HapticFeedback.selectionClick();
                                            String? token =
                                                await firebaseAuthService
                                                    .getToken(context);
                                            if (token == null) {
                                              return;
                                            }
                                            safeSetState(() =>
                                                _model.liker = !_model.liker!);
                                            if (_model.liker!) {
                                              FFAppState()
                                                  .unlikedFoods
                                                  .remove(matvare.matId);
                                              if (!FFAppState()
                                                  .likedFoods
                                                  .contains(matvare.matId)) {
                                                FFAppState()
                                                    .likedFoods
                                                    .add(matvare.matId ?? 0);
                                              }

                                              _triggerHeartAnimation();
                                              ApiLike.sendLike(
                                                  token, matvare.matId);
                                            } else {
                                              FFAppState()
                                                  .likedFoods
                                                  .remove(matvare.matId);
                                              if (!FFAppState()
                                                  .unlikedFoods
                                                  .contains(matvare.matId)) {
                                                FFAppState()
                                                    .unlikedFoods
                                                    .add(matvare.matId ?? 0);
                                              }
                                              ApiLike.deleteLike(
                                                  token, matvare.matId);
                                            }
                                          } on SocketException {
                                            if (!context.mounted) return;
                                            Toasts.showErrorToast(context,
                                                'Ingen internettforbindelse');
                                          } catch (e) {
                                            logger.d(e);
                                            if (!context.mounted) return;
                                            Toasts.showErrorToast(
                                                context, 'En feil oppstod');
                                          }
                                        },
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.59,
                                          child: Stack(
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                child: Stack(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(0.0,
                                                              0.0, 0.0, 40.0),
                                                      child: PageView(
                                                        controller: _model
                                                                .pageViewController ??=
                                                            PageController(
                                                                initialPage: 1),
                                                        onPageChanged:
                                                            (value) =>
                                                                safeSetState(
                                                                    () {}),
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        children: List.generate(
                                                          matvare.imgUrls!
                                                                  .length +
                                                              1,
                                                          (index) {
                                                            if (index == 0) {
                                                              return MapWithButton(
                                                                latitude: matvare
                                                                        .lat ??
                                                                    59.9138688,
                                                                longitude: matvare
                                                                        .lng ??
                                                                    10.7522454,
                                                                accuratePosition:
                                                                    matvare
                                                                        .accuratePosition,
                                                                onTapCallback:
                                                                    () {},
                                                              );
                                                            } else {
                                                              return ImageCard(
                                                                imageUrl:
                                                                    '${ApiConstants.baseUrl}${matvare.imgUrls![index - 1]}',
                                                                isSoldOut: matvare
                                                                        .kjopt ==
                                                                    true,
                                                              );
                                                            }
                                                          },
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
                                                        child: CustomPageIndicator(
                                                            itemCount: matvare
                                                                    .imgUrls!
                                                                    .length +
                                                                1,
                                                            currentIndex: _model
                                                                .pageViewCurrentIndex),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (_model.showHeart)
                                                Align(
                                                  alignment: Alignment.center,
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
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    5.0, 0.0, 15.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            ToggleIcon(
                                              onPressed: () async {
                                                HapticFeedback.selectionClick();
                                                String? token =
                                                    await firebaseAuthService
                                                        .getToken(context);
                                                if (token == null) {
                                                  return;
                                                }
                                                safeSetState(() => _model
                                                    .liker = !_model.liker!);
                                                if (_model.liker!) {
                                                  FFAppState()
                                                      .unlikedFoods
                                                      .remove(matvare.matId);
                                                  if (!FFAppState()
                                                      .likedFoods
                                                      .contains(
                                                          matvare.matId)) {
                                                    FFAppState().likedFoods.add(
                                                        matvare.matId ?? 0);
                                                  }

                                                  _triggerHeartAnimation();
                                                  ApiLike.sendLike(
                                                      token, matvare.matId);
                                                } else {
                                                  FFAppState()
                                                      .likedFoods
                                                      .remove(matvare.matId);
                                                  if (!FFAppState()
                                                      .unlikedFoods
                                                      .contains(
                                                          matvare.matId)) {
                                                    FFAppState()
                                                        .unlikedFoods
                                                        .add(
                                                            matvare.matId ?? 0);
                                                  }
                                                  ApiLike.deleteLike(
                                                      token, matvare.matId);
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
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                size: 32,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(2, 0, 0, 0),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  double startLat =
                                                      matvare.lat ?? 59.9138688;
                                                  double startLng =
                                                      matvare.lng ?? 10.7522454;

                                                  context.pushNamed(
                                                    'Kart',
                                                    queryParameters: {
                                                      'startLat':
                                                          startLat.toString(),
                                                      'startLng':
                                                          startLng.toString(),
                                                      'accuratePosition':
                                                          matvare
                                                              .accuratePosition
                                                              .toString(),
                                                    },
                                                  );
                                                },
                                                child: Icon(
                                                  CupertinoIcons.map,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            if (matvare.kjopt == true)
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
                                                    barrierColor:
                                                        const Color.fromARGB(
                                                            153, 0, 0, 0),
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
                                                              GetUpdatesWidget(
                                                            matId:
                                                                matvare.matId,
                                                            name: matvare.name,
                                                            pushEnabled: matvare
                                                                .wantPush,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {
                                                        if (value == true) {
                                                          safeSetState(() {});
                                                        }
                                                      }));
                                                  return;
                                                },
                                                child: Material(
                                                  color: Colors.transparent,
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
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
                                                            BorderRadius
                                                                .circular(14),
                                                      ),
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
                                                                        15,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            if (matvare.kjopt != true)
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  await detailsServices
                                                      .enterConversation(
                                                          context);
                                                },
                                                child: Material(
                                                  color: Colors.transparent,
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
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
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
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
                                                                style: FlutterFlowTheme.of(
                                                                        context)
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
                                                                              .w700,
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
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              10.0, 12.0, 0.0, 12.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0.0, 0.0, 0.0, 12.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      matvare.name ?? '',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .headlineMedium
                                                          .override(
                                                            fontFamily:
                                                                'Nunito',
                                                            fontSize: 17.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0.0, 0.0, 10.0, 0.0),
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
                                                        '${matvare.price ?? 0} Kr',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .headlineMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Nunito',
                                                              fontSize: 18.0,
                                                              letterSpacing:
                                                                  0.0,
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
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 332.0,
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
                                                              fontSize: 15.0,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                      TextSpan(
                                                        text: _model.isExpanded
                                                            ? matvare
                                                                .description
                                                            : (matvare.description!
                                                                            .length >
                                                                        100 ||
                                                                    '\n'.allMatches(matvare.description!).length >=
                                                                        2
                                                                ? "${matvare.description!.substring(0, matvare.description!.length > 100 ? 100 : matvare.description!.indexOf('\n', matvare.description!.indexOf('\n') + 1) + 1)}..." // Truncate based on condition
                                                                : matvare
                                                                    .description),
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .titleSmall
                                                            .override(
                                                              fontFamily:
                                                                  'Nunito',
                                                              fontSize: 15.0,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                  textAlign: TextAlign.start,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (matvare.description != null &&
                                              (matvare.description!.length >
                                                      100 ||
                                                  '\n'
                                                          .allMatches(matvare
                                                              .description!)
                                                          .length >=
                                                      2))
                                            GestureDetector(
                                              onTap: () {
                                                safeSetState(() {
                                                  _model.isExpanded =
                                                      !_model.isExpanded;
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4.0),
                                                child: Text(
                                                  _model.isExpanded
                                                      ? 'Se mindre'
                                                      : 'Se mer',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodySmall
                                                      .override(
                                                        fontFamily: 'Nunito',
                                                        fontSize: 13.0,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: const Color
                                                            .fromRGBO(
                                                            113, 113, 113, 1.0),
                                                      ),
                                                ),
                                              ),
                                            ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0.0, 16.0, 16.0, 5.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'PRIS',
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
                                                      Text(
                                                        '${matvare.price}Kr',
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
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'AVSTAND',
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
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  5, 0, 0, 0),
                                                          child: Text(
                                                            (CalculateDistance.calculateDistance(
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
                                                                : '${CalculateDistance.calculateDistance(FFAppState().brukerLat, FFAppState().brukerLng, matvare.lat ?? 0.0, matvare.lng ?? 0.0).toStringAsFixed(0)}Km',
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .titleMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  fontSize:
                                                                      13.0,
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
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
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
                                                        color:
                                                            Colors.transparent,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 16, 0, 20),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Sist endret ${matvare.updatetime != null ? DateFormat("d. MMM", "nb_NO").format(matvare.updatetime!.toLocal()) : ""}',
                                                  textAlign: TextAlign.start,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
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
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0.0, 16.0, 0.0, 20.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Lignende matvarer',
                                                  textAlign: TextAlign.start,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Nunito',
                                                        fontSize: 22,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w800,
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
                            ],
                          ),
                        ),
                        SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: childAspectRatio,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (_model.isloading) {
                                return const ShimmerLoadingWidget();
                              }
                              final matvare = _model.nyematvarer![index];
                              return ProductList(
                                matvare: matvare,
                                onTap: () async {
                                  try {
                                    if (widget.fromChat != true) {
                                      context.pushNamed(
                                        GoRouterState.of(context)
                                                .uri
                                                .toString()
                                                .startsWith('/profil')
                                            ? 'MatDetaljBondegard1'
                                            : GoRouterState.of(context)
                                                    .uri
                                                    .toString()
                                                    .startsWith(
                                                        '/notifications')
                                                ? 'ProductDetailNotification'
                                                : 'ProductDetail',
                                        queryParameters: {
                                          'matvare': serializeParam(
                                            matvare.toJson(),
                                            ParamType.JSON,
                                          ),
                                        },
                                      );
                                    } else {
                                      context.pushNamed(
                                        'MatDetaljBondegard2',
                                        queryParameters: {
                                          'matvare': serializeParam(
                                            matvare.toJson(),
                                            ParamType.JSON,
                                          ),
                                          'fromChat': serializeParam(
                                            true,
                                            ParamType.bool,
                                          ),
                                        },
                                      );
                                    }
                                  } catch (e) {
                                    Toasts.showErrorToast(
                                        context, 'En uforventet feil oppstod');
                                    logger.d('Error navigating page');
                                  }
                                },
                              );
                            },
                            childCount: _model.isloading
                                ? 1
                                : _model.nyematvarer?.length ?? 0,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ));
  }
}
