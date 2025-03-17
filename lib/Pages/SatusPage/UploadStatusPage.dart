import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chatnova/Controller/StatusController.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class UploadStatusPage extends StatefulWidget {
  @override
  _UploadStatusPageState createState() => _UploadStatusPageState();
}

class _UploadStatusPageState extends State<UploadStatusPage> {
  File? _selectedFile;
  String? _mediaType;
  bool _isUploading = false;

  final StatusController statusController = Get.find<StatusController>();

  // ✅ Pick Image or Video from Gallery or Camera
  Future<void> _pickMedia(ImageSource source, bool isVideo) async {
    final picker = ImagePicker();
    final pickedFile = isVideo
        ? await picker.pickVideo(source: source)
        : await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
        _mediaType = isVideo ? "video" : "image";
      });
    }
  }

  // ✅ Upload Media to Supabase Storage and Save in Database
  Future<void> _uploadStatus() async {
    if (_selectedFile == null || _mediaType == null) {
      Get.snackbar("Error", "Please select an image or video.");
      return;
    }

    setState(() => _isUploading = true);

    try {
      final fileExt = _mediaType == 'image' ? 'jpg' : 'mp4';
      final fileName = "${DateTime.now().millisecondsSinceEpoch}.$fileExt";

      // ✅ Upload file to Supabase Storage (Bucket: status)
      await Supabase.instance.client.storage
          .from('status') // ✅ Corrected bucket name
          .upload(fileName, _selectedFile!);

      // ✅ Get the public URL of the uploaded file
      final mediaUrl = Supabase.instance.client.storage
          .from('status') // ✅ Corrected bucket name
          .getPublicUrl(fileName);

      print("Uploaded File URL: $mediaUrl"); // Debugging ✅

      // ✅ Save status in database (Table: status_updates)
      await statusController.uploadStatus(mediaUrl, _mediaType!);

      setState(() {
        _selectedFile = null;
        _isUploading = false;
      });

      Get.snackbar("Success", "Status uploaded!");
    } catch (error) {
      setState(() => _isUploading = false);
      Get.snackbar("Upload Failed", error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent, // ✅ Set background color
      appBar: AppBar(
        title: const Text("Upload Status"),
        backgroundColor: Colors.blueAccent, // Darker shade for contrast
      ),
      body: Stack(
        children: [
          Center( // ✅ Center everything
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // ✅ Prevent extra space
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ✅ Preview of Selected Media
                  if (_selectedFile != null)
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            _mediaType == "image"
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(_selectedFile!,
                                  height: 200, fit: BoxFit.cover),
                            )
                                : const Icon(Icons.video_library,
                                size: 100, color: Colors.blueAccent),
                            const SizedBox(height: 10),
                            Text(
                              _mediaType == "image"
                                  ? "Selected Image"
                                  : "Selected Video",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // ✅ Centered Upload Button
                  ElevatedButton(
                    onPressed: _isUploading ? null : _uploadStatus,
                    style: ElevatedButton.styleFrom(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isUploading
                        ? const CircularProgressIndicator(color: Colors.blue)
                        : const Text("Upload Status",
                        style: TextStyle(fontSize: 16, color: Colors.blue)),
                  ),
                ],
              ),
            ),
          ),

          // ✅ Uploading Overlay
          if (_isUploading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),


      // ✅ Floating Action Button (Speed Dial)
      floatingActionButton: SpeedDial(
        icon: Icons.add, // ✅ Default icon (Plus)
        activeIcon: Icons.close, // ✅ Icon when opened
        iconTheme: const IconThemeData(color: Colors.black), // ✅ Black icon color
        backgroundColor: Colors.white, // ✅ White background
        overlayColor: Colors.black,
        overlayOpacity: 0.3, // ✅ Slight transparent overlay
        spacing: 12,
        spaceBetweenChildren: 8,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.image, color: Colors.white),
            backgroundColor: Colors.blue,
            label: "Pick Image",
            shape: const CircleBorder(),
            onTap: () => _pickMedia(ImageSource.gallery, false),
          ),
          SpeedDialChild(
            child: const Icon(Icons.video_library, color: Colors.white),
            backgroundColor: Colors.blue,
            label: "Pick Video",
            shape: const CircleBorder(),
            onTap: () => _pickMedia(ImageSource.gallery, true),
          ),
          SpeedDialChild(
            child: const Icon(Icons.camera_alt, color: Colors.white),
            backgroundColor: Colors.green,
            label: "Take Photo",
            shape: const CircleBorder(),
            onTap: () => _pickMedia(ImageSource.camera, false),
          ),
          SpeedDialChild(
            child: const Icon(Icons.videocam, color: Colors.white),
            backgroundColor: Colors.green,
            label: "Record Video",
            shape: const CircleBorder(),
            onTap: () => _pickMedia(ImageSource.camera, true),
          ),
        ],
      ),

    );
  }
}
