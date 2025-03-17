import 'package:chatnova/Controller/AuthController.dart';
import 'package:chatnova/Widget/PrimaryButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());
    TextEditingController name = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController phoneNumber = TextEditingController(); // Added Phone Number

    return Column(
      children: [
        const SizedBox(height: 40),
        TextField(
          controller: name,
          style: const TextStyle(color: Colors.black87),
          decoration: InputDecoration(
            labelText: "Full Name", // Changed hintText to labelText
            labelStyle: const TextStyle(fontSize: 20.0, color: Colors.black87), // Custom label style
            prefixIcon: const Icon(Icons.person, color: Colors.blueAccent), // Icon with blueAccent color
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),

        const SizedBox(height: 40),
        TextField(
          controller: email,
          style: const TextStyle(color: Colors.black87),
          decoration: InputDecoration(
            labelText: "Email",
            labelStyle: const TextStyle(fontSize: 20.0, color: Colors.black87),
            prefixIcon: const Icon(Icons.alternate_email_rounded, color: Colors.blueAccent),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 40),
        TextField(
          controller: phoneNumber,
          keyboardType: TextInputType.phone,
          style: const TextStyle(color: Colors.black87),
          decoration: InputDecoration(
            labelText: "Phone Number",
            labelStyle: const TextStyle(fontSize: 20.0, color: Colors.black87),
            prefixIcon: const Icon(Icons.phone, color: Colors.blueAccent),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 40),
        TextField(
          controller: password,
          obscureText: true, // For password input
          style: const TextStyle(color: Colors.black87),
          decoration: InputDecoration(
            labelText: "Password",
            labelStyle: const TextStyle(fontSize: 20.0, color: Colors.black87),
            prefixIcon: const Icon(Icons.password_outlined, color: Colors.blueAccent),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 50),
        Obx(() => authController.isLoading.value
            ? const CircularProgressIndicator()
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PrimaryButton(
              btnName: "Sign Up",
              icon: Icons.lock_open_outlined,
              ontap: () {
                authController.signUp(
                  name.text,
                  email.text,
                  password.text,
                  phoneNumber.text, // Pass Phone Number
                );
              },
            ),
          ],
        )),
      ],
    );
  }
}
