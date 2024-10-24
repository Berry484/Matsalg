// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';

// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ChooselocationLatLng;
import 'package:flutter_map/plugin_api.dart';
import '/flutter_flow/flutter_flow_widgets.dart'; // Add any missing imports if necessary
import 'dart:math' as math;

class Chooselocation extends StatefulWidget {
  const Chooselocation({
    super.key,
    this.width,
    this.height,
    required this.center,
    required this.matsted,
    this.onLocationChanged, // Add this line
  });

  final double? width;
  final double? height;
  final LatLng center; // From your FlutterFlow LatLng
  final LatLng matsted; // From your FlutterFlow LatLng
  final void Function(LatLng)? onLocationChanged; // Add this line

  @override
  State<Chooselocation> createState() => _ChooselocationState();
}

class _ChooselocationState extends State<Chooselocation> {
  MapController mapController = MapController();
  double baseRadiusMeters = 80000; // Base radius in meters (represents 1 km)
  double zoomLevel = 8; // Initial zoom level

  // Store the current center of the map
  ChooselocationLatLng.LatLng? currentCenter;

  @override
  void initState() {
    super.initState();
    // Initialize the current center with provided center coordinates
    currentCenter = ChooselocationLatLng.LatLng(
      widget.center.latitude,
      widget.center.longitude,
    );
    mapController.mapEventStream.listen((event) {
      if (event is MapEvent) {
        setState(() {
          zoomLevel =
              mapController.zoom; // Update the zoom level from the controller
        });
      }
    });
    // Force initial rendering of the circle
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: currentCenter,
              interactiveFlags:
                  InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              zoom: zoomLevel,
              minZoom: 6,
              maxZoom: 18,
              onPositionChanged: (position, hasGesture) {
                if (position.center != null) {
                  // Update currentCenter on map position change
                  setState(() {
                    currentCenter = position.center;
                  });

                  // Call the callback function to notify the parent widget
                  if (widget.onLocationChanged != null &&
                      currentCenter != null) {
                    widget.onLocationChanged!(
                      LatLng(currentCenter!.latitude, currentCenter!.longitude),
                    );
                  }
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(markers: [
                Marker(
                  width: 100.0,
                  height: 100.0,
                  point: currentCenter ??
                      ChooselocationLatLng.LatLng(
                          widget.center.latitude, widget.center.longitude),
                  builder: (ctx) => Icon(
                    Icons.location_pin,
                    color: FlutterFlowTheme.of(context).alternate,
                    size: 50,
                  ),
                ),
                Marker(
                  width:
                      _calculateCircleSize(), // Dynamic width of the marker widget
                  height:
                      _calculateCircleSize(), // Dynamic height of the marker widget
                  point: currentCenter ??
                      ChooselocationLatLng.LatLng(
                          widget.center.latitude, widget.center.longitude),
                  builder: (ctx) => CustomPaint(
                    size: Size(
                      _calculateCircleSize(),
                      _calculateCircleSize(),
                    ), // Dynamic size based on zoom
                    painter: CirclePainter(
                      radius:
                          _calculateCircleRadius(), // Pass the radius to the painter
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ],
      ),
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
