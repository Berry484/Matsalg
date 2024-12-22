//---------------------------------------------------------------------------------------------------------------
//--------------------Hold basic information about a user and its rating summary---------------------------------
//---------------------------------------------------------------------------------------------------------------
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
