import 'package:chatnova/Config/Images.dart';
import 'package:chatnova/Controller/AuthController.dart';
import 'package:chatnova/Controller/ProfileController.dart';
// import 'package:chatnova/Pages/ProfilePage/Widgets/UserInfo.dart';
import 'package:chatnova/Pages/UserProfile/Widgets/UserInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());
    ProfileController profileController = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(color: Colors.black),),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(onPressed: () {
            Get.toNamed("/updateProfilePage");
          }, icon: Icon(Icons.edit, color: Colors.black,),)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          LoginUserInfo(),
          Spacer(),
          ElevatedButton(
            onPressed: () {
              authController.logoutUser();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black, // Background color
              foregroundColor: Colors.white, // Text color
            ),
            child: Text("Logout"),
          )
        ],),
      ),
    );
  }
}
