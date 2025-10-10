import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/register_page.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';
import 'pages/edit_name_page.dart';
import 'pages/edit_password_page.dart';
import 'pages/edit_profile_pic_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://zurcddzvrdcpcpctylsh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp1cmNkZHp2cmRjcGNwY3R5bHNoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk1ODc2NDMsImV4cCI6MjA3NTE2MzY0M30._ChqkSrKcuKH2QS-6he2r6C2kxqn87dBQIueB4rRUaM',
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/edit_name': (context) => const EditNamePage(),
        '/edit_password': (context) => const EditPasswordPage(),
        '/edit_profile_pic': (context) => const EditProfilePicPage(),
      },
    );
  }
}