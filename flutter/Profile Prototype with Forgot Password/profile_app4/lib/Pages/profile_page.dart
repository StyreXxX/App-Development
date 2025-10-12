import 'package:flutter/material.dart';
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

    final theme = Theme.of(context);
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
                      buildProfileAvatar(profile, radius: 70), // Updated radius
                      AnimatedOpacity(
                        opacity: _isHovered ? 0.3 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          width: 140, // Updated to match 2 * new radius (70 * 2)
                          height: 140, // Updated to match 2 * new radius (70 * 2)
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
            const SizedBox(height: 8),

            // Name
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.85),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Text(
                  'Name: ${profile!['name']}',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.edit, color: theme.colorScheme.primary, size: 20),
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/edit_name');
                    await fetchProfile(context);
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Age
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.85),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Text(
                  'Age: ${profile!['age']}',
                  style: theme.textTheme.bodyMedium!.copyWith(fontSize: 16),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.edit, color: theme.colorScheme.primary, size: 20),
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/edit_age');
                    await fetchProfile(context);
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Email
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.85),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Text(
                  'Email: ${profile!['email']}',
                  style: theme.textTheme.bodyMedium!.copyWith(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Settings
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.85),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.settings, color: theme.colorScheme.primary, size: 20),
                title: Text('Settings', style: theme.textTheme.bodyMedium!.copyWith(fontSize: 16)),
                trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface, size: 20),
                onTap: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ),
            const SizedBox(height: 8),

            // Help Center
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.85),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.help_outline, color: theme.colorScheme.primary, size: 20),
                title: Text('Help Center', style: theme.textTheme.bodyMedium!.copyWith(fontSize: 16)),
                trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface, size: 20),
                onTap: () {
                  Navigator.pushNamed(context, '/helpcenter');
                },
              ),
            ),
            const SizedBox(height: 8),

            // Logout
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.85),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.logout, color: theme.colorScheme.primary, size: 20),
                title: Text('Log Out', style: theme.textTheme.bodyMedium!.copyWith(fontSize: 16)),
                trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface, size: 20),
                onTap: () async {
                  await SupabaseAuth().logout();
                  if (mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}