import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final auth = Supabase.instance.client.auth;
  final db = Supabase.instance.client;

  RxBool isLoading = false.obs;

  // Getter to check if the user is logged in
  bool get isLogin => auth.currentUser != null;

  // Login Function
  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      final response = await auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        print("Signed in successfully: ${response.user?.email}");

        Get.snackbar(
          "Login Successful",
          "Welcome, ${response.user?.email}!",
        );

        Get.offAllNamed("/homePage");
      }
    } catch (error) {
      print("Sign in error: $error");
      Get.snackbar(
        "Login Failed",
        error.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    isLoading.value = false;
  }

  // Sign-Up Function (With User Data Saving)
  Future<void> signUp(String name, String email, String password, String phoneNumber) async {
    isLoading.value = true;
    try {
      final response = await auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final userId = response.user!.id; // Get User ID

        // ✅ Ensure column names match your Supabase schema (snake_case)
        await db.from('users').insert({
          'id': userId,
          'name': name,
          'email': email,
          'profileimage': '',       // Ensure this matches your column
          'phonenumber': phoneNumber, // Corrected from 'phone_number'
        });

        Get.snackbar(
          "Success",
          "Account created successfully.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAllNamed("/authPage");
      }
    } catch (error) {
      Get.snackbar(
        "Sign Up Failed",
        error.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    isLoading.value = false;
  }

  // Logout Function
  Future<void> logoutUser() async {
    await auth.signOut();
    Get.toNamed("/authPage");
  }




}
