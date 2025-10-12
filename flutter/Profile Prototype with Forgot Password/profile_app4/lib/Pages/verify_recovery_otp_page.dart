import 'package:flutter/material.dart';
import 'package:profile_app4/auth/supabase_auth.dart';
import 'package:profile_app4/services/form_handler.dart';

class VerifyRecoveryOtpPage extends StatefulWidget {
  final String email;

  const VerifyRecoveryOtpPage({super.key, required this.email});

  @override
  State<VerifyRecoveryOtpPage> createState() => _VerifyRecoveryOtpPageState();
}

class _VerifyRecoveryOtpPageState extends State<VerifyRecoveryOtpPage> with FormHandler {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();
    await handleFormSubmission(
      context: context,
      formKey: _formKey,
      validate: () => _formKey.currentState!.validate(),
      action: () => SupabaseAuth().verifyRecoveryOtp(widget.email, otp),
      successMessage: 'OTP verified! Now reset your password.',
      errorMessage: 'OTP verification failed',
      onSuccess: () => Navigator.pushReplacementNamed(context, '/reset_password'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: buildForm(
        context: context,
        formKey: _formKey,
        children: [
          Text('Enter the OTP sent to ${widget.email}.'),
          const SizedBox(height: 24),
          TextFormField(
            controller: _otpController,
            decoration: const InputDecoration(labelText: 'OTP Code'),
            keyboardType: TextInputType.number,
            validator: (value) => value!.length != 6 ? 'Enter a 6-digit code' : null,
          ),
          const SizedBox(height: 24),
          buildSubmitButton('Verify OTP', _verifyOtp),
        ],
      ),
    );
  }
}