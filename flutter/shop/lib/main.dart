import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Pages/auth_gate.dart';
import 'package:shop/Pages/forgot_password_page.dart';
import 'package:shop/Pages/login_page.dart';
import 'package:shop/Pages/register_page.dart';
import 'package:shop/Pages/welcome_page.dart';
import 'package:shop/theme/theme_config.dart';
import 'package:shop/theme/theme_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://hvvkvjzrfcqvxzzmmadp.supabase.co',
    anonKey: 'sb_publishable_wgt2LvHy4BwYsU5f2hI29Q_VHLnQo-z',
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Supabase Auth',
      theme: ThemeConfig.lightTheme,
      darkTheme: ThemeConfig.darkTheme,
      themeMode: themeProvider.themeMode,
      // Home is AuthGate, which decides between Welcome or Home
      home: const AuthGate(),
      routes: {
        '/welcome': (context) => const WelcomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/forgot_password': (context) => const ForgotPasswordPage(),
      },
    );
  }
}