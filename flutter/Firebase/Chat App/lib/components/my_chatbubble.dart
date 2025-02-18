import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyChatBubble extends StatelessWidget {
  final String messege;
  final bool isCurrentUser;

  const MyChatBubble(
      {super.key, required this.messege, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Container(
        decoration: BoxDecoration(
            color: isCurrentUser
                ? (isDarkMode
                    ? const Color.fromARGB(255, 255, 211, 51)
                    : const Color.fromARGB(255, 255, 220, 94))
                : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 25),
        child: Text(messege, style: TextStyle(color: isDarkMode? Colors.white : Colors.black),));
  }
}
