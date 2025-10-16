import 'package:flutter/material.dart';
import 'package:profile_app4/auth/supabase_auth.dart';
import 'package:profile_app4/services/form_handler.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> with FormHandler {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    await handleFormSubmission(
      context: context,
      formKey: _formKey,
      validate: () => _formKey.currentState!.validate(),
      action: () => SupabaseAuth().recoverPassword(newPassword),
      successMessage: 'Password reset successful! You can now log in.',
      errorMessage: 'Reset failed',
      onSuccess: () {
        Navigator.pushReplacementNamed(context, '/login');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password'), centerTitle: true,),
      body: buildForm(
        context: context,
        formKey: _formKey,
        children: [
          const Text('Enter your new password below.'),
          const SizedBox(height: 24),
          TextFormField(
            controller: _newPasswordController,
            decoration: const InputDecoration(labelText: 'New Password'),
            obscureText: true,
            validator: (value) =>
                value!.length < 6 ? 'Password must be at least 6 characters' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: const InputDecoration(labelText: 'Confirm Password'),
            obscureText: true,
            validator: (value) =>
                value!.length < 6 ? 'Password must be at least 6 characters' : null,
          ),
          const SizedBox(height: 24),
          buildSubmitButton('Reset Password', _resetPassword),
        ],
      ),
    );
  }
}