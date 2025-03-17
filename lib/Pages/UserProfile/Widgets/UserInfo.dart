import 'package:chatnova/Config/Images.dart';
import 'package:chatnova/Controller/ProfileController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LoginUserInfo extends StatelessWidget {
  const LoginUserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.put(ProfileController());
    return       Container(
      padding: EdgeInsets.all(20),
      // height: 100,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: SvgPicture.asset(
                        AssetsImage.boypic,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover, // Ensures it covers the circular area properly
                      ),
                    )

                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(()=> Text(
                      profileController.currentUser.value.name ?? "user",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.blueGrey),
                    ),
                    ),

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(()=> Text(
                      profileController.currentUser.value.email ?? "email",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.blueGrey),
                    ),
                    ),

                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height:50,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.1), // Slight transparency
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Wrap content size
                        children: [
                          Icon(
                            Icons.phone,
                            color: Colors.green,
                            size: 25, // Sets the icon size
                          ),

                          SizedBox(width: 10),
                          Text(
                            "Call",
                            style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height:50,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.1), // Slight transparency
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Wrap content size
                        children: [
                          Icon(Icons.video_call, color: Color(0xffff7300),size: 25,),
                          SizedBox(width: 10),
                          Text(
                            "Video",
                            style: TextStyle(color: Color(0xffff7300),),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height:50,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.1), // Slight transparency
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Wrap content size
                        children: [
                          Icon(Icons.chat, color: Colors.blueAccent, size: 25,),
                          SizedBox(width: 10),
                          Text(
                            "Chat",
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ],
                      ),
                    ),

                  ],)

              ],
            ),
          )
        ],
      ),
    )
    ;
  }
}
