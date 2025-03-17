import 'dart:convert';

class ChatModel {
  String id;
  String message;
  String senderName;
  String senderId;
  String receiverId;
  DateTime timestamp;
  bool readStatus;
  String? imageUrl;
  String? videoUrl;
  String? audioUrl;
  String? documentUrl;
  List<String>? reactions; // List of reaction emojis or user IDs
  List<ChatModel>? replies; // Nested replies

  ChatModel({
    required this.id,
    required this.message,
    required this.senderName,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
    required this.readStatus,
    this.imageUrl,
    this.videoUrl,
    this.audioUrl,
    this.documentUrl,
    this.reactions,
    this.replies,
  });

  // ✅ Add copyWith method for updating specific fields
  ChatModel copyWith({
    String? id,
    String? message,
    String? senderName,
    String? senderId,
    String? receiverId,
    DateTime? timestamp,
    bool? readStatus,
    String? imageUrl,
    String? videoUrl,
    String? audioUrl,
    String? documentUrl,
    List<String>? reactions,
    List<ChatModel>? replies,
  }) {
    return ChatModel(
      id: id ?? this.id,
      message: message ?? this.message,
      senderName: senderName ?? this.senderName,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      timestamp: timestamp ?? this.timestamp,
      readStatus: readStatus ?? this.readStatus,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      documentUrl: documentUrl ?? this.documentUrl,
      reactions: reactions ?? this.reactions,
      replies: replies ?? this.replies,
    );
  }

  // Convert a ChatModel object to a Map (for JSON encoding)
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "message": message,
      "sender_name": senderName, // Matches database column name
      "sender_id": senderId, // Matches database column name
      "receiver_id": receiverId, // Matches database column name
      "timestamp": timestamp.toIso8601String(),
      "read_status": readStatus,
      "image_url": imageUrl,
      "video_url": videoUrl,
      "audio_url": audioUrl,
      "document_url": documentUrl,
      "reactions": reactions ?? [],
      "replies": replies?.map((reply) => reply.toJson()).toList() ?? [],
    };
  }

  // Create a ChatModel from a Map (for JSON decoding)
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json["id"] ?? "",
      message: json["message"] ?? "",
      senderName: json["sender_name"] ?? "",
      senderId: json["sender_id"] ?? "",
      receiverId: json["receiver_id"] ?? "",
      timestamp: DateTime.tryParse(json["timestamp"] ?? "") ?? DateTime.now(),
      readStatus: json["read_status"] ?? false,
      imageUrl: json["image_url"],
      videoUrl: json["video_url"],
      audioUrl: json["audio_url"],
      documentUrl: json["document_url"],
      reactions: List<String>.from(json["reactions"] ?? []),
      replies: json["replies"] != null
          ? (json["replies"] as List)
          .map((reply) => ChatModel.fromJson(reply))
          .toList()
          : [],
    );
  }

  // Convert JSON string to ChatModel object
  static ChatModel fromJsonString(String jsonString) {
    return ChatModel.fromJson(json.decode(jsonString));
  }

  // Convert ChatModel object to JSON string
  String toJsonString() {
    return json.encode(toJson());
  }
}
