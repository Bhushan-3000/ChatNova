import 'package:chatnova/Pages/Chat/ChatPage.dart';
import 'package:chatnova/Pages/GroupChat/GroupChatPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class Personalvoicecall extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String receiverImage;
  Personalvoicecall({
    required this.receiverId,
    required this.receiverName,
    required this.receiverImage,
  });

  @override
  _VoiceCallScreenState createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<Personalvoicecall> {
  bool isMuted = false;
  bool isSpeakerOn = false;
  int seconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        seconds++;
      });
    });
  }

  String _formatDuration(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return "$minutes:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 100,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: widget.receiverImage.isNotEmpty
                    ? NetworkImage(widget.receiverImage)
                    : null,
                child: widget.receiverImage.isEmpty
                    ? Icon(Icons.group, color: Colors.black, size: 80)
                    : null,
              ),
              SizedBox(height: 20),
              Text(
                widget.receiverName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                _formatDuration(seconds),
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(isMuted ? Icons.mic_off : Icons.mic, color: Colors.black, size: 40),
                      onPressed: () {
                        setState(() {
                          isMuted = !isMuted;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(isSpeakerOn ? Icons.volume_up : Icons.volume_off, color: Colors.black, size: 40),
                      onPressed: () {
                        setState(() {
                          isSpeakerOn = !isSpeakerOn;
                        });
                      },
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.red,
                      child: Icon(Icons.call_end, color: Colors.white, size: 30),
                      onPressed: () {
                        Get.off(() => ChatPage(receiverId: widget.receiverId, receiverName: widget.receiverName, receiverImage:widget.receiverImage,

                        ));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
