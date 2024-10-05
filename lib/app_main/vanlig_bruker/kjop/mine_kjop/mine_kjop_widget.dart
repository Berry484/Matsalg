import '/app_main/bonde_gard/salg/salg_bruker_info/salg_bruker_info_widget.dart';
import '/app_main/tom_place_holders/ingen_kjop/ingen_kjop_widget.dart';
import '/app_main/vanlig_bruker/custom_nav_bar_user/kjop_nav_bar/kjop_nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/random_data_util.dart' as random_data;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'mine_kjop_model.dart';
export 'mine_kjop_model.dart';

class MineKjopWidget extends StatefulWidget {
  const MineKjopWidget({
    super.key,
    bool? kjopt,
  }) : kjopt = kjopt ?? false;

  final bool kjopt;

  @override
  State<MineKjopWidget> createState() => _MineKjopWidgetState();
}

class _MineKjopWidgetState extends State<MineKjopWidget>
    with TickerProviderStateMixin {
  late MineKjopModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MineKjopModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
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
          backgroundColor: FlutterFlowTheme.of(context).secondary,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondary,
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).alternate),
            automaticallyImplyLeading: false,
            title: Align(
              alignment: const AlignmentDirectional(0.0, 0.0),
              child: Text(
                'Kjøp & Salg',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Montserrat',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 20.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
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
                Flexible(
                  child: SafeArea(
                    child: Container(
                      decoration: const BoxDecoration(),
                      child: Stack(
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0.0, 0.0),
                            child: Column(
                              children: [
                                Align(
                                  alignment: const Alignment(0.0, 0),
                                  child: FlutterFlowButtonTabBar(
                                    useToggleButtonStyle: true,
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily: 'Open Sans',
                                          fontSize: 17.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    unselectedLabelStyle:
                                        FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                              fontFamily: 'Open Sans',
                                              letterSpacing: 0.0,
                                            ),
                                    labelColor: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    unselectedLabelColor:
                                        const Color(0xC557636C),
                                    backgroundColor:
                                        FlutterFlowTheme.of(context).primary,
                                    unselectedBackgroundColor:
                                        const Color(0x2B57636C),
                                    unselectedBorderColor:
                                        FlutterFlowTheme.of(context)
                                            .primaryText,
                                    borderWidth: 0.0,
                                    borderRadius: 24.0,
                                    elevation: 0.3,
                                    buttonMargin:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            20.0, 0.0, 20.0, 0.0),
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            30.0, 5.0, 30.0, 5.0),
                                    tabs: const [
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
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 10.0, 0.0, 0.0),
                                        child: Builder(
                                          builder: (context) {
                                            final removeme2 = List.generate(
                                                random_data.randomInteger(5, 5),
                                                (index) =>
                                                    random_data.randomInteger(
                                                        0, 10)).toList();
                                            if (removeme2.isEmpty) {
                                              return const IngenKjopWidget();
                                            }

                                            return ListView.separated(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                0,
                                                0,
                                                0,
                                                100.0,
                                              ),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount: removeme2.length,
                                              separatorBuilder: (_, __) =>
                                                  const SizedBox(height: 15.0),
                                              itemBuilder:
                                                  (context, removeme2Index) {
                                                final removeme2Item =
                                                    removeme2[removeme2Index];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          10.0, 0.0, 10.0, 0.0),
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
                                                          'KjopDetaljVentende');
                                                    },
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      elevation: 1.0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                      ),
                                                      child: Container(
                                                        height: 107.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      24.0),
                                                          shape: BoxShape
                                                              .rectangle,
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0.0,
                                                                        1.0,
                                                                        1.0,
                                                                        1.0),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6.0),
                                                                  child: Image
                                                                      .network(
                                                                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/backup-jdlmhw/assets/hq722nopc44s/istockphoto-1409329028-612x612.jpg',
                                                                    width: 80.0,
                                                                    height:
                                                                        80.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          8.0,
                                                                          0.0,
                                                                          4.0,
                                                                          0.0),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            0.0,
                                                                            10.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Text(
                                                                          'Kantareller',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .headlineSmall
                                                                              .override(
                                                                                fontFamily: 'Open Sans',
                                                                                fontSize: 22.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            6.0),
                                                                        child:
                                                                            Text(
                                                                          'Kjøpet er fullført',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: 'Open Sans',
                                                                                fontSize: 13.0,
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
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        const AlignmentDirectional(
                                                                            0.0,
                                                                            1.0),
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              0.0,
                                                                              12.0,
                                                                              4.0,
                                                                              8.0),
                                                                          child:
                                                                              Text(
                                                                            '300',
                                                                            textAlign:
                                                                                TextAlign.end,
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: 'Open Sans',
                                                                                  color: FlutterFlowTheme.of(context).alternate,
                                                                                  fontSize: 19.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              0.0,
                                                                              12.0,
                                                                              4.0,
                                                                              8.0),
                                                                          child:
                                                                              Text(
                                                                            'Kr',
                                                                            textAlign:
                                                                                TextAlign.end,
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: 'Open Sans',
                                                                                  color: FlutterFlowTheme.of(context).alternate,
                                                                                  fontSize: 19.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.bold,
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
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 10.0, 0.0, 0.0),
                                        child: Builder(
                                          builder: (context) {
                                            final removeme2 = List.generate(
                                                random_data.randomInteger(5, 5),
                                                (index) =>
                                                    random_data.randomInteger(
                                                        0, 10)).toList();
                                            if (removeme2.isEmpty) {
                                              return const IngenKjopWidget();
                                            }

                                            return ListView.separated(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                0,
                                                0,
                                                0,
                                                100.0,
                                              ),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount: removeme2.length,
                                              separatorBuilder: (_, __) =>
                                                  const SizedBox(height: 15.0),
                                              itemBuilder:
                                                  (context, removeme2Index) {
                                                final removeme2Item =
                                                    removeme2[removeme2Index];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          10.0, 0.0, 10.0, 0.0),
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
                                                      await showModalBottomSheet(
                                                        isScrollControlled:
                                                            true,
                                                        backgroundColor:
                                                            Colors.transparent,
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
                                                                  const SalgBrukerInfoWidget(),
                                                            ),
                                                          );
                                                        },
                                                      ).then((value) =>
                                                          safeSetState(() {}));
                                                    },
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      elevation: 1.0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                      ),
                                                      child: Container(
                                                        height: 107.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      24.0),
                                                          shape: BoxShape
                                                              .rectangle,
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0.0,
                                                                        1.0,
                                                                        1.0,
                                                                        1.0),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6.0),
                                                                  child: Image
                                                                      .network(
                                                                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/backup-jdlmhw/assets/hq722nopc44s/istockphoto-1409329028-612x612.jpg',
                                                                    width: 80.0,
                                                                    height:
                                                                        80.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          8.0,
                                                                          0.0,
                                                                          4.0,
                                                                          0.0),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            0.0,
                                                                            10.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Text(
                                                                          'Kantareller',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .headlineSmall
                                                                              .override(
                                                                                fontFamily: 'Open Sans',
                                                                                fontSize: 22.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            6.0),
                                                                        child:
                                                                            Text(
                                                                          'Kjøpet er fullført',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: 'Open Sans',
                                                                                fontSize: 13.0,
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
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        const AlignmentDirectional(
                                                                            0.0,
                                                                            1.0),
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              0.0,
                                                                              12.0,
                                                                              4.0,
                                                                              8.0),
                                                                          child:
                                                                              Text(
                                                                            '300',
                                                                            textAlign:
                                                                                TextAlign.end,
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: 'Open Sans',
                                                                                  color: FlutterFlowTheme.of(context).alternate,
                                                                                  fontSize: 19.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              0.0,
                                                                              12.0,
                                                                              4.0,
                                                                              8.0),
                                                                          child:
                                                                              Text(
                                                                            'Kr',
                                                                            textAlign:
                                                                                TextAlign.end,
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: 'Open Sans',
                                                                                  color: FlutterFlowTheme.of(context).alternate,
                                                                                  fontSize: 19.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.bold,
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
                                                );
                                              },
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
                          if (FFAppState().kjopAlert == true)
                            Align(
                              alignment:
                                  const AlignmentDirectional(0.55, -0.95),
                              child: Container(
                                width: 10.0,
                                height: 10.0,
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
                  child: const KjopNavBarWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
