import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_theme.dart';
import 'package:mat_salg/helper_components/flutter_flow/lat_lng.dart';
import '../../helper_components/widgets/maps/index.dart' as custom_widgets;
import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final String imageUrl;
  final bool isSoldOut;

  const ImageCard({
    super.key,
    required this.imageUrl,
    required this.isSoldOut,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: CachedNetworkImage(
            fadeInDuration: Duration.zero,
            imageUrl: imageUrl,
            width: double.infinity,
            fit: BoxFit.cover,
            alignment: const Alignment(0.0, 0.0),
            imageBuilder: (context, imageProvider) {
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
            errorWidget: (context, url, error) => Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                image: const DecorationImage(
                  image: AssetImage('assets/images/error_image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        if (isSoldOut)
          Positioned(
            top: 18,
            right: -25,
            child: Transform.rotate(
              angle: 0.600,
              child: Container(
                width: 140,
                height: 25,
                color: Colors.redAccent,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(right: 2),
                child: const Text(
                  'Utsolgt',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class MapWithButton extends StatelessWidget {
  final double? latitude;
  final double? longitude;
  final bool? accuratePosition;
  final Function onTapCallback;

  const MapWithButton({
    super.key,
    this.latitude,
    this.longitude,
    this.accuratePosition,
    required this.onTapCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RepaintBoundary(
          child: custom_widgets.MyOsmKartNoGesture(
            center: LatLng(latitude ?? 0, longitude ?? 0),
            accuratePosition: accuratePosition ?? false,
          ),
        ),
        Positioned.fill(
          child: Container(
            color: Colors.transparent,
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTapDown: (details) => onTapCallback(),
            child: Transform.rotate(
              angle: -1.7,
              child: Container(
                height: 43,
                width: 43,
                decoration: BoxDecoration(
                  color:
                      FlutterFlowTheme.of(context).alternate.withOpacity(0.93),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  CupertinoIcons.arrow_up_left_arrow_down_right,
                  color: FlutterFlowTheme.of(context).primary,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
