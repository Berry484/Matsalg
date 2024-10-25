import 'dart:ffi';

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
  final bool? bonde;
  final double? antall;
  final String? profilepic; // This is where the profile picture will go
  final bool? kjopt;

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
    this.bonde,
    this.antall,
    this.profilepic,
    this.kjopt,
  });
  factory Matvarer.fromJson1(Map<String, dynamic> json) {
    return Matvarer(
      matId: json['matId'] as int?,
      name: json['name'] as String?,
      imgUrls: (json['imgUrl'] != null && json['imgUrl'] is List)
          ? List<String>.from(json['imgUrl'])
          : null,
      description: json['description'] as String?,
      price: json['price'] as int?,
      kategorier: (json['kategorier'] != null && json['kategorier'] is List)
          ? List<String>.from(json['kategorier'])
          : null,
      lat: json['lat'] as double?,
      lng: json['lng'] as double?,
      betaling: json['betaling'] as bool?,
      kg: json['kg'] as bool?,
      username: json['username'] as String?,
      bonde: json['bonde'] as bool?,
      antall: json['antall'] as double?,
      profilepic: json['profilepic'] as String?,
      kjopt: json['kjopt'] as bool?,
    );
  }

  factory Matvarer.fromJson(Map<String, dynamic> json) {
    return Matvarer(
      matId: json['matId'] as int?,
      name: json['name'] as String?,
      imgUrls: (json['imgUrl'] != null && json['imgUrl'] is List)
          ? List<String>.from(json['imgUrl'])
          : null,
      description: json['description'] as String?,
      price: json['price'] as int?,
      kategorier: (json['kategorier'] != null && json['kategorier'] is List)
          ? List<String>.from(json['kategorier'])
          : null,
      lat: json['lat'] as double?,
      lng: json['lng'] as double?,
      betaling: json['betaling'] as bool?,
      kg: json['kg'] as bool?,
      username: json['username'] as String?,
      bonde: json['bonde'] as bool?,
      antall: json['antall'] as double?,
      profilepic: json['user']['profilepic'] as String?,
      kjopt: json['kjopt'] as bool?,
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
      'imgUrl': imgUrls, // Ensure to convert to a list
      'description': description,
      'price': price,
      'kategorier': kategorier,
      'lat': lat,
      'lng': lng,
      'betaling': betaling,
      'kg': kg,
      'username': username,
      'bonde': bonde,
      'antall': antall,
      'profilepic': profilepic,
      'kjopt': kjopt,
    };
  }

  @override
  String toString() {
    return 'Matvarer {'
        'matId: $matId, '
        'name: $name, '
        'imgUrls: $imgUrls, ' // Adjusted to reflect the new field
        'description: $description, '
        'price: $price, '
        'kategorier: $kategorier, '
        'lat: $lat, '
        'lng: $lng, '
        'betaling: $betaling, '
        'kg: $kg, '
        'username: $username, '
        'bonde: $bonde, '
        'antall: $antall, '
        'profilepic: $profilepic, '
        'kjopt: $kjopt'
        '}';
  }
}
