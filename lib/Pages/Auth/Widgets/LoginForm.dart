import 'package:chatnova/Controller/AuthController.dart';
import 'package:chatnova/Widget/PrimaryButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    AuthController authController = Get.put(AuthController());


    return Column(
      children: [
        const SizedBox(height: 40),
        TextField(
          controller: email,
          style: const TextStyle(color: Colors.black87),
          decoration: InputDecoration(
            labelText: "Email",  // Instead of hintText, use labelText
            labelStyle: TextStyle(fontSize: 20.0, color: Colors.black87), // Custom label style
            prefixIcon: Icon(Icons.alternate_email_rounded, color: Colors.blueAccent),
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
          obscureText: true,
          style: const TextStyle(color: Colors.black87),
          decoration: InputDecoration(
            labelText: "Password",  // Instead of hintText, use labelText
            labelStyle: TextStyle(fontSize: 20.0, color: Colors.black87), // Custom label style
            prefixIcon: Icon(Icons.password_outlined, color: Colors.blueAccent),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),


        const SizedBox(height: 50),
Obx(() => authController.isLoading.value ? CircularProgressIndicator(): Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    PrimaryButton(btnName: "Login", icon: Icons.lock_open_outlined, ontap: () {
      authController.login(email.text, password.text);
    },
    ),
  ],
),),
      ],);
  }
}
