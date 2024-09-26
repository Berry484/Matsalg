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
              zoom: 12,
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
              // Marker Layer
              MarkerLayer(
                markers: [
                  Marker(
                    width: 50.0,
                    height: 50.0,
                    point: currentCenter ?? ChooselocationLatLng.LatLng(0, 0),
                    builder: (ctx) => GestureDetector(
                      onTap: () {
                        // Add any action when the marker is tapped
                      },
                      child: Icon(
                        Icons.location_pin,
                        color: FlutterFlowTheme.of(context).alternate,
                        size: 56,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
