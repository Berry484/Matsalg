import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mat_salg/logging.dart';
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
      _bonde = prefs.getBool('ff_bonde') ?? _bonde;
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

    // Initialize conversations list from shared preferences
    await _safeInitAsync(_initializeConversations);
    await _safeInitAsync(_initializeMatvarer);
    await _safeInitAsync(_initializeOrdreInfo);
  }

  // OrdreInfo List
  List<OrdreInfo> _ordreInfo = [];
  List<OrdreInfo> get ordreInfo => _ordreInfo;
  set ordreInfo(List<OrdreInfo> value) {
    _ordreInfo = value;
    _saveOrdreInfoToPrefs();
    notifyListeners();
  }

  // Add OrdreInfo to list
  void addOrdreInfo(OrdreInfo ordre) {
    _ordreInfo.add(ordre);
    _saveOrdreInfoToPrefs();
    notifyListeners();
  }

  // Remove OrdreInfo from list
  void removeOrdreInfo(OrdreInfo ordre) {
    _ordreInfo.remove(ordre);
    _saveOrdreInfoToPrefs();
    notifyListeners();
  }

  // Save OrdreInfo list to SharedPreferences
  void _saveOrdreInfoToPrefs() {
    String ordreInfoJson =
        json.encode(_ordreInfo.map((e) => e.toJson()).toList());
    prefs.setString('ff_ordre_info', ordreInfoJson);
    notifyListeners();
  }

  // Initialize OrdreInfo from SharedPreferences
  Future<void> _initializeOrdreInfo() async {
    String? ordreInfoJson = prefs.getString('ff_ordre_info');
    if (ordreInfoJson != null) {
      List<dynamic> ordreInfoList = json.decode(ordreInfoJson);
      _ordreInfo =
          ordreInfoList.map((ordre) => OrdreInfo.fromJson(ordre)).toList();
      notifyListeners();
    } else {
      _ordreInfo = [];
    }
  }

  Future<void> _initializeMatvarer() async {
    String? matvarerJson = prefs.getString('ff_matvarer');
    if (matvarerJson != null) {
      List<dynamic> matvarerList = json.decode(matvarerJson);
      _matvarer =
          matvarerList.map((matvare) => Matvarer.fromJson(matvare)).toList();
      notifyListeners();
    } else {
      _matvarer = [];
    }
  }

  void addMatvare(Matvarer matvare) {
    _matvarer.add(matvare);
    _saveMatvarerToPrefs();
    notifyListeners();
  }

  void removeMatvare(Matvarer matvare) {
    _matvarer.remove(matvare);
    _saveMatvarerToPrefs();
    notifyListeners();
  }

  void _saveMatvarerToPrefs() {
    String matvarerJson =
        json.encode(_matvarer.map((e) => e.toJson()).toList());
    prefs.setString('ff_matvarer', matvarerJson);
    notifyListeners();
  }

  late SharedPreferences prefs;
  List<Matvarer> _matvarer = [];
  List<Matvarer> get matvarer => _matvarer;
  set matvarer(List<Matvarer> value) {
    _matvarer = value;
    _saveMatvarerToPrefs();
    notifyListeners();
  }

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
  List<int> _likedFoods = [];
  List<int> get likedFoods => _likedFoods;
  set likedFoods(List<int> value) {
    _likedFoods = value;
  }

  // List of unliked foods
  List<int> _unlikedFoods = [];
  List<int> get unlikedFoods => _unlikedFoods;
  set unlikedFoods(List<int> value) {
    _unlikedFoods = value;
  }

  // List of liked foods
  List<String> _wantPush = [];
  List<String> get wantPush => _wantPush;
  set wantPush(List<String> value) {
    _wantPush = value;
  }

  // List of unliked foods
  List<String> _noPush = [];
  List<String> get noPush => _noPush;
  set noPush(List<String> value) {
    _noPush = value;
  }

  // List of liked foods
  List<int> _wantPushFoodDetails = [];
  List<int> get wantPushFoodDetails => _wantPushFoodDetails;
  set wantPushFoodDetails(List<int> value) {
    _wantPushFoodDetails = value;
  }

  // List of unliked foods
  List<int> _noPushFoodDetails = [];
  List<int> get noPushFoodDetails => _noPushFoodDetails;
  set noPushFoodDetails(List<int> value) {
    _noPushFoodDetails = value;
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

  final ValueNotifier<bool> chatAlert = ValueNotifier<bool>(false);

  String _chatRoom = '';
  String get chatRoom => _chatRoom;
  set chatRoom(String value) {
    _chatRoom = value;
    prefs.setString('ff_chatRoom', value);
  }
}

class Conversation {
  final String user;
  final String username;
  final String profilePic;
  final List<Message> messages;

  Conversation({
    required this.user,
    required this.username,
    required this.profilePic,
    required this.messages,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      user: json['user'] as String? ?? "",
      username: json['username'] as String? ?? "",
      profilePic: json['profile_picture'] as String? ?? "",
      messages: (json['messages'] as List)
          .map((messageJson) => Message.fromJson(messageJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
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

  // Flags for UI (nullable)
  bool? showDelivered;
  bool? showLest;
  bool? isMostRecent;
  bool? showTime;

  Message({
    required this.content,
    required this.time,
    this.read = false, // Default to false for unread messages
    required this.me,
    this.showDelivered, // Default to null
    this.showLest, // Default to null
    this.isMostRecent, // Default to null
    this.showTime,
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
      // You don't need to serialize the flags because they are temporary
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

class Matvarer {
  final int? matId;
  final String? name;
  final List<String>? imgUrls;
  final String? description;
  final int? price;
  final List<String>? kategorier;
  final double? lat;
  final double? lng;
  final bool? betaling;
  final bool? kg;
  final String? username;
  final String? uid;
  final bool? bonde;
  final int? antall;
  final String? profilepic;
  final bool? kjopt;
  final DateTime? updatetime; // Add updatetime here
  final bool? liked;
  final bool? wantPush;

  Matvarer({
    this.matId,
    this.name,
    this.imgUrls,
    this.description,
    this.price,
    this.kategorier,
    this.lat,
    this.lng,
    this.betaling,
    this.kg,
    this.username,
    this.uid,
    this.bonde,
    this.antall,
    this.profilepic,
    this.kjopt,
    this.updatetime, // Add updatetime to constructor
    this.liked,
    this.wantPush,
  });

  factory Matvarer.fromJson1(Map<String, dynamic>? json) {
    DateTime? parsedTime;
    if (json?['updatetime'] != null) {
      parsedTime = DateTime.tryParse(json?['updatetime']);
    }

    // Extract the 'listing' data (if it exists)
    Map<String, dynamic> listingJson = json?['listing'] ?? json;

    return Matvarer(
      matId: listingJson['matId'] as int?,
      name:
          listingJson['name'] as String? ?? "", // Default empty string if null
      imgUrls: (listingJson['imgUrl'] != null && listingJson['imgUrl'] is List)
          ? List<String>.from(listingJson['imgUrl']?.whereType<String>() ?? [])
          : [],
      description: listingJson['description'] as String? ?? "",
      price: listingJson['price'] as int?,
      kategorier: (listingJson['kategorier'] != null &&
              listingJson['kategorier'] is List)
          ? List<String>.from(listingJson['kategorier'])
          : null,
      lat: listingJson['lat'] as double?,
      lng: listingJson['lng'] as double?,
      betaling: listingJson['betaling'] as bool?,
      kg: listingJson['kg'] as bool?,
      // Getting the username and profilepic from the 'user' field inside 'listing'
      username: listingJson['username'] as String? ?? "",
      uid: listingJson['uid'] as String? ?? "",
      bonde: listingJson['bonde'] as bool?,
      antall: listingJson['antall'] as int?,
      profilepic: listingJson['profilepic'] as String? ?? "",
      kjopt: listingJson['kjopt'] as bool?,
      updatetime: parsedTime, // Parse updatetime if available
      liked: listingJson['liked'] as bool?,
      wantPush: listingJson['wantPush'] as bool?,
    );
  }

  factory Matvarer.fromJson(Map<String, dynamic>? json) {
    DateTime? parsedTime;
    if (json?['updatetime'] != null) {
      parsedTime = DateTime.tryParse(json?['updatetime']);
    }

    // Extract listing data (assuming the main object is stored in 'listing' or as root)
    Map<String, dynamic> listingJson = json?['listing'] ?? json;

    Map<String, dynamic> userJson = listingJson['user'] ?? {};
    return Matvarer(
      matId: listingJson['matId'] as int?,
      name: listingJson['name'] as String? ?? "",
      imgUrls: (listingJson['imgUrl'] != null && listingJson['imgUrl'] is List)
          ? List<String>.from(listingJson['imgUrl']?.whereType<String>() ?? [])
          : [],
      description: listingJson['description'] as String? ?? "",
      price: listingJson['price'] as int?,
      kategorier: (listingJson['kategorier'] != null &&
              listingJson['kategorier'] is List)
          ? List<String>.from(listingJson['kategorier'])
          : null,
      lat: listingJson['lat'] as double?,
      lng: listingJson['lng'] as double?,
      betaling: listingJson['betaling'] as bool?,
      kg: listingJson['kg'] as bool?,
      // Getting the username and profilepic from the 'user' field
      username: userJson['username'] as String? ?? "",
      uid: listingJson['uid'] as String? ?? "",
      bonde: userJson['bonde'] as bool?,
      antall: listingJson['antall'] as int?,
      profilepic: userJson['profilepic'] as String? ?? "",
      kjopt: listingJson['kjopt'] as bool?,
      updatetime: parsedTime,
      liked: listingJson['liked'] as bool?,
      wantPush: listingJson['wantPush'] as bool?,
    );
  }

  // Method to convert a list of snapshots to a list of Matvarer objects
  static List<Matvarer> matvarerFromSnapShot(List snapshot) {
    return snapshot.map((data) {
      return Matvarer.fromJson(data);
    }).toList();
  }

  // Convert Matvarer object to JSON
  Map<String, dynamic> toJson() {
    return {
      'matId': matId,
      'name': name,
      'imgUrl': imgUrls,
      'description': description,
      'price': price,
      'kategorier': kategorier,
      'lat': lat,
      'lng': lng,
      'betaling': betaling,
      'kg': kg,
      'uid': uid,
      'username': username,
      'bonde': bonde,
      'antall': antall,
      'profilepic': profilepic,
      'kjopt': kjopt,
      'updatetime': updatetime
          ?.toIso8601String(), // Convert DateTime to ISO string for JSON
      'liked': liked,
      'wantPush': wantPush,
    };
  }

  @override
  String toString() {
    return 'Matvarer {'
        'matId: $matId, '
        'name: $name, '
        'imgUrls: $imgUrls, '
        'description: $description, '
        'price: $price, '
        'kategorier: $kategorier, '
        'lat: $lat, '
        'lng: $lng, '
        'betaling: $betaling, '
        'kg: $kg, '
        'uid: $uid, '
        'username: $username, '
        'bonde: $bonde, '
        'antall: $antall, '
        'profilepic: $profilepic, '
        'kjopt: $kjopt, '
        'updatetime: $updatetime, '
        'liked: $liked, '
        'wantPush: $wantPush'
        '}';
  }
}

class OrdreInfo {
  final int id;
  final String kjoper;
  final String selger;
  final int matId;
  final int antall;
  final int pris;
  final DateTime time;
  final DateTime? godkjenttid;
  final DateTime? updatetime;
  final bool? hentet;
  final bool? godkjent;
  final bool? trekt;
  final bool? avvist;
  final String? kjoperProfilePic;
  final String? kjoperUsername;
  final String? selgerUsername;
  final Matvarer foodDetails;
  final bool? kjopte;
  final bool? rated;

  OrdreInfo({
    required this.id,
    required this.kjoper,
    required this.selger,
    required this.matId,
    required this.antall,
    required this.pris,
    required this.time,
    this.godkjenttid,
    required this.updatetime,
    required this.hentet,
    required this.godkjent,
    required this.trekt,
    required this.avvist,
    required this.kjoperProfilePic,
    required this.kjoperUsername,
    required this.selgerUsername,
    required this.foodDetails,
    required this.kjopte,
    required this.rated,
  });

  // Convert OrdreInfo from JSON
  factory OrdreInfo.fromJson(Map<String, dynamic> json) {
    return OrdreInfo(
      id: json['id'] as int,
      kjoper: json['kjoper'] as String,
      selger: json['selger'] as String,
      matId: json['matId'] as int,
      antall: json['antall'] as int,
      pris: json['pris'] as int,
      time: DateTime.parse(json['time']),
      godkjenttid: json['godkjenttid'] != null
          ? DateTime.parse(json['godkjenttid'])
          : null,
      updatetime: DateTime.parse(json['updatetime']),
      hentet: json['hentet'] as bool?,
      godkjent: json['godkjent'] as bool?,
      trekt: json['trekt'] as bool?,
      avvist: json['avvist'] as bool?,
      kjoperProfilePic: json['kjoperProfilePic'] as String?,
      kjoperUsername: json['kjoperUsername'] as String?,
      selgerUsername: json['selgerUsername'] as String?,
      foodDetails: Matvarer.fromJson(json['foodDetails']),
      kjopte: json['kjopte'] as bool?,
      rated: json['rated'] as bool?,
    );
  }

  // Convert OrdreInfo to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kjoper': kjoper,
      'selger': selger,
      'matId': matId,
      'antall': antall,
      'pris': pris,
      'time': time.toIso8601String(),
      'godkjenttid': godkjenttid?.toIso8601String(),
      'updatetime': updatetime?.toIso8601String(),
      'hentet': hentet,
      'godkjent': godkjent,
      'trekt': trekt,
      'avvist': avvist,
      'kjoperProfilePic': kjoperProfilePic,
      'kjoperUsername': kjoperUsername,
      'selgerUsername': selgerUsername,
      'foodDetails': foodDetails.toJson(),
      'kjopte': kjopte,
      'rated': rated,
    };
  }
}
