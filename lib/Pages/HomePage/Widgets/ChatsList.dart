import 'package:chatnova/Config/Images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        InkWell(
          onTap: () {
            Get.toNamed("/chatPage");
          },
          child: ChatTile(
            imageUrl: AssetsImage.defaultProfileUrl,
            name: "ChatNova Admin",
            lastChat: "Hey! Welcome to CHATNOVA",
            lastTime: "01:00 pm",
          ),
        ),
        ChatTile(
          imageUrl: AssetsImage.defaultProfileUrl,
          name: "Female User",
          lastChat: "Hey! Welcome to CHATNOVA",
          lastTime: "01:00 pm",
        ),
        ChatTile(
          imageUrl: AssetsImage.defaultProfileUrl,
          name: "Male User",
          lastChat: "Hey! Welcome to CHATNOVA",
          lastTime: "01:00 pm",
        ),
        ChatTile(
          imageUrl: AssetsImage.defaultProfileUrl,
          name: "Female User",
          lastChat: "Hey! Welcome to CHATNOVA",
          lastTime: "01:00 pm",
        ),
        ChatTile(
          imageUrl: AssetsImage.defaultProfileUrl,
          name: "Male User",
          lastChat: "Hey! Welcome to CHATNOVA",
          lastTime: "01:00 pm",
        ),
        ChatTile(
          imageUrl: AssetsImage.defaultProfileUrl,
          name: "Female User",
          lastChat: "Hey! Welcome to CHATNOVA",
          lastTime: "01:00 pm",
        ),
        ChatTile(
          imageUrl: AssetsImage.defaultProfileUrl,
          name: "Male User",
          lastChat: "Hey! Welcome to CHATNOVA",
          lastTime: "01:00 pm",
        ),
      ],
    );
  }
}

class ChatTile extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String lastChat;
  final String lastTime;

  const ChatTile({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.lastChat,
    required this.lastTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipOval(
                  child: SvgPicture.asset(
                    imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      lastChat,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ],
            ),
            Text(
              lastTime,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
