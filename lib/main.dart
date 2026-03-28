// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
//firebase imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackify_app/add_expense_screen.dart';
import 'package:trackify_app/home_screen.dart';
import 'package:trackify_app/login_screen.dart';
import 'package:trackify_app/profile_screen.dart';
// Providers
import 'package:trackify_app/providers/theme_provider.dart';
import 'package:trackify_app/providers/expense_provider.dart';
// Screens
import 'package:trackify_app/screens/splash_screen.dart';
import 'package:trackify_app/screens/login_screen.dart';
import 'package:trackify_app/screens/signup_screen.dart';
import 'package:trackify_app/screens/home_screen.dart';
import 'package:trackify_app/screens/add_expense_screen.dart'; 
import 'package:trackify_app/screens/profile_screen.dart';     
import 'package:trackify_app/screens/settings_screen.dart';
import 'package:trackify_app/settings_screen.dart';
import 'package:trackify_app/signup_screen.dart';
import 'package:trackify_app/splash_screen.dart';    

// --- Global Colors ---
const Color primaryBlue = Color(0xFF00B2E7);
const Color primaryPink = Color(0xFFE064F7);
const LinearGradient mainGradient = LinearGradient(
  colors: [primaryBlue, primaryPink],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

void main() async {

  WidgetsFlutterBinding.ensureInitialized();              //firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  runApp(
    // 1. Wrap the App in MultiProvider to enable State Management
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Listen to Theme Changes
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Trackify',
      debugShowCheckedModeBanner: false,
      
      // Light Theme
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey.shade100,
        primaryColor: primaryBlue,
        cardColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      
      // Dark Theme
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: primaryBlue,
        cardColor: const Color(0xFF1E1E1E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      
      themeMode: themeProvider.themeMode, 
      
      initialRoute: '/splash', 
      
      // All app routes are defined here
      routes: {
        // Authentication Flow
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        
        // Main App Flow
        '/home': (context) => const HomeScreen(),
        
        // Utility/Navigation Routes
        '/add_expense': (context) => const AddExpenseScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}