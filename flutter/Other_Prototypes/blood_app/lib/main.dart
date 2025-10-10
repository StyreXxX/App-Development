import 'package:blood_app/pages/home_page.dart';
import 'package:blood_app/pages/login_page.dart';
import 'package:blood_app/pages/register_page.dart';
import 'package:blood_app/pages/settings_page.dart';
import 'package:blood_app/theme/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:blood_app/firebase_options.dart'; 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Blood Donation App',
          theme: themeProvider.themeData,
          routes: {
            '/login': (context) => LoginPage(
                  onTap: () => Navigator.pushReplacementNamed(context, '/register'),
                ),
            '/register': (context) => RegisterPage(
                  onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                ),
            '/home': (context) => const HomePage(),
            '/settings': (context) => const SettingsPage(),
          },
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasData) {
                return const HomePage();
              }
              return LoginPage(
                onTap: () => Navigator.pushReplacementNamed(context, '/register'),
              );
            },
          ),
        );
      },
    );
  }
}