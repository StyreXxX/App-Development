import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:profile_app4/services/friend_service.dart';
import 'package:profile_app4/services/notification_service.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int _pendingFriendRequestCount = 0;
  List<Map<String, dynamic>> _notifications = [];
  bool isLoading = true;
  String? error;
  RealtimeChannel? _friendRequestChannel;
  RealtimeChannel? _notificationChannel;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _setupSubscriptions();
  }

  Future<void> _fetchData() async {
    try {
      final friendService = FriendService();
      final notificationService = NotificationService();
      final pendingCount = await friendService.getPendingRequestsCount();
      await notificationService.getUnreadNotificationCount();
      final notifications = await notificationService.getNotifications();
      final pendingRequests = await friendService.getPendingRequests();

      if (mounted) {
        setState(() {
          _pendingFriendRequestCount = pendingCount;
          _notifications = [
            if (pendingRequests.isNotEmpty)
              {
                'type': 'friend_request',
                'requests': pendingRequests,
              },
            ...notifications,
          ];
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

  void _setupSubscriptions() {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) return;

    // Friend request subscription
    _friendRequestChannel = supabase.channel('friend_requests_changes_notif');
    _friendRequestChannel!.onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'friend_requests',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'to_user',
        value: user.id,
      ),
      callback: (payload) {
        _fetchData();
      },
    );
    _friendRequestChannel!.subscribe();

    // Notification subscription
    _notificationChannel = supabase.channel('notifications_changes_notif');
    _notificationChannel!.onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'notifications',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'user_id',
        value: user.id,
      ),
      callback: (payload) {
        _fetchData();
      },
    );
    _notificationChannel!.subscribe();
  }

  @override
  void dispose() {
    _friendRequestChannel?.unsubscribe();
    _notificationChannel?.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text('Error: $error'))
              : _notifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_none,
                            size: 80,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No notifications',
                            style: TextStyle(
                              fontSize: 18,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchData,
                      child: ListView.builder(
                        itemCount: _notifications.length,
                        itemBuilder: (context, index) {
                          final notification = _notifications[index];
                          if (notification['type'] == 'friend_request') {
                            return _buildFriendRequestTile(notification['requests']);
                          } else {
                            return _buildNotificationTile(notification);
                          }
                        },
                      ),
                    ),
    );
  }

  Widget _buildFriendRequestTile(List<Map<String, dynamic>> requests) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person_add,
            color: theme.colorScheme.primary,
          ),
        ),
        title: Text(
          'Friend Requests',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('$_pendingFriendRequestCount pending request(s)'),
        children: requests.map((request) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: request['from_profile']['profile_pic_url'] != null
                  ? NetworkImage(request['from_profile']['profile_pic_url'])
                  : null,
              child: request['from_profile']['profile_pic_url'] == null
                  ? Text(request['from_profile']['name'][0].toUpperCase())
                  : null,
            ),
            title: Text('${request['from_profile']['name']}'),
            subtitle: Text('Age: ${request['from_profile']['age']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.check, color: theme.colorScheme.primary),
                  onPressed: () async {
                    await FriendService().acceptRequest(
                      request['id'],
                      request['from_user'],
                    );
                    _fetchData();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.close, color: theme.colorScheme.error),
                  onPressed: () async {
                    await FriendService().rejectRequest(request['id']);
                    _fetchData();
                  },
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotificationTile(Map<String, dynamic> notification) {
    final theme = Theme.of(context);
    final createdAt = DateTime.parse(notification['created_at']);
    final timeAgo = timeago.format(createdAt);
    final isRead = notification['is_read'] ?? false;

    return Dismissible(
      key: Key(notification['id'].toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        await NotificationService().deleteNotification(notification['id']);
        _fetchData();
      },
      background: Container(
        color: theme.colorScheme.primary,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: theme.colorScheme.onPrimary),
      ),
      child: Container(
        color: isRead ? Colors.transparent : theme.colorScheme.primary.withOpacity(0.1),
        child: ListTile(
          leading: Stack(
            children: [
              CircleAvatar(
                backgroundImage: notification['trigger_user']['profile_pic_url'] != null
                    ? NetworkImage(notification['trigger_user']['profile_pic_url'])
                    : null,
                child: notification['trigger_user']['profile_pic_url'] == null
                    ? Text(notification['trigger_user']['name'][0].toUpperCase())
                    : null,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    notification['type'] == 'like' ? Icons.favorite : Icons.comment,
                    size: 14,
                    color: notification['type'] == 'like' ? theme.colorScheme.error : theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            notification['content'],
            style: TextStyle(
              fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          subtitle: Text(
            timeAgo,
            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: () async {
              await NotificationService().deleteNotification(notification['id']);
              _fetchData();
            },
          ),
          onTap: () async {
            // Mark as read
            if (!isRead) {
              await NotificationService().markNotificationAsRead(notification['id']);
            }
            // TODO: Navigate to post with notification['post_id']
            _fetchData();
          },
        ),
      ),
    );
  }
}