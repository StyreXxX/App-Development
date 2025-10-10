import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuth {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> register({
    required String name,
    required int age,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await supabase.from('profiles').insert({
          'user_id': response.user!.id,
          'name': name,
          'age': age,
          'email': email,
        });
      }
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return null;

      final response = await supabase
          .from('profiles')
          .select()
          .eq('user_id', user.id)
          .single();
          
      return response;
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }

  Future<void> updateName({
    required String newName,
    required String password,
  }) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('No user logged in');
      
      await supabase.auth.signInWithPassword(
        email: user.email!,
        password: password,
      );

      await supabase
          .from('profiles')
          .update({'name': newName})
          .eq('user_id', user.id);
    } catch (e) {
      throw Exception('Failed to update name: $e');
    }
  }

  Future<void> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('No user logged in');
      
      await supabase.auth.signInWithPassword(
        email: user.email!,
        password: oldPassword,
      );

      await supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      throw Exception('Failed to update password: $e');
    }
  }

  Future<void> updateProfilePic(File imageFile) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      final fileExt = imageFile.path.split('.').last;
      final fileName = '${user.id}.$fileExt';

      // Fetch current profile to check existing profile picture URL
      final currentProfile = await getUserProfile();
      if (currentProfile != null && currentProfile['profile_pic_url'] != null) {
        final currentFileName = currentProfile['profile_pic_url']
            .split('/')
            .last
            .split('?')[0]; // Extract filename without param
        if (currentFileName.isNotEmpty) {
          await supabase.storage.from('profile_pics').remove([currentFileName]);
        }
      }

      // Upload new file with upsert option to overwrite if exists
      await supabase.storage.from('profile_pics').upload(
        fileName,
        imageFile,
        fileOptions: const FileOptions(upsert: true),
      );

      // Generate URL with cache-busting parameter
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final url = '${supabase.storage.from('profile_pics').getPublicUrl(fileName)}?v=$timestamp';

      await supabase
          .from('profiles')
          .update({'profile_pic_url': url})
          .eq('user_id', user.id);
    } catch (e) {
      throw Exception('Failed to update profile picture: $e');
    }
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }
}