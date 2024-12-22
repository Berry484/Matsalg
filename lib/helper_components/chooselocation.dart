// Automatic FlutterFlow imports
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ChooselocationLatLng;
// Add any missing imports if necessary
import 'dart:math' as math;

//-----------------------------------------------------------------------------------------------------------------------
//--------------------Lets the user choose a new location either for them self or in general-----------------------------
//-----------------------------------------------------------------------------------------------------------------------
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
  double baseRadiusMeters = 345000; // Base radius in meters (represents 1 km)
  double zoomLevel = 9; // Initial zoom level

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
      setState(() {
        zoomLevel =
            mapController.zoom; // Update the zoom level from the controller
      });
    });
    // Force initial rendering of the circle
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // FlutterMap widget remains interactive
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: currentCenter,
              interactiveFlags:
                  InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              zoom: zoomLevel,
              minZoom: 5,
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
                  child: Icon(
                    Icons.location_pin,
                    color: FlutterFlowTheme.of(context).alternate,
                    size: 45,
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
          ),
          // // Dark overlay with transparent circle
          // IgnorePointer(
          //   ignoring: true, // This allows touch events to pass through
          //   child: CustomPaint(
          //     size: Size(double.infinity, double.infinity),
          //     painter: OverlayPainter(
          //       center: currentCenter ??
          //           ChooselocationLatLng.LatLng(
          //               widget.center.latitude, widget.center.longitude),
          //       zoom: zoomLevel,
          //       circleRadius: _calculateCircleRadius(),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // Calculate the pixel size of the circle based on the zoom level
  double _calculateCircleRadius() {
    return _metersToPixels(baseRadiusMeters, zoomLevel) / 2;
  }

  // Convert meters to pixels based on zoom level
  double _metersToPixels(double meters, double zoom) {
    const double metersPerPixelAtZoomLevel0 = 156543.03392804097;
    double metersPerPixel = metersPerPixelAtZoomLevel0 / math.pow(2, zoom);
    return meters / metersPerPixel;
  }
}
