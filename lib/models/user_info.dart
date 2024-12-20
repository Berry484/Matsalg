class UserInfo {
  final String username;
  final String uid;
  final String firstname;
  final String lastname;
  final String profilepic;
  bool following;

  UserInfo({
    required this.uid,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.profilepic,
    required this.following,
  });
}
