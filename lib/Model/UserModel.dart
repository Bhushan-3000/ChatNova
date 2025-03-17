import 'dart:convert';

class UserModel {
  String id;
  String name;
  String email;
  String profileImage;
  String phoneNumber; // Matches 'phonenumber' in the database
  String about;
  DateTime createdAt;
  DateTime lastOnline;
  String status; // e.g., "online", "offline", "busy"

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.phoneNumber,
    required this.about,
    required this.createdAt,
    required this.lastOnline,
    required this.status,
  });

  // ✅ Add copyWith method for updating specific fields
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImage,
    String? phoneNumber,
    String? about,
    DateTime? createdAt,
    DateTime? lastOnline,
    String? status,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      about: about ?? this.about,
      createdAt: createdAt ?? this.createdAt,
      lastOnline: lastOnline ?? this.lastOnline,
      status: status ?? this.status,
    );
  }

  // Convert a UserModel object to a Map (for JSON encoding)
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "profileimage": profileImage, // Matches database column name
      "phonenumber": phoneNumber,   // Matches database column name
      "about": about,
      "created_at": createdAt.toIso8601String(), // Matches database column name
      "last_online": lastOnline.toIso8601String(), // Matches database column name
      "status": status,
    };
  }

  // Create a UserModel from a Map (for JSON decoding)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      profileImage: json["profileimage"] ?? "", // Matches database column name
      phoneNumber: json["phonenumber"] ?? "",  // Matches database column name
      about: json["about"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? "") ?? DateTime.now(),
      lastOnline: DateTime.tryParse(json["last_online"] ?? "") ?? DateTime.now(),
      status: json["status"] ?? "offline",
    );
  }

  // Convert JSON string to UserModel object
  static UserModel fromJsonString(String jsonString) {
    return UserModel.fromJson(json.decode(jsonString));
  }

  // Convert UserModel object to JSON string
  String toJsonString() {
    return json.encode(toJson());
  }
}
