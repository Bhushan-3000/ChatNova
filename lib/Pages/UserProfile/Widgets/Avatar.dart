import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Avatar extends StatelessWidget {

   Avatar({super.key, required this.imageUrl, required this.onUpload});
  final auth = Supabase.instance.client.auth;
   final db = Supabase.instance.client;
  final String? imageUrl;
  final void  Function(String imageUrl) onUpload;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: imageUrl!=null ? Image.network(imageUrl!, fit: BoxFit.cover,)

              : Container(
            color: Colors.grey,
            child: const Center(
              child: Text("No Image"),
            ),

        ),
        ),
        SizedBox(height: 12,),
        ElevatedButton(onPressed: () async {
          final ImagePicker picker = ImagePicker();
          //pick an image
          XFile? image = await picker.pickImage(source: ImageSource.gallery);
          if(image == null){
            return;
          }
          final imageExtension = image.path.split('.').last.toLowerCase();
          final imageBytes = await image.readAsBytes();
          final userId = db.auth.currentUser!.id;
          final imagePath = '/$userId/profile.jpg';
          await db.storage.from('profiles').uploadBinary( imagePath, imageBytes, fileOptions: FileOptions(upsert: true, contentType: 'image/$imageExtension',
          ),
          );
          String imageUrl = db.storage.from('profiles').getPublicUrl(imagePath);
          imageUrl = Uri.parse(imageUrl).replace(queryParameters: {'t': DateTime.now().millisecondsSinceEpoch.toString()} ).toString();
          onUpload(imageUrl);
          print(imageUrl);
          }, child: const Text("Upload"),
        ),
      ],
    );
  }
}
