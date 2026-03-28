// lib/screens/splash_screen.dart (Updated)
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:trackify_app/main.dart'; // Correct Project Name // Import main.dart for custom colors/gradients

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon/Logo (Placeholder - use an actual asset for your app)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: mainGradient, // Use the common gradient
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: primaryPink.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.account_balance_wallet_rounded, // Example icon
                size: 80,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            ShaderMask(
              shaderCallback: (bounds) => mainGradient.createShader(bounds),
              child: const Text(
                'Trackify', // Your app name
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Color is masked by the shader
                ),
              ),
            ),
            const SizedBox(height: 50),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryBlue), // Use blue accent
              strokeWidth: 4,
            ),
          ],
        ),
      ),
    );
  }
}