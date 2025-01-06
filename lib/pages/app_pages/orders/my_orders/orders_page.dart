import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/helper_components/widgets/order_list.dart';
import 'package:mat_salg/pages/app_pages/orders/my_orders/orders_services.dart';
import 'package:mat_salg/pages/app_pages/orders/order_info/info_page.dart';
import 'package:mat_salg/services/user_service.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'orders_model.dart';
export 'orders_model.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({
    super.key,
    bool? kjopt,
  }) : kjopt = kjopt ?? false;

  final bool kjopt;

  @override
  State<OrdersPage> createState() => _MineKjopWidgetState();
}

class _MineKjopWidgetState extends State<OrdersPage>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final UserInfoService userInfoService = UserInfoService();
  late OrdersModel _model;
  late OrdersServices ordersServices;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrdersModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
    ordersServices = OrdersServices(model: _model);
    _model.alleInfo = FFAppState().ordreInfo;
    ordersServices.getAll(context);
    userInfoService.updateUserStats(context);
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

  @override
  void dispose() {
    _model.dispose();
    userInfoService.updateUserStats(context).ignore();
    ordersServices.getAll(context).ignore();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

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
                                  13, 5, 13, 15),
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
                                          child: RefreshIndicator.adaptive(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            onRefresh: () async {
                                              HapticFeedback.selectionClick();
                                              ordersServices.getAll(context);
                                            },
                                            child: ListView.builder(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                0,
                                                0,
                                                0,
                                                100,
                                              ),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount: _model.isloading
                                                  ? 1
                                                  : (FFAppState()
                                                          .ordreInfo
                                                          .isEmpty)
                                                      ? 1
                                                      : FFAppState()
                                                          .ordreInfo
                                                          .length,
                                              itemBuilder: (context, index) {
                                                if (FFAppState()
                                                    .ordreInfo
                                                    .isEmpty) {
                                                  return SizedBox(
                                                    width: MediaQuery.sizeOf(
                                                            context)
                                                        .width,
                                                    height: MediaQuery.sizeOf(
                                                                context)
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
                                                                    Colors.grey[300]?.withOpacity(
                                                                            1) ??
                                                                        Colors
                                                                            .grey
                                                                            .withOpacity(0.3), // Reduce opacity
                                                                    Colors.grey[300]?.withOpacity(
                                                                            1) ??
                                                                        Colors
                                                                            .grey
                                                                            .withOpacity(0.3), // Reduce opacity
                                                                  ),

                                                                  // Second Profile Outline
                                                                  buildProfileOutline(
                                                                    context,
                                                                    80,
                                                                    Colors.grey[300]?.withOpacity(
                                                                            1) ??
                                                                        Colors
                                                                            .grey
                                                                            .withOpacity(1),
                                                                    Colors.grey[300]?.withOpacity(
                                                                            1) ??
                                                                        Colors
                                                                            .grey
                                                                            .withOpacity(1),
                                                                  ),

                                                                  // Third Profile Outline
                                                                  buildProfileOutline(
                                                                    context,
                                                                    50,
                                                                    Colors.grey[300]?.withOpacity(
                                                                            1) ??
                                                                        Colors
                                                                            .grey
                                                                            .withOpacity(1),
                                                                    Colors.grey[300]?.withOpacity(
                                                                            1) ??
                                                                        Colors
                                                                            .grey
                                                                            .withOpacity(1),
                                                                  ),

                                                                  // Fourth Profile Outline
                                                                  buildProfileOutline(
                                                                    context,
                                                                    38,
                                                                    Colors.grey[300]?.withOpacity(
                                                                            1) ??
                                                                        Colors
                                                                            .grey
                                                                            .withOpacity(1),
                                                                    Colors.grey[300]?.withOpacity(
                                                                            1) ??
                                                                        Colors
                                                                            .grey
                                                                            .withOpacity(1),
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
                                                if (_model.isloading) {
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
                                                                    .circular(
                                                                        6),
                                                            child: Container(
                                                              width: 60,
                                                              height: 60,
                                                              color: const Color
                                                                  .fromARGB(
                                                                  127,
                                                                  255,
                                                                  255,
                                                                  255),
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
                                                                    height:
                                                                        16.0,
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
                                                                    height:
                                                                        8.0),
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
                                                                    height:
                                                                        16.0,
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
                                                final alleInfo = FFAppState()
                                                    .ordreInfo
                                                    .toList()[index];
                                                return OrderList(
                                                  ordreInfo: alleInfo,
                                                  onTap: () async {
                                                    try {
                                                      await showModalBottomSheet(
                                                        isScrollControlled:
                                                            true,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        barrierColor:
                                                            const Color
                                                                .fromARGB(
                                                                60, 17, 0, 0),
                                                        useRootNavigator: true,
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
                                                              child: InfoPage(
                                                                info: alleInfo
                                                                    .foodDetails,
                                                                ordre: alleInfo,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ).then((value) =>
                                                          setState(() {
                                                            ordersServices
                                                                .getAll(
                                                                    context);
                                                          }));
                                                      return;
                                                    } on SocketException {
                                                      if (!context.mounted) {
                                                        return;
                                                      }
                                                      Toasts.showErrorToast(
                                                          context,
                                                          'Ingen internettforbindelse');
                                                    } catch (e) {
                                                      if (!context.mounted) {
                                                        return;
                                                      }
                                                      Toasts.showErrorToast(
                                                          context,
                                                          'En feil oppstod');
                                                    }
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 20, 0, 0),
                                          child: RefreshIndicator.adaptive(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            onRefresh: () async {
                                              HapticFeedback.selectionClick();
                                              ordersServices.getAll(context);
                                            },
                                            child: ListView.builder(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                0,
                                                0,
                                                0,
                                                100,
                                              ),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount: _model.isKjopLoading
                                                  ? 1
                                                  : (_model.ordreInfo?.length ??
                                                              0) ==
                                                          0
                                                      ? 1
                                                      : _model
                                                          .ordreInfo!.length,
                                              itemBuilder: (context, index) {
                                                if (_model.kjopEmpty == true) {
                                                  return SizedBox(
                                                    width: MediaQuery.sizeOf(
                                                            context)
                                                        .width,
                                                    height: MediaQuery.sizeOf(
                                                                context)
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
                                                                    Colors.grey[300]?.withOpacity(
                                                                            1) ??
                                                                        Colors
                                                                            .grey
                                                                            .withOpacity(0.3), // Reduce opacity
                                                                    Colors.grey[300]?.withOpacity(
                                                                            1) ??
                                                                        Colors
                                                                            .grey
                                                                            .withOpacity(0.3), // Reduce opacity
                                                                  ),

                                                                  // Second Profile Outline
                                                                  buildProfileOutline(
                                                                    context,
                                                                    80,
                                                                    Colors.grey[300]?.withOpacity(
                                                                            1) ??
                                                                        Colors
                                                                            .grey
                                                                            .withOpacity(1),
                                                                    Colors.grey[300]?.withOpacity(
                                                                            1) ??
                                                                        Colors
                                                                            .grey
                                                                            .withOpacity(1),
                                                                  ),

                                                                  // Third Profile Outline
                                                                  buildProfileOutline(
                                                                    context,
                                                                    50,
                                                                    Colors.grey[300]?.withOpacity(
                                                                            1) ??
                                                                        Colors
                                                                            .grey
                                                                            .withOpacity(1),
                                                                    Colors.grey[300]?.withOpacity(
                                                                            1) ??
                                                                        Colors
                                                                            .grey
                                                                            .withOpacity(1),
                                                                  ),

                                                                  // Fourth Profile Outline
                                                                  buildProfileOutline(
                                                                    context,
                                                                    38,
                                                                    Colors.grey[300]?.withOpacity(
                                                                            1) ??
                                                                        Colors
                                                                            .grey
                                                                            .withOpacity(1),
                                                                    Colors.grey[300]?.withOpacity(
                                                                            1) ??
                                                                        Colors
                                                                            .grey
                                                                            .withOpacity(1),
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
                                                if (_model.isKjopLoading) {
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
                                                                    .circular(
                                                                        6),
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
                                                                    height:
                                                                        16.0,
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
                                                                    height:
                                                                        8.0),
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
                                                                    height:
                                                                        16.0,
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
                                                    _model.ordreInfo![index];

                                                return OrderList(
                                                  ordreInfo: ordreInfo,
                                                  onTap: () async {
                                                    try {
                                                      await showModalBottomSheet(
                                                        isScrollControlled:
                                                            true,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        barrierColor:
                                                            const Color
                                                                .fromARGB(
                                                                60, 17, 0, 0),
                                                        useRootNavigator: true,
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
                                                              child: InfoPage(
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
                                                            ordersServices
                                                                .getAll(
                                                                    context);
                                                          }));
                                                      return;
                                                    } on SocketException {
                                                      if (!context.mounted) {
                                                        return;
                                                      }
                                                      Toasts.showErrorToast(
                                                          context,
                                                          'Ingen internettforbindelse');
                                                    } catch (e) {
                                                      if (!context.mounted) {
                                                        return;
                                                      }
                                                      Toasts.showErrorToast(
                                                          context,
                                                          'En feil oppstod');
                                                    }
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 20, 0, 0),
                                          child: RefreshIndicator.adaptive(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            onRefresh: () async {
                                              HapticFeedback.selectionClick();
                                              ordersServices.getAll(context);
                                            },
                                            child: ListView.builder(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                0,
                                                0,
                                                0,
                                                100,
                                              ),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount: _model.salgisLoading
                                                  ? 1
                                                  : (_model.salgInfo?.length ??
                                                              0) ==
                                                          0
                                                      ? 1
                                                      : _model.salgInfo!.length,
                                              itemBuilder: (context, index) {
                                                if (_model.salgEmpty == true) {
                                                  return SizedBox(
                                                    width: MediaQuery.sizeOf(
                                                            context)
                                                        .width,
                                                    height: MediaQuery.sizeOf(
                                                                context)
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
                                                                    Colors.grey[300]?.withOpacity(
                                                                            1) ??
                                                                        Colors
                                                                            .grey
                                                                            .withOpacity(0.3), // Reduce opacity
                                                                    Colors.grey[300]?.withOpacity(
                                                                            1) ??
                                                                        Colors
                                                                            .grey
                                                                            .withOpacity(0.3), // Reduce opacity
                                                                  ),

                                                                  // Second Profile Outline
                                                                  buildProfileOutline(
                                                                    context,
                                                                    80,
                                                                    Colors.grey[300]?.withOpacity(
                                                                            1) ??
                                                                        Colors
                                                                            .grey
                                                                            .withOpacity(1),
                                                                    Colors.grey[300]?.withOpacity(
                                                                            1) ??
                                                                        Colors
                                                                            .grey
                                                                            .withOpacity(1),
                                                                  ),

                                                                  // Third Profile Outline
                                                                  buildProfileOutline(
                                                                    context,
                                                                    50,
                                                                    Colors.grey[300]?.withOpacity(
                                                                            1) ??
                                                                        Colors
                                                                            .grey
                                                                            .withOpacity(1),
                                                                    Colors.grey[300]?.withOpacity(
                                                                            1) ??
                                                                        Colors
                                                                            .grey
                                                                            .withOpacity(1),
                                                                  ),

                                                                  // Fourth Profile Outline
                                                                  buildProfileOutline(
                                                                    context,
                                                                    38,
                                                                    Colors.grey[300]?.withOpacity(
                                                                            1) ??
                                                                        Colors
                                                                            .grey
                                                                            .withOpacity(1),
                                                                    Colors.grey[300]?.withOpacity(
                                                                            1) ??
                                                                        Colors
                                                                            .grey
                                                                            .withOpacity(1),
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
                                                if (_model.salgisLoading) {
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
                                                                    .circular(
                                                                        6),
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
                                                                    height:
                                                                        16.0,
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
                                                                    height:
                                                                        8.0),
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
                                                                    height:
                                                                        16.0,
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
                                                    _model.salgInfo![index];

                                                return OrderList(
                                                  ordreInfo: salgInfo,
                                                  onTap: () async {
                                                    try {
                                                      await showModalBottomSheet(
                                                        isScrollControlled:
                                                            true,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        barrierColor:
                                                            const Color
                                                                .fromARGB(
                                                                60, 17, 0, 0),
                                                        useRootNavigator: true,
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
                                                              child: InfoPage(
                                                                info: salgInfo
                                                                    .foodDetails,
                                                                ordre: salgInfo,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ).then((value) =>
                                                          setState(() {
                                                            ordersServices
                                                                .getAll(
                                                                    context);
                                                          }));
                                                      return;
                                                    } on SocketException {
                                                      if (!context.mounted) {
                                                        return;
                                                      }
                                                      Toasts.showErrorToast(
                                                          context,
                                                          'Ingen internettforbindelse');
                                                    } catch (e) {
                                                      if (!context.mounted) {
                                                        return;
                                                      }
                                                      Toasts.showErrorToast(
                                                          context,
                                                          'En feil oppstod');
                                                    }
                                                  },
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
    );
  }
}
