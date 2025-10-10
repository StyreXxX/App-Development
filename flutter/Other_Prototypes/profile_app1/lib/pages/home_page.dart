import 'package:flutter/material.dart';
import '../auth/supabase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundImage: _profile?['profile_pic_url'] != null
                  ? NetworkImage(_profile!['profile_pic_url'])
                  : null,
              child: _profile?['profile_pic_url'] == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            onPressed: () async {
              await Navigator.pushNamed(context, '/profile');
              await _fetchProfile(); // Refresh after returning from Profile
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome to the Home Page!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}