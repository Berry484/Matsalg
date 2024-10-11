import 'package:mat_salg/ApiCalls.dart';
import 'package:mat_salg/SecureStorage.dart';
import 'package:mat_salg/app_main/bonde_gard/salg/godkjentebud/godkjentebud_widget.dart';
import 'package:mat_salg/app_main/vanlig_bruker/kjop/budInfo/budInfo_widget.dart';
import 'package:mat_salg/app_main/vanlig_bruker/kjop/kjop_bekreft_hente/kjop_bekreft_hente_widget.dart';
import 'package:mat_salg/index.dart';
import 'package:mat_salg/matvarer.dart';
import 'package:shimmer/shimmer.dart';

import '/app_main/bonde_gard/salg/salg_bruker_info/salg_bruker_info_widget.dart';
import '/app_main/tom_place_holders/ingen_kjop/ingen_kjop_widget.dart';
import '/app_main/vanlig_bruker/custom_nav_bar_user/kjop_nav_bar/kjop_nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
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
  bool _isloading = true;
  bool _salgisLoading = true;
  final Securestorage securestorage = Securestorage();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MineKjopModel());
    getKjop();
    getSalg();

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
  }

  Future<void> getKjop() async {
    String? token = await Securestorage().readToken();
    if (token == null) {
      FFAppState().login = false;
      context.pushNamed('registrer');
      return;
    } else {
      _ordreInfo = await ApiKjop.getKjop(token);
      setState(() {
        if (_ordreInfo != null && _ordreInfo!.isEmpty) {
          return;
        } else {
          _isloading = false;
        }
      });
    }
  }

  Future<void> getSalg() async {
    String? token = await Securestorage().readToken();
    if (token == null) {
      FFAppState().login = false;
      context.pushNamed('registrer');
      return;
    } else {
      _salgInfo = await ApiKjop.getSalg(token);
      setState(() {
        if (_salgInfo != null && _salgInfo!.isEmpty) {
          return;
        } else {
          _salgisLoading = false;
        }
      });
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
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).alternate),
            automaticallyImplyLeading: false,
            title: Align(
              alignment: AlignmentDirectional(0, 0),
              child: Text(
                'Kjøp & Salg',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Montserrat',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 20,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            actions: [],
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
                      decoration: BoxDecoration(),
                      child: Stack(
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment(0, 0),
                                    child: TabBar(
                                      labelColor: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      unselectedLabelColor: Color(0xC557636C),
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            fontFamily: 'Open Sans',
                                            fontSize: 18,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                      unselectedLabelStyle:
                                          FlutterFlowTheme.of(context)
                                              .titleMedium
                                              .override(
                                                fontFamily: 'Open Sans',
                                                fontSize: 17,
                                                letterSpacing: 0.0,
                                              ),
                                      indicatorColor: Colors.transparent,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          30, 1, 30, 5),
                                      tabs: [
                                        Tab(
                                          text: 'Kjøp',
                                        ),
                                        Tab(
                                          text: 'Salg',
                                        ),
                                      ],
                                      controller: _model.tabBarController,
                                      onTap: (i) async {
                                        [
                                          () async {
                                            FFAppState().kjopAlert = false;
                                            safeSetState(() {});
                                          },
                                          () async {
                                            FFAppState().kjopAlert = false;
                                            safeSetState(() {});
                                          }
                                        ][i]();
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      controller: _model.tabBarController,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 20, 0, 0),
                                          child: ListView.builder(
                                            padding: EdgeInsets.fromLTRB(
                                              0,
                                              0,
                                              0,
                                              100,
                                            ),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount: _isloading
                                                ? 1
                                                : _ordreInfo?.length ?? 1,
                                            itemBuilder: (context, index) {
                                              if (_isloading) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal:
                                                          10.0), // Add 10px padding to left and right
                                                  child: Shimmer.fromColors(
                                                    baseColor: Colors.grey[
                                                        300]!, // Base color for the shimmer
                                                    highlightColor: Colors.grey[
                                                        100]!, // Highlight color for the shimmer
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      width: 225.0,
                                                      height: 107.0,
                                                      decoration: BoxDecoration(
                                                        color: const Color
                                                            .fromARGB(
                                                            127, 255, 255, 255),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                16.0), // Rounded corners
                                                      ),
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
                                                        EdgeInsetsDirectional
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
                                                        if (ordreInfo.hentet !=
                                                                true &&
                                                            ordreInfo.avvist !=
                                                                true) {
                                                          await showModalBottomSheet(
                                                            isScrollControlled:
                                                                true,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
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
                                                                getKjop();
                                                                getSalg();
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
                                                          height: 107,
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
                                                                EdgeInsets.all(
                                                                    8),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Stack(
                                                                  children: [
                                                                    Align(
                                                                      alignment: AlignmentDirectional(
                                                                          1.76,
                                                                          -0.05),
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
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
                                                                            ordreInfo.foodDetails.imgUrls![0],
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
                                                                                'assets/images/error_image.jpg', // Path to your local error image
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
                                                                        alignment: AlignmentDirectional(
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
                                                                            color: Color.fromARGB(
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
                                                                    padding: EdgeInsetsDirectional
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
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0,
                                                                              10,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Text(
                                                                            ordreInfo.foodDetails.name ??
                                                                                '',
                                                                            style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                  fontFamily: 'Open Sans',
                                                                                  fontSize: 20,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                        if (ordreInfo.avvist ==
                                                                            true)
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                6),
                                                                            child:
                                                                                Text(
                                                                              'Selgeren avslo budet',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Open Sans',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 13,
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
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                6),
                                                                            child:
                                                                                Text(
                                                                              'Budet er godkjent, kontakt selgeren',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Open Sans',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 13,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        if (ordreInfo.trekt ==
                                                                            true)
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                6),
                                                                            child:
                                                                                Text(
                                                                              'Du trakk budet',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Open Sans',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 13,
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
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                6),
                                                                            child:
                                                                                Text(
                                                                              'Venter svar fra selgeren',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Open Sans',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 13,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        if (ordreInfo.hentet ==
                                                                            true)
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                6),
                                                                            child:
                                                                                Text(
                                                                              'Kjøpet er fullført',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Open Sans',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 13,
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
                                                                              ? Color(0xC40B695B)
                                                                              : FlutterFlowTheme.of(context).alternate,
                                                                          borderRadius:
                                                                              BorderRadius.circular(13),
                                                                        ),
                                                                        child:
                                                                            Align(
                                                                          alignment: AlignmentDirectional(
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                15,
                                                                                0,
                                                                                12,
                                                                                0),
                                                                            child:
                                                                                Text(
                                                                              '${ordreInfo.pris} Kr',
                                                                              textAlign: TextAlign.start,
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Open Sans',
                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                    fontSize: 14,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w600,
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
                                                                              Color(0xAA262C2D),
                                                                          borderRadius:
                                                                              BorderRadius.circular(13),
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                Color(0x0D262C2D),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            Align(
                                                                              alignment: AlignmentDirectional(0, 0),
                                                                              child: Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(15, 0, 12, 0),
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
                                                                                      '${ordreInfo.pris} Kr',
                                                                                      textAlign: TextAlign.start,
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: 'Open Sans',
                                                                                            color: Color(0xE0FFFFFF),
                                                                                            fontSize: 14,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.w600,
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
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 20, 0, 0),
                                          child: ListView.builder(
                                            padding: EdgeInsets.fromLTRB(
                                              0,
                                              0,
                                              0,
                                              100,
                                            ),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount: _salgisLoading
                                                ? 1
                                                : _salgInfo?.length ?? 1,
                                            itemBuilder: (context, index) {
                                              if (_salgisLoading) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal:
                                                          10.0), // Add 10px padding to left and right
                                                  child: Shimmer.fromColors(
                                                    baseColor: Colors.grey[
                                                        300]!, // Base color for the shimmer
                                                    highlightColor: Colors.grey[
                                                        100]!, // Highlight color for the shimmer
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      width: 225.0,
                                                      height: 107.0,
                                                      decoration: BoxDecoration(
                                                        color: const Color
                                                            .fromARGB(
                                                            127, 255, 255, 255),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                16.0), // Rounded corners
                                                      ),
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
                                                        EdgeInsetsDirectional
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
                                                                getSalg();
                                                                getKjop();
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
                                                                getSalg();
                                                                getKjop();
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
                                                          height: 107,
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
                                                                EdgeInsets.all(
                                                                    8),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Stack(
                                                                  children: [
                                                                    Align(
                                                                      alignment: AlignmentDirectional(
                                                                          1.76,
                                                                          -0.05),
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
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
                                                                            salgInfo.foodDetails.imgUrls![0],
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
                                                                                'assets/images/error_image.jpg', // Path to your local error image
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
                                                                        alignment: AlignmentDirectional(
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
                                                                            color: Color.fromARGB(
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
                                                                    padding: EdgeInsetsDirectional
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
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0,
                                                                              10,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Text(
                                                                            salgInfo.foodDetails.name ??
                                                                                '',
                                                                            style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                  fontFamily: 'Open Sans',
                                                                                  fontSize: 20,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                        if (salgInfo.trekt ==
                                                                            true)
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                6),
                                                                            child:
                                                                                Text(
                                                                              'Kjøperen trakk budet',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Open Sans',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 13,
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
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                6),
                                                                            child:
                                                                                Text(
                                                                              'Vurder kjøperen',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Open Sans',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 13,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        if (salgInfo.avvist ==
                                                                            true)
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                6),
                                                                            child:
                                                                                Text(
                                                                              'Du avslo budet',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Open Sans',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 13,
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
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                6),
                                                                            child:
                                                                                Text(
                                                                              'Budet er godkjent, kontakt kjøperen',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Open Sans',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 13,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        if (salgInfo.hentet ==
                                                                            true)
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                6),
                                                                            child:
                                                                                Text(
                                                                              'Kjøpet er fullført',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Open Sans',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 13,
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
                                                                          color: salgInfo.hentet == true
                                                                              ? Color(0xC40B695B)
                                                                              : FlutterFlowTheme.of(context).alternate,
                                                                          borderRadius:
                                                                              BorderRadius.circular(13),
                                                                        ),
                                                                        child:
                                                                            Align(
                                                                          alignment: AlignmentDirectional(
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                15,
                                                                                0,
                                                                                12,
                                                                                0),
                                                                            child:
                                                                                Text(
                                                                              '+${salgInfo.pris} Kr',
                                                                              textAlign: TextAlign.start,
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Open Sans',
                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                    fontSize: 14,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w600,
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
                                                                              Color(0xAA262C2D),
                                                                          borderRadius:
                                                                              BorderRadius.circular(13),
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                Color(0x0D262C2D),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            Align(
                                                                              alignment: AlignmentDirectional(0, 0),
                                                                              child: Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(15, 0, 12, 0),
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
                                                                                      '${salgInfo.pris} Kr',
                                                                                      textAlign: TextAlign.start,
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: 'Open Sans',
                                                                                            color: Color(0xE0FFFFFF),
                                                                                            fontSize: 14,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.w600,
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
                              alignment: AlignmentDirectional(0.54, -0.96),
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
                wrapWithModel(
                  model: _model.kjopNavBarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: KjopNavBarWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
