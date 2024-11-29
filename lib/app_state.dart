import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  int _currentNavIndex = 0;

  int get currentNavIndex => _currentNavIndex;

  set currentNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

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

    // Initialize conversations list from shared preferences
    await _safeInitAsync(_initializeConversations);
  }

  Future<void> _initializeConversations() async {
    String? conversationsJson = prefs.getString('ff_conversations');
    if (conversationsJson != null) {
      List<dynamic> conversationsList = json.decode(conversationsJson);
      _conversations = conversationsList
          .map((conversation) => Conversation.fromJson(conversation))
          .toList();
    } else {
      _conversations = [];
    }
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  List<Conversation> _conversations = [];
  List<Conversation> get conversations => _conversations;
  set conversations(List<Conversation> value) {
    _conversations = value;
    _saveConversationsToPrefs();
    notifyListeners();
  }

  void addConversation(Conversation conversation) {
    _conversations.add(conversation);
    _saveConversationsToPrefs();
    notifyListeners();
  }

  void removeConversation(Conversation conversation) {
    _conversations.remove(conversation);
    _saveConversationsToPrefs();
    notifyListeners();
  }

  void _saveConversationsToPrefs() {
    String conversationsJson =
        json.encode(_conversations.map((e) => e.toJson()).toList());
    prefs.setString('ff_conversations', conversationsJson);
  }

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

  double _brukerLat = 59.9138688;
  double get brukerLat => _brukerLat;
  set brukerLat(double value) {
    _brukerLat = value;
    prefs.setDouble('ff_brukerLat', value);
  }

  double _brukerLng = 10.7522454;
  double get brukerLng => _brukerLng;
  set brukerLng(double value) {
    _brukerLng = value;
    prefs.setDouble('ff_brukerLng', value);
  }

  String _brukernavn = "";
  String get brukernavn => _brukernavn;
  set brukernavn(String value) {
    _brukernavn = value;
    prefs.setString('ff_brukernavn', value);
  }

  String _email = "";
  String get email => _email;
  set email(String value) {
    _email = value;
    prefs.setString('ff_email', value);
  }

  String _firstname = "";
  String get firstname => _firstname;
  set firstname(String value) {
    _firstname = value;
    prefs.setString('ff_firstname', value);
  }

  String _lastname = "";
  String get lastname => _lastname;
  set lastname(String value) {
    _lastname = value;
    prefs.setString('ff_lastname', value);
  }

  String _bio = "";
  String get bio => _bio;
  set bio(String value) {
    _bio = value;
    prefs.setString('ff_bio', value);
  }

  String _profilepic = "";
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

class Conversation {
  final String user;
  final String profilePic;
  final List<Message> messages;

  Conversation({
    required this.user,
    required this.profilePic,
    required this.messages,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      user: json['user'] as String? ?? "",
      profilePic: json['profile_picture'] as String? ?? "",
      messages: (json['messages'] as List)
          .map((messageJson) => Message.fromJson(messageJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'profile_picture': profilePic,
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }
}

class Message {
  final String content;
  final String time;
  bool read; // Changed to non-final to allow modification
  final bool me;

  Message({
    required this.content,
    required this.time,
    this.read = false, // Default to false for unread messages
    required this.me,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content'] as String? ?? "",
      time: json['time'] as String? ?? "",
      read: json['read'] as bool? ?? false, // Parse 'read' field from JSON
      me: json['me'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'time': time,
      'read': read,
      'me': me,
    };
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future<void> _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
