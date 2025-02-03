import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as osm_map;
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_theme.dart';
import 'dart:math' as math;

import 'package:mat_salg/helper_components/flutter_flow/lat_lng.dart';

class MyOsmKartNoGesture extends StatefulWidget {
  const MyOsmKartNoGesture({
    super.key,
    this.width,
    this.height,
    required this.center,
    required this.accuratePosition,
  });

  final double? width;
  final double? height;
  final LatLng center;
  final bool accuratePosition;

  @override
  State<MyOsmKartNoGesture> createState() => _MyOsmKartState();
}

class _MyOsmKartState extends State<MyOsmKartNoGesture> {
  MapController mapController = MapController();
  double baseRadiusMeters = 2500; // Base radius in meters
  double zoomLevel = 12.5; // Initial zoom level

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter:
            osm_map.LatLng(widget.center.latitude, widget.center.longitude),
        interactionOptions: InteractionOptions(flags: InteractiveFlag.none),
        initialZoom: zoomLevel,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(markers: [
          Marker(
            width: widget.accuratePosition ? 40 : _calculateCircleSize(),
            height: widget.accuratePosition ? 40 : _calculateCircleSize(),
            point:
                osm_map.LatLng(widget.center.latitude, widget.center.longitude),
            child: widget.accuratePosition
                ? Icon(
                    Icons.location_on,
                    color: FlutterFlowTheme.of(context).alternate,
                    size: 44,
                  )
                : CustomPaint(
                    size: Size(
                      _calculateCircleSize(),
                      _calculateCircleSize(),
                    ),
                    painter: CirclePainter(
                      radius: _calculateCircleRadius(),
                    ),
                  ),
          ),
        ]),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Text(
              '© OpenStreetMap-bidragsyterene',
              style: TextStyle(fontSize: 11, color: Colors.black54),
            ),
          ),
        ),
      ],
    );
  }

  // Calculate the pixel size of the circle based on the zoom level
  double _calculateCircleSize() {
    // Convert the radius in meters to a pixel size
    double scale = _metersToPixels(baseRadiusMeters, zoomLevel);
    return scale;
  }

  // Calculate the radius for drawing the circle
  double _calculateCircleRadius() {
    double radiusInPixels = _calculateCircleSize() / 2;
    return radiusInPixels;
  }

  // Convert meters to pixels based on zoom level
  double _metersToPixels(double meters, double zoom) {
    // Conversion factor for meters to pixels at zoom level 0
    const double metersPerPixelAtZoomLevel0 = 156543.03392804097;
    double metersPerPixel = metersPerPixelAtZoomLevel0 / math.pow(2, zoom);
    return meters / metersPerPixel;
  }
}

class CirclePainter extends CustomPainter {
  CirclePainter({required this.radius});

  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.redAccent.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      radius,
      paint,
    );

    final Paint borderPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      radius,
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
