import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final response = await supabase.from('users').select()
        .eq('id', user.id)
        .single();
    if (response != null) {
      setState(() {
        _nameController.text = response['name'] ?? '';
        _aboutController.text = response['about'] ?? '';
        _emailController.text = response['email'] ?? '';
        _phoneController.text = response['phonenumber'] ?? '';
        _profileImageUrl = response['profileimage'];
      });
    }
  }

  Future<void> _updateProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await supabase.from('users').update({
      'name': _nameController.text,
      'about': _aboutController.text,
      'email': _emailController.text,
      'phonenumber': _phoneController.text,
      'profileimage': _profileImageUrl,
    }).eq('id', user.id);
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final File file = File(pickedFile.path);
    final String fileName = '${supabase.auth.currentUser!.id}-${DateTime
        .now()
        .millisecondsSinceEpoch}${extension(file.path)}';
    final String path = 'profile_images/$fileName';

    try {
      // Upload file with upsert option
      await supabase.storage.from('profiles').uploadBinary(
          path, await file.readAsBytes(),
          fileOptions: FileOptions(upsert: true));

      // Get public URL
      final String imageUrl = supabase.storage.from('profiles').getPublicUrl(
          path);

      // Update in the database
      await supabase.from('users').update({'profileimage': imageUrl}).eq(
          'id', supabase.auth.currentUser!.id);

      setState(() {
        _profileImageUrl = imageUrl;
      });

      print('Profile image updated successfully!');
    } catch (e) {
      print('Upload failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Prevents bottom overflow
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity, // Ensures full width
        height: double.infinity,
        color: Colors.blueAccent, // Background to ensure visibility
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView( // Makes the UI scrollable when the keyboard appears
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _pickAndUploadImage,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage:
                    _profileImageUrl != null
                        ? NetworkImage(_profileImageUrl!)
                        : null,
                    child: _profileImageUrl == null
                        ? Icon(Icons.camera_alt, size: 40, color: Colors.white)
                        : null,
                  ),
                ),
                SizedBox(height: 20),
                _buildTextField(_nameController, "User Name", Icons.person),
                SizedBox(height: 15),
                _buildTextField(
                    _aboutController, "About", Icons.info_outline, maxLines: 3),
                SizedBox(height: 15),
                _buildTextField(_emailController, "Email", Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress),
                SizedBox(height: 15),
                _buildTextField(_phoneController, "Phone Number", Icons.phone,
                    keyboardType: TextInputType.phone),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // White button
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Save Changes",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper function to create a styled TextField
  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white54),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white),
        ),
        prefixIcon: Icon(icon, color: Colors.white),
      ),
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
    );
  }
}
