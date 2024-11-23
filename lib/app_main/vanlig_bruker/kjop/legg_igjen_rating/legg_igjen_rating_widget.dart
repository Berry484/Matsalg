import 'dart:io';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mat_salg/ApiCalls.dart';
import 'package:mat_salg/SecureStorage.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'legg_igjen_rating_model.dart';
export 'legg_igjen_rating_model.dart';

class LeggIgjenRatingWidget extends StatefulWidget {
  const LeggIgjenRatingWidget({
    super.key,
    required this.username,
    required this.kjop,
  });

  final dynamic username;
  final dynamic kjop;

  @override
  State<LeggIgjenRatingWidget> createState() => _LeggIgjenRatingWidgetState();
}

class _LeggIgjenRatingWidgetState extends State<LeggIgjenRatingWidget> {
  late LeggIgjenRatingModel _model;
  final ApiRating apiRating = ApiRating();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LeggIgjenRatingModel());
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
          body: SafeArea(
            top: true,
            child: Stack(
              alignment: const AlignmentDirectional(0, -1),
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: const AlignmentDirectional(0, -1),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20, 100, 20, 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/ReviewImage.png',
                            width: double.infinity,
                            height: 179,
                            fit: BoxFit.contain,
                            alignment: const Alignment(0, -1),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(0, -1),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 20),
                        child: Text(
                          'Legg igjen en vurdering',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Open Sans',
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 21,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                      child: RatingBar.builder(
                        onRatingUpdate: (newValue) => safeSetState(
                            () => _model.ratingBarValue = newValue),
                        itemBuilder: (context, index) => const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFF65E55),
                        ),
                        direction: Axis.horizontal,
                        initialRating: _model.ratingBarValue ??= 5,
                        unratedColor:
                            FlutterFlowTheme.of(context).secondaryText,
                        itemCount: 5,
                        itemSize: 45,
                        allowHalfRating: false,
                        glowColor: const Color(0xFFF65E55),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 180, 20, 0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          try {
                            String? token = await Securestorage().readToken();

                            // Early return if token is null
                            if (token == null) {
                              FFAppState().login = false;
                              if (mounted) {
                                context.pushNamed('registrer');
                              }
                              return;
                            }
                            int rating = _model.ratingBarValue?.round() ?? 5;

                            try {
                              await apiRating.giRating(
                                  token, widget.username, rating, widget.kjop);
                              if (mounted) {
                                context.pushNamed('Hjem');
                              }
                            } catch (e) {
                              if (mounted) {
                                context.pushNamed('Hjem');
                              }
                            }
                          } on SocketException {
                            showErrorToast(
                                context, 'Ingen internettforbindelse');
                          } catch (e) {
                            showErrorToast(context, 'En feil oppstod');
                          }
                        },
                        text: 'Send',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 50,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16, 0, 16, 0),
                          iconPadding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: FlutterFlowTheme.of(context).alternate,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Open Sans',
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontSize: 18,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                          elevation: 0,
                          borderRadius: BorderRadius.circular(14),
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
    );
  }
}
