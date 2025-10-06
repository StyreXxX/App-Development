import 'package:flutter/material.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            ListTile(
              leading: Icon(Icons.info_outline, color: Colors.orange),
              title: Text('FAQ'),
              subtitle: Text('Frequently Asked Questions'),
            ),
            ListTile(
              leading: Icon(Icons.contact_support, color: Colors.orange),
              title: Text('Contact Support'),
              subtitle: Text('Get in touch with our team'),
            ),
            ListTile(
              leading: Icon(Icons.book, color: Colors.orange),
              title: Text('User Guide'),
              subtitle: Text('Learn how to use the app'),
            ),
          ],
        ),
      ),
    );
  }
}