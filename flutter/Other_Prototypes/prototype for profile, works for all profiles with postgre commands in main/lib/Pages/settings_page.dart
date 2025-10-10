import 'package:flutter/material.dart';
import 'package:profile_app2/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Settings', style: theme.textTheme.headlineMedium),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: theme.colorScheme.background,
          ),
          Center(
            child: Card(
              margin: const EdgeInsets.all(16.0),
              color: theme.colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // Theme Toggle
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Text(
                        'Light Mode',
                        style: theme.textTheme.bodyMedium,
                      ),
                      trailing: Switch(
                        value: themeProvider.themeMode == ThemeMode.light,
                        onChanged: (value) {
                          themeProvider.toggleTheme(value ? ThemeMode.light : ThemeMode.dark);
                        },
                        activeColor: theme.colorScheme.primary,
                        activeTrackColor: theme.colorScheme.primary.withOpacity(0.5),
                        inactiveThumbColor: theme.colorScheme.onSurface.withOpacity(0.5),
                        inactiveTrackColor: theme.colorScheme.onSurface.withOpacity(0.3),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Change Password
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Text(
                        'Change Password',
                        style: theme.textTheme.bodyMedium,
                      ),
                      trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface),
                      onTap: () {
                        Navigator.pushNamed(context, '/edit_password');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}