import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' as osm_map;
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_theme.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_util.dart';
import 'dart:math' as math;

class MyOsmKart extends StatefulWidget {
  const MyOsmKart({
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
  State<MyOsmKart> createState() => _MyOsmKartState();
}

class _MyOsmKartState extends State<MyOsmKart> {
  MapController mapController = MapController();
  double baseRadiusMeters = 2500;
  double zoomLevel = 12.5;
  osm_map.LatLng userLocation =
      osm_map.LatLng(FFAppState().brukerLat, FFAppState().brukerLng);

  @override
  void initState() {
    super.initState();
    mapController.mapEventStream.listen((event) {
      setState(() {
        zoomLevel = mapController.camera.zoom;
      });
    });
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    // Define the LocationSettings
    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Adjust this based on your needs (meters)
    );

    // Get the current position with LocationSettings
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    setState(() {
      userLocation = osm_map.LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter:
            osm_map.LatLng(widget.center.latitude, widget.center.longitude),
        interactionOptions: InteractionOptions(
            flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag),
        initialZoom: zoomLevel,
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
          Marker(
              width: 21,
              height: 21,
              point: userLocation,
              child: Container(
                width: 19.5,
                height: 19.5,
                decoration: BoxDecoration(
                  color: CupertinoColors.activeBlue,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2.65,
                  ),
                ),
              )),
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

  double _calculateCircleSize() {
    double scale = _metersToPixels(baseRadiusMeters, zoomLevel);
    return scale;
  }

  double _calculateCircleRadius() {
    double radiusInPixels = _calculateCircleSize() / 2;
    return radiusInPixels;
  }

  double _metersToPixels(double meters, double zoom) {
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
