import 'package:supabase_flutter/supabase_flutter.dart';

class CommentService {
  final SupabaseClient supabase = Supabase.instance.client;

  // Add a comment to a post
  Future<void> addComment(int postId, String content) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    await supabase.from('comments').insert({
      'post_id': postId,
      'user_id': user.id,
      'content': content,
    });
  }

  // Fetch comments for a post with user profile details, sorted by created_at ascending
  Future<List<Map<String, dynamic>>> getComments(int postId, {int? limit}) async {
    var query = supabase
        .from('comments')
        .select('*, user:profiles(name, profile_pic_url)')
        .eq('post_id', postId)
        .order('created_at', ascending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    return await query;
  }

  // Get comment count for a post
  Future<int> getCommentCount(int postId) async {
    final count = await supabase
        .from('comments')
        .count()
        .eq('post_id', postId);

    return count;
  }

  // Update a comment (only by owner)
  Future<void> updateComment(int commentId, String content) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    await supabase
        .from('comments')
        .update({
          'content': content,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', commentId)
        .eq('user_id', user.id);
  }

  // Delete a comment (only by owner)
  Future<void> deleteComment(int commentId) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    await supabase
        .from('comments')
        .delete()
        .eq('id', commentId)
        .eq('user_id', user.id);
  }
}