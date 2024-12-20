class UserInfoRating {
  final String username;
  final String? profilepic;
  final int value;
  bool? kjoper;
  final DateTime time;

  UserInfoRating({
    required this.username,
    this.profilepic, // Optional
    required this.value,
    required this.kjoper,
    required this.time,
  });
}
