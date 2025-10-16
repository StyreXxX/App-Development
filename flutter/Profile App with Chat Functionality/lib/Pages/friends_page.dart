import 'package:flutter/material.dart';
import 'package:profile_app4/components/user_tile.dart';
import 'package:profile_app4/services/friend_service.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  List<Map<String, dynamic>> friends = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchFriends();
  }

  Future<void> _fetchFriends() async {
    try {
      final fetchedFriends = await FriendService().getFriends();
      if (mounted) {
        setState(() {
          friends = fetchedFriends;
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
    return Scaffold(
      appBar: AppBar(title: const Text('Friends'), centerTitle: true,),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text('Error: $error'))
              : friends.isEmpty
                  ? const Center(child: Text('no friends for now'))
                  : ListView.builder(
                      itemCount: friends.length,
                      itemBuilder: (context, index) {
                        final friend = friends[index];
                        return UserTile(
                          user: friend,
                          showAge: false,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.chat, color: theme.colorScheme.primary),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/chat',
                                    arguments: {
                                      'friendId': friend['user_id'],
                                      'friendName': friend['name'],
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: theme.colorScheme.error),
                                onPressed: () async {
                                  bool? confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirm Unfriend'),
                                        content: Text('Do you really want to unfriend ${friend['name']}?'),
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
                                    try {
                                      await FriendService().removeFriend(friend['user_id']);
                                      await _fetchFriends();
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Friend removed.')),
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