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
      _login = prefs.getBool('ff_login') ?? _login;
    });
    _safeInit(() {
      _bonde = prefs.getBool('ff_bonde') ?? _bonde;
    });
    _safeInit(() {
      _kjopAlert = prefs.getBool('ff_kjopAlert') ?? _kjopAlert;
    });
    _safeInit(() {
      _chatAlert = prefs.getBool('ff_chatAlert') ?? _chatAlert;
    });
    _safeInit(() {
      _brukernavn = prefs.getString('ff_brukernavn') ?? _brukernavn;
    });
    _safeInit(() {
      _firstname = prefs.getString('ff_firstname') ?? _firstname;
    });
    _safeInit(() {
      _lastname = prefs.getString('ff_lastname') ?? _lastname;
    });
    _safeInit(() {
      _bio = prefs.getString('ff_bio') ?? _bio;
    });
    _safeInit(() {
      _profilepic = prefs.getString('ff_profilepic') ?? _profilepic;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  bool _login = false;
  bool get login => _login;
  set login(bool value) {
    _login = value;
    prefs.setBool('ff_login', value);
  }

  bool _startet = false;
  bool get startet => _startet;
  set startet(bool value) {
    _startet = value;
  }

  LatLng? _brukersted = const LatLng(40.7127753, -74.0059728);
  LatLng? get brukersted => _brukersted;
  set brukersted(LatLng? value) {
    _brukersted = value;
  }

  String _brukernavn = "null";
  String get brukernavn => _brukernavn;
  set brukernavn(String value) {
    _brukernavn = value;
    prefs.setString('ff_brukernavn', value);
  }

  String _firstname = "null";
  String get firstname => _firstname;
  set firstname(String value) {
    _firstname = value;
    prefs.setString('ff_firstname', value);
  }

  String _lastname = "null";
  String get lastname => _lastname;
  set lastname(String value) {
    _lastname = value;
    prefs.setString('ff_lastname', value);
  }

  String _bio = "null";
  String get bio => _bio;
  set bio(String value) {
    _bio = value;
    prefs.setString('ff_bio', value);
  }

  String _profilepic = "null";
  String get profilepic => _profilepic;
  set profilepic(String value) {
    _profilepic = value;
    prefs.setString('ff_profilepic', value);
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
