import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'bonde_chat_copy_model.dart';
export 'bonde_chat_copy_model.dart';

class BondeChatCopyWidget extends StatefulWidget {
  const BondeChatCopyWidget({super.key});

  @override
  State<BondeChatCopyWidget> createState() => _BondeChatCopyWidgetState();
}

class _BondeChatCopyWidgetState extends State<BondeChatCopyWidget>
    with TickerProviderStateMixin {
  late BondeChatCopyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BondeChatCopyModel());

    animationsMap.addAll({
      'listViewOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 270.0.ms,
            begin: const Offset(0.0, 13.999999999999986),
            end: const Offset(0.0, 0.0),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.47,
            end: 1.0,
          ),
        ],
      ),
    });
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
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondary,
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).alternate),
            automaticallyImplyLeading: false,
            title: Align(
              alignment: const AlignmentDirectional(0.0, 0.0),
              child: Text(
                'Mine samtaler',
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
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 1.0, 0.0, 0.0),
                            child: Material(
                              color: Colors.transparent,
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          16.0, 12.0, 12.0, 12.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(1.0, 1.0),
                                            child: Material(
                                              color: Colors.transparent,
                                              elevation: 0.2,
                                              shape: const CircleBorder(),
                                              child: Container(
                                                width: 60.0,
                                                height: 60.0,
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.transparent,
                                                    width: 0.0,
                                                  ),
                                                ),
                                                child: Container(
                                                  width: 120.0,
                                                  height: 120.0,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: CachedNetworkImage(
                                                    fadeInDuration: const Duration(
                                                        milliseconds: 0),
                                                    fadeOutDuration: const Duration(
                                                        milliseconds: 0),
                                                    imageUrl:
                                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/backup-jdlmhw/assets/hq722nopc44s/istockphoto-1409329028-612x612.jpg',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(8.0, 0.0, 0.0, 0.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      12.0,
                                                                      0.0),
                                                          child: Text(
                                                            'Geir johan',
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyLarge
                                                                .override(
                                                                  fontFamily:
                                                                      'Open Sans',
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    8.0,
                                                                    0.0),
                                                        child: Container(
                                                          width: 8.0,
                                                          height: 8.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color(
                                                                0xFF2446C2),
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                              color: Colors
                                                                  .transparent,
                                                              width: 0.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    4.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Text(
                                                          'Man. 3 Juli - 14:12',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .labelSmall
                                                              .override(
                                                                fontFamily:
                                                                    'Open Sans',
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .chevron_right_rounded,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        size: 24.0,
                                                      ),
                                                    ].divide(
                                                        const SizedBox(width: 16.0)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      thickness: 1.0,
                                      indent: 35.0,
                                      endIndent: 35.0,
                                      color: Color(0x32757575),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ).animateOnPageLoad(
                          animationsMap['listViewOnPageLoadAnimation']!),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
