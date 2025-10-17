import 'package:supabase_flutter/supabase_flutter.dart';

class LikeService {
  final SupabaseClient supabase = Supabase.instance.client;

  // Like a post
  Future<void> likePost(int postId) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    await supabase.from('likes').insert({
      'post_id': postId,
      'user_id': user.id,
    });
  }

  // Unlike a post
  Future<void> unlikePost(int postId) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    await supabase
        .from('likes')
        .delete()
        .eq('post_id', postId)
        .eq('user_id', user.id);
  }

  // Get like count for a post
  Future<int> getLikeCount(int postId) async {
    final count = await supabase
        .from('likes')
        .count()
        .eq('post_id', postId);

    return count;
  }

  // Check if user has liked a post
  Future<bool> hasLiked(int postId) async {
    final user = supabase.auth.currentUser;
    if (user == null) return false;

    final response = await supabase
        .from('likes')
        .select()
        .eq('post_id', postId)
        .eq('user_id', user.id)
        .maybeSingle();

    return response != null;
  }
}