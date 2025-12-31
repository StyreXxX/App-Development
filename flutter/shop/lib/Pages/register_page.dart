import 'package:flutter/material.dart';
import 'package:shop/auth/supabase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  
  final _authService = AuthService();
  bool _isLoading = false;

  void _register() async {
    if (_passController.text != _confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authService.signUp(
        email: _emailController.text.trim(),
        password: _passController.text.trim(),
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
      );
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Verify Email"),
            content: const Text("A confirmation email has been sent. Please check your inbox."),
            actions: [
              TextButton(
                onPressed: () {
                   Navigator.pop(context); // Close dialog
                   Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text("OK"),
              )
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Full Name")),
          const SizedBox(height: 12),
          TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
          const SizedBox(height: 12),
          TextField(controller: _phoneController, decoration: const InputDecoration(labelText: "Phone (Optional)")),
          const SizedBox(height: 12),
          TextField(controller: _passController, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
          const SizedBox(height: 12),
          TextField(controller: _confirmPassController, obscureText: true, decoration: const InputDecoration(labelText: "Confirm Password")),
          const SizedBox(height: 20),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(onPressed: _register, child: const Text("Register")),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account?"),
              TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text("Login")),
            ],
          ),
          TextButton(
              onPressed: () => Navigator.pushNamed(context, '/forgot_password'),
              child: const Text("Forgot Password?")),
        ],
      ),
    );
  }
}