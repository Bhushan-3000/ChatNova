import 'package:chatnova/Config/Images.dart';
import 'package:chatnova/Config/Strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WelcomeHeading extends StatelessWidget {
  const WelcomeHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AssetsImage.appIcon,
            width: 100, // Set the desired width
            height: 100, // Set the desired height
          ),

        ],
      ),
      Text(
          AppString.appName,style:Theme.of(context).textTheme.headlineSmall)

    ],);
  }
}
