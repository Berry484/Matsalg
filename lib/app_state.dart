import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _bonde = prefs.getBool('ff_bonde') ?? _bonde;
    });
    _safeInit(() {
      _kjopAlert = prefs.getBool('ff_kjopAlert') ?? _kjopAlert;
    });
    _safeInit(() {
      _chatAlert = prefs.getBool('ff_chatAlert') ?? _chatAlert;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

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

  bool _bonde = false;
  bool get bonde => _bonde;
  set bonde(bool value) {
    _bonde = value;
    prefs.setBool('ff_bonde', value);
  }

  bool _kjopAlert = false;
  bool get kjopAlert => _kjopAlert;
  set kjopAlert(bool value) {
    _kjopAlert = value;
    prefs.setBool('ff_kjopAlert', value);
  }

  bool _chatAlert = false;
  bool get chatAlert => _chatAlert;
  set chatAlert(bool value) {
    _chatAlert = value;
    prefs.setBool('ff_chatAlert', value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
