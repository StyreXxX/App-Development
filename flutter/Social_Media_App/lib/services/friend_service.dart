import 'package:supabase_flutter/supabase_flutter.dart';

class FriendService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> sendFriendRequest(String toUserId) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    // Check if pending request already exists from this user
    final existingRequest = await supabase
        .from('friend_requests')
        .select()
        .eq('from_user', user.id)
        .eq('to_user', toUserId)
        .eq('status', 'pending')
        .maybeSingle();

    if (existingRequest != null) {
      throw Exception('Friend request already sent');
    }

    // Check if pending request exists from the other user
    final oppositeRequest = await supabase
        .from('friend_requests')
        .select()
        .eq('from_user', toUserId)
        .eq('to_user', user.id)
        .eq('status', 'pending')
        .maybeSingle();

    if (oppositeRequest != null) {
      throw Exception('Friend request already pending from the other user');
    }

    final isFriends = await _checkIfFriends(user.id, toUserId);
    if (isFriends) {
      throw Exception('Already friends');
    }

    await supabase.from('friend_requests').insert({
      'from_user': user.id,
      'to_user': toUserId,
    });
  }

  Future<List<Map<String, dynamic>>> getPendingRequests() async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    return await supabase
        .from('friend_requests')
        .select('*, from_profile:profiles!friend_requests_from_user_fkey(name, age, profile_pic_url)')
        .eq('to_user', user.id)
        .eq('status', 'pending');
  }

  Future<int> getPendingRequestsCount() async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    final response = await supabase
        .from('friend_requests')
        .select()
        .eq('to_user', user.id)
        .eq('status', 'pending')
        .count(CountOption.exact);

    return response.count;
  }

  Future<List<Map<String, dynamic>>> getSentPendingRequests() async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    return await supabase
        .from('friend_requests')
        .select('id, to_user')
        .eq('from_user', user.id)
        .eq('status', 'pending');
  }

  Future<void> acceptRequest(int requestId, String fromUserId) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    await supabase
        .from('friend_requests')
        .update({'status': 'accepted'})
        .eq('id', requestId)
        .eq('to_user', user.id);

    // Add to friendships
    final user1 = user.id.compareTo(fromUserId) < 0 ? user.id : fromUserId;
    final user2 = user.id.compareTo(fromUserId) < 0 ? fromUserId : user.id;
    await supabase.from('friendships').insert({
      'user1': user1,
      'user2': user2,
    });
  }

  Future<void> rejectRequest(int requestId) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    await supabase
        .from('friend_requests')
        .update({'status': 'rejected'})
        .eq('id', requestId)
        .eq('to_user', user.id);
  }

  Future<List<Map<String, dynamic>>> getFriends() async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    final friends1 = await supabase
        .from('friendships')
        .select('user2:profiles!friendships_user2_fkey(user_id, name, age, profile_pic_url)')
        .eq('user1', user.id);

    final friends2 = await supabase
        .from('friendships')
        .select('user1:profiles!friendships_user1_fkey(user_id, name, age, profile_pic_url)')
        .eq('user2', user.id);

    final List<Map<String, dynamic>> friends = [];
    for (var f in friends1) {
      friends.add(f['user2']);
    }
    for (var f in friends2) {
      friends.add(f['user1']);
    }

    return friends;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    return await supabase
        .from('profiles')
        .select('user_id, name, age, profile_pic_url')
        .neq('user_id', user.id); // Exclude self
  }

  Future<void> removeFriend(String friendId) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    final user1 = user.id.compareTo(friendId) < 0 ? user.id : friendId;
    final user2 = user.id.compareTo(friendId) < 0 ? friendId : user.id;

    await supabase
        .from('friendships')
        .delete()
        .eq('user1', user1)
        .eq('user2', user2);
  }

  Future<void> cancelFriendRequest(int requestId) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    await supabase
        .from('friend_requests')
        .delete()
        .eq('id', requestId)
        .eq('from_user', user.id);
  }

  Future<bool> _checkIfFriends(String userId1, String userId2) async {
    final user1 = userId1.compareTo(userId2) < 0 ? userId1 : userId2;
    final user2 = userId1.compareTo(userId2) < 0 ? userId2 : userId1;

    final result = await supabase
        .from('friendships')
        .select()
        .eq('user1', user1)
        .eq('user2', user2)
        .maybeSingle();

    return result != null;
  }
}