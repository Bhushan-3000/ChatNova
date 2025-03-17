import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class ImagePickerController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  Future<String> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    return pickedFile?.path ?? '';
  }
}
