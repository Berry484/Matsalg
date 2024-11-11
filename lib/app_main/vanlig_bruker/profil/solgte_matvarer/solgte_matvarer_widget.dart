import 'dart:io';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mat_salg/ApiCalls.dart';
import 'package:mat_salg/MyIP.dart';
import 'package:mat_salg/SecureStorage.dart';
import 'package:mat_salg/app_main/vanlig_bruker/kjop/godkjentebud/godkjentebud_widget.dart';
import 'package:shimmer/shimmer.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'solgte_matvarer_model.dart';
export 'solgte_matvarer_model.dart';

class SolgteMatvarerWidget extends StatefulWidget {
  const SolgteMatvarerWidget({super.key});

  @override
  State<SolgteMatvarerWidget> createState() => _SolgteMatvarerWidgetState();
}

class _SolgteMatvarerWidgetState extends State<SolgteMatvarerWidget> {
  late SolgteMatvarerModel _model;
  List<OrdreInfo>? _alleInfo;
  bool _isloading = true;
  bool _allEmpty = false;
  final Securestorage securestorage = Securestorage();
  final ApiCalls apicalls = ApiCalls();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getAll();
    updateUserStats();
    _model = createModel(context, () => SolgteMatvarerModel());
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
        context.pushNamed('registrer');
        return;
      } else {
        // Get the data
        List<OrdreInfo>? alleInfoList = await ApiKjop.getAll(token);

        setState(() {
          if (alleInfoList != null && alleInfoList.isNotEmpty) {
            _alleInfo = alleInfoList
                .where((ordre) => ordre.hentet == true && ordre.kjopte != true)
                .toList();

            if (_alleInfo!.isEmpty) {
              _allEmpty = true;
            } else {
              _allEmpty = false;
            }

            _isloading = false;
          } else {
            _allEmpty = true;
            _isloading = false;
          }
        });
      }
    } on SocketException {
      showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
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
        context.pushNamed('registrer');
        return;
      } else {
        await apicalls.updateUserStats(token);
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
          backgroundColor: FlutterFlowTheme.of(context).secondary,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondary,
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).alternate),
            automaticallyImplyLeading: true,
            leading: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                context.safePop();
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 28.0,
              ),
            ),
            title: Text(
              'Mine salg',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Montserrat',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 20.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            actions: const [],
            centerTitle: true,
            elevation: 0.0,
          ),
          body: SafeArea(
            top: true,
            child: Stack(
              alignment: const AlignmentDirectional(1.0, -1.0),
              children: [
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(5.0, 20.0, 5.0, 0.0),
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
                            : _alleInfo!.length,
                    itemBuilder: (context, index) {
                      if (_allEmpty == true) {
                        return Container(
                          width: MediaQuery.sizeOf(context).width,
                          height: MediaQuery.sizeOf(context).height - 315,
                          child: Align(
                            alignment: const AlignmentDirectional(0, -1),
                            child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, 110),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              70, 0, 0, 0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          'assets/images/In_no_time-rafiki.png',
                                          width: 276,
                                          height: 215,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 16, 0, 0),
                                      child: Text(
                                        'Ingen handler enda',
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .override(
                                              fontFamily: 'Open Sans',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 20,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        );
                      }
                      if (_isloading) {
                        return Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    color: const Color.fromARGB(
                                        127, 255, 255, 255),
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
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 120,
                                          height: 16.0,
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                127, 255, 255, 255),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width:
                                              90.0, // Narrower width for second line
                                          height: 16.0,
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                127, 255, 255, 255),
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
                          ),
                        );
                      }
                      final alleInfo = _alleInfo![index];
                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                try {
                                  await showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    useSafeArea: true,
                                    context: context,
                                    builder: (context) {
                                      return GestureDetector(
                                        onTap: () =>
                                            FocusScope.of(context).unfocus(),
                                        child: Padding(
                                          padding:
                                              MediaQuery.viewInsetsOf(context),
                                          child: GodkjentebudWidget(
                                            info: alleInfo.foodDetails,
                                            ordre: alleInfo,
                                          ),
                                        ),
                                      );
                                    },
                                  ).then((value) => setState(() {
                                        getAll();
                                      }));
                                  return;
                                } on SocketException {
                                  showErrorToast(
                                      context, 'Ingen internettforbindelse');
                                } catch (e) {
                                  showErrorToast(context, 'En feil oppstod');
                                }
                              },
                              child: Material(
                                color: Colors.transparent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Container(
                                  height: 107,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Stack(
                                          children: [
                                            Align(
                                              alignment:
                                                  const AlignmentDirectional(
                                                      1.76, -0.05),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 1, 1, 1),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  child: Image.network(
                                                    '${ApiConstants.baseUrl}${alleInfo.foodDetails.imgUrls![0]}',
                                                    width: 60,
                                                    height: 60,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (BuildContext context,
                                                            Object error,
                                                            StackTrace?
                                                                stackTrace) {
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
                                          ],
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(8, 0, 4, 0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0, 10, 0, 0),
                                                  child: Text(
                                                    alleInfo.foodDetails.name ??
                                                        '',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .headlineSmall
                                                        .override(
                                                          fontFamily:
                                                              'Open Sans',
                                                          fontSize: 20,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                ),
                                                if (alleInfo.trekt == true)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0, 0, 0, 6),
                                                    child: Text(
                                                      alleInfo.kjopte == true
                                                          ? 'Du trakk budet'
                                                          : 'Kjøperen trakk budet',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'Open Sans',
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText,
                                                            fontSize: 14,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                  ),
                                                if (alleInfo.godkjent != true &&
                                                    alleInfo.hentet != true &&
                                                    alleInfo.trekt != true &&
                                                    alleInfo.avvist != true)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0, 0, 0, 6),
                                                    child: Text(
                                                      alleInfo.kjopte == true
                                                          ? 'Venter svar fra selgeren'
                                                          : 'Vurder kjøperen',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'Open Sans',
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText,
                                                            fontSize: 14,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                  ),
                                                if (alleInfo.avvist == true)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0, 0, 0, 6),
                                                    child: Text(
                                                      alleInfo.kjopte == true
                                                          ? 'Selgeren avslo budet'
                                                          : 'Du avslo budet',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'Open Sans',
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText,
                                                            fontSize: 14,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                  ),
                                                if (alleInfo.godkjent == true &&
                                                    alleInfo.hentet != true)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0, 0, 0, 6),
                                                    child: Text(
                                                      alleInfo.kjopte == true
                                                          ? 'Budet er godkjent, kontakt selgeren'
                                                          : 'Budet er godkjent, kontakt kjøperen',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'Open Sans',
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText,
                                                            fontSize: 14,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                  ),
                                                if (alleInfo.hentet == true)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0, 0, 0, 6),
                                                    child: Text(
                                                      alleInfo.kjopte == true
                                                          ? 'Kjøpet er fullført'
                                                          : 'Salget er fullført',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'Open Sans',
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText,
                                                            fontSize: 14,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            if (alleInfo.trekt != true &&
                                                alleInfo.avvist != true)
                                              Container(
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  borderRadius:
                                                      BorderRadius.circular(13),
                                                ),
                                                child: Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0, 0),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            15, 0, 12, 0),
                                                    child: Text(
                                                      '+${alleInfo.pris} Kr',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'Open Sans',
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            fontSize: 14,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
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
                        ],
                      );
                    },
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
