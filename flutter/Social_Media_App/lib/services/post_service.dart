import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class PostService {
  final SupabaseClient supabase = Supabase.instance.client;

  // Create a new post with optional image
  Future<void> createPost(String content, {XFile? image}) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    String? imageUrl;
    if (image != null) {
      imageUrl = await _uploadImage(image, user.id);
    }

    await supabase.from('posts').insert({
      'user_id': user.id,
      'content': content,
      'image_url': imageUrl,
    });
  }

  // Fetch all posts with user profile details, sorted by created_at descending
  Future<List<Map<String, dynamic>>> getPosts() async {
    return await supabase
        .from('posts')
        .select('*, user:profiles(name, profile_pic_url)')
        .order('created_at', ascending: false);
  }

  // Update a post (only by owner)
  Future<void> updatePost(int postId, String content, {XFile? image}) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    String? imageUrl;
    if (image != null) {
      imageUrl = await _uploadImage(image, user.id);
    }

    final data = {
      'content': content,
      if (imageUrl != null) 'image_url': imageUrl,
      'updated_at': DateTime.now().toIso8601String(),
    };

    await supabase
        .from('posts')
        .update(data)
        .eq('id', postId)
        .eq('user_id', user.id);
  }

  // Delete a post (only by owner)
  Future<void> deletePost(int postId) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    await supabase
        .from('posts')
        .delete()
        .eq('id', postId)
        .eq('user_id', user.id);
  }

  // Private method to upload image to Supabase storage
  Future<String> _uploadImage(XFile image, String userId) async {
    final file = File(image.path);
    final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.${image.path.split('.').last}';

    final response = await supabase.storage
        .from('post_images')
        .upload(fileName, file);

    if (response.isEmpty) {
      throw Exception('Failed to upload image');
    }

    return supabase.storage.from('post_images').getPublicUrl(fileName);
  }
}