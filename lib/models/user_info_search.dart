//---------------------------------------------------------------------------------------------------------------
//--------------------Hold basic information about a user used when searching for users on the main page---------
//---------------------------------------------------------------------------------------------------------------
class UserInfoSearch {
  final String uid;
  final String username;
  final String firstname;
  final String lastname;
  final String profilepic;

  UserInfoSearch({
    required this.uid,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.profilepic,
  });
}
