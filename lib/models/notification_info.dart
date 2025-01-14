//---------------------------------------------------------------------------------------------------------------
//--------------------Hold basic information about a notification the user got-----------------------------------
//---------------------------------------------------------------------------------------------------------------
class NotificationInfo {
  final String sender;
  final String receiver;
  final String? username;
  final String? profilepic;
  final String? productImage;
  final int? matId;
  final String type;
  final DateTime time;

  NotificationInfo({
    required this.sender,
    required this.receiver,
    required this.username,
    required this.profilepic,
    required this.productImage,
    required this.matId,
    required this.type,
    required this.time,
  });
}
