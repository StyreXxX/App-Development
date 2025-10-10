import 'package:blood_app/components/my_button.dart';
import 'package:blood_app/components/my_textfield.dart';
import 'package:blood_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key, required this.onTap});

  // Controllers for all fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();

  final void Function()? onTap;

  void register(BuildContext context) async {
    final _auth = AuthService();

    // Validate password match
    if (_passwordController.text != _confirmPasswordController.text) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Passwords don't match"),
        ),
      );
      return;
    }

    // Validate all fields are filled
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _bloodGroupController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Please fill all fields"),
        ),
      );
      return;
    }

    // Validate blood group format (e.g., A+, A-, B+, etc.)
    final bloodGroupPattern = RegExp(r'^(A|B|AB|O)[+-]$');
    if (!bloodGroupPattern.hasMatch(_bloodGroupController.text)) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Invalid blood group (e.g., A+, B-, AB-, O+)"),
        ),
      );
      return;
    }

    // Register the user and save their info to Firestore
    try {
      await _auth.registerWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
        _addressController.text,
        _phoneNumberController.text,
        _bloodGroupController.text,
      );
      // Navigate to homepage on success
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/chokrobyte.jpg', width: 100, height: 100,),
              const SizedBox(height: 50),
              Text(
                "Let's create an account for you",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 25),
              MyTextField(
                hintText: 'Email',
                obscureText: false,
                controller: _emailController,
              ),
              const SizedBox(height: 10),
              MyTextField(
                hintText: 'Password',
                obscureText: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 10),
              MyTextField(
                hintText: 'Confirm Password',
                obscureText: true,
                controller: _confirmPasswordController,
              ),
              const SizedBox(height: 10),
              MyTextField(
                hintText: 'Name',
                obscureText: false,
                controller: _nameController,
              ),
              const SizedBox(height: 10),
              MyTextField(
                hintText: 'Address',
                obscureText: false,
                controller: _addressController,
              ),
              const SizedBox(height: 10),
              MyTextField(
                hintText: 'Phone Number',
                obscureText: false,
                controller: _phoneNumberController,
              ),
              const SizedBox(height: 10),
              MyTextField(
                hintText: 'Blood Group (e.g., A+)',
                obscureText: false,
                controller: _bloodGroupController,
              ),
              const SizedBox(height: 25),
              MyButton(
                text: 'Register',
                onTap: () => register(context),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already a member?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      " Login",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}