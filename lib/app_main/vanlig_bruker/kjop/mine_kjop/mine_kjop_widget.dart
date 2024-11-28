import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mat_salg/ApiCalls.dart';
import 'package:mat_salg/MyIP.dart';
import 'package:mat_salg/SecureStorage.dart';
import 'package:mat_salg/app_main/vanlig_bruker/kjop/godkjentebud/godkjentebud_widget.dart';
import 'package:mat_salg/app_main/vanlig_bruker/kjop/budInfo/budInfo_widget.dart';
import 'package:mat_salg/flutter_flow/flutter_flow_widgets.dart';
import 'package:shimmer/shimmer.dart';

import '../salg_bruker_info/salg_bruker_info_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'mine_kjop_model.dart';
export 'mine_kjop_model.dart';

class MineKjopWidget extends StatefulWidget {
  const MineKjopWidget({
    super.key,
    bool? kjopt,
  }) : this.kjopt = kjopt ?? false;

  final bool kjopt;

  @override
  State<MineKjopWidget> createState() => _MineKjopWidgetState();
}

class _MineKjopWidgetState extends State<MineKjopWidget>
    with TickerProviderStateMixin {
  late MineKjopModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<OrdreInfo>? _ordreInfo;
  List<OrdreInfo>? _salgInfo;
  List<OrdreInfo>? _alleInfo;
  bool _isloading = true;
  bool _isKjopLoading = true;
  bool _salgisLoading = true;
  bool _kjopEmpty = false;
  bool _salgEmpty = false;
  bool _allEmpty = false;
  bool _showMore = false;
  final Securestorage securestorage = Securestorage();
  final ApiCalls apicalls = ApiCalls();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MineKjopModel());
    getAll();
    updateUserStats();
    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
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

  Future<void> getAll() async {
    try {
      String? token = await Securestorage().readToken();
      if (token == null) {
        FFAppState().login = false;
        context.goNamed('registrer');
        return;
      } else {
        _alleInfo = await ApiKjop.getAll(token);

        setState(() {
          if (_alleInfo != null && _alleInfo!.isNotEmpty) {
            _isloading = false;
            _allEmpty = false;

            _ordreInfo = _alleInfo!
                .where((order) => order.kjopte == true && _isActive(order))
                .toList();
            _kjopEmpty = _ordreInfo!.isEmpty;

            _salgInfo = _alleInfo!
                .where((order) => order.kjopte == false && _isActive(order))
                .toList();
            _salgEmpty = _salgInfo!.isEmpty;

            _isloading = false;
            _salgisLoading = false;
            _isKjopLoading = false;
          } else {
            _kjopEmpty = true;
            _salgEmpty = true;
            _allEmpty = true;
          }
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

// Helper function to determine if the order is active
  bool _isActive(OrdreInfo order) {
    return !(order.hentet == true ||
        order.trekt == true ||
        order.avvist == true);
  }

  Future<void> updateUserStats() async {
    try {
      String? token = await Securestorage().readToken();
      if (token == null) {
        FFAppState().login = false;
        context.goNamed('registrer');
        return;
      } else {
        await apicalls.updateUserStats(token);
        setState(() {});
      }
    } on SocketException {
      HapticFeedback.lightImpact();
      showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      HapticFeedback.lightImpact();
      showErrorToast(context, 'En feil oppstod');
    }
  }

// Helper method to build each profile outline with shimmer effect
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
            iconTheme: IconThemeData(color: FlutterFlowTheme.of(context).price),
            automaticallyImplyLeading: false,
            title: Align(
              alignment: const AlignmentDirectional(0, 0),
              child: Text(
                'Kjøp & Salg',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Nunito',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 19,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
            actions: const [],
            centerTitle: true,
            elevation: 0,
          ),
          body: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: SafeArea(
                    child: Container(
                      decoration: const BoxDecoration(),
                      child: Stack(
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  15, 5, 20, 15),
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
                                      child:
                                          CupertinoSlidingSegmentedControl<int>(
                                        backgroundColor:
                                            const Color(0xFFEBEBED),
                                        thumbColor: CupertinoColors.white,
                                        groupValue:
                                            _model.tabBarController!.index,
                                        onValueChanged: (int? index) {
                                          if (index != null) {
                                            _model.tabBarController!
                                                .animateTo(index);
                                            [
                                              () async {},
                                              () async {
                                                FFAppState().kjopAlert = false;
                                                safeSetState(() {});
                                              },
                                              () async {
                                                FFAppState().kjopAlert = false;
                                                safeSetState(() {});
                                              }
                                            ][index]();
                                          }
                                        },
                                        children: const {
                                          0: Text(
                                            'Alle',
                                            style: TextStyle(
                                              fontFamily:
                                                  'Nunito', // Apple's system font
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600,
                                              color: CupertinoColors.black,
                                            ),
                                          ),
                                          1: Text(
                                            'Kjøp',
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600,
                                              color: CupertinoColors.black,
                                            ),
                                          ),
                                          2: Text(
                                            'Salg',
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
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      controller: _model.tabBarController,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 20, 0, 0),
                                          child: ListView.builder(
                                            padding: const EdgeInsets.fromLTRB(
                                              0,
                                              0,
                                              0,
                                              100,
                                            ),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount: _isloading
                                                ? 1
                                                : (_alleInfo?.length ?? 0) == 0
                                                    ? 1
                                                    : _showMore
                                                        ? _alleInfo!
                                                            .length // Show all items when _showMore is true
                                                        : (_alleInfo!.length < 5
                                                            ? _alleInfo!.length
                                                            : 5), // Show fewer items if length < 5, else show 5
                                            itemBuilder: (context, index) {
                                              if (_allEmpty == true) {
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
                                                                .start,
                                                        children: [
                                                          Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    0, 1),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
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
                                                                      Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.3), // Reduce opacity
                                                                  Colors.grey[300]
                                                                          ?.withOpacity(
                                                                              1) ??
                                                                      Colors
                                                                          .grey
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
                                                                      Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              1),
                                                                  Colors.grey[300]
                                                                          ?.withOpacity(
                                                                              1) ??
                                                                      Colors
                                                                          .grey
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
                                                                      Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              1),
                                                                  Colors.grey[300]
                                                                          ?.withOpacity(
                                                                              1) ??
                                                                      Colors
                                                                          .grey
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
                                                                      Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              1),
                                                                  Colors.grey[300]
                                                                          ?.withOpacity(
                                                                              1) ??
                                                                      Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              1),
                                                                ),

                                                                const SizedBox(
                                                                    height:
                                                                        8.0),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    'Du har ingen handler ennå',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineSmall
                                                                        .override(
                                                                          fontFamily:
                                                                              'Nunito',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          fontSize:
                                                                              23,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w800,
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
                                                );
                                              }
                                              if (_isloading) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0, 20, 0, 0),
                                                  child: Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey[300]!,
                                                    highlightColor:
                                                        Colors.grey[100]!,
                                                    child: Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          child: Container(
                                                            width: 60,
                                                            height: 60,
                                                            color: const Color
                                                                .fromARGB(127,
                                                                255, 255, 255),
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
                                                                    Colors.grey[
                                                                        300]!,
                                                                highlightColor:
                                                                    Colors.grey[
                                                                        100]!,
                                                                child:
                                                                    Container(
                                                                  width: 120,
                                                                  height: 16.0,
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
                                                                            8.0),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 8.0),
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
                                                                  width:
                                                                      90.0, // Narrower width for second line
                                                                  height: 16.0,
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
                                              final alleInfo =
                                                  _alleInfo![index];
                                              if ((index == 4 && !_showMore) &&
                                                  _alleInfo!.length > 4) {
                                                // This is where we show the "Show More" button
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 16.0),
                                                  child: Center(
                                                    child: FFButtonWidget(
                                                      onPressed: () async {
                                                        HapticFeedback
                                                            .lightImpact();
                                                        safeSetState(() {
                                                          _showMore = true;
                                                        });
                                                      },
                                                      text: 'Se mer',
                                                      icon: const FaIcon(
                                                        FontAwesomeIcons
                                                            .chevronDown,
                                                        size: 19,
                                                      ),
                                                      options: FFButtonOptions(
                                                        width: 118,
                                                        height: 35,
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                16, 0, 16, 0),
                                                        iconPadding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                0, 0, 0, 0),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .alternate,
                                                                  fontSize: 16,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                        elevation: 0,
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Color.fromARGB(
                                                              0, 87, 99, 108),
                                                          width: 1.5,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }

                                              return Stack(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0, 0, 0, 0),
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
                                                        if (alleInfo.kjopte ==
                                                            true) {
                                                          if (alleInfo.hentet != true &&
                                                              alleInfo.avvist !=
                                                                  true &&
                                                              alleInfo.trekt !=
                                                                  true) {
                                                            await showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              barrierColor:
                                                                  const Color
                                                                      .fromARGB(
                                                                      60,
                                                                      17,
                                                                      0,
                                                                      0),
                                                              useRootNavigator:
                                                                  true,
                                                              useSafeArea: true,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return GestureDetector(
                                                                  onTap: () =>
                                                                      FocusScope.of(
                                                                              context)
                                                                          .unfocus(),
                                                                  child:
                                                                      Padding(
                                                                    padding: MediaQuery
                                                                        .viewInsetsOf(
                                                                            context),
                                                                    child:
                                                                        BudInfoWidget(
                                                                      info: alleInfo
                                                                          .foodDetails,
                                                                      ordre:
                                                                          alleInfo,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ).then((value) =>
                                                                setState(() {
                                                                  getAll();
                                                                }));
                                                            return;
                                                          }
                                                        }
                                                        if (alleInfo.kjopte ==
                                                            true) {
                                                          if (alleInfo.godkjent !=
                                                                  true &&
                                                              alleInfo.trekt !=
                                                                  true &&
                                                              alleInfo.avvist !=
                                                                  true) {
                                                            await showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              barrierColor:
                                                                  const Color
                                                                      .fromARGB(
                                                                      60,
                                                                      17,
                                                                      0,
                                                                      0),
                                                              useRootNavigator:
                                                                  true,
                                                              useSafeArea: true,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return GestureDetector(
                                                                  onTap: () =>
                                                                      FocusScope.of(
                                                                              context)
                                                                          .unfocus(),
                                                                  child:
                                                                      Padding(
                                                                    padding: MediaQuery
                                                                        .viewInsetsOf(
                                                                            context),
                                                                    child:
                                                                        SalgBrukerInfoWidget(
                                                                      info: alleInfo
                                                                          .foodDetails,
                                                                      ordre:
                                                                          alleInfo,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ).then((value) =>
                                                                setState(() {
                                                                  getAll();
                                                                }));
                                                            return;
                                                          }
                                                        }
                                                        if (alleInfo.hentet == true ||
                                                            alleInfo.trekt ==
                                                                true ||
                                                            alleInfo.avvist ==
                                                                true ||
                                                            alleInfo.godkjent ==
                                                                true) {
                                                          await showModalBottomSheet(
                                                            isScrollControlled:
                                                                true,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            barrierColor:
                                                                const Color
                                                                    .fromARGB(
                                                                    60,
                                                                    17,
                                                                    0,
                                                                    0),
                                                            useRootNavigator:
                                                                true,
                                                            useSafeArea: true,
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
                                                                      GodkjentebudWidget(
                                                                    info: alleInfo
                                                                        .foodDetails,
                                                                    ordre:
                                                                        alleInfo,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ).then((value) =>
                                                              setState(() {
                                                                getAll();
                                                              }));
                                                          return;
                                                        }

                                                        if (alleInfo.kjopte !=
                                                            true) {
                                                          if (alleInfo.godkjent !=
                                                                  true &&
                                                              alleInfo.trekt !=
                                                                  true &&
                                                              alleInfo.avvist !=
                                                                  true) {
                                                            await showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              barrierColor:
                                                                  const Color
                                                                      .fromARGB(
                                                                      60,
                                                                      17,
                                                                      0,
                                                                      0),
                                                              useRootNavigator:
                                                                  true,
                                                              useSafeArea: true,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return GestureDetector(
                                                                  onTap: () =>
                                                                      FocusScope.of(
                                                                              context)
                                                                          .unfocus(),
                                                                  child:
                                                                      Padding(
                                                                    padding: MediaQuery
                                                                        .viewInsetsOf(
                                                                            context),
                                                                    child:
                                                                        SalgBrukerInfoWidget(
                                                                      info: alleInfo
                                                                          .foodDetails,
                                                                      ordre:
                                                                          alleInfo,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ).then((value) =>
                                                                setState(() {
                                                                  getAll();
                                                                }));
                                                          }

                                                          if (alleInfo
                                                                  .godkjent ==
                                                              true) {
                                                            await showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              barrierColor:
                                                                  const Color
                                                                      .fromARGB(
                                                                      60,
                                                                      17,
                                                                      0,
                                                                      0),
                                                              useRootNavigator:
                                                                  true,
                                                              useSafeArea: true,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return GestureDetector(
                                                                  onTap: () =>
                                                                      FocusScope.of(
                                                                              context)
                                                                          .unfocus(),
                                                                  child:
                                                                      Padding(
                                                                    padding: MediaQuery
                                                                        .viewInsetsOf(
                                                                            context),
                                                                    child:
                                                                        GodkjentebudWidget(
                                                                      info: alleInfo
                                                                          .foodDetails,
                                                                      ordre:
                                                                          alleInfo,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ).then((value) =>
                                                                setState(() {
                                                                  getAll();
                                                                }));
                                                          }
                                                        }
                                                      },
                                                      child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        elevation: 0,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(24),
                                                        ),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        24),
                                                            shape: BoxShape
                                                                .rectangle,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Stack(
                                                                  children: [
                                                                    Align(
                                                                      alignment: const AlignmentDirectional(
                                                                          1.76,
                                                                          -0.05),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            0,
                                                                            1,
                                                                            1,
                                                                            1),
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(6),
                                                                          child:
                                                                              Image.network(
                                                                            '${ApiConstants.baseUrl}${alleInfo.foodDetails.imgUrls![0]}',
                                                                            width:
                                                                                60,
                                                                            height:
                                                                                60,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            errorBuilder: (BuildContext context,
                                                                                Object error,
                                                                                StackTrace? stackTrace) {
                                                                              return Image.asset(
                                                                                'assets/images/error_image.jpg',
                                                                                width: 60,
                                                                                height: 60,
                                                                                fit: BoxFit.cover,
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      top:
                                                                          0, // Adjust vertical position as needed
                                                                      left:
                                                                          0, // Adjust horizontal position as needed
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            25, // Ensure this matches the width of the image
                                                                        height:
                                                                            25, // Ensure this matches the height of the image
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle, // Makes the border circular
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                Colors.white, // Choose your desired border color
                                                                            width:
                                                                                0.5, // Adjust the border width as needed
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            ClipOval(
                                                                          child:
                                                                              Image.network(
                                                                            alleInfo.kjopte == true
                                                                                ? '${ApiConstants.baseUrl}${alleInfo.foodDetails.profilepic}'
                                                                                : '${ApiConstants.baseUrl}${alleInfo.kjoperProfilePic}',
                                                                            width:
                                                                                25,
                                                                            height:
                                                                                25,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            errorBuilder: (BuildContext context,
                                                                                Object error,
                                                                                StackTrace? stackTrace) {
                                                                              return Image.asset(
                                                                                'assets/images/profile_pic.png',
                                                                                width: 25,
                                                                                height: 25,
                                                                                fit: BoxFit.cover,
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            8,
                                                                            0,
                                                                            4,
                                                                            0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              0,
                                                                              10,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Container(
                                                                                child: Flexible(
                                                                                  child: Text(
                                                                                    alleInfo.kjopte == true ? alleInfo.selger : alleInfo.kjoper,
                                                                                    softWrap: true, // Enables wrapping
                                                                                    overflow: TextOverflow.visible, // Allows overflow to be visible or change to ellipsis
                                                                                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                          fontFamily: 'Nunito',
                                                                                          fontSize: 16,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.w700,
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                              ),

                                                                              const SizedBox(width: 8), // Optional spacing between text and time
                                                                              Text(
                                                                                alleInfo.updatetime != null ? (DateFormat("d. MMM", "nb_NO").format(alleInfo.updatetime!.toLocal())) : "",
                                                                                style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                      fontFamily: 'Nunito',
                                                                                      fontSize: 14,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      color: Colors.grey, // Set a different color here
                                                                                    ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        if (alleInfo.trekt ==
                                                                            true)
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                6),
                                                                            child:
                                                                                Text(
                                                                              alleInfo.kjopte == true ? 'Du trakk budet' : 'Kjøperen trakk budet',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Nunito',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 15,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        if (alleInfo.godkjent != true &&
                                                                            alleInfo.hentet !=
                                                                                true &&
                                                                            alleInfo.trekt !=
                                                                                true &&
                                                                            alleInfo.avvist !=
                                                                                true)
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                6),
                                                                            child:
                                                                                Text(
                                                                              alleInfo.kjopte == true ? 'Venter svar fra selgeren' : 'Vurder kjøperen',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Nunito',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 15,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        if (alleInfo.avvist ==
                                                                            true)
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                6),
                                                                            child:
                                                                                Text(
                                                                              alleInfo.kjopte == true ? 'Selgeren avslo budet' : 'Du avslo budet',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Nunito',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 15,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        if (alleInfo.godkjent ==
                                                                                true &&
                                                                            alleInfo.hentet !=
                                                                                true)
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                6),
                                                                            child:
                                                                                Text(
                                                                              alleInfo.kjopte == true ? 'Budet er godkjent,\nkontakt selgeren' : 'Budet er godkjent, kontakt kjøperen',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Nunito',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 14,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    lineHeight: 1.1,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        if (alleInfo.hentet ==
                                                                            true)
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                6),
                                                                            child:
                                                                                Text(
                                                                              alleInfo.kjopte == true ? 'Kjøpet er fullført' : 'Salget er fullført',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Nunito',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 15,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    if (alleInfo.trekt !=
                                                                            true &&
                                                                        alleInfo.avvist !=
                                                                            true)
                                                                      Container(
                                                                        height:
                                                                            30,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: alleInfo.hentet == true
                                                                              ? FlutterFlowTheme.of(context).primary
                                                                              : FlutterFlowTheme.of(context).price,
                                                                          borderRadius:
                                                                              BorderRadius.circular(13),
                                                                          border: alleInfo.hentet == true
                                                                              ? Border.all(color: const Color.fromARGB(44, 87, 99, 108), width: 1.2) // Add black border
                                                                              : null, // No border otherwise
                                                                        ),
                                                                        child:
                                                                            Align(
                                                                          alignment: const AlignmentDirectional(
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                15,
                                                                                0,
                                                                                12,
                                                                                0),
                                                                            child:
                                                                                Text(
                                                                              (alleInfo.kjopte ?? false) ? '${alleInfo.pris.remainder(Decimal.one) == Decimal.zero ? alleInfo.pris.toBigInt() : alleInfo.pris.toStringAsFixed(2)} Kr' : '+${alleInfo.pris.remainder(Decimal.one) == Decimal.zero ? alleInfo.pris.toBigInt() : alleInfo.pris.toStringAsFixed(2)} Kr',
                                                                              textAlign: TextAlign.start,
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Nunito',
                                                                                    color: alleInfo.hentet == true ? FlutterFlowTheme.of(context).primaryText : FlutterFlowTheme.of(context).primary,
                                                                                    fontSize: 14,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    if (alleInfo.trekt ==
                                                                            true ||
                                                                        alleInfo.avvist ==
                                                                            true)
                                                                      Container(
                                                                        height:
                                                                            30,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius: BorderRadius.circular(13),
                                                                            border: Border.all(color: const Color.fromARGB(44, 87, 99, 108), width: 1.2)),
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            Align(
                                                                              alignment: const AlignmentDirectional(0, 0),
                                                                              child: Padding(
                                                                                padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 12, 0),
                                                                                child: Stack(
                                                                                  children: [
                                                                                    // White line behind the text
                                                                                    Positioned(
                                                                                      top: 10, // Adjust this value to control the vertical alignment of the line
                                                                                      left: 0,
                                                                                      right: 0,
                                                                                      child: Container(
                                                                                        height: 1, // Thickness of the line
                                                                                        color: const Color.fromARGB(255, 0, 0, 0), // Color of the line
                                                                                      ),
                                                                                    ),
                                                                                    // The actual text
                                                                                    Text(
                                                                                      '${alleInfo.pris.remainder(Decimal.one) == Decimal.zero ? alleInfo.pris.toBigInt() : alleInfo.pris.toStringAsFixed(2)} Kr',
                                                                                      textAlign: TextAlign.start,
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: 'Nunito',
                                                                                            color: FlutterFlowTheme.of(context).primaryText,
                                                                                            fontSize: 14,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.bold,
                                                                                            // You can still keep the text decoration if you want, but the line through won't be white or thick.
                                                                                            decoration: TextDecoration.none,
                                                                                          ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
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
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 20, 0, 0),
                                          child: ListView.builder(
                                            padding: const EdgeInsets.fromLTRB(
                                              0,
                                              0,
                                              0,
                                              100,
                                            ),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount: _isKjopLoading
                                                ? 1
                                                : (_ordreInfo?.length ?? 0) == 0
                                                    ? 1
                                                    : _ordreInfo!.length,
                                            itemBuilder: (context, index) {
                                              if (_kjopEmpty == true) {
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
                                                                .start,
                                                        children: [
                                                          Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    0, 1),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
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
                                                                      Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.3), // Reduce opacity
                                                                  Colors.grey[300]
                                                                          ?.withOpacity(
                                                                              1) ??
                                                                      Colors
                                                                          .grey
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
                                                                      Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              1),
                                                                  Colors.grey[300]
                                                                          ?.withOpacity(
                                                                              1) ??
                                                                      Colors
                                                                          .grey
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
                                                                      Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              1),
                                                                  Colors.grey[300]
                                                                          ?.withOpacity(
                                                                              1) ??
                                                                      Colors
                                                                          .grey
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
                                                                      Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              1),
                                                                  Colors.grey[300]
                                                                          ?.withOpacity(
                                                                              1) ??
                                                                      Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              1),
                                                                ),

                                                                const SizedBox(
                                                                    height:
                                                                        8.0),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    'Ingen pågående kjøp',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineSmall
                                                                        .override(
                                                                          fontFamily:
                                                                              'Nunito',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          fontSize:
                                                                              23,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w800,
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
                                                );
                                              }
                                              if (_isKjopLoading) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0, 20, 0, 0),
                                                  child: Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey[300]!,
                                                    highlightColor:
                                                        Colors.grey[100]!,
                                                    child: Row(
                                                      children: [
                                                        // Shimmer for Image
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          child: Container(
                                                            width: 60,
                                                            height: 60,
                                                            color: const Color
                                                                .fromARGB(
                                                                127,
                                                                255,
                                                                255,
                                                                255), // Background color
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
                                                                    Colors.grey[
                                                                        300]!,
                                                                highlightColor:
                                                                    Colors.grey[
                                                                        100]!,
                                                                child:
                                                                    Container(
                                                                  width: 120,
                                                                  height: 16.0,
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
                                                                            8.0),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 8.0),
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
                                                                  width:
                                                                      90.0, // Narrower width for second line
                                                                  height: 16.0,
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
                                              final ordreInfo =
                                                  _ordreInfo![index];

                                              return Stack(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            10, 0, 10, 0),
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
                                                        if (ordreInfo.hentet != true &&
                                                            ordreInfo.avvist !=
                                                                true &&
                                                            ordreInfo.trekt !=
                                                                true) {
                                                          await showModalBottomSheet(
                                                            isScrollControlled:
                                                                true,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            barrierColor:
                                                                const Color
                                                                    .fromARGB(
                                                                    60,
                                                                    17,
                                                                    0,
                                                                    0),
                                                            useRootNavigator:
                                                                true,
                                                            useSafeArea: true,
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
                                                                      BudInfoWidget(
                                                                    info: ordreInfo
                                                                        .foodDetails,
                                                                    ordre:
                                                                        ordreInfo,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ).then((value) =>
                                                              setState(() {
                                                                getAll();
                                                              }));
                                                        }
                                                      },
                                                      child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        elevation: 0,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(24),
                                                        ),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        24),
                                                            shape: BoxShape
                                                                .rectangle,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Stack(
                                                                  children: [
                                                                    Align(
                                                                      alignment: const AlignmentDirectional(
                                                                          1.76,
                                                                          -0.05),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            0,
                                                                            1,
                                                                            1,
                                                                            1),
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(6),
                                                                          child:
                                                                              Image.network(
                                                                            '${ApiConstants.baseUrl}${ordreInfo.foodDetails.imgUrls![0]}',
                                                                            width:
                                                                                60,
                                                                            height:
                                                                                60,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            errorBuilder: (BuildContext context,
                                                                                Object error,
                                                                                StackTrace? stackTrace) {
                                                                              return Image.asset(
                                                                                'assets/images/error_image.jpg',
                                                                                width: 60,
                                                                                height: 60,
                                                                                fit: BoxFit.cover,
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      top:
                                                                          0, // Adjust vertical position as needed
                                                                      left:
                                                                          0, // Adjust horizontal position as needed
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            25, // Ensure this matches the width of the image
                                                                        height:
                                                                            25, // Ensure this matches the height of the image
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle, // Makes the border circular
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                Colors.white, // Choose your desired border color
                                                                            width:
                                                                                0.5, // Adjust the border width as needed
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            ClipOval(
                                                                          child:
                                                                              Image.network(
                                                                            '${ApiConstants.baseUrl}${ordreInfo.foodDetails.profilepic}',
                                                                            width:
                                                                                25,
                                                                            height:
                                                                                25,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            errorBuilder: (BuildContext context,
                                                                                Object error,
                                                                                StackTrace? stackTrace) {
                                                                              return Image.asset(
                                                                                'assets/images/profile_pic.png',
                                                                                width: 25,
                                                                                height: 25,
                                                                                fit: BoxFit.cover,
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    if (ordreInfo
                                                                            .hentet ==
                                                                        true)
                                                                      Align(
                                                                        alignment: const AlignmentDirectional(
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              61,
                                                                          height:
                                                                              61,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color: const Color.fromARGB(
                                                                                84,
                                                                                159,
                                                                                159,
                                                                                159),
                                                                            borderRadius:
                                                                                BorderRadius.circular(0),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                  ],
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            8,
                                                                            0,
                                                                            4,
                                                                            0),
                                                                    child:
                                                                        Column(
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
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              0,
                                                                              10,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Container(
                                                                                child: Flexible(
                                                                                  child: Text(
                                                                                    ordreInfo.selger,
                                                                                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                          fontFamily: 'Nunito',
                                                                                          fontSize: 16,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.w700,
                                                                                        ),
                                                                                    softWrap: true, // Enables wrapping
                                                                                    overflow: TextOverflow.visible, // Allows overflow to be visible or change to ellipsis
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(width: 8),
                                                                              Text(
                                                                                ordreInfo.updatetime != null ? (DateFormat("d. MMM", "nb_NO").format(ordreInfo.updatetime!.toLocal())) : "",
                                                                                style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                      fontFamily: 'Nunito',
                                                                                      fontSize: 14,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      color: Colors.grey,
                                                                                    ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        if (ordreInfo.avvist ==
                                                                            true)
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                6),
                                                                            child:
                                                                                Text(
                                                                              'Selgeren avslo budet',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Nunito',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 15,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        if (ordreInfo.godkjent ==
                                                                                true &&
                                                                            ordreInfo.hentet !=
                                                                                true)
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                6),
                                                                            child:
                                                                                Text(
                                                                              'Budet er godkjent,\nkontakt selgeren',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Nunito',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 15,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    lineHeight: 1.2,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        if (ordreInfo.trekt ==
                                                                            true)
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                6),
                                                                            child:
                                                                                Text(
                                                                              'Du trakk budet',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Nunito',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 15,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        if (ordreInfo.godkjent != true &&
                                                                            ordreInfo.hentet !=
                                                                                true &&
                                                                            ordreInfo.trekt !=
                                                                                true &&
                                                                            ordreInfo.avvist !=
                                                                                true)
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                6),
                                                                            child:
                                                                                Text(
                                                                              'Venter svar fra selgeren',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Nunito',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 15,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        if (ordreInfo.hentet ==
                                                                            true)
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                6),
                                                                            child:
                                                                                Text(
                                                                              'Kjøpet er fullført',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Nunito',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 15,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    if (ordreInfo.trekt !=
                                                                            true &&
                                                                        ordreInfo.avvist !=
                                                                            true)
                                                                      Container(
                                                                        height:
                                                                            30,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: ordreInfo.hentet == true
                                                                              ? FlutterFlowTheme.of(context).primary
                                                                              : FlutterFlowTheme.of(context).price,
                                                                          borderRadius:
                                                                              BorderRadius.circular(13),
                                                                        ),
                                                                        child:
                                                                            Align(
                                                                          alignment: const AlignmentDirectional(
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                15,
                                                                                0,
                                                                                12,
                                                                                0),
                                                                            child:
                                                                                Text(
                                                                              (ordreInfo.kjopte ?? false) ? '${ordreInfo.pris.remainder(Decimal.one) == Decimal.zero ? ordreInfo.pris.toBigInt() : ordreInfo.pris.toStringAsFixed(2)} Kr' : '+${ordreInfo.pris.remainder(Decimal.one) == Decimal.zero ? ordreInfo.pris.toBigInt() : ordreInfo.pris.toStringAsFixed(2)} Kr',
                                                                              textAlign: TextAlign.start,
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Nunito',
                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                    fontSize: 14,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    if (ordreInfo.trekt ==
                                                                            true ||
                                                                        ordreInfo.avvist ==
                                                                            true)
                                                                      Container(
                                                                        height:
                                                                            30,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              const Color(0xAA262C2D),
                                                                          borderRadius:
                                                                              BorderRadius.circular(13),
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                const Color(0x0D262C2D),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            Align(
                                                                              alignment: const AlignmentDirectional(0, 0),
                                                                              child: Padding(
                                                                                padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 12, 0),
                                                                                child: Stack(
                                                                                  children: [
                                                                                    // White line behind the text
                                                                                    Positioned(
                                                                                      top: 10, // Adjust this value to control the vertical alignment of the line
                                                                                      left: 0,
                                                                                      right: 0,
                                                                                      child: Container(
                                                                                        height: 1.2, // Thickness of the line
                                                                                        color: Colors.white, // Color of the line
                                                                                      ),
                                                                                    ),
                                                                                    // The actual text
                                                                                    Text(
                                                                                      '${ordreInfo.pris.remainder(Decimal.one) == Decimal.zero ? ordreInfo.pris.toBigInt() : ordreInfo.pris.toStringAsFixed(2)} Kr',
                                                                                      textAlign: TextAlign.start,
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: 'Nunito',
                                                                                            color: const Color(0xE0FFFFFF),
                                                                                            fontSize: 14,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.bold,
                                                                                            // You can still keep the text decoration if you want, but the line through won't be white or thick.
                                                                                            decoration: TextDecoration.none,
                                                                                          ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
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
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 20, 0, 0),
                                          child: ListView.builder(
                                            padding: const EdgeInsets.fromLTRB(
                                              0,
                                              0,
                                              0,
                                              100,
                                            ),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount: _salgisLoading
                                                ? 1
                                                : (_salgInfo?.length ?? 0) == 0
                                                    ? 1
                                                    : _salgInfo!.length,
                                            itemBuilder: (context, index) {
                                              if (_salgEmpty == true) {
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
                                                                .start,
                                                        children: [
                                                          Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    0, 1),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
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
                                                                      Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.3), // Reduce opacity
                                                                  Colors.grey[300]
                                                                          ?.withOpacity(
                                                                              1) ??
                                                                      Colors
                                                                          .grey
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
                                                                      Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              1),
                                                                  Colors.grey[300]
                                                                          ?.withOpacity(
                                                                              1) ??
                                                                      Colors
                                                                          .grey
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
                                                                      Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              1),
                                                                  Colors.grey[300]
                                                                          ?.withOpacity(
                                                                              1) ??
                                                                      Colors
                                                                          .grey
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
                                                                      Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              1),
                                                                  Colors.grey[300]
                                                                          ?.withOpacity(
                                                                              1) ??
                                                                      Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              1),
                                                                ),

                                                                const SizedBox(
                                                                    height:
                                                                        8.0),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    'Ingen pågående salg',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineSmall
                                                                        .override(
                                                                          fontFamily:
                                                                              'Nunito',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          fontSize:
                                                                              23,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w800,
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
                                                );
                                              }
                                              if (_salgisLoading) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          20, 20, 10, 0),
                                                  child: Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey[300]!,
                                                    highlightColor:
                                                        Colors.grey[100]!,
                                                    child: Row(
                                                      children: [
                                                        // Shimmer for Image
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          child: Container(
                                                            width: 60,
                                                            height: 60,
                                                            color: const Color
                                                                .fromARGB(
                                                                127,
                                                                255,
                                                                255,
                                                                255), // Background color
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
                                                                    Colors.grey[
                                                                        300]!,
                                                                highlightColor:
                                                                    Colors.grey[
                                                                        100]!,
                                                                child:
                                                                    Container(
                                                                  width: 120,
                                                                  height: 16.0,
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
                                                                            8.0),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 8.0),
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
                                                                  width:
                                                                      90.0, // Narrower width for second line
                                                                  height: 16.0,
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
                                              final salgInfo =
                                                  _salgInfo![index];
                                              return Stack(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            10, 0, 10, 0),
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
                                                        if (salgInfo.godkjent !=
                                                                true &&
                                                            salgInfo.trekt !=
                                                                true &&
                                                            salgInfo.avvist !=
                                                                true) {
                                                          await showModalBottomSheet(
                                                            isScrollControlled:
                                                                true,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            barrierColor:
                                                                const Color
                                                                    .fromARGB(
                                                                    60,
                                                                    17,
                                                                    0,
                                                                    0),
                                                            useRootNavigator:
                                                                true,
                                                            useSafeArea: true,
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
                                                                      SalgBrukerInfoWidget(
                                                                    info: salgInfo
                                                                        .foodDetails,
                                                                    ordre:
                                                                        salgInfo,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ).then((value) =>
                                                              setState(() {
                                                                getAll();
                                                              }));
                                                        }

                                                        if (salgInfo.godkjent ==
                                                            true) {
                                                          await showModalBottomSheet(
                                                            isScrollControlled:
                                                                true,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            barrierColor:
                                                                const Color
                                                                    .fromARGB(
                                                                    60,
                                                                    17,
                                                                    0,
                                                                    0),
                                                            useRootNavigator:
                                                                true,
                                                            useSafeArea: true,
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
                                                                      GodkjentebudWidget(
                                                                    info: salgInfo
                                                                        .foodDetails,
                                                                    ordre:
                                                                        salgInfo,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ).then((value) =>
                                                              setState(() {
                                                                getAll();
                                                              }));
                                                        }
                                                      },
                                                      child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        elevation: 0,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(24),
                                                        ),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        24),
                                                            shape: BoxShape
                                                                .rectangle,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Stack(
                                                                  children: [
                                                                    Align(
                                                                      alignment: const AlignmentDirectional(
                                                                          1.76,
                                                                          -0.05),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            0,
                                                                            1,
                                                                            1,
                                                                            1),
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(6),
                                                                          child:
                                                                              Image.network(
                                                                            '${ApiConstants.baseUrl}${salgInfo.foodDetails.imgUrls![0]}',
                                                                            width:
                                                                                60,
                                                                            height:
                                                                                60,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            errorBuilder: (BuildContext context,
                                                                                Object error,
                                                                                StackTrace? stackTrace) {
                                                                              return Image.asset(
                                                                                'assets/images/error_image.jpg',
                                                                                width: 60,
                                                                                height: 60,
                                                                                fit: BoxFit.cover,
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      top:
                                                                          0, // Adjust vertical position as needed
                                                                      left:
                                                                          0, // Adjust horizontal position as needed
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            25, // Ensure this matches the width of the image
                                                                        height:
                                                                            25, // Ensure this matches the height of the image
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle, // Makes the border circular
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                Colors.white, // Choose your desired border color
                                                                            width:
                                                                                0.5, // Adjust the border width as needed
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            ClipOval(
                                                                          child:
                                                                              Image.network(
                                                                            '${ApiConstants.baseUrl}${salgInfo.kjoperProfilePic}',
                                                                            width:
                                                                                25,
                                                                            height:
                                                                                25,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            errorBuilder: (BuildContext context,
                                                                                Object error,
                                                                                StackTrace? stackTrace) {
                                                                              return Image.asset(
                                                                                'assets/images/profile_pic.png',
                                                                                width: 25,
                                                                                height: 25,
                                                                                fit: BoxFit.cover,
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    if (salgInfo
                                                                            .hentet ==
                                                                        true)
                                                                      Align(
                                                                        alignment: const AlignmentDirectional(
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              61,
                                                                          height:
                                                                              61,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color: const Color.fromARGB(
                                                                                91,
                                                                                135,
                                                                                135,
                                                                                135),
                                                                            borderRadius:
                                                                                BorderRadius.circular(0),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                  ],
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            8,
                                                                            0,
                                                                            4,
                                                                            0),
                                                                    child:
                                                                        Column(
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
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              0,
                                                                              10,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                salgInfo.kjoper,
                                                                                style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                      fontFamily: 'Nunito',
                                                                                      fontSize: 18,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w600,
                                                                                    ),
                                                                              ),
                                                                              const SizedBox(width: 8), // Optional spacing between text and time
                                                                              Text(
                                                                                salgInfo.updatetime != null ? (DateFormat("d. MMM", "nb_NO").format(salgInfo.updatetime!.toLocal())) : "",
                                                                                style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                      fontFamily: 'Nunito',
                                                                                      fontSize: 14,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      color: Colors.grey, // Set a different color here
                                                                                    ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        if (salgInfo.trekt ==
                                                                            true)
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                6),
                                                                            child:
                                                                                Text(
                                                                              'Kjøperen trakk budet',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Nunito',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 15,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        if (salgInfo.godkjent != true &&
                                                                            salgInfo.hentet !=
                                                                                true &&
                                                                            salgInfo.trekt !=
                                                                                true &&
                                                                            salgInfo.avvist !=
                                                                                true)
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                6),
                                                                            child:
                                                                                Text(
                                                                              'Vurder kjøperen',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Nunito',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 15,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        if (salgInfo.avvist ==
                                                                            true)
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                6),
                                                                            child:
                                                                                Text(
                                                                              'Du avslo budet',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Nunito',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 15,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        if (salgInfo.godkjent ==
                                                                                true &&
                                                                            salgInfo.hentet !=
                                                                                true)
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                6),
                                                                            child:
                                                                                Text(
                                                                              'Budet er godkjent,\nkontakt kjøperen',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Nunito',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 15,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    lineHeight: 1.2,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        if (salgInfo.hentet ==
                                                                            true)
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                6),
                                                                            child:
                                                                                Text(
                                                                              'Kjøpet er fullført',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Nunito',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 15,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    if (salgInfo.trekt !=
                                                                            true &&
                                                                        salgInfo.avvist !=
                                                                            true)
                                                                      Container(
                                                                        height:
                                                                            30,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).price,
                                                                          borderRadius:
                                                                              BorderRadius.circular(13),
                                                                        ),
                                                                        child:
                                                                            Align(
                                                                          alignment: const AlignmentDirectional(
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                15,
                                                                                0,
                                                                                12,
                                                                                0),
                                                                            child:
                                                                                Text(
                                                                              (salgInfo.kjopte ?? false) ? '${salgInfo.pris.remainder(Decimal.one) == Decimal.zero ? salgInfo.pris.toBigInt() : salgInfo.pris.toStringAsFixed(2)} Kr' : '+${salgInfo.pris.remainder(Decimal.one) == Decimal.zero ? salgInfo.pris.toBigInt() : salgInfo.pris.toStringAsFixed(2)} Kr',
                                                                              textAlign: TextAlign.start,
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Nunito',
                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                    fontSize: 14,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    if (salgInfo.trekt ==
                                                                            true ||
                                                                        salgInfo.avvist ==
                                                                            true)
                                                                      Container(
                                                                        height:
                                                                            30,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              const Color(0xAA262C2D),
                                                                          borderRadius:
                                                                              BorderRadius.circular(13),
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                const Color(0x0D262C2D),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            Align(
                                                                              alignment: const AlignmentDirectional(0, 0),
                                                                              child: Padding(
                                                                                padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 12, 0),
                                                                                child: Stack(
                                                                                  children: [
                                                                                    // White line behind the text
                                                                                    Positioned(
                                                                                      top: 10, // Adjust this value to control the vertical alignment of the line
                                                                                      left: 0,
                                                                                      right: 0,
                                                                                      child: Container(
                                                                                        height: 1.2, // Thickness of the line
                                                                                        color: Colors.white, // Color of the line
                                                                                      ),
                                                                                    ),
                                                                                    // The actual text
                                                                                    Text(
                                                                                      '${salgInfo.pris.remainder(Decimal.one) == Decimal.zero ? salgInfo.pris.toBigInt() : salgInfo.pris.toStringAsFixed(2)} Kr',
                                                                                      textAlign: TextAlign.start,
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: 'Nunito',
                                                                                            color: const Color(0xE0FFFFFF),
                                                                                            fontSize: 14,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.bold,
                                                                                            // You can still keep the text decoration if you want, but the line through won't be white or thick.
                                                                                            decoration: TextDecoration.none,
                                                                                          ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
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
                                                ],
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
                          ),
                          if (FFAppState().kjopAlert == true)
                            Align(
                              alignment:
                                  const AlignmentDirectional(0.54, -0.96),
                              child: Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).error,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                // wrapWithModel(
                //   model: _model.kjopNavBarModel,
                //   updateCallback: () => safeSetState(() {}),
                //   child: const KjopNavBarWidget(),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
