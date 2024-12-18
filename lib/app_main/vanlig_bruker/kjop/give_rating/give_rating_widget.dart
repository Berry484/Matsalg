import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mat_salg/apiCalls.dart';
import 'package:mat_salg/app_main/vanlig_bruker/Utils.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'give_rating_model.dart';
export 'give_rating_model.dart';

class GiveRatingWidget extends StatefulWidget {
  const GiveRatingWidget({
    super.key,
    this.kjop,
    this.username,
    this.salgInfoId,
  });

  final dynamic kjop;
  final dynamic username;
  final dynamic salgInfoId;

  @override
  State<GiveRatingWidget> createState() => _GiveRatingWidgetState();
}

class _GiveRatingWidgetState extends State<GiveRatingWidget> {
  late GiveRatingModel _model;
  bool _messageIsLoading = false;
  ApiRating apiRating = ApiRating();
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final Toasts toasts = Toasts();

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GiveRatingModel());
  }

  void showAccepted(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 56.0,
        left: 16.0,
        right: 16.0,
        child: Material(
          color: Colors.transparent,
          child: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.up, // Allow dismissing upwards
            onDismissed: (_) =>
                overlayEntry.remove(), // Remove overlay on dismiss
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.checkmark_alt_circle_fill,
                    color: FlutterFlowTheme.of(context).alternate,
                    size: 35.0,
                  ),
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
      ),
    );

    overlay.insert(overlayEntry);

    // Auto-remove the toast after 3 seconds if not dismissed
    Future.delayed(const Duration(seconds: 3), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
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
        width: double.infinity,
        height: 540,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primary,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x25090F13),
              offset: Offset(
                0.0,
                2,
              ),
            )
          ],
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              height: 22,
              thickness: 4,
              indent: MediaQuery.of(context).size.width * 0.4,
              endIndent: MediaQuery.of(context).size.width * 0.4,
              color: Colors.black12,
            ),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 30),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Vurder',
                        textAlign: TextAlign.start,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Open Sans',
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 22,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(1, -1),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 6, 12, 0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Lukk',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Open Sans',
                              fontSize: 15,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Align(
                alignment: const AlignmentDirectional(0, 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              40, 0, 40, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Legg igjen en vurdering',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Nunito',
                                      fontSize: 21,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                'Vurderingen vil være synlig for andre',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Nunito',
                                      fontSize: 16,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          )),
                      RatingBar.builder(
                        onRatingUpdate: (newValue) => safeSetState(() =>
                            _model.ratingBarValue =
                                newValue), // _model.ratingBarValue is num
                        itemBuilder: (context, index) {
                          // Check if this index should be filled or not
                          return Icon(
                            index < _model.ratingBarValue!.toInt()
                                ? CupertinoIcons.star_fill // Filled icon
                                : CupertinoIcons.star, // Unfilled icon
                            color: const Color(0xFFF65E55),
                          );
                        },
                        unratedColor: const Color(0xFFE1E1E8),
                        direction: Axis.horizontal,
                        initialRating: _model.ratingBarValue ??=
                            5, // Assign default value if null
                        itemCount: 5,
                        minRating: 1,
                        maxRating: 5,
                        itemSize: 50,
                        glow: false,
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            40, 80, 40, 45),
                        child: FFButtonWidget(
                          onPressed: () async {
                            try {
                              if (_messageIsLoading) return;
                              _messageIsLoading = true;
                              String? token =
                                  await firebaseAuthService.getToken(context);
                              // Early return if token is null
                              if (token == null) {
                                _messageIsLoading = false;
                                return;
                              }
                              int rating = _model.ratingBarValue?.round() ?? 5;
                              try {
                                if (widget.salgInfoId != null) {
                                  final response = await ApiKjop().giveRating(
                                      id: widget.salgInfoId, token: token);
                                  if (response.statusCode == 200) {
                                    await apiRating.giRating(token,
                                        widget.username, rating, widget.kjop);

                                    if (mounted) {
                                      HapticFeedback.mediumImpact();
                                      showAccepted(context, 'Vurdering sendt');
                                      _messageIsLoading = false;
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      context.goNamed('MineKjop');
                                    }
                                  }
                                } else {
                                  await apiRating.giRating(token,
                                      widget.username, rating, widget.kjop);

                                  if (mounted) {
                                    _messageIsLoading = false;
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    context.goNamed('MineKjop');
                                  }
                                }
                              } catch (e) {
                                if (mounted) {
                                  _messageIsLoading = false;
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  context.goNamed('MineKjop');
                                }
                              }
                            } on SocketException {
                              _messageIsLoading = false;

                              toasts.showErrorToast(
                                  context, 'Ingen internettforbindelse');
                            } catch (e) {
                              _messageIsLoading = false;

                              toasts.showErrorToast(context, 'En feil oppstod');
                            }
                          },
                          text: 'Send',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 47,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                11, 0, 0, 0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 0),
                            color: FlutterFlowTheme.of(context).alternate,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Nunito',
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontSize: 17,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                            elevation: 0,
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(14),
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
    );
  }
}
