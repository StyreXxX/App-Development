import 'package:flutter/material.dart';
import '../auth/supabase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final profile = await SupabaseAuth().getUserProfile();
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await SupabaseAuth().logout();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _profile == null
              ? const Center(child: Text('No profile data available'))
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _profile!['profile_pic_url'] != null
                            ? NetworkImage(_profile!['profile_pic_url'])
                            : null,
                        child: _profile!['profile_pic_url'] == null
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Name: ${_profile!['name']}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Email: ${_profile!['email']}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Age: ${_profile!['age']}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/edit_name'),
                        child: const Text('Update Name'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/edit_password'),
                        child: const Text('Update Password'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await Navigator.pushNamed(context, '/edit_profile_pic');
                          await _fetchProfile(); // Refresh profile after edit
                        },
                        child: const Text('Edit Profile Picture'),
                      ),
                    ],
                  ),
                ),
    );
  }
}