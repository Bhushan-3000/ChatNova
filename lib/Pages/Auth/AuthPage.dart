import 'package:chatnova/Config/Images.dart';
import 'package:chatnova/Config/Strings.dart';
import 'package:chatnova/Pages/Auth/Widgets/AuthPageBody.dart';
import 'package:chatnova/Pages/Welcome/Widgets/WelcomeHeading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  WelcomeHeading(),
                  SizedBox(height: 40),
                  AuthPageBody(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
