import 'package:chatnova/Model/GroupModel.dart';
import 'package:chatnova/Model/UserModel.dart';
import 'package:chatnova/Model/MessageModel.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GroupController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  var groupList = <GroupModel>[].obs; // List of groups
  var userList = <UserModel>[].obs; // Users available for selection
  var groupMessages = <MessageModel>[].obs; // Messages for a group

  @override
  void onInit() {
    super.onInit();
    fetchGroups();
    fetchUsers(); // Fetch users for selection
    _subscribeToGroupUpdates();
  }

  /// ✅ Fetch all users for group selection
  Future<void> fetchUsers() async {
    final response = await supabase.from('users').select('id, name, profile_image');

    if (response.isNotEmpty) {
      userList.value = response.map((user) => UserModel.fromJson(user)).toList();
    }
  }

  /// ✅ Fetch all groups
  Future<void> fetchGroups() async {
    final response = await supabase
        .from('groups')
        .select('id, name, image_url, members, created_at, created_by');

    if (response.isNotEmpty) {
      groupList.value = response.map((group) => GroupModel.fromJson(group)).toList();
    }
  }

  /// ✅ Create a new group
  Future<void> createGroup(String groupName, List<String> selectedMembers) async {
    final currentUserId = supabase.auth.currentUser?.id;
    if (currentUserId == null) return;

    final response = await supabase.from('groups').insert({
      'name': groupName,
      'image_url': "https://your-default-image-url.com/default.png",
      'members': [...selectedMembers, currentUserId], // Add creator
      'created_by': currentUserId,
      'created_at': DateTime.now().toIso8601String(),
    });

    if (response != null) {
      fetchGroups();
      Get.back();
      Get.snackbar("Success", "Group created successfully!");
    }
  }

  /// ✅ Add members to a group
  Future<void> addMemberToGroup(String groupId, List<String> newMembers) async {
    final response = await supabase.from('groups').select('members').eq('id', groupId).single();
    if (response == null) return;

    List<String> currentMembers = List<String>.from(response['members']);
    List<String> updatedMembers = [...currentMembers, ...newMembers];

    await supabase.from('groups').update({'members': updatedMembers}).eq('id', groupId);
    fetchGroups();
  }

  /// ✅ Fetch group messages
  Future<void> fetchGroupMessages(String groupId) async {
    final response = await supabase
        .from('group_messages')
        .select()
        .eq('group_id', groupId)
        .order('timestamp', ascending: true);

    if (response.isNotEmpty) {
      groupMessages.value = response.map((msg) => MessageModel.fromJson(msg)).toList();
    }
  }

  /// ✅ Send a message in a group
  Future<void> sendMessage(String groupId, String senderId, String senderName, String text) async {
    await supabase.from('group_messages').insert({
      'group_id': groupId,
      'sender_id': senderId,
      'sender_name': senderName,
      'text': text,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// ✅ Subscribe to real-time updates for groups
  void _subscribeToGroupUpdates() {
    supabase.from('groups').stream(primaryKey: ['id']).listen((data) {
      fetchGroups();
    });

    supabase.from('group_messages').stream(primaryKey: ['id']).listen((data) {
      if (data.isNotEmpty) {
        fetchGroupMessages(data.first['group_id']);
      }
    });
  }
}
