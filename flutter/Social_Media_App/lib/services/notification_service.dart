import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  final SupabaseClient supabase = Supabase.instance.client;

  // Fetch notifications for the current user
  Future<List<Map<String, dynamic>>> getNotifications({int? limit}) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    var query = supabase
        .from('notifications')
        .select('id, type, post_id, trigger_user_id, content, is_read, created_at, trigger_user:profiles!notifications_trigger_user_id_fkey(name, profile_pic_url)')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    if (limit != null) {
      query = query.limit(limit);
    }

    return await query;
  }

  // Get notification count (unread)
  Future<int> getUnreadNotificationCount() async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    final response = await supabase
        .from('notifications')
        .select()
        .eq('user_id', user.id)
        .eq('is_read', false)
        .count(CountOption.exact);

    return response.count;
  }

  // Mark notification as read
  Future<void> markNotificationAsRead(int notificationId) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    await supabase
        .from('notifications')
        .update({
          'is_read': true,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', notificationId)
        .eq('user_id', user.id);
  }

  // Delete notification
  Future<void> deleteNotification(int notificationId) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    await supabase
        .from('notifications')
        .delete()
        .eq('id', notificationId)
        .eq('user_id', user.id);
  }
}