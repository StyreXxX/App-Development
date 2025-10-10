import 'package:flutter/material.dart';

mixin FormHandler<T extends StatefulWidget> on State<T> {
  bool _isLoading = false;

  Widget buildForm({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required List<Widget> children,
  }) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: children,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSubmitButton(String label, VoidCallback onPressed) {
    return _isLoading
        ? const CircularProgressIndicator()
        : AnimatedScale(
            scale: _isLoading ? 0.8 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: ElevatedButton(
              onPressed: _isLoading ? null : onPressed,
              child: Text(label),
            ),
          );
  }

  Future<void> handleFormSubmission({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required bool Function() validate,
    required Future<void> Function() action,
    required String successMessage,
    required String errorMessage,
    required VoidCallback onSuccess,
  }) async {
    if (!validate()) return;

    if (mounted) setState(() => _isLoading = true);
    try {
      await action();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(successMessage)),
        );
        onSuccess();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$errorMessage: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}