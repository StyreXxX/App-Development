import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_wall/components/button.dart';
import 'package:the_wall/components/text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUp(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    if (passwordController.text != confirmPasswordController.text) {
      Navigator.pop(context);
      displayMessege("Passwords don't match!");
      return;
    }
    try {
      //create the user
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      //after creating the user, create a new document in cloud firestore called Users
      FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email!)
          .set({
            'username': emailController.text.split('@')[0],
            'bio': 'Empty bio...'//initially empty
          });

      if (context.mounted){
        Navigator.pop(context);
      } 
    } on FirebaseAuthException catch (e) {
      if(context.mounted){
        Navigator.pop(context);
        displayMessege(e.code);
      }
    } catch(e){
      if(context.mounted){
        Navigator.pop(context);
        displayMessege("An error occurred: $e");
      }
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
              Text("Hello there, Lets make an account for you!"),
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
              MyTextField(
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  obscureTest: true),
              const SizedBox(
                height: 20,
              ),
              //signin button
              MyButton(onTap:()=> signUp(context), text: "Sign up"),
              const SizedBox(
                height: 15,
              ),
              //go to register page
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Login now",
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
