class StatusModel {
  final String userId;
  final String userName;
  final String mediaUrl;
  final String mediaType;
  final String createdAt;

  StatusModel({
    required this.userId,
    required this.userName,
    required this.mediaUrl,
    required this.mediaType,
    required this.createdAt,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      userId: json['user_id'],
      userName: json['user_name'],
      mediaUrl: json['media_url'],
      mediaType: json['media_type'],
      createdAt: json['created_at'],
    );
  }
}
