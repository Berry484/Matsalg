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

class Chooselocation extends StatefulWidget {
  const Chooselocation({
    super.key,
    this.width,
    this.height,
    required this.center,
    required this.matsted,
  });

  final double? width;
  final double? height;
  final LatLng center; // From your FlutterFlow LatLng
  final LatLng matsted; // From your FlutterFlow LatLng

  @override
  State<Chooselocation> createState() => _ChooselocationState();
}

class _ChooselocationState extends State<Chooselocation> {
  MapController mapController = MapController();

  // Store the current center of the map
  ChooselocationLatLng.LatLng? currentCenter;

  // Define how much to offset the marker's latitude (in degrees)
  final double markerOffsetY = 0.01; // Adjust this value as needed

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
              zoom: 13,
              minZoom: 6,
              maxZoom: 18,
              onPositionChanged: (position, hasGesture) {
                // Update currentCenter on map position change
                setState(() {
                  currentCenter = position.center;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              // Marker Layer
              MarkerLayer(markers: [
                Marker(
                  width: 50.0,
                  height: 50.0,
                  // Offset the latitude of the marker
                  point: ChooselocationLatLng.LatLng(
                    currentCenter!.latitude + markerOffsetY, // Adjust latitude
                    currentCenter!.longitude,
                  ),
                  builder: (ctx) => GestureDetector(
                    onTap: () {
                      // Show a dialog with the current marker's coordinates
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Marker Location'),
                          content: Text(
                            'Latitude: ${currentCenter!.latitude + markerOffsetY}\nLongitude: ${currentCenter!.longitude}',
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Icon(
                      Icons.location_pin,
                      color: FlutterFlowTheme.of(context).alternate,
                      size: 50,
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
}
