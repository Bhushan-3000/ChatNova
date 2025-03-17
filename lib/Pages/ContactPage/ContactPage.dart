import 'package:chatnova/Controller/ContactController.dart';
import 'package:chatnova/Pages/Chat/ChatPage.dart';
import 'package:chatnova/Pages/GroupChat/CreateGroupPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatnova/Pages/ContactPage/Widgets/ContactSearch.dart';
import 'package:chatnova/Pages/ContactPage/Widgets/NewContactTile.dart';


class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool isSearchEnable = false.obs;
    ContactController contactController = Get.put(ContactController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select Contact",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          Obx(
                () => IconButton(
              onPressed: () {
                isSearchEnable.value = !isSearchEnable.value;
              },
              icon: isSearchEnable.value
                  ? const Icon(Icons.close, color: Colors.white)
                  : const Icon(Icons.search, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.blueAccent,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() => isSearchEnable.value ? ContactSearch() : const SizedBox()),

              const SizedBox(height: 10),
              NewContactTile(
                btnName: 'New Group',
                icon: Icons.group_add_rounded,
                onTap: () {
                  Get.to(() => CreateGroupPage()); // Navigate to Create Group Page
                },
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Text(
                    "Contacts on ChatNova",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Displaying contact list
              Obx(
                    () => Column(
                  children: contactController.userList.map(
                        (e) => InkWell(
                      onTap: () {
                        Get.to(ChatPage(
                          receiverId: e.id!,
                          receiverName: e.name ?? "Unknown User",
                          receiverImage: e.profileImage ??
                              "https://your-default-image-url.com/default.png",
                        ));
                      },
                      child: _buildChatTile(
                        imageUrl: (e.profileImage?.isNotEmpty == true)
                            ? e.profileImage!
                            : "https://your-default-image-url.com/default.png",
                        name: e.name?.trim().isNotEmpty == true ? e.name! : "User",
                        lastChat: e.about?.trim().isNotEmpty == true
                            ? e.about!
                            : "ChatNova Messaging App",
                        lastTime: e.status?.trim().isNotEmpty == true ? e.status! : "",
                      ),
                    ),
                  ).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ChatTile Widget
Widget _buildChatTile({
  required String imageUrl,
  required String name,
  required String lastChat,
  required String lastTime,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.network(
                  imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.person, size: 60),
                ),
              ),
              const SizedBox(width: 15),
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
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            lastTime,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    ),
  );
}
