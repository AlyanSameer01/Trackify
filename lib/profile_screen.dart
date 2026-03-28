import 'package:flutter/material.dart';
import 'package:trackify_app/main.dart'; // For custom colors (primaryBlue)

// Convert to StatefulWidget to ensure fresh state initialization
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Dummy user data moved to state variables
  // *** Values set as requested ***
  String userName = 'Alyan Sameer';
  String userEmail = 'alyansameer01@gmail.com';
  String memberSince = 'November 2025';

  @override
  void initState() {
    super.initState();
    // Although the data is static, using initState forces the values to be
    // bound during the initial creation of the state object.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            // MainAxisAlignment.start to position content neatly below the AppBar
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),

              // --- Profile Picture ---
              const CircleAvatar(
                radius: 70,
                backgroundColor: primaryBlue,
                child: Icon(Icons.person, size: 70, color: Colors.white),
              ),
              const SizedBox(height: 30),

              // --- User Details Card ---
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.badge, color: primaryBlue),
                        title: const Text('Name'),
                        trailing: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const Divider(height: 1, indent: 15, endIndent: 15),
                      ListTile(
                        leading: const Icon(Icons.email, color: primaryBlue),
                        title: const Text('Email'),
                        trailing: Text(userEmail, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const Divider(height: 1, indent: 15, endIndent: 15),
                      ListTile(
                        leading: const Icon(Icons.calendar_month, color: primaryBlue),
                        title: const Text('Member Since'),
                        trailing: Text(memberSince, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // --- Edit Profile Button ---
              OutlinedButton.icon(
                onPressed: () {
                    // Placeholder for navigating to an Edit Profile form
                    print("Navigate to Edit Profile screen...");
                },
                icon: const Icon(Icons.edit, color: primaryPink),
                label: const Text(
                  "Edit Profile",
                  style: TextStyle(color: primaryPink, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  side: const BorderSide(color: primaryPink, width: 2),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}