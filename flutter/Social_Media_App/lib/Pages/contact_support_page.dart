import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContactSupportPage extends StatefulWidget {
  const ContactSupportPage({super.key});

  @override
  State<ContactSupportPage> createState() => _ContactSupportPageState();
}

class _ContactSupportPageState extends State<ContactSupportPage> {
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  Future<void> _sendMessage() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final subject = _subjectController.text.trim();
    final body = _bodyController.text.trim();

    if (subject.isEmpty || body.isEmpty) {
      setState(() {
        _error = 'Please fill in both subject and message.';
        _isLoading = false;
      });
      return;
    }

    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw 'User not authenticated';
      }

      await supabase.from('support_requests').insert({
        'user_id': user.id,
        'subject': subject,
        'body': body,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message sent successfully!')),
      );
      _subjectController.clear();
      _bodyController.clear();
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _error = 'Failed to send message: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Support'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            if (_error != null)
              Text(
                _error!,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            SizedBox(height: 16),
            Center(
              child: _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _sendMessage,
                      child: Text('Send'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}