import 'package:flutter/material.dart';
import 'package:profile_app2/Pages/edit_age_page.dart';
import 'package:profile_app2/Pages/help_center_page.dart';
import 'package:profile_app2/Pages/settings_page.dart';
import 'package:profile_app2/theme/theme_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/register_page.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';
import 'pages/edit_name_page.dart';
import 'pages/edit_password_page.dart';
import 'pages/edit_profile_pic_page.dart';
import 'theme/theme_config.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: '', 
    anonKey: '', 
  );

  final supabase = Supabase.instance.client;
  final initialRoute = supabase.auth.currentSession != null ? '/home' : '/login';

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Supabase Flutter App',
          theme: ThemeConfig.lightTheme,
          darkTheme: ThemeConfig.darkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: initialRoute,
          routes: {
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/home': (context) => const HomePage(),
            '/profile': (context) => const ProfilePage(),
            '/edit_name': (context) => const EditNamePage(),
            '/edit_password': (context) => const EditPasswordPage(),
            '/edit_profile_pic': (context) => const EditProfilePicPage(),
            '/settings': (context) => const SettingsPage(),
            '/helpcenter': (context) => const HelpCenterPage(),
            '/edit_age': (context) => const EditAgePage(),
          },
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

/*
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

 */