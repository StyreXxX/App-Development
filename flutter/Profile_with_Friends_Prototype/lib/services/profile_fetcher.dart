import 'package:flutter/material.dart';
import '../auth/supabase_auth.dart';

mixin ProfileFetcher<T extends StatefulWidget> on State<T> {
  Map<String, dynamic>? profile;
  bool isLoading = true;

  Future<void> fetchProfile(BuildContext context) async {
    try {
      final fetchedProfile = await SupabaseAuth().getUserProfile();
      if (mounted) {
        setState(() {
          profile = fetchedProfile;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch profile: $e')),
        );
        setState(() => isLoading = false);
      }
    }
  }

  Widget buildProfileAvatar(Map<String, dynamic>? profile, {double radius = 70}) { // Increased from 50 to 70
    return AnimatedScale(
      scale: 1.0,
      duration: const Duration(milliseconds: 200),
      child: CircleAvatar(
        radius: radius,
        backgroundImage: profile?['profile_pic_url'] != null
            ? NetworkImage(profile!['profile_pic_url'])
            : null,
        child: profile?['profile_pic_url'] == null
            ? Icon(Icons.person, size: radius) // Scaled icon size with radius
            : null,
      ),
    );
  }
}