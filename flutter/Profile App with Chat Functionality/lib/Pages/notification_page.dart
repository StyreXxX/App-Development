// pages/notifications_page.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:profile_app4/components/notification_tile.dart';
import 'package:profile_app4/services/friend_service.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int _pendingCount = 0;
  bool isLoading = true;
  String? error;
  RealtimeChannel? _channel;

  @override
  void initState() {
    super.initState();
    _fetchCount();
    _setupSubscription();
  }

  Future<void> _fetchCount() async {
    try {
      final count = await FriendService().getPendingRequestsCount();
      if (mounted) {
        setState(() {
          _pendingCount = count;
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

  void _setupSubscription() {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) return;

    _channel = supabase.channel('friend_requests_changes_notif');
    _channel!.onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'friend_requests',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'to_user',
        value: user.id,
      ),
      callback: (payload) {
        _fetchCount();
      },
    );
    _channel!.subscribe();
  }

  @override
  void dispose() {
    _channel?.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications'), centerTitle: true,),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text('Error: $error'))
              : NotificationTile(count: _pendingCount),
    );
  }
}