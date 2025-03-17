import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class GroupSettingsPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String? groupImageUrl;

  GroupSettingsPage({required this.groupId, required this.groupName, this.groupImageUrl});

  @override
  _GroupSettingsPageState createState() => _GroupSettingsPageState();
}

class _GroupSettingsPageState extends State<GroupSettingsPage> {
  final TextEditingController _nameController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.groupName;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateGroup() async {
    String? imageUrl = widget.groupImageUrl;

    if (_imageFile != null) {
      final imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageResponse = await supabase.storage.from('group_images').upload(imageName, _imageFile!);
      imageUrl = supabase.storage.from('group_images').getPublicUrl(imageName);
    }

    await supabase.from('groups').update({
      'name': _nameController.text,
      'image_url': imageUrl,
    }).eq('id', widget.groupId);

    Navigator.pop(context);
  }

  Future<void> _leaveGroup() async {
    await supabase.from('group_members').delete().match({
      'group_id': widget.groupId,
      'user_id': supabase.auth.currentUser!.id,
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Group Settings'),
      backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.blueAccent  ,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!)
                    : (widget.groupImageUrl != null ? NetworkImage(widget.groupImageUrl!) : null),
                child: _imageFile == null && widget.groupImageUrl == null ? Icon(Icons.camera_alt, size: 30) : null,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Group Name'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateGroup,
              child: Text('Save Changes'),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: _leaveGroup,
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text('Leave Group'),
            ),
          ],
        ),
      ),
    );
  }
}
