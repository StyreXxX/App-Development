import 'package:flutter/material.dart';
import 'package:profile_app4/services/form_handler.dart';
import '../auth/supabase_auth.dart';

class EditNamePage extends StatefulWidget {
  const EditNamePage({super.key});

  @override
  State<EditNamePage> createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> with FormHandler {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _updateName() async {
    await handleFormSubmission(
      context: context,
      formKey: _formKey,
      validate: () => _formKey.currentState!.validate(),
      action: () => SupabaseAuth().updateName(
        newName: _nameController.text,
        password: _passwordController.text,
      ),
      successMessage: 'Name updated successfully',
      errorMessage: 'Failed to update name',
      onSuccess: () => Navigator.pop(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Name'), centerTitle: true,),
      body: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 500),
        child: buildForm(
          context: context,
          formKey: _formKey,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'New Name'),
              validator: (value) => value!.isEmpty ? 'Please enter a new name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Current Password'),
              obscureText: true,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter your current password' : null,
            ),
            const SizedBox(height: 24),
            buildSubmitButton('Update Name', _updateName),
          ],
        ),
      ),
    );
  }
}