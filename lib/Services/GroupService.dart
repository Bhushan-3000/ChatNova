import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chatnova/Model/GroupModel.dart';

class GroupService {
  static final SupabaseClient db = Supabase.instance.client;

  // Fetch all groups the user is part of
  static Future<List<GroupModel>> getGroups(String userId) async {
    final response = await db
        .from('groups')
        .select()
        .contains('members', [userId]) // Fetch groups where the user is a member
        .order('created_at', ascending: false);

    if (response.isEmpty) return [];
    return response.map((group) => GroupModel.fromJson(group)).toList();
  }

  // Create a new group
  static Future<GroupModel?> createGroup(String name, String image, List<String> members, String createdBy) async {
    final newGroup = {
      'name': name,
      'image': image,
      'members': members,
      'created_by': createdBy,
      'created_at': DateTime.now().toIso8601String(),
    };

    final response = await db.from('groups').insert(newGroup).select().single();

    if (response == null) return null;
    return GroupModel.fromJson(response);
  }

  // Send a message in a group
  static Future<void> sendMessage(String groupId, String senderId, String senderName, String text) async {
    await db.from('group_messages').insert({
      'group_id': groupId,
      'sender_id': senderId,
      'sender_name': senderName,
      'text': text,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  // Get messages for a specific group
  static Stream<List<Map<String, dynamic>>> getGroupMessages(String groupId) {
    return db
        .from('group_messages')
        .stream(primaryKey: ['id'])
        .eq('group_id', groupId)
        .order('created_at', ascending: true);
  }
}
