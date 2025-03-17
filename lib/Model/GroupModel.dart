class GroupModel {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> members;
  final String createdBy;
  final DateTime createdAt;

  GroupModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.members,
    required this.createdBy,
    required this.createdAt,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'] ?? "https://your-default-image-url.com/default.png",
      members: List<String>.from(json['members'] ?? []),
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'members': members,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
