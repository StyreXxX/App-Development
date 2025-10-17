-- Create profiles table to store user data
CREATE TABLE profiles (
    user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    age INTEGER NOT NULL CHECK (age > 0),
    email TEXT NOT NULL,
    profile_pic_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Enable Row Level Security (RLS) on profiles table
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Policy: Allow users to view their own profile
CREATE POLICY "Users can view their own profile" ON profiles
    FOR SELECT
    USING (auth.uid() = user_id);

-- Policy: Allow users to insert their own profile
CREATE POLICY "Users can insert their own profile" ON profiles
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Policy: Allow users to update their own profile
CREATE POLICY "Users can update their own profile" ON profiles
    FOR UPDATE
    USING (auth.uid() = user_id);

-- Create storage bucket for profile pictures
INSERT INTO storage.buckets (id, name, public)
VALUES ('profile_pics', 'profile_pics', true)
ON CONFLICT (id) DO NOTHING;

-- Policy: Allow public read access to profile pictures
CREATE POLICY "Allow public read on profile pics"
ON storage.objects FOR SELECT
USING (bucket_id = 'profile_pics');

-- Policy: Allow authenticated users to upload their own profile picture
CREATE POLICY "Allow user to upload own profile pic"
ON storage.objects FOR INSERT
WITH CHECK (
    bucket_id = 'profile_pics'
    AND auth.uid()::text = split_part(name, '.', 1)
);

-- Policy: Allow authenticated users to update their own profile picture
CREATE POLICY "Allow user to update own profile pic"
ON storage.objects FOR UPDATE
USING (
    bucket_id = 'profile_pics'
    AND auth.uid()::text = split_part(name, '.', 1)
);

-- Policy: Allow authenticated users to delete their own profile picture
CREATE POLICY "Allow user to delete own profile pic"
ON storage.objects FOR DELETE
USING (
    bucket_id = 'profile_pics'
    AND auth.uid()::text = split_part(name, '.', 1)
);

-- Create index on user_id for performance (optional, as PRIMARY KEY already indexes)
CREATE INDEX IF NOT EXISTS profiles_user_id_idx ON profiles (user_id);


-- Drop the old select policy if it exists
DROP POLICY IF EXISTS "Users can view their own profile" ON profiles;

-- New Policy: Allow authenticated users to view all profiles
CREATE POLICY "Authenticated users can view all profiles" ON profiles
    FOR SELECT
    USING (auth.role() = 'authenticated');

-- Create index on user_id for performance (optional, as PRIMARY KEY already indexes)
CREATE INDEX IF NOT EXISTS profiles_user_id_idx ON profiles (user_id);

-- New table for friend requests
CREATE TABLE friend_requests (
    id SERIAL PRIMARY KEY,
    from_user UUID NOT NULL REFERENCES profiles(user_id) ON DELETE CASCADE,
    to_user UUID NOT NULL REFERENCES profiles(user_id) ON DELETE CASCADE,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Enable RLS on friend_requests
ALTER TABLE friend_requests ENABLE ROW LEVEL SECURITY;

-- Policy: Allow authenticated users to insert their own requests
CREATE POLICY "Users can insert friend requests" ON friend_requests
    FOR INSERT
    WITH CHECK (auth.uid() = from_user);

-- Policy: Allow users to view their own sent and received requests
CREATE POLICY "Users can view own requests" ON friend_requests
    FOR SELECT
    USING (auth.uid() = from_user OR auth.uid() = to_user);

-- Policy: Allow receivers to update status of requests
CREATE POLICY "Receivers can update request status" ON friend_requests
    FOR UPDATE
    USING (auth.uid() = to_user);

-- New table for friendships (undirected, using CHECK to avoid duplicates)
CREATE TABLE friendships (
    user1 UUID NOT NULL REFERENCES profiles(user_id) ON DELETE CASCADE,
    user2 UUID NOT NULL REFERENCES profiles(user_id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user1, user2),
    CHECK (user1 < user2)
);

-- Enable RLS on friendships
ALTER TABLE friendships ENABLE ROW LEVEL SECURITY;

-- Policy: Allow authenticated users to insert friendships (but in practice, this will be done after accepting requests)
CREATE POLICY "Users can insert friendships" ON friendships
    FOR INSERT
    WITH CHECK (true); -- Since we'll handle logic in code, but restrict to authenticated

-- Policy: Allow users to view their own friendships
CREATE POLICY "Users can view own friendships" ON friendships
    FOR SELECT
    USING (auth.uid() = user1 OR auth.uid() = user2);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS friend_requests_from_user_idx ON friend_requests (from_user);
CREATE INDEX IF NOT EXISTS friend_requests_to_user_idx ON friend_requests (to_user);
CREATE INDEX IF NOT EXISTS friendships_user1_idx ON friendships (user1);
CREATE INDEX IF NOT EXISTS friendships_user2_idx ON friendships (user2);

-- New Policy: Allow users to delete their own friendships
CREATE POLICY "Users can delete own friendships" ON friendships
FOR DELETE
USING (auth.uid() = user1 OR auth.uid() = user2);

-- Enable Realtime for friend_requests table
ALTER PUBLICATION supabase_realtime ADD TABLE friend_requests;
-- Optionally, enable Realtime for friendships table if needed in the future
ALTER PUBLICATION supabase_realtime ADD TABLE friendships;

-- Add policy for senders to cancel (delete) pending friend requests
CREATE POLICY "Senders can cancel pending requests" ON friend_requests
    FOR DELETE
    USING (auth.uid() = from_user AND status = 'pending');

-- Create messages table
CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    from_user UUID NOT NULL REFERENCES profiles(user_id) ON DELETE CASCADE,
    to_user UUID NOT NULL REFERENCES profiles(user_id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Enable RLS on messages
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- Policy: Allow users to send messages to friends
CREATE POLICY "Users can send messages to friends" ON messages
    FOR INSERT
    WITH CHECK (
        auth.uid() = from_user
        AND EXISTS (
            SELECT 1 FROM friendships
            WHERE (user1 = from_user AND user2 = to_user) OR (user1 = to_user AND user2 = from_user)
        )
    );

-- Policy: Allow users to view messages in their chats
CREATE POLICY "Users can view own messages" ON messages
    FOR SELECT
    USING (auth.uid() = from_user OR auth.uid() = to_user);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS messages_from_user_idx ON messages (from_user);
CREATE INDEX IF NOT EXISTS messages_to_user_idx ON messages (to_user);
CREATE INDEX IF NOT EXISTS messages_created_at_idx ON messages (created_at);

-- Enable Realtime for messages table
ALTER PUBLICATION supabase_realtime ADD TABLE messages;

-- Create storage bucket for post images
INSERT INTO storage.buckets (id, name, public)
VALUES ('post_images', 'post_images', true)
ON CONFLICT (id) DO NOTHING;

-- Policy: Allow public read access to post images
CREATE POLICY "Allow public read on post images"
ON storage.objects FOR SELECT
USING (bucket_id = 'post_images');

-- Policy: Allow authenticated users to upload images for their posts
CREATE POLICY "Allow user to upload post images"
ON storage.objects FOR INSERT
WITH CHECK (
    bucket_id = 'post_images'
    AND auth.role() = 'authenticated'
);

-- Policy: Allow authenticated users to update their post images
CREATE POLICY "Allow user to update post images"
ON storage.objects FOR UPDATE
USING (
    bucket_id = 'post_images'
    AND auth.role() = 'authenticated'
);

-- Policy: Allow authenticated users to delete their post images
CREATE POLICY "Allow user to delete post images"
ON storage.objects FOR DELETE
USING (
    bucket_id = 'post_images'
    AND auth.role() = 'authenticated'
);

-- Create posts table
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES profiles(user_id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Enable RLS on posts
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;

-- Policy: Allow authenticated users to insert their own posts
CREATE POLICY "Users can insert own posts" ON posts
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Policy: Allow authenticated users to view all posts
CREATE POLICY "Authenticated users can view all posts" ON posts
    FOR SELECT
    USING (auth.role() = 'authenticated');

-- Policy: Allow users to update their own posts
CREATE POLICY "Users can update own posts" ON posts
    FOR UPDATE
    USING (auth.uid() = user_id);

-- Policy: Allow users to delete their own posts
CREATE POLICY "Users can delete own posts" ON posts
    FOR DELETE
    USING (auth.uid() = user_id);

-- Indexes for posts
CREATE INDEX IF NOT EXISTS posts_user_id_idx ON posts (user_id);
CREATE INDEX IF NOT EXISTS posts_created_at_idx ON posts (created_at DESC);

-- Create likes table
CREATE TABLE likes (
    id SERIAL PRIMARY KEY,
    post_id INTEGER NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES profiles(user_id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (post_id, user_id) -- Prevent duplicate likes
);

-- Enable RLS on likes
ALTER TABLE likes ENABLE ROW LEVEL SECURITY;

-- Policy: Allow authenticated users to insert their own likes
CREATE POLICY "Users can insert own likes" ON likes
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Policy: Allow authenticated users to view all likes
CREATE POLICY "Authenticated users can view all likes" ON likes
    FOR SELECT
    USING (auth.role() = 'authenticated');

-- Policy: Allow users to delete their own likes
CREATE POLICY "Users can delete own likes" ON likes
    FOR DELETE
    USING (auth.uid() = user_id);

-- Indexes for likes
CREATE INDEX IF NOT EXISTS likes_post_id_idx ON likes (post_id);
CREATE INDEX IF NOT EXISTS likes_user_id_idx ON likes (user_id);

-- Create comments table
CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    post_id INTEGER NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES profiles(user_id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Enable RLS on comments
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;

-- Policy: Allow authenticated users to insert their own comments
CREATE POLICY "Users can insert own comments" ON comments
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Policy: Allow authenticated users to view all comments
CREATE POLICY "Authenticated users can view all comments" ON comments
    FOR SELECT
    USING (auth.role() = 'authenticated');

-- Policy: Allow users to update their own comments
CREATE POLICY "Users can update own comments" ON comments
    FOR UPDATE
    USING (auth.uid() = user_id);

-- Policy: Allow users to delete their own comments
CREATE POLICY "Users can delete own comments" ON comments
    FOR DELETE
    USING (auth.uid() = user_id);

-- Indexes for comments
CREATE INDEX IF NOT EXISTS comments_post_id_idx ON comments (post_id);
CREATE INDEX IF NOT EXISTS comments_user_id_idx ON comments (user_id);
CREATE INDEX IF NOT EXISTS comments_created_at_idx ON comments (created_at DESC);

-- Enable Realtime for new tables
ALTER PUBLICATION supabase_realtime ADD TABLE posts;
ALTER PUBLICATION supabase_realtime ADD TABLE likes;
ALTER PUBLICATION supabase_realtime ADD TABLE comments;

-- Create notifications table
CREATE TABLE notifications (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES profiles(user_id) ON DELETE CASCADE,
    type TEXT NOT NULL CHECK (type IN ('like', 'comment')),
    post_id INTEGER NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    trigger_user_id UUID NOT NULL REFERENCES profiles(user_id) ON DELETE CASCADE,
    content TEXT NOT NULL, -- e.g., "Someone commented on your post recently"
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Enable RLS on notifications
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Policy: Allow users to view their own notifications
CREATE POLICY "Users can view own notifications" ON notifications
    FOR SELECT
    USING (auth.uid() = user_id);

-- Policy: Allow users to update their own notifications (e.g., mark as read)
CREATE POLICY "Users can update own notifications" ON notifications
    FOR UPDATE
    USING (auth.uid() = user_id);

-- Policy: Allow users to delete their own notifications
CREATE POLICY "Users can delete own notifications" ON notifications
    FOR DELETE
    USING (auth.uid() = user_id);

-- Policy: Allow authenticated users to insert notifications for others
CREATE POLICY "Authenticated users can insert notifications" ON notifications
    FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

-- Indexes for performance
CREATE INDEX IF NOT EXISTS notifications_user_id_idx ON notifications (user_id);
CREATE INDEX IF NOT EXISTS notifications_post_id_idx ON notifications (post_id);
CREATE INDEX IF NOT EXISTS notifications_created_at_idx ON notifications (created_at DESC);

-- Enable Realtime for notifications table
ALTER PUBLICATION supabase_realtime ADD TABLE notifications;

-- Function to create notifications for likes
CREATE OR REPLACE FUNCTION notify_like()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO notifications (user_id, type, post_id, trigger_user_id, content)
    SELECT p.user_id, 'like', NEW.post_id, NEW.user_id, 
           (SELECT name FROM profiles WHERE user_id = NEW.user_id) || ' liked your post recently'
    FROM posts p
    WHERE p.id = NEW.post_id
    AND p.user_id != NEW.user_id; -- Don't notify if user likes their own post
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for likes
CREATE TRIGGER trigger_notify_like
AFTER INSERT ON likes
FOR EACH ROW
EXECUTE FUNCTION notify_like();

-- Function to create notifications for comments
CREATE OR REPLACE FUNCTION notify_comment()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO notifications (user_id, type, post_id, trigger_user_id, content)
    SELECT p.user_id, 'comment', NEW.post_id, NEW.user_id, 
           (SELECT name FROM profiles WHERE user_id = NEW.user_id) || ' commented on your post recently'
    FROM posts p
    WHERE p.id = NEW.post_id
    AND p.user_id != NEW.user_id; -- Don't notify if user comments on their own post
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for comments
CREATE TRIGGER trigger_notify_comment
AFTER INSERT ON comments
FOR EACH ROW
EXECUTE FUNCTION notify_comment();

-- Create support_requests table
CREATE TABLE support_requests (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES profiles(user_id) ON DELETE CASCADE,
    subject TEXT NOT NULL,
    body TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Enable RLS on support_requests
ALTER TABLE support_requests ENABLE ROW LEVEL SECURITY;

-- Policy: Allow authenticated users to insert their own support requests
CREATE POLICY "Users can insert own support requests" ON support_requests
    FOR INSERT
    WITH CHECK (auth.role() = 'authenticated' AND auth.uid() = user_id);

-- Policy: Allow admins to view all support requests (assuming admin role or specific user)
-- You may need to adjust this based on your admin setup
CREATE POLICY "Admins can view support requests" ON support_requests
    FOR SELECT
    USING (auth.role() = 'service_role');  -- Or use a specific condition for admins

-- Indexes for performance
CREATE INDEX IF NOT EXISTS support_requests_user_id_idx ON support_requests (user_id);
CREATE INDEX IF NOT EXISTS support_requests_created_at_idx ON support_requests (created_at DESC);