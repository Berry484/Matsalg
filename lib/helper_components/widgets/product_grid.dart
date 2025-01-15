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

  String getFormattedDistance() {
    final distance = CalculateDistance.calculateDistance(
      FFAppState().brukerLat,
      FFAppState().brukerLng,
      matvare.lat ?? 0.0,
      matvare.lng ?? 0.0,
    );
    return (distance < 1) ? '<1 Km' : '${distance.toStringAsFixed(0)} Km';
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final imageUrl = '${ApiConstants.baseUrl}${matvare.imgUrls![0]}';

    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 235,
            height: 290,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.transparent,
              ),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(2, 0, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProductImage(imageUrl: imageUrl),
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
                            child: Text(
                              matvare.name ?? '',
                              textAlign: TextAlign.start,
                              style: theme.bodyLarge.override(
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
                                  11, 0, 11, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${matvare.price} Kr',
                                    textAlign: TextAlign.end,
                                    style: theme.titleLarge.override(
                                      fontFamily: 'Nunito',
                                      color: theme.secondaryText,
                                      fontSize: 14,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    getFormattedDistance(),
                                    textAlign: TextAlign.start,
                                    style: theme.bodyMedium.override(
                                      fontFamily: 'Nunito',
                                      color: theme.secondaryText,
                                      fontSize: 14,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
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
                ],
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

class ProductImage extends StatelessWidget {
  final String imageUrl;

  const ProductImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      key: ValueKey(imageUrl),
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) {
        return Container(
          width: 200,
          height: 229,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      fadeInDuration: const Duration(milliseconds: 40),
      placeholder: (context, url) => const SizedBox(
        width: 200,
        height: 229,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Color(0xFFFAFAFA),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: 200,
        height: 229,
        color: Colors.grey,
        child: const Center(
          child: Icon(Icons.error, color: Colors.white),
        ),
      ),
    );
  }
}
