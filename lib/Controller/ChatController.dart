import 'package:supabase_flutter/supabase_flutter.dart';

class ChatController {
  final SupabaseClient supabase = Supabase.instance.client;

  /// 🔹 Update Typing Status (Set user as typing or not typing)
  Future<void> updateTypingStatus(String roomId, String userId,
      bool isTyping) async {
    // Check if an entry already exists
    final existingRecords = await supabase
        .from('typing_status')
        .select()
        .eq('room_id', roomId)
        .eq('user_id', userId);

    if (existingRecords.isNotEmpty) {
      // If exists, update it
      await supabase
          .from('typing_status')
          .update({'is_typing': isTyping})
          .eq('room_id', roomId)
          .eq('user_id', userId);
    } else {
      // If not, insert new record
      await supabase
          .from('typing_status')
          .insert({
        'room_id': roomId,
        'user_id': userId,
        'is_typing': isTyping,
      });
    }
  }
}
