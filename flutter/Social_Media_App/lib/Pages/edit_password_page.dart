import 'package:flutter/material.dart';
import 'package:profile_app4/services/form_handler.dart';
import '../auth/supabase_auth.dart';

class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({super.key});

  @override
  State<EditPasswordPage> createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> with FormHandler {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    await handleFormSubmission(
      context: context,
      formKey: _formKey,
      validate: () => _formKey.currentState!.validate(),
      action: () => SupabaseAuth().updatePassword(
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
      ),
      successMessage: 'Password updated successfully',
      errorMessage: 'Failed to update password',
      onSuccess: () => Navigator.pop(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Password'), centerTitle: true,),
      body: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 500),
        child: buildForm(
          context: context,
          formKey: _formKey,
          children: [
            TextFormField(
              controller: _oldPasswordController,
              decoration: const InputDecoration(labelText: 'Current Password'),
              obscureText: true,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter your current password' : null,
            ),
            const SizedBox(height: 16),
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
              decoration: const InputDecoration(labelText: 'Confirm New Password'),
              obscureText: true,
              validator: (value) =>
                  value != _newPasswordController.text ? 'Passwords do not match' : null,
            ),
            const SizedBox(height: 24),
            buildSubmitButton('Update Password', _updatePassword),
          ],
        ),
      ),
    );
  }
}