import 'package:chatnova/Config/Images.dart';
import 'package:chatnova/Config/Strings.dart';
import 'package:chatnova/Pages/Auth/Widgets/LoginForm.dart';
import 'package:chatnova/Pages/Auth/Widgets/SignupForm.dart';
import 'package:chatnova/Pages/Welcome/Widgets/WelcomeHeading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AuthPageBody extends StatelessWidget {
  const AuthPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool isLogin = true.obs;
    return  Container(
        padding: EdgeInsets.all(20),
        // height: 400,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white70, Colors.white54],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),

        child: Row(children: [
          Expanded(child: Column(children: [
            Obx(()=>Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,

              children: [
                InkWell(
                  onTap: (){
                    isLogin.value = true;
                  },
    child: Container(
    width: MediaQuery.sizeOf(context).width / 2.7 ,
    child: Column(
                  children: [
                    Text("Login", style: isLogin.value
                        ? Theme.of(context).textTheme.bodyLarge?.copyWith(
    color: Colors.white)
                        : Theme.of(context).textTheme.labelLarge?.copyWith(
        color: Colors.black),
                    ),
                    SizedBox(height: 5),
                    AnimatedContainer(duration: Duration(milliseconds: 200),
                      width: isLogin.value ? 100 : 0,
                      height: 3,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.black),
                    )
                  ],),)),

                InkWell(
                  onTap: () {
                    isLogin.value = false;
                  },
                  child: Container(
                    width: MediaQuery.sizeOf(context).width / 2.7 ,
                    child: Column(
                    children: [
                    Text("Sign-Up", style: isLogin.value
                        ? Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.black)
                        : Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white),
                    ),
                    SizedBox(height: 5),
                    AnimatedContainer(duration: Duration(milliseconds: 200),
                      width: isLogin.value ? 0 : 100,
                      height: 3,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.black),
                    )
                  ],),))
              ],)),
          Obx(()=> isLogin.value ? const LoginForm() : const SignupForm(),
          )
          ],
          )
          )
        ],)
    );
  }
}
