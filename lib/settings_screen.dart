import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackify_app/providers/theme_provider.dart';
import 'package:trackify_app/main.dart'; // For primaryBlue color reference

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch the ThemeProvider to get the current theme state
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // --- Theme/Dark Mode Toggle ---
          Card(
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(
                themeProvider.isDarkMode ? Icons.wb_sunny : Icons.dark_mode, 
                color: themeProvider.isDarkMode ? Colors.orange : primaryBlue
              ),
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: themeProvider.isDarkMode,
                activeColor: primaryPink,
                onChanged: (value) => themeProvider.toggleTheme(value),
              ),
            ),
          ),
          
          const SizedBox(height: 10),

          // --- General Settings Section ---
          const Padding(
            padding: EdgeInsets.only(left: 8.0, top: 10, bottom: 5),
            child: Text(
              "GENERAL", 
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)
            ),
          ),

          // Notification Setting
          Card(
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: const ListTile(
              leading: Icon(Icons.notifications, color: primaryBlue),
              title: Text('Notification Preferences'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ),

          // Language Setting
          Card(
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: const ListTile(
              leading: Icon(Icons.language, color: primaryBlue),
              title: Text('Language'),
              trailing: Text('English', style: TextStyle(color: Colors.grey)),
            ),
          ),
          
          // --- Account Settings Section ---
          const Padding(
            padding: EdgeInsets.only(left: 8.0, top: 20, bottom: 5),
            child: Text(
              "ACCOUNT", 
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)
            ),
          ),

          // Change Password
          Card(
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: const ListTile(
              leading: Icon(Icons.security, color: primaryBlue),
              title: Text('Change Password'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ),
          
          // Privacy Policy (Placeholder)
          Card(
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: const ListTile(
              leading: Icon(Icons.policy, color: primaryBlue),
              title: Text('Privacy Policy'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}