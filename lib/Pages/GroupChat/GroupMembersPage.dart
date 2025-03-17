import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class GroupMembersPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminId;
  final String groupImageUrl;

  GroupMembersPage({
    required this.groupId,
    required this.groupName,
    required this.adminId,
    required this.groupImageUrl,
  });

  @override
  _GroupMembersPageState createState() => _GroupMembersPageState();
}

class _GroupMembersPageState extends State<GroupMembersPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  String currentUserId = Supabase.instance.client.auth.currentUser!.id;
  final ImagePicker _picker = ImagePicker();

  Future<List<Map<String, dynamic>>> _fetchMembers() async {
    return await supabase
        .from('group_members')
        .select('user_id, users(username, avatar_url)')
        .eq('group_id', widget.groupId);
  }

  Future<void> _addMember(String userId) async {
    await supabase.from('group_members').insert({
      'group_id': widget.groupId,
      'user_id': userId,
    });
    setState(() {});
  }

  Future<void> _removeMember(String userId) async {
    await supabase.from('group_members').delete().match({
      'group_id': widget.groupId,
      'user_id': userId,
    });
    setState(() {});
  }

  Future<void> _deleteGroup() async {
    await supabase.from('group_messages').delete().match({'group_id': widget.groupId});
    await supabase.from('group_members').delete().match({'group_id': widget.groupId});
    await supabase.from('groups').delete().match({'id': widget.groupId});
    Navigator.pop(context);
  }

  Future<void> _uploadGroupImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    String filePath = 'grouppictures/${widget.groupId}.jpg'; // Use groupId for unique filename

    final File file = File(pickedFile.path);

    await supabase.storage.from('grouppictures').upload(filePath, file);
    final String publicUrl = supabase.storage.from('grouppictures').getPublicUrl(filePath);

    await supabase.from('groups').update({'group_image': publicUrl}).eq('id', widget.groupId);
    setState(() {});
  }

  void _showAddMemberDialog() {
    TextEditingController userIdController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Member'),
        content: TextField(
          controller: userIdController,
          decoration: InputDecoration(labelText: 'Enter User ID'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _addMember(userIdController.text);
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showDeleteGroupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Group'),
        content: Text('Are you sure you want to delete this group? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteGroup();
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Members'),
        actions: widget.adminId == currentUserId
            ? [
          IconButton(
            icon: Icon(Icons.image, color: Colors.blue),
            onPressed: _uploadGroupImage,
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: _showDeleteGroupDialog,
          )
        ]
            : null,
      ),
      body: FutureBuilder(
        future: _fetchMembers(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final members = snapshot.data!;

          return ListView.builder(
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              final isAdmin = widget.adminId == member['user_id'];
              final isCurrentUserAdmin = widget.adminId == currentUserId;

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: member['users']['avatar_url'] != null
                      ? NetworkImage(member['users']['avatar_url'])
                      : null,
                  child: member['users']['avatar_url'] == null ? Icon(Icons.person) : null,
                ),
                title: Text(member['users']['username']),
                subtitle: isAdmin ? Text('Admin', style: TextStyle(color: Colors.green)) : null,
                trailing: isCurrentUserAdmin && !isAdmin
                    ? IconButton(
                  icon: Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () => _removeMember(member['user_id']),
                )
                    : null,
              );
            },
          );
        },
      ),
      floatingActionButton: widget.adminId == currentUserId
          ? FloatingActionButton(
        onPressed: _showAddMemberDialog,
        child: Icon(Icons.person_add),
      )
          : null,
    );
  }
}
