import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:profile_app4/services/comment_service.dart';
import 'package:intl/intl.dart';

class CommentSection extends StatefulWidget {
  final int postId;

  const CommentSection({super.key, required this.postId});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  List<Map<String, dynamic>> _comments = [];
  bool _showAll = false;
  bool _isLoading = true;
  final TextEditingController _commentController = TextEditingController();
  RealtimeChannel? _commentChannel;
  int? _editingCommentId;
  final TextEditingController _editCommentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchComments();
    _setupRealtime();
  }

  Future<void> _fetchComments() async {
    final limit = _showAll ? null : 3;
    final comments = await CommentService().getComments(widget.postId, limit: limit);
    if (mounted) {
      setState(() {
        _comments = comments;
        _isLoading = false;
      });
    }
  }

  void _setupRealtime() {
    _commentChannel = Supabase.instance.client.channel('comments_changes_${widget.postId}');
    _commentChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'comments',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'post_id',
            value: widget.postId,
          ),
          callback: (payload) {
            _fetchComments();
          },
        )
        .subscribe();
  }

  Future<void> _addComment() async {
    final content = _commentController.text.trim();
    if (content.isNotEmpty) {
      try {
        await CommentService().addComment(widget.postId, content);
        _commentController.clear();
        await _fetchComments();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error adding comment: $e')),
          );
        }
      }
    }
  }

  Future<void> _startEditing(int commentId, String content) async {
    setState(() {
      _editingCommentId = commentId;
      _editCommentController.text = content;
    });
  }

  Future<void> _updateComment() async {
    final content = _editCommentController.text.trim();
    if (content.isNotEmpty && _editingCommentId != null) {
      try {
        await CommentService().updateComment(_editingCommentId!, content);
        _editCommentController.clear();
        setState(() {
          _editingCommentId = null;
        });
        await _fetchComments();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating comment: $e')),
          );
        }
      }
    }
  }

  Future<void> _deleteComment(int commentId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Comment'),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes')),
        ],
      ),
    );
    if (confirm == true) {
      try {
        await CommentService().deleteComment(commentId);
        await _fetchComments();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting comment: $e')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _commentChannel?.unsubscribe();
    _commentController.dispose();
    _editCommentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._comments.map((comment) {
          final user = comment['user'] ?? {};
          final date = DateTime.parse(comment['created_at']);
          final formattedDate = DateFormat.yMMMd().add_jm().format(date);
          final currentUserId = Supabase.instance.client.auth.currentUser?.id;
          final isOwner = comment['user_id'] == currentUserId;

          if (_editingCommentId == comment['id']) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _editCommentController,
                      decoration: const InputDecoration(
                        hintText: 'Edit comment...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: _updateComment,
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        _editingCommentId = null;
                      });
                    },
                  ),
                ],
              ),
            );
          }

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: user['profile_pic_url'] != null
                  ? NetworkImage(user['profile_pic_url'])
                  : null,
              child: user['profile_pic_url'] == null ? const Icon(Icons.person) : null,
            ),
            title: Text(user['name'] ?? 'Unknown'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comment['content']),
                Text(formattedDate, style: const TextStyle(fontSize: 12)),
              ],
            ),
            trailing: isOwner
                ? PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'edit') {
                        _startEditing(comment['id'], comment['content']);
                      } else if (value == 'delete') {
                        _deleteComment(comment['id']);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: Text('Edit comment'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('Delete comment'),
                      ),
                    ],
                  )
                : null,
          );
        }),
        if (!_showAll && _comments.length >= 3)
          TextButton(
            onPressed: () {
              setState(() {
                _showAll = true;
              });
              _fetchComments();
            },
            child: const Text('View More'),
          ),
        if (_showAll)
          TextButton(
            onPressed: () {
              setState(() {
                _showAll = false;
              });
              _fetchComments();
            },
            child: const Text('Show Less'),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: 'Add a comment...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _addComment,
              ),
            ],
          ),
        ),
      ],
    );
  }
}