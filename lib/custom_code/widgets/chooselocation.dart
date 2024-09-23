// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
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
  final LatLng center;
  final LatLng matsted;

  @override
  State<Chooselocation> createState() => _ChooselocationState();
}

class _ChooselocationState extends State<Chooselocation> {
  MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
          center: ChooselocationLatLng.LatLng(
              widget.center.latitude, widget.center.longitude),
          interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
          zoom: 16,
          minZoom: 6,
          maxZoom: 18),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(markers: [
          Marker(
            width: 100.0,
            height: 100.0,
            point: ChooselocationLatLng.LatLng(
                widget.matsted.latitude, widget.matsted.longitude),
            builder: (ctx) => const Icon(
              Icons.location_pin,
              color: Colors.redAccent, // Set the icon color to redAccent
              size: 34,
            ),
          )
        ]),
      ],
    );
  }
}
