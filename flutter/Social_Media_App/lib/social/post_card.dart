import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:profile_app4/social/comment_section.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:profile_app4/services/like_service.dart';
import 'package:profile_app4/services/comment_service.dart';
import 'package:profile_app4/services/post_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int _likeCount = 0;
  bool _hasLiked = false;
  int _commentCount = 0;
  RealtimeChannel? _likeChannel;
  RealtimeChannel? _commentChannel; // 👈 Added comment realtime channel
  bool _isEditing = false;
  final TextEditingController _editController = TextEditingController();
  XFile? _editImage;

  @override
  void initState() {
    super.initState();
    _updateEditController();
    _fetchLikeData();
    _fetchCommentCount();
    _setupRealtime();
  }

  @override
  void didUpdateWidget(covariant PostCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.post['content'] != oldWidget.post['content']) {
      _updateEditController();
    }
  }

  void _updateEditController() {
    _editController.text = widget.post['content'] ?? '';
  }

  Future<void> _fetchLikeData() async {
    final likeCount = await LikeService().getLikeCount(widget.post['id']);
    final hasLiked = await LikeService().hasLiked(widget.post['id']);
    if (mounted) {
      setState(() {
        _likeCount = likeCount;
        _hasLiked = hasLiked;
      });
    }
  }

  Future<void> _fetchCommentCount() async {
    final commentCount = await CommentService().getCommentCount(widget.post['id']);
    if (mounted) {
      setState(() {
        _commentCount = commentCount;
      });
    }
  }

  void _setupRealtime() {
    // ✅ Realtime for Likes
    _likeChannel = Supabase.instance.client.channel('likes_changes_${widget.post['id']}');
    _likeChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'likes',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'post_id',
            value: widget.post['id'],
          ),
          callback: (payload) {
            _fetchLikeData();
          },
        )
        .subscribe();

    // ✅ Realtime for Comments
    _commentChannel = Supabase.instance.client.channel('comments_changes_${widget.post['id']}');
    _commentChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'comments',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'post_id',
            value: widget.post['id'],
          ),
          callback: (payload) {
            _fetchCommentCount(); // 👈 Updates comment count live
          },
        )
        .subscribe();
  }

  Future<void> _toggleLike() async {
    try {
      if (_hasLiked) {
        await LikeService().unlikePost(widget.post['id']);
      } else {
        await LikeService().likePost(widget.post['id']);
      }
      await _fetchLikeData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _editPost() async {
    try {
      await PostService().updatePost(
        widget.post['id'],
        _editController.text.trim(),
        image: _editImage,
      );
      setState(() {
        _isEditing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post updated!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _deletePost() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes')),
        ],
      ),
    );
    if (confirm == true) {
      try {
        await PostService().deletePost(widget.post['id']);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post deleted!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  Future<void> _pickEditImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null && mounted) {
      setState(() {
        _editImage = image;
      });
    }
  }

  @override
  void dispose() {
    _likeChannel?.unsubscribe();
    _commentChannel?.unsubscribe(); // 👈 Dispose comment realtime channel
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = widget.post['user'] ?? {};
    final date = DateTime.parse(widget.post['created_at']);
    final formattedDate = DateFormat.yMMMd().add_jm().format(date);
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    final isOwner = widget.post['user_id'] == currentUserId;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: user['profile_pic_url'] != null
                      ? NetworkImage(user['profile_pic_url'])
                      : null,
                  child: user['profile_pic_url'] == null ? const Icon(Icons.person) : null,
                ),
                const SizedBox(width: 8),
                Text(
                  user['name'] ?? 'Unknown',
                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  formattedDate,
                  style: theme.textTheme.bodySmall,
                ),
                if (isOwner)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'edit') {
                        setState(() {
                          _isEditing = true;
                        });
                      } else if (value == 'delete') {
                        _deletePost();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: Text('Edit post'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('Delete post'),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (_isEditing) ...[
              TextField(
                controller: _editController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                maxLines: null,
              ),
              const SizedBox(height: 8),
              if (_editImage != null)
                Image.file(
                  File(_editImage!.path),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              else if (widget.post['image_url'] != null)
                Image.network(
                  widget.post['image_url'],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.photo),
                    onPressed: _pickEditImage,
                  ),
                  ElevatedButton(
                    onPressed: _editPost,
                    child: const Text('Update'),
                  ),
                ],
              ),
            ] else ...[
              Text(widget.post['content']),
              if (widget.post['image_url'] != null) ...[
                const SizedBox(height: 8),
                Image.network(
                  widget.post['image_url'],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ],
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    _hasLiked ? Icons.favorite : Icons.favorite_border,
                    color: _hasLiked ? theme.colorScheme.error : null,
                  ),
                  onPressed: _toggleLike,
                ),
                Text('$_likeCount likes'),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: () {
                    // You can open comment section or modal
                  },
                ),
                Text('$_commentCount comments'),
              ],
            ),
            CommentSection(postId: widget.post['id']),
          ],
        ),
      ),
    );
  }
}
