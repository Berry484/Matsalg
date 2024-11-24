import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mat_salg/ApiCalls.dart';
import 'package:mat_salg/Bonder.dart';
import 'package:mat_salg/MyIP.dart';
import 'package:mat_salg/SecureStorage.dart';
import 'package:mat_salg/matvarer.dart';
import 'package:shimmer/shimmer.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'bruker_page_model.dart';
export 'bruker_page_model.dart';

class BrukerPageWidget extends StatefulWidget {
  const BrukerPageWidget({this.bruker, this.username, super.key});

  final dynamic bruker;
  final String? username;

  @override
  State<BrukerPageWidget> createState() => _BrukerPageWidgetState();
}

class _BrukerPageWidgetState extends State<BrukerPageWidget>
    with TickerProviderStateMixin {
  late BrukerPageModel _model;
  bool _isLoading = true;
  bool _empty = false;
  List<Bonder>? _brukerinfo;
  List<Matvarer>? _matvarer;
  UserInfoStats? _ratingStats;
  bool _matisLoading = true;
  Bonder? bruker;
  String? folgere;
  String? folger;
  bool? brukerFolger = false;
  double ratingVerdi = 5.0;
  int ratingantall = 0;
  bool ingenRatings = false;
  bool _messageIsLoading = false;
  bool _folgerLoading = false;
  bool _isExpanded = false;
  final Securestorage securestorage = Securestorage();
  final ApiFolg apiFolg = ApiFolg();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BrukerPageModel());
    getRatingStats();
    sjekkFolger();
    _checkUser();
    getUserFood();
    tellFolger();
    tellFolgere();
    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
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

  Future<void> _checkUser() async {
    try {
      String? token = await Securestorage().readToken();
      if (token == null) {
        FFAppState().login = false;
        context.pushNamed('registrer');
        return;
      } else {
        // Fetch user info only if bruker is null
        if (widget.bruker != 1) {
          _brukerinfo = await ApiGetUser.checkUser(token, widget.username);
          if (_brukerinfo != null && _brukerinfo!.isNotEmpty) {
            bruker = _brukerinfo![0]; // Get the first Bonder object

            _isLoading = false;
          } else {
            // Fallback values
            bruker = Bonder(
              username: '',
              firstname: '',
              lastname: '',
              profilepic: '', // Default image
              email: '',
              bio: '',
              phoneNumber: '',
              lat: null,
              lng: null,
              bonde: null,
              gardsnavn: '',
            );
          }
        } else {
          // Initialize bruker from passed parameter
          bruker = Bonder.fromJson(widget.bruker);
          _isLoading = false;
        }
        setState(() {
          _isLoading = false; // Update loading state after data is fetched
        });
      }
    } on SocketException {
      showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      showErrorToast(context, 'En feil oppstod');
    }
  }

  Future<void> getRatingStats() async {
    try {
      String? token = await Securestorage().readToken();
      if (token == null) {
        FFAppState().login = false;
        context.pushNamed('registrer');
        return;
      } else {
        _ratingStats = await ApiRating.ratingSummary(token, widget.username);
        setState(() {
          ratingVerdi = _ratingStats!.averageValue ?? 5.0;
          ratingantall = _ratingStats!.totalCount ?? 0;
          if (ratingantall == 0) {
            ingenRatings = true;
          }
        });
      }
    } on SocketException {
      showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      showErrorToast(context, 'En feil oppstod');
    }
  }

  Future<void> sjekkFolger() async {
    try {
      String? token = await Securestorage().readToken();
      if (token == null) {
        FFAppState().login = false;
        context.pushNamed('registrer');
        return;
      } else {
        brukerFolger = await ApiFolg.sjekkFolger(token, widget.username);
        if (brukerFolger == true) {
          _model.folger = true;
        }
        setState(() {});
      }
    } on SocketException {
      showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
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

  Future<void> unFolg() async {
    try {
      await apiFolg.unfolgBruker(Securestorage.authToken, bruker?.username);
      safeSetState(() {
        tellFolgere();
      });
    } on SocketException {
      showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      showErrorToast(context, 'En feil oppstod');
    }
  }

  Future<void> folgBruker() async {
    try {
      await apiFolg.folgbruker(Securestorage.authToken, bruker?.username);
      safeSetState(() {
        tellFolgere();
      });
    } on SocketException {
      showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      showErrorToast(context, 'En feil oppstod');
    }
  }

  Future<void> getUserFood() async {
    try {
      String? token = await Securestorage().readToken();
      if (token == null) {
        FFAppState().login = false;
        context.pushNamed('registrer');
        return;
      } else {
        _matvarer = await ApiGetUserFood.getUserFood(token, widget.username);
        setState(() {
          if (_matvarer != null && _matvarer!.isNotEmpty) {
            _matisLoading = false;
            return;
          } else {
            _empty = true;
            _matisLoading = false;
          }
        });
      }
    } on SocketException {
      showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      showErrorToast(context, 'En feil oppstod');
    }
  }

  Future<void> tellFolger() async {
    try {
      String? token = await Securestorage().readToken();
      if (token == null) {
        FFAppState().login = false;
        context.pushNamed('registrer');
        return;
      } else {
        folger = await ApiFolg.tellFolger(token, widget.username);
        setState(() {});
      }
    } on SocketException {
      showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      showErrorToast(context, 'En feil oppstod');
    }
  }

  Future<void> tellFolgere() async {
    try {
      String? token = await Securestorage().readToken();
      if (token == null) {
        FFAppState().login = false;
        context.pushNamed('registrer');
        return;
      } else {
        folgere = await ApiFolg.tellFolgere(token, widget.username);
        setState(() {});
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
            backgroundColor: FlutterFlowTheme.of(context)
                .primary, // Set to your primary color, e.g., Colors.white
            elevation: 0, // Removes shadow to keep it flat
            scrolledUnderElevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle
                .dark, // Adjusts status bar icons for light background
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 28.0,
              ),
              onPressed: () {
                context.safePop();
              },
            ),
            centerTitle: true,
            title: Text(
              '@${widget.username ?? 'Profil'}',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Nunito',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 18,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          body: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    primary: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            SingleChildScrollView(
                              primary: false,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Align(
                                    alignment: const AlignmentDirectional(0, 0),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 10, 0, 10),
                                      child: SafeArea(
                                        child: Container(
                                          width: valueOrDefault<double>(
                                            MediaQuery.sizeOf(context).width,
                                            500.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_isLoading != true)
                                    ListView(
                                      padding: EdgeInsets.zero,
                                      primary: false,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 0, 0, 30),
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
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width: 85,
                                                        height: 85,
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        decoration:
                                                            const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
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
                                                          imageUrl: _isLoading
                                                              ? ''
                                                              : '${ApiConstants.baseUrl}${bruker?.profilepic}',
                                                          fit: BoxFit.cover,
                                                          errorWidget: (context,
                                                                  error,
                                                                  stackTrace) =>
                                                              Image.asset(
                                                            'assets/images/profile_pic.png',
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                7, 0, 0, 0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      10,
                                                                      0,
                                                                      0,
                                                                      0),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            5,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              70,
                                                                          height:
                                                                              50,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primary,
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                _matvarer?.length.toString() ?? '',
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
                                                                                      fontSize: 12,
                                                                                      letterSpacing: 0.0,
                                                                                    ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            5,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              70,
                                                                          height:
                                                                              50,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primary,
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
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
                                                                              if (folgere != '0') {
                                                                                context.pushNamed(
                                                                                  'Folgere',
                                                                                  queryParameters: {
                                                                                    'username': serializeParam(widget.username, ParamType.String),
                                                                                    'folger': serializeParam('Følgere', ParamType.String),
                                                                                  }.withoutNulls,
                                                                                );
                                                                              }
                                                                            },
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Text(
                                                                                  folgere ?? '',
                                                                                  textAlign: TextAlign.center,
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Nunito',
                                                                                        fontSize: 16,
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
                                                                                        fontSize: 12,
                                                                                        letterSpacing: 0.0,
                                                                                      ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            5,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              70,
                                                                          height:
                                                                              50,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primary,
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
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
                                                                              if (folger != '0') {
                                                                                context.pushNamed(
                                                                                  'Folgere',
                                                                                  queryParameters: {
                                                                                    'username': serializeParam(widget.username, ParamType.String),
                                                                                    'folger': serializeParam(
                                                                                      'Følger',
                                                                                      ParamType.String,
                                                                                    ),
                                                                                  }.withoutNulls,
                                                                                );
                                                                              }
                                                                            },
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Text(
                                                                                  folger ?? '',
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
                                                                                        fontSize: 12,
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
                                                                  if (_model
                                                                          .folger ==
                                                                      true)
                                                                    FFButtonWidget(
                                                                      onPressed:
                                                                          () async {
                                                                        if (_folgerLoading)
                                                                          return;
                                                                        _folgerLoading =
                                                                            true;
                                                                        HapticFeedback
                                                                            .mediumImpact();
                                                                        _model.folger =
                                                                            false;
                                                                        safeSetState(
                                                                            () {});
                                                                        unFolg();
                                                                        _folgerLoading =
                                                                            false;
                                                                      },
                                                                      text:
                                                                          'Følger',
                                                                      options:
                                                                          FFButtonOptions(
                                                                        width:
                                                                            120,
                                                                        height:
                                                                            34,
                                                                        padding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            16,
                                                                            0,
                                                                            16,
                                                                            0),
                                                                        iconPadding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                        textStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .override(
                                                                              fontFamily: 'Nunito',
                                                                              color: FlutterFlowTheme.of(context).primaryText,
                                                                              fontSize: 14,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                        elevation:
                                                                            0,
                                                                        borderSide:
                                                                            const BorderSide(
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              32,
                                                                              87,
                                                                              99,
                                                                              108),
                                                                          width:
                                                                              1.3,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(9),
                                                                      ),
                                                                    ),
                                                                  if (_model
                                                                          .folger !=
                                                                      true)
                                                                    FFButtonWidget(
                                                                      onPressed:
                                                                          () async {
                                                                        if (_folgerLoading) {
                                                                          return;
                                                                        }
                                                                        _folgerLoading =
                                                                            true;
                                                                        HapticFeedback
                                                                            .mediumImpact();
                                                                        _model.folger =
                                                                            true;
                                                                        safeSetState(
                                                                            () {});
                                                                        folgBruker();
                                                                        _folgerLoading =
                                                                            false;
                                                                      },
                                                                      text:
                                                                          'Følg',
                                                                      options:
                                                                          FFButtonOptions(
                                                                        width:
                                                                            120,
                                                                        height:
                                                                            34,
                                                                        padding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            16,
                                                                            0,
                                                                            16,
                                                                            0),
                                                                        iconPadding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .alternate,
                                                                        textStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .override(
                                                                              fontFamily: 'Nunito',
                                                                              color: Colors.white,
                                                                              letterSpacing: 0.0,
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                        elevation:
                                                                            0,
                                                                        borderRadius:
                                                                            BorderRadius.circular(9),
                                                                      ),
                                                                    ),
                                                                  if (ingenRatings !=
                                                                      true)
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
                                                                          context
                                                                              .pushNamed(
                                                                            'BrukerRating',
                                                                            extra: <String,
                                                                                dynamic>{
                                                                              kTransitionInfoKey: const TransitionInfo(
                                                                                hasTransition: true,
                                                                                transitionType: PageTransitionType.bottomToTop,
                                                                                duration: Duration(milliseconds: 200),
                                                                              ),
                                                                            },
                                                                            queryParameters: {
                                                                              'username': serializeParam(
                                                                                widget.username,
                                                                                ParamType.String,
                                                                              ),
                                                                              'mine': serializeParam(
                                                                                false,
                                                                                ParamType.bool,
                                                                              ),
                                                                            },
                                                                          );
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              88,
                                                                          height:
                                                                              33,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primary,
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                            border:
                                                                                Border.all(
                                                                              color: const Color.fromARGB(32, 87, 99, 108),
                                                                              width: 1.3,
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              FaIcon(
                                                                                FontAwesomeIcons.solidStar,
                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                size: 16,
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsetsDirectional.fromSTEB(1, 0, 0, 0),
                                                                                child: Text(
                                                                                  ratingVerdi.toString(),
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Nunito',
                                                                                        fontSize: 14,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w600,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsetsDirectional.fromSTEB(1, 0, 0, 0),
                                                                                child: Text(
                                                                                  ' (${ratingantall.toString()})',
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
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            9,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                    child:
                                                                        FFButtonWidget(
                                                                      onPressed:
                                                                          () async {
                                                                        try {
                                                                          // Prevent multiple submissions while loading
                                                                          if (_messageIsLoading)
                                                                            return;
                                                                          _messageIsLoading =
                                                                              true;

                                                                          // Step 1: Validate username (non-nullable, so no need for null check)
                                                                          if (widget.username !=
                                                                              null) {
                                                                            // Step 2: Check if there's already an existing conversation for the given username
                                                                            Conversation
                                                                                existingConversation =
                                                                                FFAppState().conversations.firstWhere(
                                                                              (conv) => conv.user == widget.username,
                                                                              orElse: () {
                                                                                // If no conversation is found, create a new one and add it to the list
                                                                                final newConversation = Conversation(
                                                                                  user: widget.username ?? '',
                                                                                  profilePic: bruker?.profilepic ?? '',
                                                                                  messages: [], // No messages initially
                                                                                );

                                                                                // Add the new conversation to the list
                                                                                FFAppState().conversations.add(newConversation);

                                                                                // Return the new conversation
                                                                                return newConversation;
                                                                              },
                                                                            );

                                                                            // Step 3: Serialize the conversation object to JSON
                                                                            String?
                                                                                serializedConversation =
                                                                                serializeParam(
                                                                              existingConversation.toJson(), // Convert the conversation to JSON
                                                                              ParamType.JSON,
                                                                            );

                                                                            // Step 4: Stop loading and navigate to message screen
                                                                            _messageIsLoading =
                                                                                false;
                                                                            if (serializedConversation !=
                                                                                null) {
                                                                              // Step 5: Navigate to 'message' screen with the conversation
                                                                              context.pushNamed(
                                                                                'message',
                                                                                queryParameters: {
                                                                                  'conversation': serializedConversation, // Pass the serialized conversation
                                                                                },
                                                                              );
                                                                            }
                                                                          }
                                                                        } on SocketException {
                                                                          _messageIsLoading =
                                                                              false;
                                                                          showErrorToast(
                                                                              context,
                                                                              'Ingen internettforbindelse');
                                                                        } catch (e) {
                                                                          _messageIsLoading =
                                                                              false;
                                                                          showErrorToast(
                                                                              context,
                                                                              'En feil oppstod');
                                                                        }
                                                                      },
                                                                      text: '',
                                                                      icon:
                                                                          Icon(
                                                                        CupertinoIcons
                                                                            .chat_bubble,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                        size:
                                                                            24,
                                                                      ),
                                                                      options:
                                                                          FFButtonOptions(
                                                                        width:
                                                                            45,
                                                                        height:
                                                                            33,
                                                                        padding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        iconPadding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            10,
                                                                            1,
                                                                            0,
                                                                            0),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                        textStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .override(
                                                                              fontFamily: 'Nunito',
                                                                              color: FlutterFlowTheme.of(context).alternate,
                                                                              fontSize: 1,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                        elevation:
                                                                            0,
                                                                        borderSide:
                                                                            const BorderSide(
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              32,
                                                                              87,
                                                                              99,
                                                                              108),
                                                                          width:
                                                                              1.3,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(9),
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
                                                        .fromSTEB(0, 5, 0, 0),
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
                                                        _isLoading
                                                            ? '' // Show an empty string while loading
                                                            : (bruker?.bonde ==
                                                                    true
                                                                ? bruker!
                                                                    .gardsnavn
                                                                    .toString()
                                                                : '${bruker?.firstname} ${bruker?.lastname}'), // Show gardsnavn if bonde is true, otherwise show username
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineLarge
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
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(24, 4, 40, 0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                      ),
                                                      child: Text(
                                                        _isLoading
                                                            ? ''
                                                            : bruker?.bio ?? '',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  fontSize: 14,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                        maxLines: _isExpanded
                                                            ? null
                                                            : 2, // Show limited lines if not expanded
                                                        overflow: _isExpanded
                                                            ? TextOverflow
                                                                .visible
                                                            : TextOverflow
                                                                .ellipsis,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          _isExpanded =
                                                              !_isExpanded; // Toggle the expanded state
                                                        });
                                                      },
                                                      child: Text(
                                                        _isExpanded
                                                            ? 'Se mindre'
                                                            : 'Se mer',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: const Color
                                                                      .fromRGBO(
                                                                      113,
                                                                      113,
                                                                      113,
                                                                      1.0),
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
                                          width: double.infinity,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 20, 0, 0),
                                            child: Column(
                                              children: [
                                                Align(
                                                  alignment:
                                                      const Alignment(0, 0),
                                                  child: TabBar(
                                                    labelColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .primaryText,
                                                    unselectedLabelColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .secondaryText,
                                                    labelStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          letterSpacing: 0.0,
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
                                                        const Color(0x00F6F6F6),
                                                    dividerColor:
                                                        const Color.fromARGB(
                                                            10, 0, 0, 0),
                                                    indicatorWeight: 1,
                                                    tabs: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            CupertinoIcons
                                                                .square_grid_2x2,
                                                            color: _model
                                                                        .tabBarCurrentIndex ==
                                                                    0
                                                                ? FlutterFlowTheme.of(
                                                                        context)
                                                                    .alternate
                                                                : FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
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
                                                          FaIcon(
                                                            FontAwesomeIcons
                                                                .bars,
                                                            color: _model
                                                                        .tabBarCurrentIndex ==
                                                                    1
                                                                ? FlutterFlowTheme.of(
                                                                        context)
                                                                    .alternate
                                                                : FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                            size: 27,
                                                          ),
                                                          const Tab(
                                                            text: '',
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                    controller:
                                                        _model.tabBarController,
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
                                                    controller:
                                                        _model.tabBarController,
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
                                  if (_isLoading != true && _empty == true)
                                    Container(
                                      width: MediaQuery.sizeOf(context).width,
                                      height:
                                          MediaQuery.sizeOf(context).height -
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
                                              CupertinoIcons
                                                  .camera_on_rectangle,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 56,
                                            ),
                                            const SizedBox(height: 16),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Ingen annonser ennå',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyLarge
                                                      .override(
                                                        fontFamily: 'Nunito',
                                                        fontSize: 19,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (_isLoading != true)
                                    if (_model.tabBarCurrentIndex == 0)
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(5, 0, 5, 70),
                                        child: RefreshIndicator(
                                          onRefresh: () async {},
                                          child: GridView.builder(
                                            padding: const EdgeInsets.fromLTRB(
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
                                            itemCount: _matisLoading
                                                ? 1
                                                : _matvarer?.length ?? 1,
                                            itemBuilder: (context, index) {
                                              if (_matisLoading || _empty) {
                                                return Shimmer.fromColors(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor:
                                                      Colors.grey[100]!,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .all(5.0),
                                                        width: 200.0,
                                                        height: 230.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color
                                                              .fromARGB(127,
                                                              255, 255, 255),
                                                          borderRadius:
                                                              BorderRadius.circular(
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

                                              final matvarer =
                                                  _matvarer![index];

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
                                                        context.pushNamed(
                                                          'MatDetaljBondegard',
                                                          queryParameters: {
                                                            'matvare':
                                                                serializeParam(
                                                              matvarer
                                                                  .toJson(), // Convert to JSON before passing
                                                              ParamType.JSON,
                                                            ),
                                                          },
                                                        );
                                                      },
                                                      child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        elevation: 0,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
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
                                                            border: Border.all(
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
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          3,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            17),
                                                                    child: Image
                                                                        .network(
                                                                      '${ApiConstants.baseUrl}${matvarer.imgUrls![0]}',
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
                                                                          fit: BoxFit
                                                                              .cover,
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
                                                                      alignment:
                                                                          const AlignmentDirectional(
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
                                                                          matvarer.name ??
                                                                              '',
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                          minFontSize:
                                                                              11,
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyLarge
                                                                              .override(
                                                                                fontFamily: 'Nunito',
                                                                                fontSize: 15,
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
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              5,
                                                                              0,
                                                                              5,
                                                                              0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.end,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                                                                child: Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsetsDirectional.fromSTEB(7, 0, 0, 0),
                                                                                      child: Text(
                                                                                        '${matvarer.price} Kr',
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
                                                                                    if (matvarer.kg == true)
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
                                                                                    // if (matvarer.kg != true)
                                                                                    //   Text(
                                                                                    //     '/stk',
                                                                                    //     textAlign: TextAlign.end,
                                                                                    //     style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                    //           fontFamily: 'Nunito',
                                                                                    //           color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    //           fontSize: 14,
                                                                                    //           letterSpacing: 0.0,
                                                                                    //           fontWeight: FontWeight.bold,
                                                                                    //         ),
                                                                                    //   ),
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
                                                                                      (calculateDistance(FFAppState().brukerLat ?? 0.0, FFAppState().brukerLng ?? 0.0, matvarer.lat ?? 0.0, matvarer.lng ?? 0.0) < 1) ? '<1 Km' : '${calculateDistance(FFAppState().brukerLat ?? 0.0, FFAppState().brukerLng ?? 0.0, matvarer.lat ?? 0.0, matvarer.lng ?? 0.0).toStringAsFixed(0)} Km',
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
                                                  if (matvarer.kjopt == true)
                                                    Positioned(
                                                      top:
                                                          15, // Slight offset from the top edge
                                                      right:
                                                          -29, // Fine-tune the positioning (shift it to the right edge)
                                                      child: Transform.rotate(
                                                        angle:
                                                            0.600, // 45-degree angle (approx.)
                                                        child: Container(
                                                          width:
                                                              140, // Adjusted width to avoid overflow after rotation
                                                          height: 23,
                                                          color:
                                                              Colors.redAccent,
                                                          alignment:
                                                              Alignment.center,
                                                          child: const Text(
                                                            'Utsolgt',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
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
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (_model.tabBarCurrentIndex == 1)
                          ListView.builder(
                            padding: const EdgeInsets.fromLTRB(
                              0,
                              0,
                              0,
                              170,
                            ),
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount:
                                _matisLoading ? 1 : _matvarer?.length ?? 1,
                            itemBuilder: (context, index) {
                              if (_matisLoading || _empty) {
                                return Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      17, 20, 0, 0),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Row(
                                      children: [
                                        // Shimmer for Image
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            color: const Color.fromARGB(
                                                127,
                                                255,
                                                255,
                                                255), // Background color
                                          ),
                                        ),
                                        const SizedBox(width: 16.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Shimmer.fromColors(
                                                baseColor: Colors.grey[300]!,
                                                highlightColor:
                                                    Colors.grey[100]!,
                                                child: Container(
                                                  width: 120,
                                                  height: 16.0,
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        127, 255, 255, 255),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 8.0),
                                              Shimmer.fromColors(
                                                baseColor: Colors.grey[300]!,
                                                highlightColor:
                                                    Colors.grey[100]!,
                                                child: Container(
                                                  width:
                                                      90.0, // Narrower width for second line
                                                  height: 16.0,
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        127, 255, 255, 255),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              final matvarer = _matvarer![index];

                              return Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 10, 10, 0),
                                child: Stack(
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        context.pushNamed(
                                          'MatDetaljBondegard',
                                          queryParameters: {
                                            'matvare': serializeParam(
                                              matvarer
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
                                              BorderRadius.circular(24),
                                        ),
                                        child: Container(
                                          height: 107,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                              color: const Color(0x5957636C),
                                              width: 0.8,
                                            ),
                                          ),
                                          child: Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                    0, 0),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                0, 1, 1, 1),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(13),
                                                          child: Image.network(
                                                            '${ApiConstants.baseUrl}${matvarer.imgUrls![0]}',
                                                            width: 80,
                                                            height: 80,
                                                            fit: BoxFit.cover,
                                                            errorBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    Object
                                                                        error,
                                                                    StackTrace?
                                                                        stackTrace) {
                                                              return Image
                                                                  .asset(
                                                                'assets/images/error_image.jpg',
                                                                width: 80,
                                                                height: 80,
                                                                fit: BoxFit
                                                                    .cover,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                5, 0, 0, 0),
                                                        child: Container(
                                                          width: 151,
                                                          height: 103,
                                                          decoration:
                                                              const BoxDecoration(),
                                                          child: Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    -1, -1),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      0,
                                                                      10,
                                                                      0,
                                                                      0),
                                                              child: Text(
                                                                matvarer.name ??
                                                                    '',
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineSmall
                                                                    .override(
                                                                      fontFamily:
                                                                          'Nunito',
                                                                      fontSize:
                                                                          17,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Stack(
                                                    alignment:
                                                        const AlignmentDirectional(
                                                            1, -1),
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                0, 3, 3, 0),
                                                        child: Icon(
                                                          Icons.open_in_full,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          size: 20,
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            const AlignmentDirectional(
                                                                1, 1),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0, 0, 0, 10),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0,
                                                                        12,
                                                                        0,
                                                                        0),
                                                                child: Text(
                                                                  '${matvarer.price ?? ''} Kr',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .end,
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Nunito',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                        fontSize:
                                                                            16,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                ),
                                                              ),
                                                              if (matvarer.kg ==
                                                                  true)
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0,
                                                                          12,
                                                                          4,
                                                                          0),
                                                                  child: Text(
                                                                    '/kg',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Nunito',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                          fontSize:
                                                                              16,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w600,
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
                                      ),
                                    ),
                                    if (matvarer.kjopt == true)
                                      Positioned(
                                        top:
                                            15, // Slight offset from the top edge
                                        left:
                                            -29, // Fine-tune the positioning (shift it to the right edge)
                                        child: Transform.rotate(
                                          angle:
                                              -0.600, // 45-degree angle (approx.)
                                          child: Container(
                                            width:
                                                140, // Adjusted width to avoid overflow after rotation
                                            height: 23,
                                            color: Colors.redAccent,
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'Utsolgt',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    14, // Font size adjusted to fit the banner
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                      ],
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
