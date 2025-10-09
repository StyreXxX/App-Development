// pages/users_page.dart (updated with similar fix for consistency)
import 'package:flutter/material.dart';
import 'package:profile_app4/components/user_tile.dart';
import 'package:profile_app4/services/friend_service.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> friends = [];
  List<String> pendingOutgoing = [];
  List<String> pendingIncoming = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final fetchedUsers = await FriendService().getAllUsers();
      final fetchedFriends = await FriendService().getFriends();
      final sentRequests = await FriendService().getSentPendingRequests();
      final List<String> outgoingIds = sentRequests.map((r) => r['to_user'] as String).toList();
      final pendingRequests = await FriendService().getPendingRequests();
      final List<String> incomingIds = pendingRequests.map((r) => r['from_user'] as String).toList();
      if (mounted) {
        setState(() {
          users = fetchedUsers;
          friends = fetchedFriends;
          pendingOutgoing = outgoingIds;
          pendingIncoming = incomingIds;
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
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text('Error: $error'))
              : users.isEmpty
                  ? const Center(child: Text('No other users found'))
                  : ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        final String uId = user['user_id'] as String;
                        final bool isFriend = friends.any((f) => f['user_id'] == uId);
                        final bool isPending = pendingOutgoing.contains(uId) || pendingIncoming.contains(uId);
                        Widget trailing;
                        if (isFriend) {
                          trailing = const Icon(Icons.check, color: Colors.green);
                        } else if (isPending) {
                          trailing = const Text('Pending');
                        } else {
                          trailing = IconButton(
                            icon: const Icon(Icons.person_add),
                            onPressed: () async {
                              final messenger = ScaffoldMessenger.of(context);
                              try {
                                await FriendService().sendFriendRequest(uId);
                                if (mounted) {
                                  messenger.showSnackBar(
                                    const SnackBar(content: Text('Friend request sent!')),
                                  );
                                  // Refresh pendings
                                  final sentRequests = await FriendService().getSentPendingRequests();
                                  final pendingRequests = await FriendService().getPendingRequests();
                                  setState(() {
                                    pendingOutgoing = sentRequests.map((r) => r['to_user'] as String).toList();
                                    pendingIncoming = pendingRequests.map((r) => r['from_user'] as String).toList();
                                  });
                                }
                              } catch (e) {
                                if (mounted) {
                                  messenger.showSnackBar(
                                    SnackBar(content: Text('Error: $e')),
                                  );
                                }
                              }
                            },
                          );
                        }
                        return UserTile(
                          user: user,
                          trailing: trailing,
                        );
                      },
                    ),
    );
  }
}