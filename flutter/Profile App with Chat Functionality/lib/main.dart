import 'package:flutter/material.dart';
import 'package:profile_app4/Pages/edit_age_page.dart';
import 'package:profile_app4/Pages/forgot_password_page.dart';
import 'package:profile_app4/Pages/friend_req_page.dart';
import 'package:profile_app4/Pages/help_center_page.dart';
import 'package:profile_app4/Pages/notification_page.dart';
import 'package:profile_app4/Pages/reset_password_page.dart';
import 'package:profile_app4/Pages/settings_page.dart';
import 'package:profile_app4/Pages/user_page.dart';
import 'package:profile_app4/Pages/friends_page.dart';
import 'package:profile_app4/Pages/verify_recovery_otp_page.dart';
import 'package:profile_app4/theme/theme_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/register_page.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';
import 'pages/edit_name_page.dart';
import 'pages/edit_password_page.dart';
import 'pages/edit_profile_pic_page.dart';
import 'pages/chat_page.dart'; // Add this import
import 'theme/theme_config.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://cqypdqnjalzgeiemilux.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNxeXBkcW5qYWx6Z2VpZW1pbHV4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk4MTk4ODMsImV4cCI6MjA3NTM5NTg4M30.c-PEega-uhnugH7Jc0hmdKqgM3Ki30bEIVbR52GJCk8',
    authOptions: const FlutterAuthClientOptions(),
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
            '/users': (context) => const UsersPage(),
            '/friends': (context) => const FriendsPage(),
            '/friend_requests': (context) => const FriendRequestsPage(),
            '/notifications': (context) => const NotificationsPage(),
            '/reset_password': (context) => const ResetPasswordPage(),
            '/forgot_password': (context) => const ForgotPasswordPage(),
            '/verify_recovery_otp': (context) => VerifyRecoveryOtpPage(
              email: ModalRoute.of(context)!.settings.arguments as String,
            ),
            '/chat': (context) { // Add this route
              final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
              return ChatPage(
                friendId: args['friendId'],
                friendName: args['friendName'],
              );
            },
          },
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}