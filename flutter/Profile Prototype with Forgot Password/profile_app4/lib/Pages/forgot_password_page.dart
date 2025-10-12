import 'package:flutter/material.dart';
import 'package:profile_app4/auth/supabase_auth.dart';
import 'package:profile_app4/services/form_handler.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> with FormHandler {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendReset() async {
    await handleFormSubmission(
      context: context,
      formKey: _formKey,
      validate: () => _formKey.currentState!.validate(),
      action: () => SupabaseAuth().sendPasswordReset(_emailController.text),
      successMessage: 'Password reset email sent! Check your inbox.',
      errorMessage: 'Failed to send reset email',
      onSuccess: () => Navigator.pushNamed(
        context,
        '/verify_recovery_otp',
        arguments: _emailController.text,  // Pass email
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: buildForm(
        context: context,
        formKey: _formKey,
        children: [
          const Text('Enter your email to receive a password reset link.'),
          const SizedBox(height: 24),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) => value!.isEmpty || !value.contains('@')
                ? 'Please enter a valid email'
                : null,
          ),
          const SizedBox(height: 24),
          buildSubmitButton('Send Reset Link', _sendReset),
        ],
      ),
    );
  }
}