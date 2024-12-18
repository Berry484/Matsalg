import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mat_salg/apiCalls.dart';
import 'package:mat_salg/User.dart';
import 'package:mat_salg/app_main/vanlig_bruker/Utils.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/myIP.dart';
import 'package:shimmer/shimmer.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'bruker_rating_model.dart';
export 'bruker_rating_model.dart';

class BrukerRatingWidget extends StatefulWidget {
  const BrukerRatingWidget({
    super.key,
    this.uid,
    this.username,
    this.mine,
  });

  final dynamic username;
  final dynamic uid;
  final dynamic mine;

  @override
  State<BrukerRatingWidget> createState() => _BrukerRatingWidgetState();
}

class _BrukerRatingWidgetState extends State<BrukerRatingWidget>
    with TickerProviderStateMixin {
  late BrukerRatingModel _model;
  List<UserInfoRating>? _ratings;
  List<UserInfoRating>? _kjopratings = [];
  List<UserInfoRating>? _selgratings = [];
  List<User>? _brukerinfo;
  User? bruker;
  String? username;
  bool _ratingisLoading = true;
  bool ingenRatings = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final Toasts toasts = Toasts();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BrukerRatingModel());
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
        _brukerinfo = await ApiGetUser.checkUser(token, widget.username);
        if (_brukerinfo != null && _brukerinfo!.isNotEmpty) {
          bruker = _brukerinfo![0];
        } else {
          // Fallback values
          bruker = User(
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
      _ratingisLoading = true;
      toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      _ratingisLoading = true;

      toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

  Future<void> getAllRatings() async {
    try {
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return;
      } else {
        if (widget.mine != true && widget.uid != null) {
          _ratings = await ApiRating.listRatings(token, widget.uid);
        } else {
          _ratings = await ApiRating.listMineRatings(token);
        }

        setState(() {
          if (_ratings != null && _ratings!.isNotEmpty) {
            _kjopratings =
                _ratings!.where((rating) => rating.kjoper == false).toList();
            _selgratings = _ratings!
                .where(
                    (rating) => rating.kjoper == true || rating.kjoper == null)
                .toList();

            _ratingisLoading = false;
          } else {
            if (widget.mine != true) {
              _ratingisLoading = true;
            }
            ingenRatings = true;
            _ratingisLoading = true;
          }
        });
      }
    } on SocketException {
      _ratingisLoading = true;
      toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      _ratingisLoading = true;
      toasts.showErrorToast(context, 'En feil oppstod');
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
                                            toasts.showErrorToast(context,
                                                'Ingen internettforbindelse');
                                          } catch (e) {
                                            toasts.showErrorToast(
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
                                          itemCount: _ratingisLoading
                                              ? 1
                                              : (_ratings?.length ?? 0) == 0
                                                  ? 1
                                                  : _ratings!.length,
                                          itemBuilder: (context, index) {
                                            if (ingenRatings == true) {
                                              return Container(
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
                                                                width: 276,
                                                                height: 215,
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
                                            if (_ratingisLoading) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 16.0),
                                                child: Row(
                                                  children: [
                                                    // Circular profile picture placeholder
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
                                            final ratings = _ratings![index];
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
                                          itemCount: _ratingisLoading
                                              ? 1
                                              : (_selgratings?.length ?? 0) == 0
                                                  ? 1
                                                  : _selgratings!.length,
                                          itemBuilder: (context, index) {
                                            if ((_selgratings!.isEmpty &&
                                                    _ratingisLoading ==
                                                        false) ||
                                                ingenRatings == true) {
                                              return Container(
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
                                                                width: 276,
                                                                height: 215,
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
                                            if (_ratingisLoading) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 16.0),
                                                child: Row(
                                                  children: [
                                                    // Circular profile picture placeholder
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
                                                _selgratings![index];
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
                                          itemCount: _ratingisLoading
                                              ? 1
                                              : (_kjopratings?.length ?? 0) == 0
                                                  ? 1
                                                  : _kjopratings!.length,
                                          itemBuilder: (context, index) {
                                            if ((_kjopratings!.isEmpty &&
                                                    _ratingisLoading ==
                                                        false) ||
                                                ingenRatings == true) {
                                              return Container(
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
                                                                width: 276,
                                                                height: 215,
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
                                            if (_ratingisLoading) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 16.0),
                                                child: Row(
                                                  children: [
                                                    // Circular profile picture placeholder
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
                                                _kjopratings![index];
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
