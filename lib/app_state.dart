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
      _brukerLat = prefs.getDouble('ff_brukerLat') ?? _brukerLat;
    });
    _safeInit(() {
      _brukerLng = prefs.getDouble('ff_brukerLng') ?? _brukerLng;
    });
    _safeInit(() {
      _firstname = prefs.getString('ff_kommune') ?? _kommune;
    });
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
      _email = prefs.getString('ff_email') ?? _email;
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

  String _kommune = 'Norge';
  String get kommune => _kommune;
  set kommune(String value) {
    _kommune = value;
    prefs.setString('ff_kommune', value);
  }

  bool _startet = false;
  bool get startet => _startet;
  set startet(bool value) {
    _startet = value;
  }

  bool _lagtUt = false;
  bool get lagtUt => _lagtUt;
  set lagtUt(bool value) {
    _lagtUt = value;
  }

  bool _liked = false;
  bool get liked => _liked;
  set liked(bool value) {
    _liked = value;
  }

  bool _harKjopt = false;
  bool get harKjopt => _harKjopt;
  set harKjopt(bool value) {
    _harKjopt = value;
  }

  bool _harSolgt = false;
  bool get harSolgt => _harSolgt;
  set harSolgt(bool value) {
    _harSolgt = value;
  }

  LatLng? _brukersted = const LatLng(59.9138688, 10.7522454);
  LatLng? get brukersted => _brukersted;
  set brukersted(LatLng? value) {
    _brukersted = value;
  }

  double? _brukerLat = 59.9138688;
  double? get brukerLat => _brukerLat;
  set brukerLat(double? value) {
    _brukerLat = value;
  }

  double? _brukerLng = 10.7522454;
  double? get brukerLng => _brukerLng;
  set brukerLng(double? value) {
    _brukerLng = value;
  }

  String _brukernavn = " ";
  String get brukernavn => _brukernavn;
  set brukernavn(String value) {
    _brukernavn = value;
    prefs.setString('ff_brukernavn', value);
  }

  String _email = " ";
  String get email => _email;
  set email(String value) {
    _email = value;
    prefs.setString('ff_email', value);
  }

  String _firstname = " ";
  String get firstname => _firstname;
  set firstname(String value) {
    _firstname = value;
    prefs.setString('ff_firstname', value);
  }

  String _lastname = " ";
  String get lastname => _lastname;
  set lastname(String value) {
    _lastname = value;
    prefs.setString('ff_lastname', value);
  }

  String _bio = " ";
  String get bio => _bio;
  set bio(String value) {
    _bio = value;
    prefs.setString('ff_bio', value);
  }

  String _profilepic = " ";
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
