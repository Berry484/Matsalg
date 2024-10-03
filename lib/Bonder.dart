class Bonder {
  final String? username;
  final String? firstname;
  final String? lastname;
  final String? profilepic;
  final String? email;
  final String? bio; // Added field to match API response
  final String? phoneNumber; // CamelCase to match API's "phoneNumber"
  final double? lat;
  final double? lng;
  final bool? bonde;
  final String? gardsnavn;

  Bonder({
    this.username,
    this.firstname,
    this.lastname,
    this.profilepic,
    this.email,
    this.bio,
    this.phoneNumber,
    this.lat,
    this.lng,
    this.bonde,
    this.gardsnavn,
  });

  // Factory constructor to create Bonder object from JSON
  factory Bonder.fromJson(Map<String, dynamic>? json) {
    return Bonder(
      username: json?['username'] as String?,
      firstname: json?['firstname'] as String?,
      lastname: json?['lastname'] as String?,
      profilepic: json?['profilepic'] as String?,
      email: json?['email'] as String?,
      bio: json?['bio'] as String?, // Added bio field
      phoneNumber: json?['phoneNumber'] as String?, // Matched "phoneNumber"
      lat: json?['lat'] as double?,
      lng: json?['lng'] as double?,
      bonde: json?['bonde'] as bool?,
      gardsnavn: json?['gardsnavn'] as String?,
    );
  }

  // Static method to create a list of Bonder objects from a list of JSON data
  static List<Bonder> bonderFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Bonder.fromJson(data);
    }).toList();
  }

  // Convert Bonder object to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
      'profilepic': profilepic,
      'email': email,
      'bio': bio, // Bio added to JSON output
      'phoneNumber': phoneNumber, // Matches API's "phoneNumber"
      'lat': lat,
      'lng': lng,
      'bonde': bonde,
      'gardsnavn': gardsnavn,
    };
  }

  @override
  String toString() {
    return 'Bonder {'
        'username: $username, '
        'firstname: $firstname, '
        'lastname: $lastname, '
        'profilepic: $profilepic, '
        'email: $email, '
        'bio: $bio, ' // Reflects the "bio" field
        'phoneNumber: $phoneNumber, ' // Updated to camelCase
        'lat: $lat, '
        'lng: $lng, '
        'bonde: $bonde, '
        'gardsnavn: $gardsnavn'
        '}';
  }
}
