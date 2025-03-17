import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateGroupPage extends StatefulWidget {
  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final TextEditingController _groupNameController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;
  File? _imageFile;
  List<Map<String, dynamic>> _users = [];
  List<String> _selectedUserIds = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  /// Fetch list of users (excluding the current user)
  Future<void> _fetchUsers() async {
    final currentUserId = supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      print("User is not authenticated");
      return;
    }

    try {
      final response = await supabase.from('users').select('id, email').neq('id', currentUserId);
      print("Fetched users: $response");

      setState(() {
        _users = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  /// Picks an image from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  /// Uploads group image to Supabase Storage and returns the public URL
  Future<String?> _uploadGroupImage(File imageFile, String groupId) async {
    try {
      final filePath = 'group_pictures/$groupId.jpg';
      await supabase.storage.from('grouppictures').upload(filePath, imageFile);
      final imageUrl = supabase.storage.from('grouppictures').getPublicUrl(filePath);
      print("Image uploaded successfully: $imageUrl");
      return imageUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  /// Creates a new group and adds selected members
  Future<void> _createGroup() async {
    if (_groupNameController.text.isEmpty || _selectedUserIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a group name and select users.')),
      );
      return;
    }

    final currentUserId = supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      print("No authenticated user found");
      return;
    }

    String? imageUrl;
    if (_imageFile != null) {
      imageUrl = await _uploadGroupImage(_imageFile!, currentUserId);
    }

    try {
      final groupResponse = await supabase.from('groups').insert({
        'name': _groupNameController.text,
        'image_url': imageUrl,
        'created_by': currentUserId,
      }).select('id').single();

      if (groupResponse == null) {
        print("Failed to create group");
        return;
      }

      final groupId = groupResponse['id'];
      print("Group created successfully: $groupId");

      List<Map<String, dynamic>> members = _selectedUserIds
          .map((userId) => {'group_id': groupId, 'user_id': userId})
          .toList();

      members.add({'group_id': groupId, 'user_id': currentUserId});

      final memberResponse = await supabase.from('group_members').insert(members);
      print("Members added successfully: $memberResponse");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Group created successfully!')),
      );

      Navigator.pop(context);
    } catch (e) {
      print("Error creating group: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create group. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group'),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.blueAccent,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                child: _imageFile == null ? Icon(Icons.camera_alt) : null,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _groupNameController,
              decoration: InputDecoration(hintText: 'Enter group name'),
            ),
            SizedBox(height: 10),
            Expanded(
              child: _users.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return CheckboxListTile(
                    title: Text(user['email']),
                    value: _selectedUserIds.contains(user['id']),
                    onChanged: (bool? selected) {
                      setState(() {
                        if (selected == true) {
                          _selectedUserIds.add(user['id']);
                        } else {
                          _selectedUserIds.remove(user['id']);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _createGroup,
              child: Text('Create Group'),
            ),
          ],
        ),
      ),
    );
  }
}
