import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mat_salg/MyIP.dart';
import 'package:mat_salg/app_main/vanlig_bruker/hjem/bruker_rating/bruker_rating_widget.dart';
import 'package:shimmer/shimmer.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'profil_model.dart';
export 'profil_model.dart';
import 'package:mat_salg/ApiCalls.dart';
import 'package:mat_salg/SecureStorage.dart';

import 'package:provider/provider.dart';

class ProfilWidget extends StatefulWidget {
  const ProfilWidget({super.key});

  @override
  State<ProfilWidget> createState() => _ProfilWidgetState();
}

class _ProfilWidgetState extends State<ProfilWidget>
    with TickerProviderStateMixin {
  late ProfilModel _model;
  List<Matvarer>? _likesmatvarer;
  bool _isloading = false;
  bool _likesisloading = true;
  bool _isExpanded = false;
  final ApiCalls apicalls = ApiCalls();
  final Securestorage securestorage = Securestorage();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, dynamic>? userInfo;

  @override
  void initState() {
    super.initState();
    getMyFoods();
    getAllLikes();
    fetchData();

    _model = createModel(context, () => ProfilModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
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

  Future<void> getMyFoods() async {
    try {
      String? token = await Securestorage().readToken();
      if (token == null) {
        // If there's no token, mark as logged out
        FFAppState().login = false;
        context.goNamed('registrer'); // Redirect to the register screen
        return;
      } else {
        // Fetch the Matvarer from the API
        List<Matvarer>? fetchedMatvarer = await ApiGetMyFoods.getMyFoods(token);

        if (fetchedMatvarer != null && fetchedMatvarer.isNotEmpty) {
          // If Matvarer are fetched successfully, store them in FFAppState
          FFAppState().matvarer = fetchedMatvarer;
          safeSetState(() {
            _isloading = false;
          });
        } else {
          // If no Matvarer are fetched, you can decide what to do here
          safeSetState(() {
            _isloading = false;
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

  Future<void> getAllLikes() async {
    try {
      String? token = await Securestorage().readToken();
      if (token == null) {
        FFAppState().login = false;
        context.goNamed('registrer');
        return;
      } else {
        _likesmatvarer = await ApiGetAllLikes.getAllLikes(token);
        safeSetState(() {
          if (_likesmatvarer != null && _likesmatvarer!.isEmpty) {
            return;
          }
          _likesisloading = false;
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

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primary,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            // iconTheme:
            //     IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0.0,
            title: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              child: Align(
                alignment: const AlignmentDirectional(0, 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: SafeArea(
                    child: Container(
                      width: valueOrDefault<double>(
                        MediaQuery.sizeOf(context).width,
                        500.0,
                      ),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                      child: Stack(
                        alignment: const AlignmentDirectional(0, 0),
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 0, 8, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Align(
                                  alignment: const AlignmentDirectional(1, 0),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        try {
                                          context.pushNamed('innstillinger');
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
                                      child: Icon(
                                        CupertinoIcons.gear,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        size: 29,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Text(
                              '@${FFAppState().brukernavn}',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Nunito',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize: 19,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
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
            actions: const [],
            centerTitle: true,
            elevation: 0.0,
          ),
          body: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: RefreshIndicator.adaptive(
                    color: FlutterFlowTheme.of(context).alternate,
                    onRefresh: () async {
                      HapticFeedback.lightImpact();
                      getMyFoods();
                      getAllLikes();
                      fetchData();
                    },
                    child: SingleChildScrollView(
                      primary: false,
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 20, 0, 0),
                                child: SingleChildScrollView(
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
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 0, 0),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        const AlignmentDirectional(
                                                            0, 0),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              24, 0, 0, 5),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: 85,
                                                            height: 85,
                                                            clipBehavior:
                                                                Clip.antiAlias,
                                                            decoration:
                                                                const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child:
                                                                CachedNetworkImage(
                                                              fadeInDuration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          0),
                                                              fadeOutDuration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          0),
                                                              imageUrl:
                                                                  '${ApiConstants.baseUrl}${FFAppState().profilepic}',
                                                              fit: BoxFit.cover,
                                                              errorWidget: (context,
                                                                      error,
                                                                      stackTrace) =>
                                                                  Image.asset(
                                                                'assets/images/profile_pic.png',
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(7,
                                                                    0, 0, 20),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          10,
                                                                          15,
                                                                          0,
                                                                          0),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                5,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            child:
                                                                                Container(
                                                                              width: 70,
                                                                              height: 50,
                                                                              decoration: BoxDecoration(
                                                                                color: FlutterFlowTheme.of(context).primary,
                                                                                borderRadius: BorderRadius.circular(10),
                                                                              ),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Text(
                                                                                    FFAppState().matvarer.length.toString(),
                                                                                    textAlign: TextAlign.center,
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: 'Nunito',
                                                                                          fontSize: 16,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                  ),
                                                                                  Text(
                                                                                    'matvarer',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: 'Nunito',
                                                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                                                          fontSize: 13,
                                                                                          letterSpacing: 0.0,
                                                                                        ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                5,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            child:
                                                                                Container(
                                                                              width: 70,
                                                                              height: 50,
                                                                              decoration: BoxDecoration(
                                                                                color: FlutterFlowTheme.of(context).primary,
                                                                                borderRadius: BorderRadius.circular(10),
                                                                              ),
                                                                              child: InkWell(
                                                                                splashColor: Colors.transparent,
                                                                                focusColor: Colors.transparent,
                                                                                hoverColor: Colors.transparent,
                                                                                highlightColor: Colors.transparent,
                                                                                onTap: () async {
                                                                                  try {
                                                                                    if (FFAppState().followersCount != 0) {
                                                                                      context.pushNamed(
                                                                                        'Folgere',
                                                                                        queryParameters: {
                                                                                          'username': serializeParam(FFAppState().brukernavn, ParamType.String),
                                                                                          'folger': serializeParam(
                                                                                            'Følgere',
                                                                                            ParamType.String,
                                                                                          ),
                                                                                        }.withoutNulls,
                                                                                      );
                                                                                    }
                                                                                  } on SocketException {
                                                                                    HapticFeedback.lightImpact();
                                                                                    showErrorToast(context, 'Ingen internettforbindelse');
                                                                                  } catch (e) {
                                                                                    HapticFeedback.lightImpact();
                                                                                    showErrorToast(context, 'En feil oppstod');
                                                                                  }
                                                                                },
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Text(
                                                                                      FFAppState().followersCount.toString(),
                                                                                      textAlign: TextAlign.center,
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: 'Nunito',
                                                                                            fontSize: 17,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.w600,
                                                                                          ),
                                                                                    ),
                                                                                    Text(
                                                                                      'følgere',
                                                                                      textAlign: TextAlign.center,
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: 'Nunito',
                                                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                                                            fontSize: 13,
                                                                                            letterSpacing: 0.0,
                                                                                          ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                5,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            child:
                                                                                Container(
                                                                              width: 70,
                                                                              height: 50,
                                                                              decoration: BoxDecoration(
                                                                                color: FlutterFlowTheme.of(context).primary,
                                                                                borderRadius: BorderRadius.circular(10),
                                                                              ),
                                                                              child: InkWell(
                                                                                splashColor: Colors.transparent,
                                                                                focusColor: Colors.transparent,
                                                                                hoverColor: Colors.transparent,
                                                                                highlightColor: Colors.transparent,
                                                                                onTap: () async {
                                                                                  try {
                                                                                    if (FFAppState().followingCount != 0) {
                                                                                      context.pushNamed(
                                                                                        'Folgere',
                                                                                        queryParameters: {
                                                                                          'username': serializeParam(FFAppState().brukernavn, ParamType.String),
                                                                                          'folger': serializeParam(
                                                                                            'Følger',
                                                                                            ParamType.String,
                                                                                          ),
                                                                                        }.withoutNulls,
                                                                                      );
                                                                                    }
                                                                                  } on SocketException {
                                                                                    HapticFeedback.lightImpact();
                                                                                    showErrorToast(context, 'Ingen internettforbindelse');
                                                                                  } catch (e) {
                                                                                    HapticFeedback.lightImpact();
                                                                                    showErrorToast(context, 'En feil oppstod');
                                                                                  }
                                                                                },
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Text(
                                                                                      FFAppState().followingCount.toString(),
                                                                                      textAlign: TextAlign.center,
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: 'Nunito',
                                                                                            fontSize: 16,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.w600,
                                                                                          ),
                                                                                    ),
                                                                                    Text(
                                                                                      'følger',
                                                                                      textAlign: TextAlign.center,
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: 'Nunito',
                                                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                                                            fontSize: 13,
                                                                                            letterSpacing: 0.0,
                                                                                          ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0,
                                                                          10,
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
                                                                            9,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            InkWell(
                                                                          splashColor:
                                                                              Colors.transparent,
                                                                          focusColor:
                                                                              Colors.transparent,
                                                                          hoverColor:
                                                                              Colors.transparent,
                                                                          highlightColor:
                                                                              Colors.transparent,
                                                                          onTap:
                                                                              () async {
                                                                            try {
                                                                              await showModalBottomSheet(
                                                                                isScrollControlled: true,
                                                                                backgroundColor: Colors.transparent,
                                                                                barrierColor: const Color.fromARGB(60, 17, 0, 0),
                                                                                useRootNavigator: true,
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return GestureDetector(
                                                                                    onTap: () => FocusScope.of(context).unfocus(),
                                                                                    child: Padding(
                                                                                      padding: MediaQuery.viewInsetsOf(context),
                                                                                      child: const BrukerRatingWidget(
                                                                                        mine: true,
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              ).then((value) => setState(() {}));
                                                                              return;
                                                                            } on SocketException {
                                                                              HapticFeedback.lightImpact();
                                                                              showErrorToast(context, 'Ingen internettforbindelse');
                                                                            } catch (e) {
                                                                              HapticFeedback.lightImpact();
                                                                              showErrorToast(context, 'En feil oppstod');
                                                                            }
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                200,
                                                                            height:
                                                                                30,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                              borderRadius: BorderRadius.circular(8),
                                                                              border: Border.all(
                                                                                color: const Color(0x4A57636C),
                                                                                width: 1.3,
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
                                                                              child: Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  if (FFAppState().ratingTotalCount == 0)
                                                                                    Padding(
                                                                                      padding: const EdgeInsetsDirectional.fromSTEB(1, 0, 0, 0),
                                                                                      child: Text(
                                                                                        'Ingen vurderinger',
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: 'Nunito',
                                                                                              fontSize: 14,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.w600,
                                                                                            ),
                                                                                      ),
                                                                                    ),
                                                                                  if (FFAppState().ratingTotalCount != 0)
                                                                                    FaIcon(
                                                                                      FontAwesomeIcons.solidStar,
                                                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                                                      size: 16,
                                                                                    ),
                                                                                  if (FFAppState().ratingTotalCount != 0)
                                                                                    Padding(
                                                                                      padding: const EdgeInsetsDirectional.fromSTEB(1, 0, 0, 0),
                                                                                      child: Text(
                                                                                        FFAppState().ratingAverageValue.toString(),
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: 'Nunito',
                                                                                              fontSize: 14,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.w600,
                                                                                            ),
                                                                                      ),
                                                                                    ),
                                                                                  if (FFAppState().ratingTotalCount != 0)
                                                                                    Padding(
                                                                                      padding: const EdgeInsetsDirectional.fromSTEB(1, 0, 0, 0),
                                                                                      child: Text(
                                                                                        ' (${FFAppState().ratingTotalCount.toString()})',
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: 'Nunito',
                                                                                              color: const Color(0xB0262C2D),
                                                                                              fontSize: 14,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.w500,
                                                                                            ),
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
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0, 5, 0, 0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  24, 0, 0, 0),
                                                          child: Text(
                                                            '${FFAppState().firstname} ${FFAppState().lastname}',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .headlineLarge
                                                                .override(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  fontSize: 18,
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
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            24, 0, 40, 0),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        {
                                                          context.pushNamed(
                                                            'ProfilRediger',
                                                            queryParameters: {
                                                              'konto':
                                                                  serializeParam(
                                                                'Bio',
                                                                ParamType
                                                                    .String,
                                                              ),
                                                            },
                                                          );
                                                        }
                                                      },
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary,
                                                            ),
                                                            child: Text(
                                                              FFAppState()
                                                                      .bio
                                                                      .isEmpty
                                                                  ? 'Trykk for å legge til bio...'
                                                                  : FFAppState()
                                                                      .bio,
                                                              maxLines: _isExpanded
                                                                  ? null
                                                                  : 2, // Expand or limit lines
                                                              overflow: _isExpanded
                                                                  ? TextOverflow
                                                                      .visible
                                                                  : TextOverflow
                                                                      .ellipsis,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Nunito',
                                                                    fontSize: FFAppState()
                                                                            .bio
                                                                            .isEmpty
                                                                        ? 15
                                                                        : 14,
                                                                    color: FFAppState()
                                                                            .bio
                                                                            .isEmpty
                                                                        ? const Color
                                                                            .fromRGBO(
                                                                            113,
                                                                            113,
                                                                            113,
                                                                            1.0)
                                                                        : FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                            ),
                                                          ),
                                                          if (FFAppState()
                                                                      .bio
                                                                      .length >
                                                                  50 ||
                                                              '\n'
                                                                      .allMatches(
                                                                          FFAppState()
                                                                              .bio)
                                                                      .length >=
                                                                  2)
                                                            if (FFAppState()
                                                                .bio
                                                                .isNotEmpty)
                                                              GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    _isExpanded =
                                                                        !_isExpanded; // Toggle expanded state
                                                                  });
                                                                },
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              2),
                                                                  child: Text(
                                                                    _isExpanded
                                                                        ? 'Se mindre'
                                                                        : 'Se mer',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .override(
                                                                          fontFamily:
                                                                              'Nunito',
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                          color: const Color
                                                                              .fromRGBO(
                                                                              113,
                                                                              113,
                                                                              113,
                                                                              1.0),
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    height: 90,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              0, 30, 0, 0),
                                                      child: Column(
                                                        children: [
                                                          Align(
                                                            alignment:
                                                                const Alignment(
                                                                    0, 0),
                                                            child: TabBar(
                                                              labelColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                              unselectedLabelColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                              labelStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Nunito',
                                                                        letterSpacing:
                                                                            0.0,
                                                                      ),
                                                              unselectedLabelStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Nunito',
                                                                        letterSpacing:
                                                                            0.0,
                                                                      ),
                                                              indicatorColor:
                                                                  const Color
                                                                      .fromARGB(
                                                                      0,
                                                                      0,
                                                                      0,
                                                                      0),
                                                              dividerColor:
                                                                  const Color
                                                                      .fromARGB(
                                                                      10,
                                                                      0,
                                                                      0,
                                                                      0),
                                                              indicatorWeight:
                                                                  1,
                                                              tabs: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Icon(
                                                                      CupertinoIcons
                                                                          .square_grid_2x2,
                                                                      color: _model.tabBarCurrentIndex == 0
                                                                          ? FlutterFlowTheme.of(context)
                                                                              .primaryText
                                                                          : Colors
                                                                              .grey,
                                                                      size: 32,
                                                                    ),
                                                                    const Tab(
                                                                      text: '',
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Icon(
                                                                      CupertinoIcons
                                                                          .heart,
                                                                      color: _model.tabBarCurrentIndex == 1
                                                                          ? FlutterFlowTheme.of(context)
                                                                              .primaryText
                                                                          : Colors
                                                                              .grey,
                                                                      size: 32,
                                                                    ),
                                                                    const Tab(
                                                                      text: '',
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                              controller: _model
                                                                  .tabBarController,
                                                              onTap: (i) async {
                                                                [
                                                                  () async {},
                                                                  () async {}
                                                                ][i]();
                                                              },
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: TabBarView(
                                                              controller: _model
                                                                  .tabBarController,
                                                              physics:
                                                                  const NeverScrollableScrollPhysics(),
                                                              children: [
                                                                Container(),
                                                                Container(),
                                                              ],
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
                                        ],
                                      ),
                                      if (_model.tabBarCurrentIndex == 0)
                                        if ((FFAppState().lagtUt != true &&
                                            _model.tabBarCurrentIndex == 0))
                                          Container(
                                            width: MediaQuery.sizeOf(context)
                                                .width,
                                            height: MediaQuery.sizeOf(context)
                                                    .height -
                                                550,
                                            child: Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize
                                                    .min, // Use min to fit content
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    CupertinoIcons.add,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    size: 53,
                                                  ),
                                                  const SizedBox(height: 16),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Trykk på ',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .override(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  fontSize: 17,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                      ),
                                                      Icon(
                                                        CupertinoIcons.add,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        size: 23,
                                                      ),
                                                      Text(
                                                        ' for å lage din første annonse',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .override(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  fontSize: 17,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                      if (FFAppState().lagtUt &&
                                          _model.tabBarCurrentIndex == 0)
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(5, 15, 5, 0),
                                          child: RefreshIndicator(
                                            onRefresh: () async {
                                              try {
                                                getMyFoods();
                                                getAllLikes();
                                                fetchData();
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
                                            child: GridView.builder(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                0,
                                                0,
                                                0,
                                                70,
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
                                                  : FFAppState()
                                                      .matvarer
                                                      .length,
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
                                                                .fromARGB(127,
                                                                255, 255, 255),
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
                                                                .fromARGB(127,
                                                                255, 255, 255),
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

                                                final matvare = FFAppState()
                                                    .matvarer
                                                    .toList()[index];
                                                return Stack(
                                                  children: [
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
                                                              try {
                                                                context
                                                                    .pushNamed(
                                                                  'MinMatvareDetalj',
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
                                                              } on SocketException {
                                                                HapticFeedback
                                                                    .lightImpact();
                                                                showErrorToast(
                                                                    context,
                                                                    'Ingen internettforbindelse');
                                                              } catch (e) {
                                                                HapticFeedback
                                                                    .lightImpact();
                                                                showErrorToast(
                                                                    context,
                                                                    'En feil oppstod');
                                                              }
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
                                                                            0,
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
                                                                                      fontWeight: FontWeight.bold,
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
                                                        // Sale banner
                                                        if (matvare.kjopt ==
                                                            true)
                                                          Positioned(
                                                            top:
                                                                15, // Slight offset from the top edge
                                                            right:
                                                                -29, // Fine-tune the positioning (shift it to the right edge)
                                                            child: Transform
                                                                .rotate(
                                                              angle:
                                                                  0.600, // 45-degree angle (approx.)
                                                              child: Container(
                                                                width:
                                                                    140, // Adjusted width to avoid overflow after rotation
                                                                height: 23,
                                                                color: Colors
                                                                    .redAccent,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    const Text(
                                                                  'Utsolgt',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14, // Font size adjusted to fit the banner
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      if (_model.tabBarCurrentIndex == 1)
                                        if (FFAppState().liked != true &&
                                            _model.tabBarCurrentIndex == 1)
                                          Container(
                                            width: MediaQuery.sizeOf(context)
                                                .width,
                                            height: MediaQuery.sizeOf(context)
                                                    .height -
                                                550,
                                            child: Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize
                                                    .min, // Use min to fit content
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    CupertinoIcons.heart,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    size: 50,
                                                  ),
                                                  const SizedBox(height: 16),
                                                  Text(
                                                    'Du kan se mat du har likt her.',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLarge
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 17,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                      if (FFAppState().liked &&
                                          _model.tabBarCurrentIndex == 1)
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(5, 15, 5, 0),
                                          child: RefreshIndicator(
                                            onRefresh: () async {
                                              try {
                                                getAllLikes();
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
                                            child: GridView.builder(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                0,
                                                0,
                                                0,
                                                70,
                                              ),
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                childAspectRatio: 0.68,
                                              ),
                                              primary: false,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount: _likesisloading
                                                  ? 1
                                                  : _likesmatvarer?.length ?? 1,
                                              itemBuilder: (context, index) {
                                                if (_likesisloading) {
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
                                                                .fromARGB(127,
                                                                255, 255, 255),
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
                                                                .fromARGB(127,
                                                                255, 255, 255),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                        ),
                                                        // const SizedBox(
                                                        //     height: 8.0),
                                                        // Align(
                                                        //   alignment: Alignment
                                                        //       .centerLeft,
                                                        //   child: Padding(
                                                        //     padding:
                                                        //         const EdgeInsets
                                                        //             .only(
                                                        //             left: 10.0),
                                                        //     child: Container(
                                                        //       width: 38,
                                                        //       height: 15,
                                                        //       decoration:
                                                        //           BoxDecoration(
                                                        //         color: const Color
                                                        //             .fromARGB(
                                                        //             127,
                                                        //             255,
                                                        //             255,
                                                        //             255),
                                                        //         borderRadius:
                                                        //             BorderRadius
                                                        //                 .circular(
                                                        //                     10.0),
                                                        //       ),
                                                        //     ),
                                                        //   ),
                                                        // )
                                                      ],
                                                    ),
                                                  );
                                                }

                                                final likesmatvare =
                                                    _likesmatvarer![index];

                                                return Stack(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          const AlignmentDirectional(
                                                              0, -1),
                                                      child: InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          try {
                                                            context.pushNamed(
                                                              'MatDetaljBondegard',
                                                              queryParameters: {
                                                                'matvare':
                                                                    serializeParam(
                                                                  likesmatvare
                                                                      .toJson(), // Convert to JSON before passing
                                                                  ParamType
                                                                      .JSON,
                                                                ),
                                                              },
                                                            );
                                                          } on SocketException {
                                                            HapticFeedback
                                                                .lightImpact();
                                                            showErrorToast(
                                                                context,
                                                                'Ingen internettforbindelse');
                                                          } catch (e) {
                                                            HapticFeedback
                                                                .lightImpact();
                                                            showErrorToast(
                                                                context,
                                                                'En feil oppstod');
                                                          }
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
                                                              border:
                                                                  Border.all(
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
                                                                          0, 0),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            3,
                                                                            0,
                                                                            3,
                                                                            0),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              17),
                                                                      child: Image
                                                                          .network(
                                                                        '${ApiConstants.baseUrl}${likesmatvare.imgUrls![0]}',
                                                                        width:
                                                                            200,
                                                                        height:
                                                                            229,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        errorBuilder: (BuildContext context,
                                                                            Object
                                                                                error,
                                                                            StackTrace?
                                                                                stackTrace) {
                                                                          return Image
                                                                              .asset(
                                                                            'assets/images/error_image.jpg',
                                                                            width:
                                                                                200,
                                                                            height:
                                                                                229,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          5,
                                                                          0,
                                                                          5,
                                                                          0),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Align(
                                                                        alignment: const AlignmentDirectional(
                                                                            -1,
                                                                            0),
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              7,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              AutoSizeText(
                                                                            likesmatvare.name ??
                                                                                '',
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            minFontSize:
                                                                                11,
                                                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                  fontFamily: 'Nunito',
                                                                                  fontSize: 14,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.bold,
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
                                                                          .fromSTEB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          4),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Flexible(
                                                                        child:
                                                                            Align(
                                                                          alignment: const AlignmentDirectional(
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                5,
                                                                                0,
                                                                                5,
                                                                                0),
                                                                            child:
                                                                                Row(
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
                                                                                          '${likesmatvare.price} Kr',
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
                                                                                      if (likesmatvare.kg == true)
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
                                                                                        (calculateDistance(FFAppState().brukerLat, FFAppState().brukerLng, likesmatvare.lat ?? 0.0, likesmatvare.lng ?? 0.0) < 1) ? '<1 Km' : '${calculateDistance(FFAppState().brukerLat, FFAppState().brukerLng, likesmatvare.lat ?? 0.0, likesmatvare.lng ?? 0.0).toStringAsFixed(0)} Km',
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
                // wrapWithModel(
                //   model: _model.profilNavBarModel,
                //   updateCallback: () => safeSetState(() {}),
                //   child: const ProfilNavBarWidget(),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
