import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostDetailPage extends StatefulWidget {
  final int postId;

  const PostDetailPage({super.key, required this.postId});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  Map<String, dynamic>? _post;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchPost();
  }

  Future<void> _fetchPost() async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('posts')
          .select('*, user:profiles(name, profile_pic_url)')
          .eq('id', widget.postId)
          .single();

      if (mounted) {
        setState(() {
          _post = response;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = e.toString();
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Post')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Post')),
        body: Center(child: Text('Error: $error')),
      );
    }

    final createdAt = DateTime.parse(_post!['created_at']);
    final timeAgo = timeago.format(createdAt);

    return Scaffold(
      appBar: AppBar(title: const Text('Post')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: _post!['user']['profile_pic_url'] != null
                    ? NetworkImage(_post!['user']['profile_pic_url'])
                    : null,
                child: _post!['user']['profile_pic_url'] == null
                    ? Text(_post!['user']['name'][0].toUpperCase())
                    : null,
              ),
              title: Text(_post!['user']['name']),
              subtitle: Text(timeAgo),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(_post!['content'], style: theme.textTheme.bodyMedium),
            ),
            if (_post!['image_url'] != null)
              Image.network(_post!['image_url']),
            // Add sections for likes and comments as needed
          ],
        ),
      ),
    );
  }
}