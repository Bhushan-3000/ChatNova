import 'package:chatnova/Pages/HomePage/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:chatnova/Controller/StatusController.dart';

class UpdatesPage extends StatelessWidget {
  final StatusController statusController = Get.put(StatusController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent, // ✅ Background color set to blueAccent
      body: Obx(() {
        if (statusController.statusList.isEmpty) {
          return const Center(
            child: Text(
              "No updates available",
              style: TextStyle(color: Colors.white, fontSize: 18), // ✅ White text for visibility
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(10), // ✅ Adds spacing around the entire list
          itemCount: statusController.statusList.length,
          itemBuilder: (context, index) {
            final status = statusController.statusList[index];
            return Card(
              margin: const EdgeInsets.all(10), // ✅ Spacing between cards
              elevation: 5, // ✅ Adds shadow for better visibility
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // ✅ Rounded corners
              ),
              child: Padding(
                padding: const EdgeInsets.all(10), // ✅ Padding inside the card
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Uploaded by: ${status.userName}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8), // ✅ Spacing between elements
                    status.mediaType == "image"
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(10), // ✅ Rounded corners for image
                      child: Image.network(status.mediaUrl),
                    )
                        : VideoPlayerWidget(videoUrl: status.mediaUrl),
                    const SizedBox(height: 8),
                    Text(
                      "Posted at: ${formatDateTime(status.createdAt)}",
                      style: TextStyle(color: Colors.grey[700]),
                    ),

                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
  String formatDateTime(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate);
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

}
