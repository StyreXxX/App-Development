import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sign Up
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    try {
      // We pass metadata so our SQL trigger can pick it up
      return await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'phone_number': phone,
          'is_guest': false,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  // Sign In
  Future<AuthResponse> signIn({required String email, required String password}) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Guest Login (Anonymous)
  Future<AuthResponse> signInAsGuest() async {
    try {
      return await _supabase.auth.signInAnonymously(
        data: {'is_guest': true, 'full_name': 'Guest User'},
      );
    } catch (e) {
      rethrow;
    }
  }

  // Password Reset
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Get Current User
  User? get currentUser => _supabase.auth.currentUser;
}