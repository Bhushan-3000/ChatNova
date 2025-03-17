import 'package:chatnova/Model/UserModel.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContactController extends GetxController {
  final SupabaseClient db = Supabase.instance.client;
  RxBool isLoading = false.obs;
  RxList<UserModel> userList = <UserModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await getUserList();
  }

  Future<void> getUserList() async {
    isLoading.value = true;
    try {
      userList.clear();
      final response = await db.from('users').select();

      if (response != null) {
        userList.value = response.map((e) => UserModel.fromJson(e)).toList();
      }
    } catch (ex) {
      print("Error fetching users: $ex");
    } finally {
      isLoading.value = false;
    }
  }
}
