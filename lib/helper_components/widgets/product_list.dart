import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mat_salg/models/matvarer.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_theme.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:mat_salg/helper_components/functions/calculate_distance.dart';
import 'package:mat_salg/my_ip.dart';

//-----------------------------------------------------------------------------------------------------------------------
//--------------------Displays a product that is used in the product lists-----------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------
class ProductList extends StatelessWidget {
  final Matvarer matvare;
  final VoidCallback onTap;

  const ProductList({
    super.key,
    required this.matvare,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: const AlignmentDirectional(0, -1),
          child: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: onTap,
            child: Material(
              color: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: 235,
                height: 290,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(3, 0, 0, 0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(17),
                            child: CachedNetworkImage(
                              imageUrl:
                                  '${ApiConstants.baseUrl}${matvare.imgUrls![0]}',
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  width: 200,
                                  height: 229,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                              fadeInDuration: Duration(milliseconds: 300),
                              placeholder: (context, url) => Container(
                                  width: 200,
                                  height: 229,
                                  color: Colors.grey[50]),
                              errorWidget: (context, url, error) => Container(
                                width: 200,
                                height: 229,
                                color: Colors.grey,
                                child: Center(
                                  child: Icon(Icons.error, color: Colors.white),
                                ),
                              ),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(-1, 0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  7, 0, 0, 0),
                              child: AutoSizeText(
                                matvare.name ?? '',
                                textAlign: TextAlign.start,
                                minFontSize: 11,
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: 'Nunito',
                                      fontSize: 14,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Align(
                              alignment: const AlignmentDirectional(0, 0),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    5, 0, 5, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 0, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(7, 0, 0, 0),
                                            child: Text(
                                              '${matvare.price} Kr',
                                              textAlign: TextAlign.end,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .titleLarge
                                                  .override(
                                                    fontFamily: 'Nunito',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    fontSize: 14,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                          if (matvare.kg == true)
                                            Text(
                                              '/kg',
                                              textAlign: TextAlign.end,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .titleLarge
                                                  .override(
                                                    fontFamily: 'Nunito',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    fontSize: 14,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 0, 7, 0),
                                          child: Text(
                                            (CalculateDistance
                                                        .calculateDistance(
                                                            FFAppState()
                                                                .brukerLat,
                                                            FFAppState()
                                                                .brukerLng,
                                                            matvare.lat ?? 0.0,
                                                            matvare.lng ??
                                                                0.0) <
                                                    1)
                                                ? '<1 Km'
                                                : '${CalculateDistance.calculateDistance(FFAppState().brukerLat, FFAppState().brukerLng, matvare.lat ?? 0.0, matvare.lng ?? 0.0).toStringAsFixed(0)} Km',
                                            textAlign: TextAlign.start,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Nunito',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  fontSize: 14,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Sale banner
        if (matvare.kjopt == true)
          Positioned(
            top: 15,
            right: -29,
            child: Transform.rotate(
              angle: 0.600,
              child: Container(
                width: 140,
                height: 23,
                color: Colors.redAccent,
                alignment: Alignment.center,
                child: const Text(
                  'Utsolgt',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
