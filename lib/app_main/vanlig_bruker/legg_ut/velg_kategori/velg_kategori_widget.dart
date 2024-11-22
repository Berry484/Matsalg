import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

import 'velg_kategori_model.dart';
export 'velg_kategori_model.dart';

class VelgKategoriWidget extends StatefulWidget {
  const VelgKategoriWidget({super.key, this.kategori});
  final dynamic kategori;

  @override
  State<VelgKategoriWidget> createState() => _VelgKategoriWidgetState();
}

class _VelgKategoriWidgetState extends State<VelgKategoriWidget> {
  late VelgKategoriModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VelgKategoriModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 60, 0, 0),
      child: Container(
        width: 500,
        height: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primary,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                height: 100,
                child: Stack(
                  alignment: const AlignmentDirectional(0, 1),
                  children: [
                    Material(
                      color: Colors.transparent,
                      elevation: 10,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primary,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Divider(
                              height: 22,
                              thickness: 4,
                              indent: 168,
                              endIndent: 168,
                              color: Color.fromRGBO(197, 197, 199, 1),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      15, 0, 0, 0),
                                  child: Text(
                                    'Lukk',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Nunito',
                                          color: Colors.transparent,
                                          fontSize: 16,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                                Text(
                                  'Velg kategori',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Nunito',
                                        fontSize: 17,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 15, 0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Lukk',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Nunito',
                                            fontSize: 16,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: const AlignmentDirectional(-1, 0),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    20, 20, 0, 0),
                                child: Text(
                                  'Alle kategorier',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Nunito',
                                        fontSize: 19,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 20, 0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Align(
                                    alignment:
                                        const AlignmentDirectional(-1, 0),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              20, 0, 20, 16),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 8, 0),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  HapticFeedback.lightImpact();
                                                  Navigator.pop(
                                                      context, 'kjøtt');
                                                },
                                                child: Container(
                                                  width: 100,
                                                  height: 110,
                                                  decoration: BoxDecoration(
                                                    color: widget.kategori ==
                                                            'kjøtt'
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .alternate
                                                        : const Color(
                                                            0xFFF6F6F6),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Ionicons
                                                            .restaurant_outline,
                                                        color:
                                                            widget.kategori ==
                                                                    'kjøtt'
                                                                ? Colors.white
                                                                : const Color(
                                                                    0xFF838383),
                                                        size: 36,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                0, 2, 0, 0),
                                                        child: Text(
                                                          'Kjøtt',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Nunito',
                                                                color: widget
                                                                            .kategori ==
                                                                        'kjøtt'
                                                                    ? Colors
                                                                        .white
                                                                    : const Color(
                                                                        0xFF838383),
                                                                fontSize: 15,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 8, 0),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  HapticFeedback.lightImpact();
                                                  Navigator.pop(
                                                      context, 'grønt');
                                                },
                                                child: Container(
                                                  width: 100,
                                                  height: 110,
                                                  decoration: BoxDecoration(
                                                    color: widget.kategori ==
                                                            'grønt'
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .alternate
                                                        : const Color(
                                                            0xFFF6F6F6),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Ionicons.leaf_outline,
                                                        color:
                                                            widget.kategori ==
                                                                    'grønt'
                                                                ? Colors.white
                                                                : const Color(
                                                                    0xFF838383),
                                                        size: 36,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                0, 2, 0, 0),
                                                        child: Text(
                                                          'Grønt',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Nunito',
                                                                color: widget
                                                                            .kategori ==
                                                                        'grønt'
                                                                    ? Colors
                                                                        .white
                                                                    : const Color(
                                                                        0xFF838383),
                                                                fontSize: 15,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 8, 0),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  HapticFeedback.lightImpact();
                                                  Navigator.pop(
                                                      context, 'meieri');
                                                },
                                                child: Container(
                                                  width: 100,
                                                  height: 110,
                                                  decoration: BoxDecoration(
                                                    color: widget.kategori ==
                                                            'meieri'
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .alternate
                                                        : const Color(
                                                            0xFFF6F6F6),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Ionicons.egg_outline,
                                                        color:
                                                            widget.kategori ==
                                                                    'meieri'
                                                                ? Colors.white
                                                                : const Color(
                                                                    0xFF838383),
                                                        size: 36,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                0, 2, 0, 0),
                                                        child: Text(
                                                          'meieri',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Nunito',
                                                                color: widget
                                                                            .kategori ==
                                                                        'meieri'
                                                                    ? Colors
                                                                        .white
                                                                    : const Color(
                                                                        0xFF838383),
                                                                fontSize: 15,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
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
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            20, 0, 20, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 8, 0),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                HapticFeedback.lightImpact();
                                                Navigator.pop(
                                                    context, 'bakverk');
                                              },
                                              child: Container(
                                                width: 100,
                                                height: 110,
                                                decoration: BoxDecoration(
                                                  color: widget.kategori ==
                                                          'bakverk'
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .alternate
                                                      : const Color(0xFFF6F6F6),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Ionicons.basket_outline,
                                                      color: widget.kategori ==
                                                              'bakverk'
                                                          ? Colors.white
                                                          : const Color(
                                                              0xFF838383),
                                                      size: 36,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              0, 2, 0, 0),
                                                      child: Text(
                                                        'Bakverk',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Nunito',
                                                              color: widget
                                                                          .kategori ==
                                                                      'bakverk'
                                                                  ? Colors.white
                                                                  : const Color(
                                                                      0xFF838383),
                                                              fontSize: 15,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 8, 0),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                HapticFeedback.lightImpact();
                                                Navigator.pop(
                                                    context, 'sjømat');
                                              },
                                              child: Container(
                                                width: 100,
                                                height: 110,
                                                decoration: BoxDecoration(
                                                  color: widget.kategori ==
                                                          'sjømat'
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .alternate
                                                      : const Color(0xFFF6F6F6),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Ionicons.fish_outline,
                                                      color: widget.kategori ==
                                                              'sjømat'
                                                          ? Colors.white
                                                          : const Color(
                                                              0xFF838383),
                                                      size: 36,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              0, 2, 0, 0),
                                                      child: Text(
                                                        'Sjømat',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Nunito',
                                                              color: widget
                                                                          .kategori ==
                                                                      'sjømat'
                                                                  ? Colors.white
                                                                  : const Color(
                                                                      0xFF838383),
                                                              fontSize: 15,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 8, 0),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                HapticFeedback.lightImpact();
                                                Navigator.pop(context, 'annet');
                                              },
                                              child: Container(
                                                width: 100,
                                                height: 110,
                                                decoration: BoxDecoration(
                                                  color: widget.kategori ==
                                                          'annet'
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .alternate
                                                      : const Color(0xFFF6F6F6),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Ionicons
                                                          .help_circle_outline,
                                                      color: widget.kategori ==
                                                              'annet'
                                                          ? Colors.white
                                                          : const Color(
                                                              0xFF838383),
                                                      size: 36,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              0, 2, 0, 0),
                                                      child: Text(
                                                        'Annet',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Nunito',
                                                              color: widget
                                                                          .kategori ==
                                                                      'annet'
                                                                  ? Colors.white
                                                                  : const Color(
                                                                      0xFF838383),
                                                              fontSize: 15,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
