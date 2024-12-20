// import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '/flutter_flow/flutter_flow_util.dart';

// import 'package:flutter_map/plugin_api.dart';

import 'package:latlong2/latlong.dart' as MyOsmKartLatLng;
import 'dart:math' as math;

class MyOsmKart extends StatefulWidget {
  const MyOsmKart({
    super.key,
    this.width,
    this.height,
    required this.center,
  });

  final double? width;
  final double? height;
  final LatLng center;

  @override
  State<MyOsmKart> createState() => _MyOsmKartState();
}

class _MyOsmKartState extends State<MyOsmKart> {
  MapController mapController = MapController();
  double baseRadiusMeters = 2500; // Base radius in meters (represents 1 km)
  double zoomLevel = 12.5; // Initial zoom level

  @override
  void initState() {
    super.initState();
    mapController.mapEventStream.listen((event) {
      setState(() {
        zoomLevel =
            mapController.zoom; // Update the zoom level from the controller
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: MyOsmKartLatLng.LatLng(
            widget.center.latitude, widget.center.longitude),
        interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
        zoom: zoomLevel,
        minZoom: 5.5,
        maxZoom: 18,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(markers: [
          Marker(
            width: _calculateCircleSize(),
            height: _calculateCircleSize(),
            point: MyOsmKartLatLng.LatLng(
                widget.center.latitude, widget.center.longitude),
            child: CustomPaint(
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
      ..color =
          Colors.redAccent.withOpacity(0.3) // Circle color with transparency
      ..style = PaintingStyle.fill;

    // Draw the circle in the center of the CustomPaint widget
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      radius, // Radius in pixels
      paint,
    );

    final Paint borderPaint = Paint()
      ..color = Colors.red // Border color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2; // Border stroke width

    // Draw the circle border
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
