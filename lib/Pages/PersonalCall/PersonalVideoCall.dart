import 'package:chatnova/Pages/Chat/ChatPage.dart';
import 'package:chatnova/Pages/GroupChat/GroupChatPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:camera/camera.dart';

class Personalvideocall extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String receiverImage;

  Personalvideocall({
    required this.receiverId,
    required this.receiverName,
    required this.receiverImage,
  });

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<Personalvideocall> {
  bool isMuted = false;
  bool isCameraOff = false;
  bool isFrontCamera = true;
  int seconds = 0;
  Timer? _timer;
  CameraController? _cameraController;
  List<CameraDescription> cameras = [];

  @override
  void initState() {
    super.initState();
    _startTimer();
    _initializeCamera();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        seconds++;
      });
    });
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(
          isFrontCamera ? cameras.first : cameras.last, // Use first for front, last for rear
          ResolutionPreset.medium,
          enableAudio: true,
        );
        await _cameraController!.initialize();
        if (mounted) setState(() {});
      }
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  void _switchCamera() async {
    setState(() {
      isFrontCamera = !isFrontCamera;
    });
    await _cameraController?.dispose();
    await _initializeCamera();
  }

  String _formatDuration(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return "$minutes:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Video Stream (if camera is on)
            if (!isCameraOff && _cameraController != null && _cameraController!.value.isInitialized)
              Positioned.fill(
                child: CameraPreview(_cameraController!),
              )
            else
            // Placeholder if camera is off
              Container(
                color: Colors.black,
                alignment: Alignment.center,
                child: Text(
                  "Camera Off",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),

            // Call Details and Timer
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50),
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

                // Controls
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
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
                        icon: Icon(isCameraOff ? Icons.videocam_off : Icons.videocam, color: Colors.black, size: 40),
                        onPressed: () {
                          setState(() {
                            isCameraOff = !isCameraOff;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.switch_camera, color: Colors.black, size: 40),
                        onPressed: _switchCamera,
                      ),
                      FloatingActionButton(
                        backgroundColor: Colors.red,
                        child: Icon(Icons.call_end, color: Colors.white, size: 30),
                        onPressed: () {
                          Get.off(() => ChatPage(
                            receiverId: widget.receiverId,
                            receiverName: widget.receiverName,
                            receiverImage: widget.receiverImage,
                          ));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
