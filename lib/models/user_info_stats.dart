//---------------------------------------------------------------------------------------------------------------
//--------------------Hold basic information about a users average rating value and how many ratings he has------
//---------------------------------------------------------------------------------------------------------------
class UserInfoStats {
  final int? totalCount;
  final double? averageValue;

  UserInfoStats({
    required this.totalCount,
    required this.averageValue,
  });
}
