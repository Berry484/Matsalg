import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mat_salg/helper_components/widgets/product_list.dart';
import 'package:mat_salg/helper_components/widgets/shimmer_product.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/my_ip.dart';
import 'package:mat_salg/services/firebase_service.dart';
import 'package:mat_salg/services/food_service.dart';
import 'package:mat_salg/services/user_service.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'home_model.dart';
export 'home_model.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HjemWidgetState();
}

class _HjemWidgetState extends State<HomeWidget> with TickerProviderStateMixin {
  late HomeModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController1 = ScrollController();
  bool _isLoading = false;
  bool _isFollowerLoading = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _model.textFieldFocusNode!.addListener(() => safeSetState(() {
          _model.searching = true;
        }));
    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {
          if (_model.tabBarCurrentIndex == 1) {
            getFolgerFoods(true);
          }
        }));
    FirebaseApi().initNotifications();
    fetchData();
    getAllFoods(true);
    getFolgerFoods(true);
    _scrollController1.addListener(_scrollListener1);
    _scrollController.addListener(_scrollListener);
  }

  Widget buildProfileOutline(BuildContext context, int opacity, Color baseColor,
      Color highlightColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              width: 65.0,
              height: 65.0,
              decoration: BoxDecoration(
                color: Color.fromARGB(opacity, 255, 255, 255),
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  child: Container(
                    width: 75.0,
                    height: 13.0,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(opacity, 255, 255, 255),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  child: Container(
                    width: 200,
                    height: 13.0,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(opacity, 255, 255, 255),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> handleSearch() async {
    try {
      _model.profilisloading = true;
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return;
      } else {
        _model.profiler = await UserInfoService.searchUsers(
            token, _model.textController.text);
        if (mounted) {
          setState(() {
            if (_model.profiler != null && _model.profiler!.isEmpty) {
              _model.profilisloading = false;
              return;
            } else {
              _model.profilisloading = false;
            }
          });
        }
      }
    } on SocketException {
      if (!mounted) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      if (!mounted) return;
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

  Future<void> getAllFoods(bool refresh) async {
    try {
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return;
      } else {
        if (FFAppState().brukerLat == 59.9138688 ||
            FFAppState().brukerLng == 10.7522454) {
          await fetchData();
        }
        if (refresh == true) {
          _model.followerEnd = false;
          _model.followerPage = 0;
          _model.matvarer = await ApiFoodService.getAllFoods(token, 0);
        } else {
          List<Matvarer>? nyeMatvarer =
              await ApiFoodService.getAllFoods(token, _model.page);

          _model.matvarer ??= [];

          if (nyeMatvarer != null && nyeMatvarer.isNotEmpty) {
            _model.matvarer?.addAll(nyeMatvarer);
          } else {
            _model.end = true;
          }
        }

        if (mounted) {
          setState(() {
            if (_model.matvarer != null && _model.matvarer!.isEmpty) {
              return;
            } else {
              _model.isloading = false;
            }
          });
        }
      }
    } on SocketException {
      setState(() {
        _model.noWifi = true;
        _model.isloading = false;
      });
      if (!mounted) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      if (!mounted) return;
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

  Future<void> getFolgerFoods(bool refresh) async {
    try {
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return;
      } else {
        if (FFAppState().brukerLat == 59.9138688 ||
            FFAppState().brukerLng == 10.7522454) {
          await fetchData();
        }
        if (refresh == true) {
          _model.folgerMatvarer =
              await ApiFoodService.getFolgerFood(token, _model.followerPage);
        } else {
          List<Matvarer>? nyeFollowerMatvarer =
              await ApiFoodService.getFolgerFood(token, _model.page);

          _model.folgerMatvarer ??= [];

          if (nyeFollowerMatvarer != null && nyeFollowerMatvarer.isNotEmpty) {
            _model.folgerMatvarer?.addAll(nyeFollowerMatvarer);
          } else {
            _model.end = true;
          }
        }
        if (mounted) {
          setState(() {
            if (_model.folgerMatvarer != null &&
                _model.folgerMatvarer!.isNotEmpty) {
              _model.folgermatLoading = false;
              return;
            } else {
              _model.folgermatLoading = false;
            }
          });
        }
      }
    } on SocketException {
      if (!mounted) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      if (!mounted) return;
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

  Future<void> fetchData() async {
    try {
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return;
      } else {
        final response = await UserInfoService.checkUserInfo(token);
        if (response.statusCode == 200) {
          final decodedResponse = jsonDecode(response.body);
          final userInfo = decodedResponse['userInfo'] ?? {};
          LatLng? location = await getCurrentUserLocation(
              defaultLocation: const LatLng(0.0, 0.0));
          if (location != const LatLng(0.0, 0.0)) {
            FFAppState().brukerLat = location.latitude;
            FFAppState().brukerLng = location.longitude;
          } else {
            FFAppState().brukerLat = userInfo['lat'] ?? 59.9138688;
            FFAppState().brukerLng = userInfo['lng'] ?? 10.7522454;
          }

          FFAppState().brukernavn = userInfo['username'] ?? '';
          FFAppState().email = userInfo['email'] ?? '';
          FFAppState().firstname = userInfo['firstname'] ?? '';
          FFAppState().lastname = userInfo['lastname'] ?? '';
          FFAppState().bio = userInfo['bio'] ?? '';
          FFAppState().profilepic = userInfo['profilepic'] ?? '';
          FFAppState().followersCount = decodedResponse['followersCount'] ?? 0;
          FFAppState().followingCount = decodedResponse['followingCount'] ?? 0;
          FFAppState().ratingTotalCount =
              decodedResponse['ratingTotalCount'] ?? 0;
          FFAppState().ratingAverageValue =
              decodedResponse['ratingAverageValue'] ?? 5.0;
        }
        if (response.statusCode == 401) {
          if (!mounted) return;
          FFAppState().login = false;
          context.goNamed('registrer');
          return;
        }
      }
    } on SocketException {
      if (!mounted) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      if (!mounted) return;
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

  void _scrollListener1() async {
    if (_scrollController1.position.pixels >=
        _scrollController1.position.maxScrollExtent) {
      if (_isLoading || _model.end || _model.matvarer!.length < 44) return;
      _isLoading = true;
      _model.page += 1;
      await getAllFoods(false);
      _isLoading = false;
    }
  }

  void _scrollListener() async {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      if (_isFollowerLoading ||
          _model.followerEnd ||
          _model.folgerMatvarer!.length < 44) return;
      _isFollowerLoading = true;
      _model.followerPage += 1;
      await getFolgerFoods(false);
      _isFollowerLoading = false;
    }
  }

  @override
  void dispose() {
    _model.dispose();
    _scrollController1.removeListener(_scrollListener);
    _scrollController1.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
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
            toolbarHeight: 95,
            backgroundColor: FlutterFlowTheme.of(context).primary,
            iconTheme: IconThemeData(
              color: FlutterFlowTheme.of(context).alternate,
            ),
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0.0,
            title: Align(
              alignment: const AlignmentDirectional(0.0, 0.0),
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                child: SafeArea(
                  child: Container(
                    width: valueOrDefault<double>(
                      MediaQuery.sizeOf(context).width,
                      500.0,
                    ),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (_model.searching != true)
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 8),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TabBar(
                                    isScrollable: true,
                                    indicator: UnderlineTabIndicator(
                                      borderSide: BorderSide(
                                        width:
                                            2.5, // Thickness of the indicator
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                      ),
                                      insets:
                                          EdgeInsets.symmetric(horizontal: 15),
                                    ),
                                    indicatorPadding: EdgeInsets.zero,
                                    labelPadding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    labelColor:
                                        FlutterFlowTheme.of(context).alternate,
                                    dividerColor: Colors.transparent,
                                    unselectedLabelColor:
                                        Colors.black.withOpacity(0.5),
                                    labelStyle: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    tabAlignment: TabAlignment.center,
                                    tabs: const [
                                      SizedBox(
                                        height: 30.0,
                                        child: Center(
                                          child: Text('For deg'),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30.0,
                                        child: Center(
                                          child: Text('Følger'),
                                        ),
                                      ),
                                    ],
                                    controller: _model.tabBarController,
                                    onTap: (i) async {
                                      [() async {}, () async {}][i]();
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground, // or choose the correct background color
                                    borderRadius: BorderRadius.circular(13.0),
                                  ),
                                  child: CupertinoSearchTextField(
                                    controller: _model.textController,
                                    focusNode: _model.textFieldFocusNode,
                                    autofocus: false,
                                    onChanged: (text) {
                                      setState(() {
                                        _model.profilisloading = true;
                                      });
                                      if (_model.debounce?.isActive ?? false) {
                                        _model.debounce!.cancel();
                                      }
                                      _model.debounce = Timer(
                                          const Duration(milliseconds: 500),
                                          () {
                                        handleSearch();
                                      });
                                    },
                                    backgroundColor: const Color.fromARGB(
                                        255, 238, 238, 238),
                                    prefixInsets:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            12, 6, 6, 6),
                                    borderRadius: BorderRadius.circular(24.0),
                                    onSubmitted: (value) {
                                      if (_model
                                          .textController.text.isNotEmpty) {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        context.pushNamed(
                                          'BondeGardPage',
                                          queryParameters: {
                                            'kategori': serializeParam(
                                                'Søk', ParamType.String),
                                            'query': serializeParam(
                                                _model.textController.text,
                                                ParamType.String),
                                          }.withoutNulls,
                                        );
                                      }
                                    },
                                    placeholder: 'Søk',
                                    prefixIcon: Icon(
                                      CupertinoIcons.search,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText, // match text color from theme
                                      size: 20,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          fontFamily: 'Nunito',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText, // matching text color from theme
                                          fontSize: 15.0,
                                          letterSpacing: 0.0,
                                        ),
                                    onTap: () {
                                      setState(() {
                                        _model.searching =
                                            true; // Set searching to true when tapped
                                      });
                                    },
                                  ),
                                ),
                              ),
                              if (_model.searching == true)
                                GestureDetector(
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    setState(() {
                                      _model.textController!.clear();
                                    });
                                    setState(() {
                                      _model.searching = false;
                                      _model.profiler = null;
                                      _model.profilisloading = false;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left:
                                            10.0), // 10 pixels of left padding
                                    child: Text(
                                      'Avbryt',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Nunito',
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            fontSize: 17,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: const [],
            centerTitle: true,
            elevation: 0.0,
          ),
          body: _model.searching != true
              ? SafeArea(
                  top: true,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: SafeArea(
                          child: Container(
                            decoration: const BoxDecoration(),
                            child: TabBarView(
                              physics: const ClampingScrollPhysics(),
                              controller: _model.tabBarController,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 5.0, 0.0, 0.0),
                                  child: RefreshIndicator.adaptive(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    onRefresh: () async {
                                      HapticFeedback.selectionClick();
                                      _model.page = 0;
                                      _model.end = false;
                                      fetchData();
                                      getAllFoods(true);
                                    },
                                    child: SingleChildScrollView(
                                      controller: _scrollController1,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      primary: false,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          ListView(
                                            padding: EdgeInsets.zero,
                                            primary: false,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            children: [
                                              Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        0, -1),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(0, 0, 0, 0),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  8, 0, 0, 19),
                                                          child: Text(
                                                            'Kategorier',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  fontSize: 22,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0, 11, 0, 19),
                                                          child:
                                                              SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          8,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      context
                                                                          .pushNamed(
                                                                        'BondeGardPage',
                                                                        queryParameters:
                                                                            {
                                                                          'kategori':
                                                                              serializeParam(
                                                                            'kjøtt',
                                                                            ParamType.String,
                                                                          ),
                                                                        }.withoutNulls,
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width: 90,
                                                                      height:
                                                                          103.14,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: const Color(
                                                                            0xFFF6F6F6),
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Icon(
                                                                            Ionicons.restaurant_outline,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primaryText,
                                                                            size:
                                                                                29,
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                2,
                                                                                0,
                                                                                0),
                                                                            child:
                                                                                Text(
                                                                              'Kjøtt',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Nunito',
                                                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                                                    fontSize: 14,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w700,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          8,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      context
                                                                          .pushNamed(
                                                                        'BondeGardPage',
                                                                        queryParameters:
                                                                            {
                                                                          'kategori':
                                                                              serializeParam(
                                                                            'grønt',
                                                                            ParamType.String,
                                                                          ),
                                                                        }.withoutNulls,
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width: 90,
                                                                      height:
                                                                          103.14,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: const Color(
                                                                            0xFFF6F6F6),
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Icon(
                                                                            Ionicons.leaf_outline,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primaryText,
                                                                            size:
                                                                                29,
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                2,
                                                                                0,
                                                                                0),
                                                                            child:
                                                                                Text(
                                                                              'Grønt',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Nunito',
                                                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                                                    fontSize: 14,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w700,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          8,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      context
                                                                          .pushNamed(
                                                                        'BondeGardPage',
                                                                        queryParameters:
                                                                            {
                                                                          'kategori':
                                                                              serializeParam(
                                                                            'meieri',
                                                                            ParamType.String,
                                                                          ),
                                                                        }.withoutNulls,
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width: 90,
                                                                      height:
                                                                          103.14,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: const Color(
                                                                            0xFFF6F6F6),
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Icon(
                                                                            Ionicons.egg_outline,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primaryText,
                                                                            size:
                                                                                29,
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                2,
                                                                                0,
                                                                                0),
                                                                            child:
                                                                                Text(
                                                                              'meieri',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Nunito',
                                                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                                                    fontSize: 14,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w700,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          8,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      context
                                                                          .pushNamed(
                                                                        'BondeGardPage',
                                                                        queryParameters:
                                                                            {
                                                                          'kategori':
                                                                              serializeParam(
                                                                            'bakverk',
                                                                            ParamType.String,
                                                                          ),
                                                                        }.withoutNulls,
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width: 90,
                                                                      height:
                                                                          103.14,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: const Color(
                                                                            0xFFF6F6F6),
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Icon(
                                                                            Ionicons.basket_outline,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primaryText,
                                                                            size:
                                                                                29,
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                2,
                                                                                0,
                                                                                0),
                                                                            child:
                                                                                Text(
                                                                              'Bakverk',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Nunito',
                                                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                                                    fontSize: 14,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w700,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          8,
                                                                          0,
                                                                          8,
                                                                          0),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      context
                                                                          .pushNamed(
                                                                        'BondeGardPage',
                                                                        queryParameters:
                                                                            {
                                                                          'kategori':
                                                                              serializeParam(
                                                                            'sjømat',
                                                                            ParamType.String,
                                                                          ),
                                                                        }.withoutNulls,
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width: 90,
                                                                      height:
                                                                          103.14,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: const Color(
                                                                            0xFFF6F6F6),
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Icon(
                                                                            Ionicons.fish_outline,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primaryText,
                                                                            size:
                                                                                29,
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                2,
                                                                                0,
                                                                                0),
                                                                            child:
                                                                                Text(
                                                                              'Sjømat',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Nunito',
                                                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                                                    fontSize: 14,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w700,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  -0.76, -0.61),
                                                          child: Container(
                                                            width: MediaQuery
                                                                    .sizeOf(
                                                                        context)
                                                                .width,
                                                            height: 50,
                                                            decoration:
                                                                const BoxDecoration(),
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
                                                                          8,
                                                                          0,
                                                                          0,
                                                                          17),
                                                                  child: Text(
                                                                    'Lokalmat',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Nunito',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          fontSize:
                                                                              22,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w800,
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
                                                ),
                                              )
                                            ],
                                          ),
                                          if ((_model.matvarer == null ||
                                                  _model.matvarer!.isEmpty) &&
                                              _model.isloading == false)
                                            SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                  .width,
                                              height: 500,
                                              child: Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        0, -1),
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0, 0, 0, 110),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          child: Image.asset(
                                                            'assets/images/Usability_testing-pana.png',
                                                            width: 290,
                                                            height: 250,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0, 16, 0, 0),
                                                          child: Text(
                                                            'Her var det tomt',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .headlineSmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontSize: 20,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(5.0, 13.0, 5.0, 0.0),
                                            child: RefreshIndicator(
                                              onRefresh: () async {
                                                _model.page = 0;
                                                _model.end = false;
                                                await getAllFoods(true);
                                                setState(() {});
                                              },
                                              child: GridView.builder(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
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
                                                itemCount: _model.isloading
                                                    ? 1
                                                    : _model.end
                                                        ? _model.matvarer
                                                                ?.length ??
                                                            0
                                                        : (_model.matvarer
                                                                    ?.length ??
                                                                0) +
                                                            1,
                                                itemBuilder: (context, index) {
                                                  if (_model.isloading) {
                                                    return ShimmerLoadingWidget();
                                                  }
                                                  if (index <
                                                      (_model.matvarer
                                                              ?.length ??
                                                          0)) {
                                                    final matvare =
                                                        _model.matvarer![index];
                                                    return ProductList(
                                                      matvare: matvare,
                                                      onTap: () async {
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                FocusNode());
                                                        context.pushNamed(
                                                          'MatDetaljBondegard',
                                                          queryParameters: {
                                                            'matvare':
                                                                serializeParam(
                                                              matvare.toJson(),
                                                              ParamType.JSON,
                                                            ),
                                                          },
                                                        );
                                                      },
                                                    );
                                                  } else {
                                                    if (_model
                                                            .matvarer!.length <
                                                        44) {
                                                      return Container();
                                                    } else {
                                                      return ShimmerLoadingWidget();
                                                    }
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 5.0, 0.0, 0.0),
                                  child: RefreshIndicator.adaptive(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    onRefresh: () async {
                                      HapticFeedback.selectionClick();
                                      getFolgerFoods(true);
                                    },
                                    child: SingleChildScrollView(
                                      controller: _scrollController,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      primary: false,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          if (_model.folgerMatvarer != null &&
                                              _model.folgerMatvarer!.isNotEmpty)
                                            Align(
                                              alignment:
                                                  const AlignmentDirectional(
                                                      -1, 0),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(8, 0, 0, 0),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                8, 15, 0, 17),
                                                        child: Text(
                                                          'Følger',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Nunito',
                                                                fontSize: 22,
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
                                          if ((_model.folgerMatvarer == null ||
                                              _model.folgerMatvarer!.isEmpty))
                                            SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                  .width,
                                              child: Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        0, -1),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0, 20, 0, 0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            const AlignmentDirectional(
                                                                0, 1),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            // First Profile Outline
                                                            buildProfileOutline(
                                                              context,
                                                              100,
                                                              Colors.grey[300]
                                                                      ?.withOpacity(
                                                                          1) ??
                                                                  Colors.grey
                                                                      .withOpacity(
                                                                          0.3), // Reduce opacity
                                                              Colors.grey[300]
                                                                      ?.withOpacity(
                                                                          1) ??
                                                                  Colors.grey
                                                                      .withOpacity(
                                                                          0.3), // Reduce opacity
                                                            ),

                                                            // Second Profile Outline
                                                            buildProfileOutline(
                                                              context,
                                                              80,
                                                              Colors.grey[300]
                                                                      ?.withOpacity(
                                                                          1) ??
                                                                  Colors.grey
                                                                      .withOpacity(
                                                                          1),
                                                              Colors.grey[300]
                                                                      ?.withOpacity(
                                                                          1) ??
                                                                  Colors.grey
                                                                      .withOpacity(
                                                                          1),
                                                            ),

                                                            // Third Profile Outline
                                                            buildProfileOutline(
                                                              context,
                                                              50,
                                                              Colors.grey[300]
                                                                      ?.withOpacity(
                                                                          1) ??
                                                                  Colors.grey
                                                                      .withOpacity(
                                                                          1),
                                                              Colors.grey[300]
                                                                      ?.withOpacity(
                                                                          1) ??
                                                                  Colors.grey
                                                                      .withOpacity(
                                                                          1),
                                                            ),

                                                            // Fourth Profile Outline
                                                            buildProfileOutline(
                                                              context,
                                                              38,
                                                              Colors.grey[300]
                                                                      ?.withOpacity(
                                                                          1) ??
                                                                  Colors.grey
                                                                      .withOpacity(
                                                                          1),
                                                              Colors.grey[300]
                                                                      ?.withOpacity(
                                                                          1) ??
                                                                  Colors.grey
                                                                      .withOpacity(
                                                                          1),
                                                            ),

                                                            const SizedBox(
                                                                height: 8.0),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      25,
                                                                      0,
                                                                      25,
                                                                      0),
                                                              child: Text(
                                                                'Du kan se annonser fra folk du følger her',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineSmall
                                                                    .override(
                                                                      fontFamily:
                                                                          'Nunito',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                      fontSize:
                                                                          23,
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
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(5.0, 13.0, 5.0, 0.0),
                                            child: RefreshIndicator(
                                              onRefresh: () async {
                                                await getFolgerFoods(true);
                                                setState(() {});
                                              },
                                              child: GridView.builder(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
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
                                                itemCount: _model.isloading
                                                    ? 1
                                                    : _model.followerEnd
                                                        ? _model.folgerMatvarer
                                                                ?.length ??
                                                            0
                                                        : (_model.folgerMatvarer
                                                                    ?.length ??
                                                                0) +
                                                            1,
                                                itemBuilder: (context, index) {
                                                  if (_model.folgermatLoading) {
                                                    return ShimmerLoadingWidget();
                                                  }

                                                  if (index <
                                                      (_model.folgerMatvarer
                                                              ?.length ??
                                                          0)) {
                                                    final folgerMat = _model
                                                        .folgerMatvarer![index];

                                                    return ProductList(
                                                      matvare: folgerMat,
                                                      onTap: () async {
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                FocusNode());
                                                        context.pushNamed(
                                                          'MatDetaljBondegard',
                                                          queryParameters: {
                                                            'matvare':
                                                                serializeParam(
                                                              folgerMat
                                                                  .toJson(),
                                                              ParamType.JSON,
                                                            ),
                                                          },
                                                        );
                                                      },
                                                    );
                                                  } else {
                                                    if (_model.folgerMatvarer!
                                                            .length <
                                                        44) {
                                                      return Container();
                                                    } else {
                                                      return ShimmerLoadingWidget();
                                                    }
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SafeArea(
                  top: true,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification notification) {
                            if (notification is ScrollStartNotification) {
                              // Dismiss the keyboard when scrolling starts
                              FocusScope.of(context).unfocus();
                            }
                            return false; // Return false to allow further handling of the event
                          },
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            primary: false,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    if (_model.searching == true)
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 0.0, 0.0, 80.0),
                                        child: SingleChildScrollView(
                                          primary: false,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        20, 0, 15, 30),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    // When the search button is pressed
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            FocusNode());
                                                    context.pushNamed(
                                                      'BondeGardPage',
                                                      queryParameters: {
                                                        'kategori':
                                                            serializeParam(
                                                                'Søk',
                                                                ParamType
                                                                    .String),
                                                        'query': serializeParam(
                                                            _model
                                                                .textController
                                                                .text,
                                                            ParamType.String),
                                                      }.withoutNulls,
                                                    );
                                                  },
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 62,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.transparent,
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Icon(
                                                              CupertinoIcons
                                                                  .search,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryText,
                                                              size: 28,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      15,
                                                                      0,
                                                                      0,
                                                                      0),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    _model
                                                                            .textController
                                                                            .text
                                                                            .isNotEmpty
                                                                        ? 'Søk etter \"${_model.textController.text}\"'
                                                                        : 'Nye matvarer',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Nunito',
                                                                          fontSize:
                                                                              16,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                  ),
                                                                  Text(
                                                                    'Blant hele matsalg.no',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Nunito',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                          fontSize:
                                                                              15,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Icon(
                                                          CupertinoIcons
                                                              .chevron_forward,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          size: 23,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              if (_model.profiler != null)
                                                if (_model
                                                        .profiler!.isNotEmpty &&
                                                    _model.profilisloading !=
                                                        true)
                                                  Align(
                                                    alignment:
                                                        const AlignmentDirectional(
                                                            -1, 0),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              15, 0, 0, 10),
                                                      child: Text(
                                                        'Folk',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  fontSize: 21,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        5.0, 0.0, 5.0, 170.0),
                                                child: RefreshIndicator(
                                                  onRefresh: () async {
                                                    await handleSearch();
                                                    setState(() {});
                                                  },
                                                  child: ListView.builder(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                      0,
                                                      0,
                                                      0,
                                                      0,
                                                    ),
                                                    primary: false,
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount:
                                                        _model.profilisloading
                                                            ? 10
                                                            : _model.profiler
                                                                    ?.length ??
                                                                0,
                                                    itemBuilder:
                                                        (context, index) {
                                                      if (_model
                                                          .profilisloading) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 8.0,
                                                                  horizontal:
                                                                      16.0),
                                                          child: Row(
                                                            children: [
                                                              Shimmer
                                                                  .fromColors(
                                                                baseColor:
                                                                    Colors.grey[
                                                                        300]!,
                                                                highlightColor:
                                                                    Colors.grey[
                                                                        100]!,
                                                                child:
                                                                    Container(
                                                                  width: 50.0,
                                                                  height: 50.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        127,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            100.0),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 16.0),
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Shimmer
                                                                        .fromColors(
                                                                      baseColor:
                                                                          Colors
                                                                              .grey[300]!,
                                                                      highlightColor:
                                                                          Colors
                                                                              .grey[100]!,
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            75.0, // Narrower width for second line
                                                                        height:
                                                                            13.0,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              127,
                                                                              255,
                                                                              255,
                                                                              255),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            8.0),
                                                                    Shimmer
                                                                        .fromColors(
                                                                      baseColor:
                                                                          Colors
                                                                              .grey[300]!,
                                                                      highlightColor:
                                                                          Colors
                                                                              .grey[100]!,
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            120,
                                                                        height:
                                                                            13.0,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              127,
                                                                              255,
                                                                              255,
                                                                              255),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                      final profil = _model
                                                          .profiler![index];
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(5.0,
                                                                0.0, 10.0, 0.0),
                                                        child: InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            FocusScope.of(
                                                                    context)
                                                                .requestFocus(
                                                                    FocusNode());
                                                            context.pushNamed(
                                                              'BrukerPage',
                                                              queryParameters: {
                                                                'uid':
                                                                    serializeParam(
                                                                  profil.uid,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'username':
                                                                    serializeParam(
                                                                  profil
                                                                      .username,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                              },
                                                            );
                                                          },
                                                          child: Material(
                                                            color: Colors
                                                                .transparent,
                                                            elevation: 0.0,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          13.0),
                                                            ),
                                                            child: Container(
                                                              height: 73.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            13.0),
                                                                shape: BoxShape
                                                                    .rectangle,
                                                              ),
                                                              child: Align(
                                                                alignment:
                                                                    const AlignmentDirectional(
                                                                        0.0,
                                                                        0.0),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
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
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                1.0,
                                                                                1.0,
                                                                                1.0),
                                                                            child:
                                                                                ClipRRect(
                                                                              borderRadius: BorderRadius.circular(100.0),
                                                                              child: CachedNetworkImage(
                                                                                imageUrl: '${ApiConstants.baseUrl}${profil.profilepic}',
                                                                                width: 45.0,
                                                                                height: 45.0,
                                                                                fit: BoxFit.cover,
                                                                                imageBuilder: (context, imageProvider) {
                                                                                  return Container(
                                                                                    width: 45.0,
                                                                                    height: 45.0,
                                                                                    decoration: BoxDecoration(
                                                                                      image: DecorationImage(
                                                                                        image: imageProvider,
                                                                                        fit: BoxFit.cover,
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                                errorWidget: (context, url, error) => Image.asset(
                                                                                  'assets/images/profile_pic.png',
                                                                                  width: 45.0,
                                                                                  height: 45.0,
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                5.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Container(
                                                                              width: 179.0,
                                                                              height: 103.0,
                                                                              decoration: const BoxDecoration(),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                children: [
                                                                                  Align(
                                                                                    alignment: const AlignmentDirectional(-1.0, 1.0),
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsetsDirectional.fromSTEB(3.0, 0.0, 0.0, 20.0),
                                                                                      child: Text(
                                                                                        profil.username,
                                                                                        textAlign: TextAlign.start,
                                                                                        style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                              fontFamily: 'Nunito',
                                                                                              fontSize: 17.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.w600,
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
                                                                      Align(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .arrow_forward_ios,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                          size:
                                                                              18.0,
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
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
