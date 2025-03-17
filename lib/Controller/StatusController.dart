import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chatnova/Model/StatusModel.dart';

class StatusController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;
  final RxList<StatusModel> statusList = <StatusModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchStatuses();
  }

  // ✅ Fetch Status Updates from Supabase
  Future<void> fetchStatuses() async {
    try {
      final response = await _supabase
          .from('status_updates') // ✅ Correct table name
          .select()
          .order('created_at', ascending: false);

      print("Fetched Statuses: $response"); // Debugging ✅

      if (response.isNotEmpty) {
        statusList.value =
            response.map((data) => StatusModel.fromJson(data)).toList();
      } else {
        statusList.clear();
        print("No statuses found in database"); // Debugging ✅
      }
    } catch (e) {
      print("Fetch Status Error: $e"); // Debugging ✅
      Get.snackbar("Error", "Failed to fetch statuses: $e");
    }
  }

  // ✅ Upload a new status (Image/Video)
  Future<void> uploadStatus(String mediaUrl, String mediaType) async {
    final userId = _supabase.auth.currentUser?.id;
    final userName = _supabase.auth.currentUser?.email;

    if (userId == null) {
      Get.snackbar("Error", "User not authenticated");
      return;
    }

    final status = {
      'user_id': userId,
      'user_name': userName ?? "Unknown",
      'media_url': mediaUrl,
      'media_type': mediaType,
      'created_at': DateTime.now().toIso8601String(),
    };

    try {
      await _supabase.from('status_updates').insert(status);
      print("✅ Status uploaded successfully!"); // Debugging ✅
      fetchStatuses(); // Refresh statuses after uploading
      Get.back();
      Get.snackbar("Success", "Status uploaded!");
    } catch (e) {
      print("Upload Status Error: $e"); // Debugging ✅
      Get.snackbar("Error", "Upload failed: $e");
    }
  }

  // ✅ Delete expired statuses (older than 24 hours)
  Future<void> deleteExpiredStatuses() async {
    final expirationTime =
    DateTime.now().subtract(const Duration(hours: 24)).toIso8601String();

    try {
      await _supabase
          .from('status_updates') // ✅ Correct table name
          .delete()
          .lt('created_at', expirationTime);

      print("✅ Expired statuses deleted!"); // Debugging ✅
      fetchStatuses(); // Refresh status list after deletion
    } catch (e) {
      print("Delete Status Error: $e"); // Debugging ✅
      Get.snackbar("Error", "Failed to delete expired statuses: $e");
    }
  }
}
