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
    final response = await supabase.auth.signUp(email: email, password: password);
    if (response.user == null) throw Exception('Registration failed: No user created');

    await supabase.from('profiles').insert({
      'user_id': response.user!.id,
      'name': name,
      'age': age,
      'email': email,
    });
  }

  Future<void> login({required String email, required String password}) async {
    await supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;
    return await supabase.from('profiles').select().eq('user_id', user.id).single();
  }

  Future<void> updateName({required String newName, required String password}) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No user logged in');
    await supabase.auth.signInWithPassword(email: user.email!, password: password);
    await supabase.from('profiles').update({'name': newName}).eq('user_id', user.id);
  }

  Future<void> updateAge({required int newAge}) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No user logged in');
    await supabase.from('profiles').update({'age': newAge}).eq('user_id', user.id);
  }

  Future<void> updatePassword({required String oldPassword, required String newPassword}) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No user logged in');
    await supabase.auth.signInWithPassword(email: user.email!, password: oldPassword);
    await supabase.auth.updateUser(UserAttributes(password: newPassword));
  }

  Future<void> updateProfilePic(File imageFile) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    final fileExt = imageFile.path.split('.').last;
    final fileName = '${user.id}.$fileExt';

    final currentProfile = await getUserProfile();
    if (currentProfile?['profile_pic_url'] != null) {
      final currentFileName = currentProfile!['profile_pic_url'].split('/').last.split('?').first;
      if (currentFileName.isNotEmpty) {
        await supabase.storage.from('profile_pics').remove([currentFileName]);
      }
    }

    await supabase.storage.from('profile_pics').upload(
      fileName,
      imageFile,
      fileOptions: const FileOptions(upsert: true),
    );

    final url = '${supabase.storage.from('profile_pics').getPublicUrl(fileName)}?v=${DateTime.now().millisecondsSinceEpoch}';
    await supabase.from('profiles').update({'profile_pic_url': url}).eq('user_id', user.id);
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }
}