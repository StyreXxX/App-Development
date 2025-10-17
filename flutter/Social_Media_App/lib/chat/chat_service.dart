import 'package:supabase_flutter/supabase_flutter.dart';

class ChatService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getMessages(String friendId) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    final me = user.id;

    return await supabase
        .from('messages')
        .select()
        .or(
          'and(from_user.eq.$me,to_user.eq.$friendId),and(from_user.eq.$friendId,to_user.eq.$me)'
        )
        .order('created_at', ascending: true);
  }

  Future<void> sendMessage(String friendId, String message) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    final me = user.id;

    await supabase.from('messages').insert({
      'from_user': me,
      'to_user': friendId,
      'message': message,
    });
  }
}