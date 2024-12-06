import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mat_salg/MyIP.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:mat_salg/ApiCalls.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mat_salg/SecureStorage.dart';
import 'dart:math';
import 'hjem_model.dart';
export 'hjem_model.dart';

class HjemWidget extends StatefulWidget {
  const HjemWidget({super.key});

  @override
  State<HjemWidget> createState() => _HjemWidgetState();
}

class _HjemWidgetState extends State<HjemWidget> with TickerProviderStateMixin {
  late HjemModel _model;

  List<Matvarer>? _matvarer;
  List<Matvarer>? _folgerMatvarer;
  List<UserInfoSearch>? _profiler;
  bool _isloading = true;
  bool _folgermatLoading = true;
  bool _profilisloading = false;
  bool searching = false;
  Timer? _debounce;
  final ScrollController _scrollController = ScrollController();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ApiCalls apicalls = ApiCalls();
  final Securestorage securestorage = Securestorage();

  LatLng? currentUserLocationValue;
  Map<String, dynamic>? userInfo;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HjemModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _model.textFieldFocusNode!.addListener(() => safeSetState(() {
          searching = true;
        }));

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {
          if (_model.tabBarCurrentIndex == 1) {
            getFolgerFoods();
          }
        }));
    fetchData();
    getAllFoods();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      currentUserLocationValue =
          await getCurrentUserLocation(defaultLocation: const LatLng(0.0, 0.0));
      FFAppState().brukersted = currentUserLocationValue;
      FFAppState().bonde = false;

      _scrollController.addListener(_onScroll);
      safeSetState(() {});
    });
  }

  Future<void> getUserLocation() async {
    LatLng? location;
    location =
        await getCurrentUserLocation(defaultLocation: const LatLng(0.0, 0.0));
    if (location != const LatLng(0.0, 0.0)) {
      FFAppState().brukerLat = location.latitude;
      FFAppState().brukerLng = location.latitude;
    }
  }

  void _onScroll() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (mounted) {
      setState(() {});
    }
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

  void showErrorToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        left: 16.0,
        right: 16.0,
        child: Material(
          color: Colors.transparent,
          child: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.up, // Allow dismissing upwards
            onDismissed: (_) =>
                overlayEntry.remove(), // Remove overlay on dismiss
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    offset: Offset(0, 2),
                  ),
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
      ),
    );

    overlay.insert(overlayEntry);

    // Auto-remove the toast after 3 seconds if not dismissed
    Future.delayed(const Duration(seconds: 3), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  Future<void> handleSearch() async {
    try {
      _profilisloading = true;
      String? token = await Securestorage().readToken();
      if (token == null) {
        FFAppState().login = false;
        context.goNamed('registrer');
        return;
      } else {
        _profiler =
            await ApiSearchUsers.searchUsers(token, _model.textController.text);
        if (mounted) {
          setState(() {
            if (_profiler != null && _profiler!.isEmpty) {
              _profilisloading = false;
              return;
            } else {
              _profilisloading = false;
            }
          });
        }
      }
    } on SocketException {
      HapticFeedback.lightImpact();
      showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      HapticFeedback.lightImpact();
      showErrorToast(context, 'En feil oppstod');
    }
  }

  Future<void> getAllFoods() async {
    try {
      String? token = await Securestorage().readToken();
      if (token == null) {
        FFAppState().login = false;
        context.goNamed('registrer');
        return;
      } else {
        if (FFAppState().brukerLat == 59.9138688 ||
            FFAppState().brukerLng == 10.7522454) {
          await fetchData();
        }
        _matvarer = await ApiGetAllFoods.getAllFoods(token);
        if (mounted) {
          setState(() {
            if (_matvarer != null && _matvarer!.isEmpty) {
              return;
            } else {
              _isloading = false;
            }
          });
        }
      }
    } on SocketException {
      HapticFeedback.lightImpact();
      showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      HapticFeedback.lightImpact();
      showErrorToast(context, 'En feil oppstod');
    }
  }

  Future<void> getFolgerFoods() async {
    try {
      String? token = await Securestorage().readToken();
      if (token == null) {
        FFAppState().login = false;
        context.goNamed('registrer');
        return;
      } else {
        if (FFAppState().brukerLat == 59.9138688 ||
            FFAppState().brukerLng == 10.7522454) {
          await fetchData();
        }
        _folgerMatvarer = await ApiGetFilterFood.getFolgerFood(token);
        if (mounted) {
          setState(() {
            if (_folgerMatvarer != null && _folgerMatvarer!.isNotEmpty) {
              _folgermatLoading = false;
              return;
            } else {
              _folgermatLoading = false;
            }
          });
        }
      }
    } on SocketException {
      HapticFeedback.lightImpact();
      showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      HapticFeedback.lightImpact();
      showErrorToast(context, 'En feil oppstod');
    }
  }

  Future<void> fetchData() async {
    try {
      String? token = await Securestorage().readToken();
      if (token == null) {
        FFAppState().login = false;
        context.goNamed('registrer');
        return;
      } else {
        final response = await apicalls.checkUserInfo(Securestorage.authToken);
        if (response.statusCode == 200) {
          final decodedResponse = jsonDecode(response.body);
          final userInfo = decodedResponse['userInfo'] ?? {};

          FFAppState().brukerLat = userInfo['lat'] ?? 59.9138688;
          FFAppState().brukerLng = userInfo['lng'] ?? 10.7522454;
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
          getUserLocation();
        }
        if (response.statusCode == 401) {
          FFAppState().login = false;
          context.goNamed('registrer');
          return;
        }
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

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: WillPopScope(
        onWillPop: () async => false,
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
                        if (searching != true)
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
                                    indicator: const UnderlineTabIndicator(
                                      borderSide: BorderSide(
                                        width:
                                            2.5, // Thickness of the indicator
                                        color: Colors
                                            .blue, // Color of the indicator
                                      ),
                                      insets:
                                          EdgeInsets.symmetric(horizontal: 15),
                                    ),
                                    indicatorPadding: EdgeInsets.zero,
                                    labelPadding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    labelColor: Colors.blue,
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
                                        height:
                                            30.0, // Set an explicit height for tighter control
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
                                        _profilisloading = true;
                                      });
                                      if (_debounce?.isActive ?? false)
                                        _debounce!.cancel();
                                      _debounce = Timer(
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
                                        // When the search button is pressed
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
                                        searching =
                                            true; // Set searching to true when tapped
                                      });
                                    },
                                  ),
                                ),
                              ),
                              if (searching == true)
                                GestureDetector(
                                  onTap: () async {
                                    _model.textController!.clear();
                                    setState(() {
                                      searching = false;
                                      _profiler = null;
                                      _profilisloading = false;
                                    });
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
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
          body: searching != true
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
                                      HapticFeedback.lightImpact();
                                      fetchData();
                                      getAllFoods();
                                    },
                                    child: SingleChildScrollView(
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
                                          if ((_matvarer == null ||
                                                  _matvarer!.isEmpty) &&
                                              _isloading == false)
                                            Container(
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
                                                await getAllFoods();
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
                                                itemCount: _isloading
                                                    ? 1
                                                    : _matvarer?.length ?? 0,
                                                itemBuilder: (context, index) {
                                                  if (_isloading) {
                                                    return Shimmer.fromColors(
                                                      baseColor:
                                                          Colors.grey[300]!,
                                                      highlightColor:
                                                          Colors.grey[100]!,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(5.0),
                                                            width: 200.0,
                                                            height: 230.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color
                                                                  .fromARGB(
                                                                  127,
                                                                  255,
                                                                  255,
                                                                  255),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16.0), // Rounded corners
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 8.0),
                                                          Container(
                                                            width: 200,
                                                            height: 15,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color
                                                                  .fromARGB(
                                                                  127,
                                                                  255,
                                                                  255,
                                                                  255),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                  final matvare =
                                                      _matvarer![index];
                                                  return Stack(children: [
                                                    Stack(
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  0, -1),
                                                          child: InkWell(
                                                            splashColor: Colors
                                                                .transparent,
                                                            focusColor: Colors
                                                                .transparent,
                                                            hoverColor: Colors
                                                                .transparent,
                                                            highlightColor:
                                                                Colors
                                                                    .transparent,
                                                            onTap: () async {
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      FocusNode());
                                                              context.pushNamed(
                                                                'MatDetaljBondegard',
                                                                queryParameters: {
                                                                  'matvare':
                                                                      serializeParam(
                                                                    matvare
                                                                        .toJson(), // Convert to JSON before passing
                                                                    ParamType
                                                                        .JSON,
                                                                  ),
                                                                },
                                                              );
                                                            },
                                                            child: Material(
                                                              color: Colors
                                                                  .transparent,
                                                              elevation: 0,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16),
                                                              ),
                                                              child: Container(
                                                                width: 235,
                                                                height: 290,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16),
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .transparent,
                                                                  ),
                                                                ),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Align(
                                                                      alignment:
                                                                          const AlignmentDirectional(
                                                                              0,
                                                                              0),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            3,
                                                                            0,
                                                                            3,
                                                                            0),
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(17),
                                                                          child:
                                                                              Image.network(
                                                                            '${ApiConstants.baseUrl}${matvare.imgUrls![0]}',
                                                                            width:
                                                                                200,
                                                                            height:
                                                                                229,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            errorBuilder: (BuildContext context,
                                                                                Object error,
                                                                                StackTrace? stackTrace) {
                                                                              return Image.asset(
                                                                                'assets/images/error_image.jpg',
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
                                                                      padding: const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          5,
                                                                          0,
                                                                          5,
                                                                          0),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          Align(
                                                                            alignment:
                                                                                const AlignmentDirectional(-1, 0),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsetsDirectional.fromSTEB(7, 0, 0, 0),
                                                                              child: AutoSizeText(
                                                                                matvare.name ?? '',
                                                                                textAlign: TextAlign.start,
                                                                                minFontSize: 11,
                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                      fontFamily: 'Nunito',
                                                                                      fontSize: 14,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w700,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          4),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          Flexible(
                                                                            child:
                                                                                Align(
                                                                              alignment: const AlignmentDirectional(0, 0),
                                                                              child: Padding(
                                                                                padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                                                                                child: Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        children: [
                                                                                          Padding(
                                                                                            padding: const EdgeInsetsDirectional.fromSTEB(7, 0, 0, 0),
                                                                                            child: Text(
                                                                                              '${matvare.price} Kr',
                                                                                              textAlign: TextAlign.end,
                                                                                              style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                                    fontFamily: 'Nunito',
                                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                    fontSize: 14,
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                  ),
                                                                                            ),
                                                                                          ),
                                                                                          if (matvare.kg == true)
                                                                                            Text(
                                                                                              '/kg',
                                                                                              textAlign: TextAlign.end,
                                                                                              style: FlutterFlowTheme.of(context).titleLarge.override(
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
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 7, 0),
                                                                                          child: Text(
                                                                                            // Directly calculate the distance using the provided latitude and longitude
                                                                                            (calculateDistance(FFAppState().brukerLat, FFAppState().brukerLng, matvare.lat ?? 0.0, matvare.lng ?? 0.0) < 1) ? '<1 Km' : '${calculateDistance(FFAppState().brukerLat, FFAppState().brukerLng, matvare.lat ?? 0.0, matvare.lng ?? 0.0).toStringAsFixed(0)} Km',
                                                                                            textAlign: TextAlign.start,
                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
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
                                                    ),
                                                  ]);
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
                                      HapticFeedback.lightImpact();
                                      getFolgerFoods();
                                    },
                                    child: SingleChildScrollView(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      primary: false,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          if (_folgerMatvarer != null &&
                                              _folgerMatvarer!.isNotEmpty)
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
                                          if ((_folgerMatvarer == null ||
                                                  _folgerMatvarer!.isEmpty) &&
                                              _folgermatLoading == false)
                                            SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                  .width,
                                              height: MediaQuery.sizeOf(context)
                                                  .height,
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
                                                await getFolgerFoods();
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
                                                itemCount: _isloading
                                                    ? 1
                                                    : _folgerMatvarer?.length ??
                                                        0,
                                                itemBuilder: (context, index) {
                                                  if (_folgermatLoading) {
                                                    return Shimmer.fromColors(
                                                      baseColor:
                                                          Colors.grey[300]!,
                                                      highlightColor:
                                                          Colors.grey[100]!,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(5.0),
                                                            width: 200.0,
                                                            height: 230.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color
                                                                  .fromARGB(
                                                                  127,
                                                                  255,
                                                                  255,
                                                                  255),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16.0), // Rounded corners
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 8.0),
                                                          Container(
                                                            width: 200,
                                                            height: 15,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color
                                                                  .fromARGB(
                                                                  127,
                                                                  255,
                                                                  255,
                                                                  255),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                  final folgerMat =
                                                      _folgerMatvarer![index];
                                                  return Stack(children: [
                                                    Stack(
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  0, -1),
                                                          child: InkWell(
                                                            splashColor: Colors
                                                                .transparent,
                                                            focusColor: Colors
                                                                .transparent,
                                                            hoverColor: Colors
                                                                .transparent,
                                                            highlightColor:
                                                                Colors
                                                                    .transparent,
                                                            onTap: () async {
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      FocusNode());
                                                              context.pushNamed(
                                                                'MatDetaljBondegard',
                                                                queryParameters: {
                                                                  'matvare':
                                                                      serializeParam(
                                                                    folgerMat
                                                                        .toJson(), // Convert to JSON before passing
                                                                    ParamType
                                                                        .JSON,
                                                                  ),
                                                                },
                                                              );
                                                            },
                                                            child: Material(
                                                              color: Colors
                                                                  .transparent,
                                                              elevation: 0,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16),
                                                              ),
                                                              child: Container(
                                                                width: 235,
                                                                height: 290,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16),
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .transparent,
                                                                  ),
                                                                ),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Align(
                                                                      alignment:
                                                                          const AlignmentDirectional(
                                                                              0,
                                                                              0),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            3,
                                                                            0,
                                                                            3,
                                                                            0),
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(17),
                                                                          child:
                                                                              Image.network(
                                                                            '${ApiConstants.baseUrl}${folgerMat.imgUrls![0]}',
                                                                            width:
                                                                                200,
                                                                            height:
                                                                                229,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            errorBuilder: (BuildContext context,
                                                                                Object error,
                                                                                StackTrace? stackTrace) {
                                                                              return Image.asset(
                                                                                'assets/images/error_image.jpg',
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
                                                                      padding: const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          5,
                                                                          0,
                                                                          5,
                                                                          0),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          Align(
                                                                            alignment:
                                                                                const AlignmentDirectional(-1, 0),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsetsDirectional.fromSTEB(7, 0, 0, 0),
                                                                              child: AutoSizeText(
                                                                                folgerMat.name ?? '',
                                                                                textAlign: TextAlign.start,
                                                                                minFontSize: 11,
                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                      fontFamily: 'Nunito',
                                                                                      fontSize: 14,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w700,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          4),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          Flexible(
                                                                            child:
                                                                                Align(
                                                                              alignment: const AlignmentDirectional(0, 0),
                                                                              child: Padding(
                                                                                padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                                                                                child: Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        children: [
                                                                                          Padding(
                                                                                            padding: const EdgeInsetsDirectional.fromSTEB(7, 0, 0, 0),
                                                                                            child: Text(
                                                                                              '${folgerMat.price} Kr',
                                                                                              textAlign: TextAlign.end,
                                                                                              style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                                    fontFamily: 'Nunito',
                                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                    fontSize: 14,
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                  ),
                                                                                            ),
                                                                                          ),
                                                                                          if (folgerMat.kg == true)
                                                                                            Text(
                                                                                              '/kg',
                                                                                              textAlign: TextAlign.end,
                                                                                              style: FlutterFlowTheme.of(context).titleLarge.override(
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
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 7, 0),
                                                                                          child: Text(
                                                                                            // Directly calculate the distance using the provided latitude and longitude
                                                                                            (calculateDistance(FFAppState().brukerLat, FFAppState().brukerLng, folgerMat.lat ?? 0.0, folgerMat.lng ?? 0.0) < 1) ? '<1 Km' : '${calculateDistance(FFAppState().brukerLat, FFAppState().brukerLng, folgerMat.lat ?? 0.0, folgerMat.lng ?? 0.0).toStringAsFixed(0)} Km',
                                                                                            textAlign: TextAlign.start,
                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
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
                                                    ),
                                                  ]);
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
                            primary: false,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    if (searching == true)
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 0.0, 0.0, 80.0),
                                        child: SingleChildScrollView(
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
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
                                              if (_profiler != null)
                                                if (_profiler!.isNotEmpty &&
                                                    _profilisloading != true)
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
                                                    itemCount: _profilisloading
                                                        ? 10
                                                        : _profiler?.length ??
                                                            0,
                                                    itemBuilder:
                                                        (context, index) {
                                                      if (_profilisloading) {
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
                                                      final profil =
                                                          _profiler![index];
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
                                                              height: 80.0,
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
                                                                              child: Image.network(
                                                                                '${ApiConstants.baseUrl}${profil.profilepic}',
                                                                                width: 45.0,
                                                                                height: 45.0,
                                                                                fit: BoxFit.cover,
                                                                                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                                                                  return Image.asset(
                                                                                    'assets/images/profile_pic.png',
                                                                                    width: 45.0,
                                                                                    height: 45.0,
                                                                                    fit: BoxFit.cover,
                                                                                  );
                                                                                },
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
