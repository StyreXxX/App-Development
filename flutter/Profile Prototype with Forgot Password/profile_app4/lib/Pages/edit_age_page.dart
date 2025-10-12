import 'package:flutter/material.dart';
import 'package:profile_app4/services/form_handler.dart';
import '../auth/supabase_auth.dart';

class EditAgePage extends StatefulWidget {
  const EditAgePage({super.key});

  @override
  State<EditAgePage> createState() => _EditAgePageState();
}

class _EditAgePageState extends State<EditAgePage> with FormHandler {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _updateAge() async {
    await handleFormSubmission(
      context: context,
      formKey: _formKey,
      validate: () => _formKey.currentState!.validate(),
      action: () => SupabaseAuth().updateAge(newAge: int.parse(_ageController.text)),
      successMessage: 'Age updated successfully',
      errorMessage: 'Failed to update age',
      onSuccess: () => Navigator.pop(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Age')),
      body: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 500),
        child: buildForm(
          context: context,
          formKey: _formKey,
          children: [
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'New Age'),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a new age' : null,
            ),
            const SizedBox(height: 24),
            buildSubmitButton('Update Age', _updateAge),
          ],
        ),
      ),
    );
  }
}
