import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplaceController extends GetxController{
  final auth = Supabase.instance.client.auth;

  void onInit() async{
    super.onInit();
    splaceHandle();
  }


  Future<void>splaceHandle() async{
   await Future.delayed(Duration(seconds: 3),
    );
    if(auth.currentUser == null){
      Get.offAllNamed("/authPage");
    }else {
      Get.offAllNamed("/homePage");
      print(auth.currentUser!.email);
    }
  }
}