import 'package:chatnova/Config/Images.dart';
import 'package:chatnova/Controller/AuthController.dart';
import 'package:chatnova/Controller/ContactController.dart';
import 'package:chatnova/Controller/GroupController.dart';
import 'package:chatnova/Controller/ProfileController.dart';
import 'package:chatnova/Controller/StatusController.dart';
import 'package:chatnova/Pages/Chat/ChatPage.dart';
import 'package:chatnova/Pages/GroupChat/CreateGroupPage.dart';
import 'package:chatnova/Pages/GroupChat/GroupChatPage.dart';
import 'package:chatnova/Pages/GroupChat/GroupListPage.dart';
import 'package:chatnova/Pages/SatusPage/UpdatesPage.dart';
import 'package:chatnova/Pages/SatusPage/UploadStatusPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:chatnova/Pages/ContactPage/Widgets/ContactSearch.dart';
import 'package:chatnova/Pages/ContactPage/Widgets/NewContactTile.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Track selected index for Bottom Navigation

  final ProfileController profileController = Get.find<ProfileController>();
  final GroupController groupController = Get.find<GroupController>();
  final AuthController authController = Get.find<AuthController>();
  final ContactController contactController = Get.find<ContactController>();
  final StatusController statusController = Get.put(StatusController());

  @override
  void initState() {
    super.initState();
    groupController.fetchGroups(); // Load groups on HomePage start
    statusController.fetchStatuses(); // Load statuses on HomePage start
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SvgPicture.asset(
          AssetsImage.appIcon,
          width: 24,
          height: 24,
        ),
        title: const Text("ChatNova", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 5,
        actions: [
          IconButton(
            onPressed: () async {
              Get.toNamed("/authPage");
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              Get.toNamed("/profilePage");
            },
            icon: const Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),

      body: _getSelectedPage(),
      backgroundColor: Colors.blueAccent,

      // ✅ Bottom Navigation Bar with Updates feature
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: _selectedIndex == 0 ? Colors.white : Colors.black),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group, color: _selectedIndex == 1 ? Colors.white : Colors.black),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.update, color: _selectedIndex == 2 ? Colors.white : Colors.black),
            label: 'Updates',
          ),
        ],
        selectedItemColor: Colors.white, // Selected label color
        unselectedItemColor: Colors.black, // Unselected label color
        backgroundColor: Colors.blueAccent,
      ),

      // ✅ Floating Button (Chat, Group, or Status Upload)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedIndex == 0) {
            Get.toNamed("/contactPage");
          } else if (_selectedIndex == 1) {
            Get.to(() => CreateGroupPage());
          } else {
            Get.to(() => UploadStatusPage()); // Open the Upload Status Page
          }
        },
        backgroundColor: Colors.white,
        child: Icon(
          _selectedIndex == 0 ? Icons.add : _selectedIndex == 1 ? Icons.group_add : Icons.update,
          color: Colors.black,
        ),
      ),

    );
  }

  // ✅ Get the selected page based on current index
  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildChatList();
      case 1:
        return GroupListPage();
      case 2:
        return UpdatesPage();
      default:
        return _buildChatList();
    }
  }

  // ✅ Chat List Widget
  Widget _buildChatList() {
    if (contactController.userList.isEmpty) {
      return const Center(child: Text("No contacts available"));
    }

    return ListView.builder(
      itemCount: contactController.userList.length,
      itemBuilder: (context, index) {
        final user = contactController.userList[index];
        final lastMessage = user.about ?? "No messages yet";

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
                color: Colors.white
            ),

            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(user.profileImage ?? "https://your-default-image-url.com/default.png"),
              ),
              title: Text(user.name ?? "User", style: TextStyle(color: Colors.black),),
              subtitle: Text(lastMessage,
              style: TextStyle(color: Colors.blueGrey),
              ),
              onTap: () {
                Get.to(() => ChatPage(
                  receiverId: user.id!,
                  receiverName: user.name ?? "Unknown",
                  receiverImage: user.profileImage ?? "https://your-default-image-url.com/default.png",
                ));
              },
            ),
          ),
        );

      },
    );

  }

  // ✅ Group List Widget

  // ✅ Updates Page with Image & Video Status
  Widget _buildUpdatesPage() {
    return Obx(() {
      if (statusController.statusList.isEmpty) {
        return const Center(child: Text("No updates available"));
      }

      return ListView.builder(
        itemCount: statusController.statusList.length,
        itemBuilder: (context, index) {
          final status = statusController.statusList[index];
          return Card(
            child: Column(
              children: [
                status.mediaType == "image"
                    ? Image.network(status.mediaUrl)
                    : VideoPlayerWidget(videoUrl: status.mediaUrl),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Posted at: ${status.createdAt}"),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}

// ✅ Video Player Widget for Status Updates
class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    )
        : const Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
