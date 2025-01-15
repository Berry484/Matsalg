// Automatic FlutterFlow imports
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as choose_location;

//-----------------------------------------------------------------------------------------------------------------------
//--------------------Lets the user choose a new location either for them self or in general-----------------------------
//-----------------------------------------------------------------------------------------------------------------------
class Chooselocation extends StatefulWidget {
  const Chooselocation({
    super.key,
    this.width,
    this.height,
    this.zoom,
    required this.center,
    required this.matsted,
    this.onLocationChanged, // Add this line
  });

  final double? zoom;
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
  double baseRadiusMeters = 345000; // Base radius in meters (represents 1 km
  double zoomLevel = 9; // Initial zoom level

  // Store the current center of the map
  choose_location.LatLng? currentCenter;

  @override
  void initState() {
    super.initState();
    widget.zoom != null ? zoomLevel = widget.zoom! : zoomLevel = 9;
    currentCenter = choose_location.LatLng(
      widget.center.latitude,
      widget.center.longitude,
    );
    mapController.mapEventStream.listen((event) {
      setState(() {
        zoomLevel = mapController.camera.zoom;
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
              initialCenter: currentCenter!,
              interactionOptions: InteractionOptions(
                  flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag),
              initialZoom: zoomLevel,
              minZoom: 5,
              maxZoom: 18,
              onPositionChanged: (position, hasGesture) {
                // Update currentCenter on map position change
                setState(() {
                  currentCenter = position.center;
                });

                // Call the callback function to notify the parent widget
                if (widget.onLocationChanged != null && currentCenter != null) {
                  widget.onLocationChanged!(
                    LatLng(currentCenter!.latitude, currentCenter!.longitude),
                  );
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
                      choose_location.LatLng(
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
        ],
      ),
    );
  }
}
