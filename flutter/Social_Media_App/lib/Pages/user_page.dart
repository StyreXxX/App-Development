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
  List<Map<String, dynamic>> outgoingRequests = [];
  List<String> incomingIds = [];
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
      final pendingRequests = await FriendService().getPendingRequests();
      final List<String> incoming = pendingRequests.map((r) => r['from_user'] as String).toList();
      if (mounted) {
        setState(() {
          users = fetchedUsers;
          friends = fetchedFriends;
          outgoingRequests = sentRequests;
          incomingIds = incoming;
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

  Future<void> _refreshPendings() async {
    try {
      final sentRequests = await FriendService().getSentPendingRequests();
      final pendingRequests = await FriendService().getPendingRequests();
      final List<String> incoming = pendingRequests.map((r) => r['from_user'] as String).toList();
      if (mounted) {
        setState(() {
          outgoingRequests = sentRequests;
          incomingIds = incoming;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error refreshing: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users'), centerTitle: true,),
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
                        final bool isOutgoingPending = outgoingRequests.any((r) => r['to_user'] == uId);
                        final bool isIncomingPending = incomingIds.contains(uId);
                        Widget trailing;
                        if (isFriend) {
                          trailing = const Icon(Icons.check, color: Colors.green);
                        } else if (isOutgoingPending) {
                          final requestId = outgoingRequests.firstWhere((r) => r['to_user'] == uId)['id'] as int;
                          trailing = Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Pending'),
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert),
                                onSelected: (value) async {
                                  if (value == 'cancel') {
                                    bool? confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Confirm Cancel'),
                                          content: Text('Are you sure you want to cancel the friend request to ${user['name']}?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('No'),
                                              onPressed: () => Navigator.of(context).pop(false),
                                            ),
                                            TextButton(
                                              child: const Text('Yes'),
                                              onPressed: () => Navigator.of(context).pop(true),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (confirm == true) {
                                      final messenger = ScaffoldMessenger.of(context);
                                      try {
                                        await FriendService().cancelFriendRequest(requestId);
                                        await _refreshPendings();
                                        if (mounted) {
                                          messenger.showSnackBar(
                                            const SnackBar(content: Text('Friend request cancelled!')),
                                          );
                                        }
                                      } catch (e) {
                                        if (mounted) {
                                          messenger.showSnackBar(
                                            SnackBar(content: Text('Error: $e')),
                                          );
                                        }
                                      }
                                    }
                                  }
                                },
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'cancel',
                                    child: Text('Cancel Friend Request'),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else if (isIncomingPending) {
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
                                  await _refreshPendings();
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