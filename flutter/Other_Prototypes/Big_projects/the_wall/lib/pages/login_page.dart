import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_wall/components/button.dart';
import 'package:the_wall/components/text_field.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessege(e.code);
    }
  }

  void displayMessege(String messege) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(messege),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo
              Icon(Icons.lock, size: 100),
              const SizedBox(
                height: 50,
              ),
              //welcome back messege
              Text("Welcome Back! You have been missed"),
              const SizedBox(height: 25),
              //email textfield
              MyTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureTest: false),
              const SizedBox(
                height: 20,
              ),
              //password textfield
              MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureTest: true),
              const SizedBox(
                height: 20,
              ),
              //signin button
              MyButton(onTap: signIn, text: "Sign in"),
              const SizedBox(
                height: 15,
              ),
              //go to register page
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member?",
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Register Now!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700]),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
