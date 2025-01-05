import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_theme.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:provider/provider.dart';

import 'how_it_works_model.dart';
export 'how_it_works_model.dart';

class HowItWorksWidget extends StatefulWidget {
  const HowItWorksWidget({super.key});

  @override
  State<HowItWorksWidget> createState() => _HowItWorksWidgetState();
}

class _HowItWorksWidgetState extends State<HowItWorksWidget> {
  late HowItWorksModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HowItWorksModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  String title() {
    if (_model.pageViewCurrentIndex == 0) {
      return 'Gratulerer! Du har lagt ut din første annonse.';
    }
    if (_model.pageViewCurrentIndex == 1) {
      return 'Kjøpere kan sende bud med kjøpsknappen';
    }
    if (_model.pageViewCurrentIndex == 2) {
      return 'Bruk chatten til å avtale overlevering av varen.';
    }
    if (_model.pageViewCurrentIndex == 3) {
      return 'Gjør deg klar for å motta utbetalinger.';
    }
    return '';
  }

  String underTitle() {
    if (_model.pageViewCurrentIndex == 0) {
      return 'Oppdag hvor enkelt det er å kjøpe og selge lokalt gjennom MatSalg.no-appen';
    }
    if (_model.pageViewCurrentIndex == 1) {
      return 'Godta eller avslå budet direkte i appen';
    }
    if (_model.pageViewCurrentIndex == 2) {
      return 'Bruk chatten til å bli enige om tid og sted for overlevering av varen.';
    }
    if (_model.pageViewCurrentIndex == 3) {
      return 'For å få betalt, må vi vite hvor pengene skal sendes. Følg instruksjonene for å gjøre kontoen din klar til å motta utbetalinger.';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
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
          body: SafeArea(
            top: true,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 460,
                        decoration: BoxDecoration(),
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            child: PageView(
                              controller: _model.pageViewController ??=
                                  PageController(initialPage: 0),
                              onPageChanged: (_) => safeSetState(() {}),
                              scrollDirection: Axis.horizontal,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.asset(
                                        'assets/images/posted_product.png',
                                        width: 290,
                                        height: 400,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.asset(
                                        'assets/images/bid.png',
                                        width: 290,
                                        height: 400,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.network(
                                        'https://picsum.photos/seed/820/600',
                                        width: double.infinity,
                                        height: 420,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Opacity(
                                        opacity: 0.95,
                                        child: Image.asset(
                                          'assets/images/money.png',
                                          width: 310,
                                          height: 220,
                                          fit: BoxFit.cover,
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
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Text(
                            title(),
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Nunito',
                                  fontSize: 23.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Text(
                            underTitle(),
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Nunito',
                                  fontSize: 17.0,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          return Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _model.pageViewCurrentIndex == index
                                      ? FlutterFlowTheme.of(context).alternate
                                      : const Color.fromARGB(
                                          173, 212, 212, 212),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              if (index < 3) const SizedBox(width: 10),
                            ],
                          );
                        }),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      FFButtonWidget(
                        showLoadingIndicator: false,
                        onPressed: () async {
                          if (_model.pageViewCurrentIndex == 3) {
                            Toasts.showAccepted(context, 'Dette kommer senere');
                            context.goNamed('Hjem');
                          }
                          await _model.pageViewController?.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                        text: _model.pageViewCurrentIndex == 3
                            ? 'Legg til utbetalingskonto'
                            : 'Neste',
                        options: FFButtonOptions(
                          width: _model.pageViewCurrentIndex == 3 ? 250 : 115,
                          height: 50,
                          padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                          iconPadding:
                              EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: FlutterFlowTheme.of(context).alternate,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Open Sans',
                                    color: Colors.white,
                                    fontSize: 15,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                          elevation: 0,
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      if (_model.pageViewCurrentIndex == 3)
                        const SizedBox(
                          height: 8,
                        ),
                      if (_model.pageViewCurrentIndex == 3)
                        TextButton(
                          onPressed: () {
                            context.goNamed('Hjem');
                          },
                          child: Text(
                            'Konfigurer senere',
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Nunito',
                                  fontSize: 17.0,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
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
    );
  }
}
