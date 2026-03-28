import 'package:flutter/material.dart';
import 'package:trackify_app/add_expense_screen.dart';
import 'package:trackify_app/dashboard_screen.dart';
import 'package:trackify_app/main.dart'; // For primaryBlue, primaryPink, and mainGradient
import 'package:trackify_app/profile_screen.dart';
import 'package:trackify_app/screens/profile_screen.dart'; 
import 'package:trackify_app/screens/dashboard_screen.dart'; 
import 'package:trackify_app/screens/add_expense_screen.dart'; 
import 'package:trackify_app/screens/stats_screen.dart'; 
import 'package:trackify_app/screens/settings_screen.dart';
import 'package:trackify_app/settings_screen.dart';
import 'package:trackify_app/stats_screen.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardScreen(), // Index 0 (Home tab)
    const StatsScreen(),     // Index 1 (Chart tab)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- DRAWER (Side Menu) ---
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // User Profile Header inside Drawer
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(gradient: mainGradient),
              accountName: Text(
                "Alyan Sameer", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              accountEmail: Text("alyansameer01@gmail.com"), 
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: primaryBlue),
              ),
            ),
            
            // Drawer Items
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('My Profile'),
              onTap: () {
                Navigator.pop(context); 
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context); 
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Log Out', style: TextStyle(color: Colors.red)),
              onTap: () {
                 // Assumes '/login' is the route name defined in main.dart
                 Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      
      // AppBar
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? 'Dashboard' : 'Analytics'),
        centerTitle: true,
      ),

      // Body (Switches between Dashboard and Stats)
      body: _currentIndex == 0 ? _pages[0] : _pages[1],

      // --- BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: BottomNavigationBar(
        // Handles the fact that we have 3 visual icons but only 2 selectable pages (add opens a new screen)
        currentIndex: _currentIndex == 1 ? 2 : _currentIndex, 
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 1) {
            // Index 1 is the "Add" button -> Navigate to Add Screen
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AddExpenseScreen()));
          } else if (index == 2) {
            // Index 2 is "Chart" -> Show Stats Screen, which is page index 1
            setState(() {
              _currentIndex = 1; 
            });
          } else {
            // Index 0 is "Home" (Dashboard), which is page index 0
            setState(() {
              _currentIndex = 0;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 45, color: primaryPink),
            label: '', // No label for the big add button
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Chart',
            ),
        ],
      ),
    );
  }
}