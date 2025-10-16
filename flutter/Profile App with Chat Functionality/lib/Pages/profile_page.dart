import 'package:flutter/material.dart';
import 'package:profile_app4/components/profile_item.dart';
import 'package:profile_app4/services/profile_fetcher.dart';
import '../auth/supabase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with ProfileFetcher {
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    fetchProfile(context);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 500),
            child: const CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (profile == null) {
      return Scaffold(
        body: Center(
          child: AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 500),
            child: const Text('No profile data available', style: TextStyle(fontSize: 18)),
          ),
        ),
      );
    }

    Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 500),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          children: [
            const SizedBox(height: 16),
            Center(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/edit_profile_pic');
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      buildProfileAvatar(profile, radius: 70),
                      AnimatedOpacity(
                        opacity: _isHovered ? 0.3 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ProfileItem(
              label: 'Name',
              icon: Icons.person,
              value: profile!['name'],
              onEdit: () async {
                await Navigator.pushNamed(context, '/edit_name');
                await fetchProfile(context);
              },
            ),
            const SizedBox(height: 12),
            ProfileItem(
              label: 'Age',
              icon: Icons.person_3,
              value: profile!['age'].toString(),
              onEdit: () async {
                await Navigator.pushNamed(context, '/edit_age');
                await fetchProfile(context);
              },
            ),
            const SizedBox(height: 12),
            ProfileItem(
              label: 'Email',
              icon: Icons.email,
              value: profile!['email'],
            ),
            const SizedBox(height: 12),
            ProfileItem(
              label: 'Settings',
              icon: Icons.settings,
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            const SizedBox(height: 12),
            ProfileItem(
              label: 'Help Center',
              icon: Icons.help_outline,
              onTap: () {
                Navigator.pushNamed(context, '/helpcenter');
              },
            ),
            const SizedBox(height: 12),
            ProfileItem(
              label: 'Log Out',
              icon: Icons.logout,
              onTap: () async {
                await SupabaseAuth().logout();
                if (mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}