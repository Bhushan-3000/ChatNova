import 'package:chatnova/Pages/Auth/AuthPage.dart';
import 'package:chatnova/Pages/Chat/ChatPage.dart';
import 'package:chatnova/Pages/ContactPage/ContactPage.dart';
import 'package:chatnova/Pages/HomePage/HomePage.dart';
import 'package:chatnova/Pages/ProfilePage/ProfilePage.dart';
import 'package:chatnova/Pages/UserProfile/ProfilePage.dart';
import 'package:chatnova/Pages/UserProfile/UpdateProfile.dart';
import 'package:chatnova/Pages/UserProfile/ProfilePage.dart';
import 'package:get/get.dart';
var pagePath = [
  GetPage(
      name: "/authPage",
      page: ()=>AuthPage(),
      transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: "/homePage",
    page: ()=>HomePage(),
    transition: Transition.rightToLeftWithFade,
  ),
  // GetPage(
  //   name: "/chatPage",
  //   page: ()=>ChatPage(),
  //   transition: Transition.rightToLeftWithFade,
  // ),
  GetPage(
    name: "/profilePage",
    page: ()=>ProfilePage(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: "/UserProfilePage",
    page: ()=>UserProfilePage(),
    transition: Transition.rightToLeftWithFade,
  ),

  GetPage(
    name: "/updateProfilePage",
    page: ()=>UserUpdateProfile(),
    transition: Transition.rightToLeftWithFade,
  ),

  GetPage(
    name: "/contactPage",
    page: ()=>ContactPage(),
    transition: Transition.rightToLeftWithFade,
  ),
];