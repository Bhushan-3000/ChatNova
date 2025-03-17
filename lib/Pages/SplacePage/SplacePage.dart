import 'package:chatnova/Config/Images.dart';
import 'package:chatnova/Controller/SplaceController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SplacePage extends StatelessWidget{
  const SplacePage({super.key});

  @override
  Widget build(BuildContext context) {
    SplaceController splaceController = Get.put(SplaceController());
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(AssetsImage.appIcon,width: 200, height: 200,
        ),
      ),
    );
  }
  

}