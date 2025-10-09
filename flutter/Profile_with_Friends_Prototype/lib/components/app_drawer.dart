// components/app_drawer.dart (updated with new options)
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth/supabase_auth.dart';
import '../services/friend_service.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  int _pendingCount = 0;
  bool _loadingCount = true;
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
          _loadingCount = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loadingCount = false);
      }
    }
  }

  void _setupSubscription() {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) return;

    _channel = supabase.channel('friend_requests_changes_drawer');
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
    final theme = Theme.of(context);

    return Drawer(
      child: Container(
        color: theme.colorScheme.background,
        child: Column(
          children: [
            // Header
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Menu items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: const Text('Users'),
                    onTap: () {
                      Navigator.pushNamed(context, '/users');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.group),
                    title: const Text('Friends'),
                    onTap: () {
                      Navigator.pushNamed(context, '/friends');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person_add),
                    title: const Text('Friend Request'),
                    onTap: () {
                      Navigator.pushNamed(context, '/friend_requests');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: _loadingCount
                        ? const Text('Notifications')
                        : RichText(
                            text: TextSpan(
                              style: theme.textTheme.bodyLarge,
                              children: [
                                const TextSpan(text: 'Notifications'),
                                if (_pendingCount > 0)
                                  TextSpan(
                                    text: ' ($_pendingCount)',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                    onTap: () {
                      Navigator.pushNamed(context, '/notifications');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('Help Center'),
                    onTap: () {
                      Navigator.pushNamed(context, '/helpcenter');
                    },
                  ),
                ],
              ),
            ),

            // Logout button fixed at bottom
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Icon(Icons.logout, color: theme.colorScheme.primary),
                  title: Text(
                    'Log Out',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () async {
                    await SupabaseAuth().logout();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}