import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mat_salg/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helper_components/flutter_flow/flutter_flow_util.dart';

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
      _ratingAverageValue =
          prefs.getDouble('ff_ratingAverageValue') ?? _ratingAverageValue;
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
      _followersCount = prefs.getInt('ff_followersCount') ?? _followersCount;
    });
    _safeInit(() {
      _followingCount = prefs.getInt('ff_followingCount') ?? _followingCount;
    });
    _safeInit(() {
      _ratingTotalCount =
          prefs.getInt('ff_ratingTotalCount') ?? _ratingTotalCount;
    });
    _safeInit(() {
      _profilepic = prefs.getString('ff_profilepic') ?? _profilepic;
    });

    await _safeInitAsync(_initializeConversations);
  }

  late SharedPreferences prefs;

  Future<void> _initializeConversations() async {
    String? conversationsJson = prefs.getString('ff_conversations');
    if (conversationsJson != null) {
      List<dynamic> conversationsList = json.decode(conversationsJson);
      _conversations = conversationsList
          .map((conversation) => Conversation.fromJson(conversation))
          .toList();
      notifyListeners();
    } else {
      _conversations = [];
    }
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  List<Conversation> _conversations = [];
  List<Conversation> get conversations => _conversations;
  set conversations(List<Conversation> value) {
    _conversations = value;
    _saveConversationsToPrefs();
    notifyListeners();
  }

  void updateIblock(String user, bool iblock) {
    bool updated = false; // Flag to check if any conversation was updated

    // Iterate through all conversations
    for (var conversation in _conversations) {
      // Check if the current conversation is between the user and the current conversation user
      if (conversation.user == user) {
        conversation.iblocked = iblock;
        updated = true;
      }
    }

    if (updated) {
      _saveConversationsToPrefs();
    }
  }

  void addConversation(Conversation conversation) {
    _conversations = [..._conversations, conversation];
    _saveConversationsToPrefs();
    notifyListeners();
  }

  void removeConversation(Conversation conversation) {
    _conversations = _conversations.where((c) => c != conversation).toList();
    _saveConversationsToPrefs();
    notifyListeners();
  }

  void _saveConversationsToPrefs() {
    String conversationsJson =
        json.encode(_conversations.map((e) => e.toJson()).toList());
    prefs.setString('ff_conversations', conversationsJson);
    notifyListeners();
  }

  void updateUI() {
    try {
      notifyListeners();
    } on Error {
      logger.d('Error updating ui');
    } catch (e) {
      logger.d('Error updating ui $e');
    }
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

  bool startet = false;

  bool lagtUt = false;

  bool liked = false;

  bool hasNotification = false;

  bool pushSent = false;

  LatLng? brukersted = const LatLng(59.9138688, 10.7522454);

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

  int _followersCount = 0;
  int get followersCount => _followersCount;
  set followersCount(int value) {
    _followersCount = value;
    prefs.setInt('ff_followersCount', value);
  }

  int _followingCount = 0;
  int get followingCount => _followingCount;
  set followingCount(int value) {
    _followingCount = value;
    prefs.setInt('ff_followingCount', value);
  }

  int _ratingTotalCount = 0;
  int get ratingTotalCount => _ratingTotalCount;
  set ratingTotalCount(int value) {
    _ratingTotalCount = value;
    prefs.setInt('ff_ratingTotalCount', value);
  }

  double _ratingAverageValue = 5;
  double get ratingAverageValue => _ratingAverageValue;
  set ratingAverageValue(double value) {
    _ratingAverageValue = value;
    prefs.setDouble('ff_ratingAverageValue', value);
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

  // List of liked foods
  List<int> likedFoods = [];

  // List of unliked foods
  List<int> unlikedFoods = [];

  // List of liked foods
  List<String> wantPush = [];

  // List of unliked foods
  List<String> noPush = [];

  // List of liked foods
  List<int> wantPushFoodDetails = [];

  // List of unliked foods
  List<int> noPushFoodDetails = [];

  String _profilepic = "";
  String get profilepic => _profilepic;
  set profilepic(String value) {
    _profilepic = value;
    prefs.setString('ff_profilepic', value);
  }

  final ValueNotifier<bool> chatAlert = ValueNotifier<bool>(false);
  final ValueNotifier<bool> notificationAlert = ValueNotifier<bool>(false);

  String _chatRoom = '';
  String get chatRoom => _chatRoom;
  set chatRoom(String value) {
    _chatRoom = value;
    prefs.setString('ff_chatRoom', value);
  }

  Future<void> storeTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('lastRequestTime', DateTime.now().millisecondsSinceEpoch);
  }

  Future<bool> canRequestCode() async {
    final prefs = await SharedPreferences.getInstance();
    final lastRequestTime = prefs.getInt('lastRequestTime');
    if (lastRequestTime == null) return true;

    final timePassed = DateTime.now().millisecondsSinceEpoch - lastRequestTime;
    return timePassed > 60000; // 1 minute
  }
}

class Conversation {
  final String user;
  final String username;
  final String profilePic;
  final bool deleted;
  String? lastactive;
  final List<Message> messages;
  int? matId;
  bool isOwner = false;
  String? productImage;
  bool? slettet = false;
  bool? kjopt = false;
  bool? iblocked;
  bool? otherblocked;

  Conversation(
      {required this.user,
      required this.username,
      required this.profilePic,
      required this.lastactive,
      required this.deleted,
      required this.messages,
      this.matId,
      this.isOwner = false,
      this.productImage,
      this.slettet = false,
      this.kjopt = false,
      this.iblocked = false,
      this.otherblocked = false});

  factory Conversation.fromJson(Map<String, dynamic> json) {
    // Checking if matId is present, and if not, it won't be included
    return Conversation(
      user: json['user'] as String? ?? "",
      username: json['username'] as String? ?? "",
      lastactive: json['lastactive'] as String?,
      profilePic: json['profile_picture'] as String? ?? "",
      deleted: json['deleted'] as bool? ?? false,
      messages: (json['messages'] as List)
          .map((messageJson) => Message.fromJson(messageJson))
          .toList(),

      matId: json['matId'], // matId is nullable
      isOwner: json['isOwner'] ?? false,
      productImage: json['productImage'],
      slettet: json['slettet'] ?? false,
      kjopt: json['kjopt'] ?? false,
      iblocked: json['iblocked'] as bool? ?? false,
      otherblocked: json['otherblocked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'user': user,
      'lastactive': lastactive,
      'deleted': deleted,
      'profile_picture': profilePic,
      'messages': messages.map((message) => message.toJson()).toList(),
      'matId': matId,
      'isOwner': isOwner,
      'productImage': productImage,
      'slettet': slettet,
      'kjopt': kjopt,
      'iblocked': iblocked,
      'otherblocked': otherblocked,
    };
  }

  void updateLastActive(String? newLastActive) {
    if (newLastActive == null) return;
    lastactive = newLastActive;
  }
}

class Message {
  final String content;
  final String time;
  bool read;
  final bool me;
  final int? matId;

  // Flags for UI (nullable)
  bool? showDelivered;
  bool? showLest;
  bool? isMostRecent;
  bool? showTime;

  Message({
    required this.content,
    required this.time,
    this.read = false,
    required this.me,
    this.showDelivered,
    this.showLest,
    this.isMostRecent,
    this.showTime,
    this.matId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content'] as String? ?? "",
      time: json['time'] as String? ?? "",
      read: json['read'] as bool? ?? false,
      me: json['me'] as bool? ?? false,
      matId:
          json['matId'] != null ? int.tryParse(json['matId'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'time': time,
      'read': read,
      'me': me,
      'matId': matId,
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
