import 'package:flutter/material.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  LatLng? _brukersted = const LatLng(40.7127753, -74.0059728);
  LatLng? get brukersted => _brukersted;
  set brukersted(LatLng? value) {
    _brukersted = value;
  }

  bool _likt = false;
  bool get likt => _likt;
  set likt(bool value) {
    _likt = value;
  }
}
