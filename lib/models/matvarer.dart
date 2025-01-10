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
  final DateTime? updatetime;
  final bool? liked;
  final bool? wantPush;
  final bool? accuratePosition;
  final String? lastactive;

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
    this.updatetime,
    this.liked,
    this.wantPush,
    this.accuratePosition,
    this.lastactive,
  });

  factory Matvarer.fromJson1(Map<String, dynamic>? json) {
    DateTime? parsedTime;
    if (json?['updatetime'] != null) {
      parsedTime = DateTime.tryParse(json?['updatetime']);
    }

    return Matvarer(
      matId: json?['matId'] as int?,
      name: json?['name'] as String? ?? "",
      imgUrls: (json?['imgUrl'] != null && json?['imgUrl'] is List)
          ? List<String>.from(json?['imgUrl']?.whereType<String>() ?? [])
          : [],
      description: json?['description'] as String? ?? "",
      price: json?['price'] as int?,
      kategorier: (json?['kategorier'] != null && json?['kategorier'] is List)
          ? List<String>.from(json?['kategorier'])
          : null,
      lat: json?['lat'] as double?,
      lng: json?['lng'] as double?,
      betaling: json?['betaling'] as bool?,
      kg: json?['kg'] as bool?,
      // Getting the username and profilepic from the 'user' field inside 'listing'
      username: json?['username'] as String? ?? "",
      uid: json?['uid'] as String? ?? "",
      bonde: json?['bonde'] as bool?,
      antall: json?['antall'] as int?,
      profilepic: json?['profilepic'] as String? ?? "",
      kjopt: json?['kjopt'] as bool?,
      accuratePosition: json?['accuratePosition'] as bool? ?? false,
      updatetime: parsedTime,
      liked: json?['liked'] as bool?,
      wantPush: json?['wantPush'] as bool?,
      lastactive: json?['lastactive'] as String? ?? "",
    );
  }

  factory Matvarer.fromJson(Map<String, dynamic>? json) {
    DateTime? parsedTime;
    if (json?['updatetime'] != null) {
      parsedTime = DateTime.tryParse(json?['updatetime']);
    }

    Map<String, dynamic> userJson = json?['user'] ?? {};
    return Matvarer(
      matId: json?['matId'] as int?,
      name: json?['name'] as String? ?? "",
      imgUrls: (json?['imgUrl'] != null && json?['imgUrl'] is List)
          ? List<String>.from(json?['imgUrl']?.whereType<String>() ?? [])
          : [],
      description: json?['description'] as String? ?? "",
      price: json?['price'] as int?,
      kategorier: (json?['kategorier'] != null && json?['kategorier'] is List)
          ? List<String>.from(json?['kategorier'])
          : null,
      lat: json?['lat'] as double?,
      lng: json?['lng'] as double?,
      betaling: json?['betaling'] as bool?,
      kg: json?['kg'] as bool?,
      username: userJson['username'] as String? ?? "",
      lastactive: userJson['lastactive'] as String? ?? "",
      uid: json?['uid'] as String? ?? "",
      bonde: userJson['bonde'] as bool?,
      antall: json?['antall'] as int?,
      profilepic: userJson['profilepic'] as String? ?? "",
      kjopt: json?['kjopt'] as bool?,
      accuratePosition: json?['accuratePosition'] as bool? ?? false,
      updatetime: parsedTime,
      liked: json?['liked'] as bool?,
      wantPush: json?['wantPush'] as bool?,
    );
  }

  static List<Matvarer> matvarerFromSnapShot(List snapshot) {
    return snapshot.map((data) {
      return Matvarer.fromJson(data);
    }).toList();
  }

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
      'lastactive': lastactive,
      'bonde': bonde,
      'antall': antall,
      'profilepic': profilepic,
      'kjopt': kjopt,
      'accuratePosition': accuratePosition,
      'updatetime': updatetime?.toIso8601String(),
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
        'lastactive: $lastactive, '
        'bonde: $bonde, '
        'antall: $antall, '
        'profilepic: $profilepic, '
        'kjopt: $kjopt, '
        'accuratePosition: $accuratePosition, '
        'updatetime: $updatetime, '
        'liked: $liked, '
        'wantPush: $wantPush'
        '}';
  }
}
