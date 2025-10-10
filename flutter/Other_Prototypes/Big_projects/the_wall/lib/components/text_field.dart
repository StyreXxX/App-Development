import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureTest;

  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureTest});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureTest,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ), 
        hintText: hintText,
        fillColor: Theme.of(context).colorScheme.primary,
        filled: true,
        hintStyle: TextStyle(color: Colors.grey[500])
      ),
    );
  }
}
