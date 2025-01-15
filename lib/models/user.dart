//---------------------------------------------------------------------------------------------------------------
//--------------------Hold a lot of information about a user-----------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
class User {
  final String? username;
  final String? uid;
  final String? firstname;
  final String? lastname;
  final String? profilepic;
  final String? email;
  final String? bio;
  final String? phoneNumber;
  final double? lat;
  final double? lng;
  final DateTime? time;
  final String? lastactive;

  // New fields for data outside userInfo
  final bool? isFollowing;
  final bool? getPush;
  final int? followersCount;
  final int? followingCount;
  final int? ratingTotalCount;
  final double? ratingAverageValue;

  User({
    // Fields for userInfo
    this.username,
    this.uid,
    this.firstname,
    this.lastname,
    this.profilepic,
    this.email,
    this.bio,
    this.phoneNumber,
    this.lat,
    this.lng,
    this.time,
    this.lastactive,

    // New fields
    this.getPush,
    this.isFollowing,
    this.followersCount,
    this.followingCount,
    this.ratingTotalCount,
    this.ratingAverageValue,
  });

  factory User.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) {
      throw const FormatException('Empty or null response');
    }

    // Extracting userInfo
    final userInfo = json['userInfo'] ?? {};

    DateTime? parsedTime;
    if (userInfo['time'] != null) {
      parsedTime = DateTime.tryParse(userInfo['time']);
    }

    return User(
      // Fields from userInfo

      username: userInfo['username'] as String?,
      uid: userInfo['uid'] as String?,
      firstname: userInfo['firstname'] as String?,
      lastname: userInfo['lastname'] as String?,
      profilepic: userInfo['profilepic'] as String?,
      email: userInfo['email'] as String?,
      bio: userInfo['bio'] as String?,
      phoneNumber: userInfo['phoneNumber'] as String?,
      lat: userInfo['lat'] as double?,
      lng: userInfo['lng'] as double?,
      lastactive: userInfo['lastactive'] as String?,
      time: parsedTime,

      // New fields outside userInfo
      getPush: json['getPush'] as bool? ?? false,
      isFollowing: json['isFollowing'] as bool? ?? false,
      followersCount: json['followersCount'] as int? ?? 0,
      followingCount: json['followingCount'] as int? ?? 0,
      ratingTotalCount: json['ratingTotalCount'] as int? ?? 0,
      ratingAverageValue: json['ratingAverageValue'] as double? ?? 5,
    );
  }

  // Static method to create a list of User objects from a list of JSON data
  static List<User> usersFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return User.fromJson(data);
    }).toList();
  }

  // Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      // Fields from userInfo

      'username': username,
      'uid': uid,
      'firstname': firstname,
      'lastname': lastname,
      'profilepic': profilepic,
      'email': email,
      'bio': bio,
      'phoneNumber': phoneNumber,
      'lat': lat,
      'lng': lng,
      'lastactive': lastactive,
      'time': time?.toIso8601String(),

      // New fields outside userInfo
      'getPush': getPush,
      'isFollowing': isFollowing,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'ratingTotalCount': ratingTotalCount,
      'ratingAverageValue': ratingAverageValue,
    };
  }

  @override
  String toString() {
    return 'User {'
        'username: $username, '
        'uid: $uid, '
        'firstname: $firstname, '
        'lastname: $lastname, '
        'profilepic: $profilepic, '
        'email: $email, '
        'bio: $bio, '
        'phoneNumber: $phoneNumber, '
        'lat: $lat, '
        'lng: $lng, '
        'lastactive: $lastactive, '
        'time: $time, '
        'getPush: $getPush, '
        'isFollowing: $isFollowing, '
        'followersCount: $followersCount, '
        'followingCount: $followingCount, '
        'ratingTotalCount: $ratingTotalCount, '
        'ratingAverageValue: $ratingAverageValue'
        '}';
  }
}
