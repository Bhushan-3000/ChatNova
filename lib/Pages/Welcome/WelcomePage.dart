import 'package:chatnova/Config/Colors.dart';
import 'package:chatnova/Config/Images.dart';
import 'package:chatnova/Config/Strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:slide_to_act/slide_to_act.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
        child: Column(
            children: [
            SizedBox(height: 200),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AssetsImage.appIcon,
                  width: 200, // Set the desired width
                  height: 200, // Set the desired height
                ),

              ],
      ),
              Text(
                  AppString.appName,style:Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.black,
              ),),
              // Text(
              //     WelcomePageString.connected,style:Theme.of(context).textTheme.headlineSmall),
              Text(
                textAlign: TextAlign.center,
                  WelcomePageString.desc,style:Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.blueGrey,
              ),),
              SizedBox(height: 150),
              SlideAction(
                onSubmit: (){
                  Get.offAllNamed("/authPage");
                },
                innerColor: Theme.of(context).colorScheme.primary,
                outerColor: Theme.of(context).colorScheme.primaryContainer,
                sliderRotate: false,
                // animationDuration: Duration(seconds:1),
                text: WelcomePageString.slide,
                textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.blueGrey,
                ),
                // sliderButtonIcon: Icon(Icons.rocket_launch),
                submittedIcon: Icon(Icons.rocket_launch),
              ),
        ],
      ),
      ),
    ),
    );
  }
}
