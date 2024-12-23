import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mat_salg/models/user.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/my_ip.dart';
import 'package:mat_salg/services/rating_service.dart';
import 'package:mat_salg/services/user_service.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'ratings_model.dart';
export 'ratings_model.dart';

class RatingsWidget extends StatefulWidget {
  const RatingsWidget({
    super.key,
    this.uid,
    this.username,
    this.mine,
  });

  final dynamic username;
  final dynamic uid;
  final dynamic mine;

  @override
  State<RatingsWidget> createState() => _BrukerRatingWidgetState();
}

class _BrukerRatingWidgetState extends State<RatingsWidget>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  late RatingsModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RatingsModel());
    _checkUser();
    getAllRatings();
    timeago.setLocaleMessages('nb_NO', timeago.NbNoMessages());

    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
  }

  Future<void> _checkUser() async {
    try {
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return;
      } else {
        _model.brukerinfo =
            await UserInfoService.checkUser(token, widget.username);
        if (_model.brukerinfo != null && _model.brukerinfo!.isNotEmpty) {
          _model.bruker = _model.brukerinfo![0];
        } else {
          // Fallback values
          _model.bruker = User(
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

        setState(() {});
      }
    } on SocketException {
      _model.ratingisLoading = true;
      if (!mounted) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      _model.ratingisLoading = true;
      if (!mounted) return;
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

  Future<void> getAllRatings() async {
    try {
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return;
      } else {
        if (widget.mine != true && widget.uid != null) {
          _model.ratings = await RatingService.listRatings(token, widget.uid);
        } else {
          _model.ratings = await RatingService.listMineRatings(token);
        }

        setState(() {
          if (_model.ratings != null && _model.ratings!.isNotEmpty) {
            _model.kjopratings = _model.ratings!
                .where((rating) => rating.kjoper == false)
                .toList();
            _model.selgratings = _model.ratings!
                .where(
                    (rating) => rating.kjoper == true || rating.kjoper == null)
                .toList();

            _model.ratingisLoading = false;
          } else {
            if (widget.mine != true) {
              _model.ratingisLoading = true;
            }
            _model.ingenRatings = true;
            _model.ratingisLoading = true;
          }
        });
      }
    } on SocketException {
      _model.ratingisLoading = true;
      if (!mounted) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      _model.ratingisLoading = true;
      if (!mounted) return;
      Toasts.showErrorToast(context, 'En feil oppstod');
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
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) {
            return;
          }
        },
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 60, 0, 0),
          child: Container(
            width: 500,
            height: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: ClipRRect(
              key: scaffoldKey,
              child: SafeArea(
                top: true,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(
                              height: 22,
                              thickness: 4,
                              indent: MediaQuery.of(context).size.width * 0.4,
                              endIndent:
                                  MediaQuery.of(context).size.width * 0.4,
                              color: Colors.black12,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 12),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        7, 0, 0, 0),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                      child: Text(
                                        'Lukk',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Nunito',
                                              color: Colors.transparent,
                                              fontSize: 16,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 0, 0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center, // Centers the column content
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center, // Centers the text horizontally
                                        children: [
                                          Text(
                                            'Vurderinger', // First part
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Nunito',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  fontSize: 17,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                          ),
                                          Text(
                                            'for ${widget.username}', // Second part
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Nunito',
                                                  color: Colors
                                                      .black38, // Different color for the second text
                                                  fontSize: 14,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ],
                                      )),
                                  Align(
                                    alignment: const AlignmentDirectional(0, 0),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 7, 0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          try {
                                            Navigator.pop(context);
                                          } on SocketException {
                                            Toasts.showErrorToast(context,
                                                'Ingen internettforbindelse');
                                          } catch (e) {
                                            Toasts.showErrorToast(
                                                context, 'En feil oppstod');
                                          }
                                        },
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 5, 0),
                                          child: Text(
                                            'Lukk',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Nunito',
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
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
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 5),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  height: 50, // Integer height
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(
                                      0), // Integer padding
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        14), // Integer radius
                                  ),
                                  child: CupertinoSlidingSegmentedControl<int>(
                                    backgroundColor: const Color(0xFFEBEBED),
                                    thumbColor: CupertinoColors.white,
                                    groupValue: _model.tabBarController!.index,
                                    onValueChanged: (int? index) {
                                      if (index != null) {
                                        _model.tabBarController!
                                            .animateTo(index);
                                        [
                                          () async {},
                                          () async {
                                            safeSetState(() {});
                                          },
                                          () async {
                                            safeSetState(() {});
                                          }
                                        ][index]();
                                      }
                                    },
                                    children: const {
                                      0: Text(
                                        'Alle',
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                          color: CupertinoColors.black,
                                        ),
                                      ),
                                      1: Text(
                                        'Solgt',
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                          color: CupertinoColors.black,
                                        ),
                                      ),
                                      2: Text(
                                        'Kjøpt',
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                          color: CupertinoColors.black,
                                        ),
                                      ),
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TabBarView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  controller: _model.tabBarController,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 10, 0, 0),
                                      child: ListView.builder(
                                          padding: const EdgeInsets.fromLTRB(
                                            0,
                                            0,
                                            0,
                                            0,
                                          ),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount: _model.ratingisLoading
                                              ? 1
                                              : (_model.ratings?.length ?? 0) ==
                                                      0
                                                  ? 1
                                                  : _model.ratings!.length,
                                          itemBuilder: (context, index) {
                                            if (_model.ingenRatings == true) {
                                              return SizedBox(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                        .width,
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                            .height -
                                                        315,
                                                child: Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0, 0),
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
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    0, 0, 0, 0),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/none_reviews.png',
                                                                width: 200,
                                                                height: 160,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(0,
                                                                    16, 0, 0),
                                                            child: Text(
                                                              'Ingen vurderinger fra kjøpere',
                                                              textAlign:
                                                                  TextAlign
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
                                                                    fontSize:
                                                                        20,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                ),
                                              );
                                            }
                                            if (_model.ratingisLoading) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 16.0),
                                                child: Row(
                                                  children: [
                                                    Shimmer.fromColors(
                                                      baseColor:
                                                          Colors.grey[300]!,
                                                      highlightColor:
                                                          Colors.grey[100]!,
                                                      child: Container(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color
                                                              .fromARGB(127,
                                                              255, 255, 255),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100.0),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16.0),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Shimmer.fromColors(
                                                            baseColor: Colors
                                                                .grey[300]!,
                                                            highlightColor:
                                                                Colors
                                                                    .grey[100]!,
                                                            child: Container(
                                                              width:
                                                                  75.0, // Narrower width for second line
                                                              height: 13.0,
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
                                                                            8.0),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 8.0),
                                                          Shimmer.fromColors(
                                                            baseColor: Colors
                                                                .grey[300]!,
                                                            highlightColor:
                                                                Colors
                                                                    .grey[100]!,
                                                            child: Container(
                                                              width: 120,
                                                              height: 13.0,
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
                                                                            8.0),
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
                                            final ratings =
                                                _model.ratings![index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(10, 8, 10, 0),
                                              child: Material(
                                                color: Colors.transparent,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(13),
                                                ),
                                                child: Container(
                                                  height: 80,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        const AlignmentDirectional(
                                                            0, 0),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              9, 5, 9, 5),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0,
                                                                        1,
                                                                        1,
                                                                        1),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100),
                                                                  child: Image
                                                                      .network(
                                                                    '${ApiConstants.baseUrl}${ratings.profilepic}',
                                                                    width: 50.0,
                                                                    height:
                                                                        50.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    errorBuilder: (BuildContext
                                                                            context,
                                                                        Object
                                                                            error,
                                                                        StackTrace?
                                                                            stackTrace) {
                                                                      return Image
                                                                          .asset(
                                                                        'assets/images/profile_pic.png',
                                                                        width:
                                                                            50.0,
                                                                        height:
                                                                            50.0,
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
                                                                        5,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                child:
                                                                    Container(
                                                                  width: 135,
                                                                  height: 103,
                                                                  decoration:
                                                                      const BoxDecoration(),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            10),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Align(
                                                                          alignment: const AlignmentDirectional(
                                                                              -1,
                                                                              1),
                                                                          child:
                                                                              Text(
                                                                            ratings.username,
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                  fontFamily: 'Nunito',
                                                                                  fontSize: 16,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.w600,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                        Align(
                                                                          alignment: const AlignmentDirectional(
                                                                              -1,
                                                                              1),
                                                                          child:
                                                                              Text(
                                                                            ratings.kjoper == true
                                                                                ? 'Kjøper'
                                                                                : 'Selger',
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                  fontFamily: 'Nunito',
                                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                                  fontSize: 14,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.w600,
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
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    0, 0, 5, 0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          3),
                                                                  child:
                                                                      RatingBarIndicator(
                                                                    itemBuilder:
                                                                        (context,
                                                                                index) =>
                                                                            const FaIcon(
                                                                      FontAwesomeIcons
                                                                          .solidStar,
                                                                      color: Color(
                                                                          0xFFF65E55),
                                                                    ),
                                                                    direction: Axis
                                                                        .horizontal,
                                                                    rating: ratings
                                                                        .value
                                                                        .toDouble(),
                                                                    unratedColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                    itemCount:
                                                                        5,
                                                                    itemSize:
                                                                        19,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          5),
                                                                  child: Text(
                                                                    timeago.format(
                                                                        ratings
                                                                            .time,
                                                                        locale:
                                                                            'nb_NO'),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Nunito',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
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
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 10, 0, 0),
                                      child: ListView.builder(
                                          padding: const EdgeInsets.fromLTRB(
                                            0,
                                            0,
                                            0,
                                            0,
                                          ),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount: _model.ratingisLoading
                                              ? 1
                                              : (_model.selgratings?.length ??
                                                          0) ==
                                                      0
                                                  ? 1
                                                  : _model.selgratings!.length,
                                          itemBuilder: (context, index) {
                                            if ((_model.selgratings!.isEmpty &&
                                                    _model.ratingisLoading ==
                                                        false) ||
                                                _model.ingenRatings == true) {
                                              return SizedBox(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                        .width,
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                            .height -
                                                        315,
                                                child: Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0, 0),
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
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    0, 0, 0, 0),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/none_reviews.png',
                                                                width: 200,
                                                                height: 160,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(0,
                                                                    16, 0, 0),
                                                            child: Text(
                                                              'Ingen vurderinger fra kjøpere',
                                                              textAlign:
                                                                  TextAlign
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
                                                                    fontSize:
                                                                        20,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                ),
                                              );
                                            }
                                            if (_model.ratingisLoading) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 16.0),
                                                child: Row(
                                                  children: [
                                                    Shimmer.fromColors(
                                                      baseColor:
                                                          Colors.grey[300]!,
                                                      highlightColor:
                                                          Colors.grey[100]!,
                                                      child: Container(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color
                                                              .fromARGB(127,
                                                              255, 255, 255),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100.0),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16.0),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Shimmer.fromColors(
                                                            baseColor: Colors
                                                                .grey[300]!,
                                                            highlightColor:
                                                                Colors
                                                                    .grey[100]!,
                                                            child: Container(
                                                              width:
                                                                  75.0, // Narrower width for second line
                                                              height: 13.0,
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
                                                                            8.0),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 8.0),
                                                          Shimmer.fromColors(
                                                            baseColor: Colors
                                                                .grey[300]!,
                                                            highlightColor:
                                                                Colors
                                                                    .grey[100]!,
                                                            child: Container(
                                                              width: 120,
                                                              height: 13.0,
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
                                                                            8.0),
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
                                            final selgerRatings =
                                                _model.selgratings![index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(10, 8, 10, 0),
                                              child: Material(
                                                color: Colors.transparent,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(13),
                                                ),
                                                child: Container(
                                                  height: 80,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        const AlignmentDirectional(
                                                            0, 0),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              9, 5, 9, 5),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0,
                                                                        1,
                                                                        1,
                                                                        1),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100),
                                                                  child: Image
                                                                      .network(
                                                                    '${ApiConstants.baseUrl}${selgerRatings.profilepic}',
                                                                    width: 50.0,
                                                                    height:
                                                                        50.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    errorBuilder: (BuildContext
                                                                            context,
                                                                        Object
                                                                            error,
                                                                        StackTrace?
                                                                            stackTrace) {
                                                                      return Image
                                                                          .asset(
                                                                        'assets/images/profile_pic.png',
                                                                        width:
                                                                            50.0,
                                                                        height:
                                                                            50.0,
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
                                                                        5,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                child:
                                                                    Container(
                                                                  width: 135,
                                                                  height: 103,
                                                                  decoration:
                                                                      const BoxDecoration(),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            10),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Align(
                                                                          alignment: const AlignmentDirectional(
                                                                              -1,
                                                                              1),
                                                                          child:
                                                                              Text(
                                                                            selgerRatings.username,
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                  fontFamily: 'Nunito',
                                                                                  fontSize: 16,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.w600,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                        Align(
                                                                          alignment: const AlignmentDirectional(
                                                                              -1,
                                                                              1),
                                                                          child:
                                                                              Text(
                                                                            'Kjøper',
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                  fontFamily: 'Nunito',
                                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                                  fontSize: 14,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.w600,
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
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    0, 0, 5, 0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          3),
                                                                  child:
                                                                      RatingBarIndicator(
                                                                    itemBuilder:
                                                                        (context,
                                                                                index) =>
                                                                            const FaIcon(
                                                                      FontAwesomeIcons
                                                                          .solidStar,
                                                                      color: Color(
                                                                          0xFFF65E55),
                                                                    ),
                                                                    direction: Axis
                                                                        .horizontal,
                                                                    rating: selgerRatings
                                                                        .value
                                                                        .toDouble(),
                                                                    unratedColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                    itemCount:
                                                                        5,
                                                                    itemSize:
                                                                        19,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          5),
                                                                  child: Text(
                                                                    timeago.format(
                                                                        selgerRatings
                                                                            .time,
                                                                        locale:
                                                                            'nb_NO'),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Nunito',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
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
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 10, 0, 0),
                                      child: ListView.builder(
                                          padding: const EdgeInsets.fromLTRB(
                                            0,
                                            0,
                                            0,
                                            0,
                                          ),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount: _model.ratingisLoading
                                              ? 1
                                              : (_model.kjopratings?.length ??
                                                          0) ==
                                                      0
                                                  ? 1
                                                  : _model.kjopratings!.length,
                                          itemBuilder: (context, index) {
                                            if ((_model.kjopratings!.isEmpty &&
                                                    _model.ratingisLoading ==
                                                        false) ||
                                                _model.ingenRatings == true) {
                                              return SizedBox(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                        .width,
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                            .height -
                                                        315,
                                                child: Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0, 0),
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
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    0, 0, 0, 0),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/none_reviews.png',
                                                                width: 200,
                                                                height: 160,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(0,
                                                                    16, 0, 0),
                                                            child: Text(
                                                              'Ingen vurderinger fra selgere',
                                                              textAlign:
                                                                  TextAlign
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
                                                                    fontSize:
                                                                        20,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                ),
                                              );
                                            }
                                            if (_model.ratingisLoading) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 16.0),
                                                child: Row(
                                                  children: [
                                                    Shimmer.fromColors(
                                                      baseColor:
                                                          Colors.grey[300]!,
                                                      highlightColor:
                                                          Colors.grey[100]!,
                                                      child: Container(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color
                                                              .fromARGB(127,
                                                              255, 255, 255),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100.0),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16.0),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Shimmer.fromColors(
                                                            baseColor: Colors
                                                                .grey[300]!,
                                                            highlightColor:
                                                                Colors
                                                                    .grey[100]!,
                                                            child: Container(
                                                              width:
                                                                  75.0, // Narrower width for second line
                                                              height: 13.0,
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
                                                                            8.0),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 8.0),
                                                          Shimmer.fromColors(
                                                            baseColor: Colors
                                                                .grey[300]!,
                                                            highlightColor:
                                                                Colors
                                                                    .grey[100]!,
                                                            child: Container(
                                                              width: 120,
                                                              height: 13.0,
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
                                                                            8.0),
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
                                            final kjoperRatings =
                                                _model.kjopratings![index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(10, 8, 10, 0),
                                              child: Material(
                                                color: Colors.transparent,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(13),
                                                ),
                                                child: Container(
                                                  height: 80,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        const AlignmentDirectional(
                                                            0, 0),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              9, 5, 9, 5),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0,
                                                                        1,
                                                                        1,
                                                                        1),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100),
                                                                  child: Image
                                                                      .network(
                                                                    '${ApiConstants.baseUrl}${kjoperRatings.profilepic}',
                                                                    width: 50.0,
                                                                    height:
                                                                        50.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    errorBuilder: (BuildContext
                                                                            context,
                                                                        Object
                                                                            error,
                                                                        StackTrace?
                                                                            stackTrace) {
                                                                      return Image
                                                                          .asset(
                                                                        'assets/images/profile_pic.png',
                                                                        width:
                                                                            50.0,
                                                                        height:
                                                                            50.0,
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
                                                                        5,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                child:
                                                                    Container(
                                                                  width: 135,
                                                                  height: 103,
                                                                  decoration:
                                                                      const BoxDecoration(),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            10),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Align(
                                                                          alignment: const AlignmentDirectional(
                                                                              -1,
                                                                              1),
                                                                          child:
                                                                              Text(
                                                                            kjoperRatings.username,
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                  fontFamily: 'Nunito',
                                                                                  fontSize: 16,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.w600,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                        Align(
                                                                          alignment: const AlignmentDirectional(
                                                                              -1,
                                                                              1),
                                                                          child:
                                                                              Text(
                                                                            'Selger',
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                  fontFamily: 'Nunito',
                                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                                  fontSize: 14,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.w600,
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
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    0, 0, 5, 0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          3),
                                                                  child:
                                                                      RatingBarIndicator(
                                                                    itemBuilder:
                                                                        (context,
                                                                                index) =>
                                                                            const FaIcon(
                                                                      FontAwesomeIcons
                                                                          .solidStar,
                                                                      color: Color(
                                                                          0xFFF65E55),
                                                                    ),
                                                                    direction: Axis
                                                                        .horizontal,
                                                                    rating: kjoperRatings
                                                                        .value
                                                                        .toDouble(),
                                                                    unratedColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                    itemCount:
                                                                        5,
                                                                    itemSize:
                                                                        19,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          5),
                                                                  child: Text(
                                                                    timeago.format(
                                                                        kjoperRatings
                                                                            .time,
                                                                        locale:
                                                                            'nb_NO'),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Nunito',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
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
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
