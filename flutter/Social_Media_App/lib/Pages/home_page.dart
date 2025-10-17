import 'package:flutter/material.dart';
import 'package:profile_app4/components/app_drawer.dart';
import 'package:profile_app4/components/sliding_background.dart';
import 'package:profile_app4/services/profile_fetcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:profile_app4/services/post_service.dart';
import 'package:profile_app4/social/post_card.dart';
import 'package:profile_app4/social/whats_on_your_mind_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ProfileFetcher {
  final List<String> backgroundImages = [
    'assets/image1.jpg',
    'assets/image2.jpg',
    'assets/image3.jpg',
    'assets/image4.jpg',
  ];

  List<Map<String, dynamic>> _posts = [];
  RealtimeChannel? _channel;

  @override
  void initState() {
    super.initState();
    fetchProfile(context);
    _fetchPosts();
    _setupRealtime();
  }

  Future<void> _fetchPosts() async {
    try {
      final posts = await PostService().getPosts();
      if (mounted) {
        setState(() {
          _posts = posts;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching posts: $e')),
        );
      }
    }
  }

  void _setupRealtime() {
    _channel = Supabase.instance.client.channel('posts_changes');
    _channel!
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'posts',
          callback: (payload) {
            _insertNewPost(payload.newRecord);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'posts',
          callback: (payload) {
            _updatePost(payload.newRecord);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'posts',
          callback: (payload) {
            _deletePost(payload.oldRecord['id']);
          },
        )
        .subscribe();
  }

  void _insertNewPost(Map<String, dynamic> newPost) {
    // Fetch user details for the new post
    // Assuming newPost has user_id, fetch profile
    // For simplicity, refresh all, or implement logic to add with user data
    _fetchPosts(); // Fallback to full refresh for now
  }

  void _updatePost(Map<String, dynamic> updatedPost) {
    if (mounted) {
      setState(() {
        final index = _posts.indexWhere((p) => p['id'] == updatedPost['id']);
        if (index != -1) {
          _posts[index] = {..._posts[index], ...updatedPost};
        }
      });
    }
  }

  void _deletePost(int postId) {
    if (mounted) {
      setState(() {
        _posts.removeWhere((p) => p['id'] == postId);
      });
    }
  }

  @override
  void dispose() {
    _channel?.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          SlidingBackground(
            imagePaths: backgroundImages,
            imageCount: backgroundImages.length,
            slideDuration: const Duration(seconds: 5),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, size: 30),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                    Text(
                      isLoading
                          ? 'Loading profile...'
                          : profile != null
                              ? 'Welcome, ${profile!['name']}!'
                              : 'No profile data available',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    IconButton(
                      icon: buildProfileAvatar(profile, radius: 20),
                      onPressed: () async {
                        await Navigator.pushNamed(context, '/profile');
                        await fetchProfile(context);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _posts.length + 1, // +1 for WhatsOnYourMindCard
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const WhatsOnYourMindCard();
                    }
                    return PostCard(key: Key(_posts[index - 1]['id'].toString()), post: _posts[index - 1]);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}