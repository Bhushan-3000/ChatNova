import 'package:chatnova/Pages/GroupCall/VideoCallScreen.dart';
import 'package:chatnova/Pages/GroupCall/VoiceCall.dart';
import 'package:chatnova/Pages/GroupChat/GroupInfoPage.dart';
import 'package:chatnova/Pages/GroupChat/GroupMembersPage.dart';
import 'package:chatnova/Pages/GroupChat/GroupSettingsPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'dart:io';

class GroupChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String groupImageUrl;

  GroupChatPage({required this.groupId, required this.groupName, required this.groupImageUrl});

  @override
  _GroupChatPageState createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final SupabaseClient supabase = Supabase.instance.client;
  File? _imageFile;
  bool _showEmojiPicker = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _sendMessage(imageFile: _imageFile);
    }
  }

  Future<void> _sendMessage({File? imageFile}) async {
    if (_messageController.text.isEmpty && imageFile == null) return;

    final userId = supabase.auth.currentUser!.id;
    String? imageUrl;

    try {
      if (imageFile != null) {
        final imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        await supabase.storage.from('group-chat-images').upload(imageName, imageFile);
        imageUrl = supabase.storage.from('group-chat-images').getPublicUrl(imageName);
      }

      await supabase.from('group_messages').insert({
        'group_id': widget.groupId,
        'sender_id': userId,
        'message': _messageController.text.isNotEmpty ? _messageController.text : null,
        'image_url': imageUrl,
        'timestamp': DateTime.now().toIso8601String(),
      });

      _messageController.clear();
      _scrollToBottom();
    } catch (e) {
      print("Error sending message: $e");
    }
    setState(() {});
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _toggleEmojiPicker() {
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
    });
  }

  Future<String> _fetchSenderName(String senderId) async {
    final response = await supabase.from('users').select('name').eq('id', senderId).maybeSingle();
    return response != null ? response['name'] : 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    final userId = supabase.auth.currentUser!.id;
    print("Group Image URL: ${widget.groupImageUrl}");

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.shade300, // Default color
              backgroundImage: widget.groupImageUrl.isNotEmpty
                  ? NetworkImage(widget.groupImageUrl)
                  : null,
              child: widget.groupImageUrl.isEmpty
                  ? Icon(Icons.group, color: Colors.black)
                  : null,
            ),

            SizedBox(width: 10),
            Expanded( // Prevents overflow by making the text take available space
              child: Text(
                widget.groupName,
                overflow: TextOverflow.ellipsis, // Ensures text doesn't exceed space
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(icon: Icon(Icons.info_outline_rounded), onPressed: () {
            Get.to(() => GroupInfoPage(
              groupId: widget.groupId,
              groupName: widget.groupName,
              groupImageUrl: widget.groupImageUrl,
            ));
          }),
          IconButton(icon: Icon(Icons.phone), onPressed: () {
            Get.to(() => VoiceCallScreen(groupId: widget.groupId, groupName:widget.groupName, groupImageUrl: widget.groupImageUrl,));
          }),
          IconButton(icon: Icon(Icons.videocam), onPressed: () {
            Get.to(() => VideoCallScreen(groupId: widget.groupId, groupName:widget.groupName, groupImageUrl: widget.groupImageUrl,));

          }),
        ],
      ),

      backgroundColor: Colors.blueAccent,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: supabase
                  .from('group_messages')
                  .stream(primaryKey: ['id'])
                  .eq('group_id', widget.groupId)
                  .order('timestamp'),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!;
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  reverse: false,
                  itemBuilder: (context, index) {
                    final message = messages[messages.length - 1 - index];
                    final bool isSentByUser = message['sender_id'] == userId;

                    return FutureBuilder<String>(
                      future: _fetchSenderName(message['sender_id']),
                      builder: (context, nameSnapshot) {
                        final senderName = nameSnapshot.data ?? 'Unknown';

                        return Align(
                          alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSentByUser ? Colors.black : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  senderName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isSentByUser ? Colors.green : Colors.red,
                                  ),
                                ),
                                if (message['message'] != null)
                                  Text(
                                    message['message'],
                                    style: TextStyle(color: isSentByUser ? Colors.white : Colors.black),
                                  ),
                                if (message['image_url'] != null)
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        message['image_url'],
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          if (_showEmojiPicker)
            SizedBox(
              height: 250,
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  setState(() {
                    _messageController.text += emoji.emoji;
                  });
                },
              ),
            ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Row(
                children: [
                  IconButton(icon: Icon(Icons.emoji_emotions, color: Colors.white), onPressed: _toggleEmojiPicker),
                  IconButton(icon: Icon(Icons.image, color: Colors.white), onPressed: _pickImage),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: Colors.blueGrey),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(icon: Icon(Icons.send, color: Colors.white), onPressed: _sendMessage),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
