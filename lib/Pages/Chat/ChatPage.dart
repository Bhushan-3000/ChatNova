import 'package:chatnova/Pages/GroupCall/VoiceCall.dart';
import 'package:chatnova/Pages/PersonalCall/PersonalVideoCall.dart';
import 'package:chatnova/Pages/PersonalCall/PersonalVoiceCall.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'full_screen_image_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class ChatPage extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String receiverImage;

  const ChatPage({
    Key? key,
    required this.receiverId,
    required this.receiverName,
    required this.receiverImage,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker picker = ImagePicker();
  final String senderId = Supabase.instance.client.auth.currentUser!.id;
  bool isEmojiVisible = false;

  @override
  void initState() {
    super.initState();
    markMessagesAsSeen();
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
  }

  void scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void markMessagesAsSeen() async {
    await supabase
        .from('messages')
        .update({'status': 'seen'})
        .match({'receiver_id': senderId, 'sender_id': widget.receiverId});
  }

  String getMessageStatusIcon(String status) {
    switch (status) {
      case 'sent':
        return '✓';
      case 'delivered':
        return '✓✓';
      case 'seen':
        return '✓✓ (Seen)';
      default:
        return '✓';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.receiverImage),
            ),
            const SizedBox(width: 10),
            Text(widget.receiverName),
          ],
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(icon: Icon(Icons.phone), onPressed: () {
            Get.to(() => Personalvoicecall(receiverId: widget.receiverId, receiverName:widget.receiverName, receiverImage: widget.receiverImage,));
          }),
          IconButton(icon: Icon(Icons.video_call), onPressed: () {
            Get.to(() => Personalvideocall(receiverId: widget.receiverId, receiverName:widget.receiverName, receiverImage: widget.receiverImage,));
          }),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.blueAccent,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: supabase
                    .from('messages')
                    .stream(primaryKey: ['id'])
                    .order('created_at', ascending: false)
                    .map((snapshot) => snapshot.where((msg) =>
                (msg['sender_id'] == senderId && msg['receiver_id'] == widget.receiverId) ||
                    (msg['sender_id'] == widget.receiverId && msg['receiver_id'] == senderId))
                    .toList()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No messages yet"));
                  }

                  final messages = snapshot.data!;
                  WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());

                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe = message['sender_id'] == senderId;
                      final String fileUrl = message['message'];

                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.black : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (fileUrl.startsWith('http'))
                                GestureDetector(
                                  onTap: () {
                                    if (fileUrl.contains('.jpg') || fileUrl.contains('.png') || fileUrl.contains('.jpeg')) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FullScreenImageView(imageUrl: fileUrl),
                                        ),
                                      );
                                    } else {
                                      Uri url = Uri.parse(Uri.encodeFull(fileUrl));
                                      launchUrl(url, mode: LaunchMode.externalApplication);
                                    }
                                  },
                                  child: fileUrl.contains('.jpg') || fileUrl.contains('.png') || fileUrl.contains('.jpeg')
                                      ? Image.network(
                                    fileUrl,
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  )
                                      : Row(
                                    children: [
                                      const Icon(Icons.insert_drive_file, color: Colors.blue, size: 24),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          "Open File",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )

                              else
                                Text(
                                  message['message'],
                                  style: TextStyle(color: isMe ? Colors.white : Colors.black),
                                ),
                              Text(
                                getMessageStatusIcon(message['status']),
                                style: const TextStyle(fontSize: 12, color: Colors.green),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            _buildMessageInput(),
            isEmojiVisible ? _buildEmojiPicker() : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return SafeArea( // Ensures input box is above system navigation buttons
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 1, right: 1),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.emoji_emotions, color: Colors.white),
              onPressed: () {
                setState(() {
                  isEmojiVisible = !isEmojiVisible;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.attach_file, color: Colors.white),
              onPressed: pickFile,
            ),
            Expanded(
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                  filled: true,
                  hintText: "Type a message...",
                  hintStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiPicker() {
    return EmojiPicker(
      onEmojiSelected: (category, emoji) {
        messageController.text += emoji.emoji;
      },
    );
  }

  Future<void> sendMessage([String? fileUrl]) async {
    String messageText = fileUrl ?? messageController.text;
    if (messageText.isEmpty) return;

    await supabase.from('messages').insert({
      'sender_id': senderId,
      'receiver_id': widget.receiverId,
      'message': messageText,
      'status': 'sent',
      'created_at': DateTime.now().toIso8601String(),
    });

    messageController.clear();

    // **Force UI update after sending a message**
    setState(() {});
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      String? uploadedUrl = await uploadFile(file);
      if (uploadedUrl != null) {
        await sendMessage(uploadedUrl);
      }
    }
  }

  Future<String?> uploadFile(File file) async {
    final String fileName = 'uploads/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
    await supabase.storage.from('chat_files').upload(fileName, file);
    return supabase.storage.from('chat_files').getPublicUrl(fileName);
  }
}
