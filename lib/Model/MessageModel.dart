class MessageModel {
  final String senderId;
  final String senderName;
  final String text;
  final String timestamp;

  MessageModel({
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderId: json['sender_id'],
      senderName: json['sender_name'],
      text: json['text'],
      timestamp: json['timestamp'],
    );
  }
}
