import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: theme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.secondary,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text("Profile Pic", style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              child: Text("Edit Profile Picture", style: TextStyle(color: theme.inversePrimary)),
            ),
            const SizedBox(height: 30),
            _buildInfoCard(context, "Name"),
            const SizedBox(height: 20),
            _buildInfoCard(context, "Email"),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(top: 280),
              child: TextButton(
                onPressed: () {},
                
                child: Text("Edit Profile", style: TextStyle(color: theme.inversePrimary, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}
