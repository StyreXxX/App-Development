// pages/friend_requests_page.dart (updated with fix)
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:profile_app4/components/user_tile.dart';
import 'package:profile_app4/services/friend_service.dart';

class FriendRequestsPage extends StatefulWidget {
  const FriendRequestsPage({super.key});

  @override
  State<FriendRequestsPage> createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends State<FriendRequestsPage> {
  List<Map<String, dynamic>> requests = [];
  bool isLoading = true;
  String? error;
  RealtimeChannel? _channel;

  @override
  void initState() {
    super.initState();
    _fetchRequests();
    _setupSubscription();
  }

  Future<void> _fetchRequests() async {
    try {
      final fetchedRequests = await FriendService().getPendingRequests();
      if (mounted) {
        setState(() {
          requests = fetchedRequests;
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

    _channel = supabase.channel('friend_requests_changes_page');
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
        _fetchRequests();
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
      appBar: AppBar(title: const Text('Friend Requests'), centerTitle: true,),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text('Error: $error'))
              : requests.isEmpty
                  ? const Center(child: Text('No pending friend requests'))
                  : ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final request = requests[index];
                        final fromProfile = request['from_profile'] ?? {};
                        return UserTile(
                          user: {
                            'name': fromProfile['name'],
                            'age': fromProfile['age'] ?? 'N/A',
                            'profile_pic_url': fromProfile['profile_pic_url'],
                          },
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check, color: Colors.green),
                                onPressed: () async {
                                  final messenger = ScaffoldMessenger.of(context);
                                  try {
                                    await FriendService().acceptRequest(
                                      request['id'],
                                      request['from_user'],
                                    );
                                    await _fetchRequests();
                                    if (mounted) {
                                      messenger.showSnackBar(
                                        const SnackBar(content: Text('Friend request accepted!')),
                                      );
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      messenger.showSnackBar(
                                        SnackBar(content: Text('Error: $e')),
                                      );
                                    }
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: () async {
                                  final messenger = ScaffoldMessenger.of(context);
                                  try {
                                    await FriendService().rejectRequest(request['id']);
                                    await _fetchRequests();
                                    if (mounted) {
                                      messenger.showSnackBar(
                                        const SnackBar(content: Text('Friend request rejected.')),
                                      );
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      messenger.showSnackBar(
                                        SnackBar(content: Text('Error: $e')),
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }
}