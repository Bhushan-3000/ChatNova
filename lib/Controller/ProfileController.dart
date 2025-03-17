import 'dart:io';

import 'package:chatnova/Model/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  final auth = Supabase.instance.client.auth;
  final db = Supabase.instance.client;

  Rx<UserModel> currentUser = UserModel(
    id: '',
    name: '',
    email: '',
    profileImage: '',
    phoneNumber: '',
    about: '',
    createdAt: DateTime.now(),
    lastOnline: DateTime.now(),
    status: 'offline',
  ).obs;

  RxBool isLoading = true.obs; // Added loading state



  @override
  void onInit() {
    super.onInit();
    getUserDetails();
  }

  // ✅ Fetch user details from Supabase
  Future<void> getUserDetails() async {
    try {
      isLoading.value = true; // Set loading while fetching

      final userId = auth.currentUser?.id;
      if (userId == null) {
        Get.snackbar("Error", "User not logged in");
        return;
      }

      final response = await db
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle(); // Use maybeSingle to avoid exceptions on empty results

      if (response == null) {
        Get.snackbar("Error", "User data not found");
        return;
      }

      // Debugging output (to verify data is received)
      debugPrint("Fetched user data: $response");

      // Ensure data is correctly mapped
      currentUser.value = UserModel.fromJson(response);
    } catch (error) {
      Get.snackbar("Error", "Failed to fetch user details");
      debugPrint("Error fetching user: $error");
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  // ✅ Update user profile in Supabase
  Future<void> updateUserProfile({
    required String name,
    required String about,
    required String phoneNumber,
    String? profileImagePath, // Accept local image path
  }) async {
    try {
      final userId = auth.currentUser?.id;
      if (userId == null) return;

      String imageUrl = currentUser.value.profileImage;

      // Upload image if a new image is selected
      if (profileImagePath != null && profileImagePath.isNotEmpty) {
        final uploadedUrl = await uploadProfileImage(File(profileImagePath));
        if (uploadedUrl != null) {
          imageUrl = uploadedUrl; // Use uploaded image URL
        }
      }

      final updatedData = {
        'name': name,
        'about': about,
        'phonenumber': phoneNumber,
        'profileimage': imageUrl,
      };

      // Update the user's profile in Supabase
      await db.from('users').update(updatedData).eq('id', userId);

      // Update local model
      currentUser.value = currentUser.value.copyWith(
        name: name,
        about: about,
        phoneNumber: phoneNumber,
        profileImage: imageUrl,
      );

      Get.snackbar("Success", "Profile updated successfully");
    } catch (error) {
      Get.snackbar("Error", "Failed to update profile");
      debugPrint("Error updating profile: $error");
    }
  }


  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      final userId = auth.currentUser?.id;
      if (userId == null) return null;

      final fileExt = imageFile.path.split('.').last; // Get file extension
      final fileName = 'profile_$userId.$fileExt'; // Unique file name
      final filePath = 'profile_images/$fileName'; // Storage path

      // ✅ Corrected Upload method
      await db.storage
          .from('profile_images') // Ensure this matches your bucket name
          .upload(filePath, imageFile);

      // ✅ Generate a public URL for the uploaded image
      final imageUrl = db.storage.from('profile_images').getPublicUrl(filePath);

      return imageUrl;
    } catch (error) {
      debugPrint("Error uploading profile image: $error");
      return null;
    }
  }

}
