import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voice_assistant/screens/authentications/welcome_screen.dart';

// Define SuccessLoginScreen widget
class SuccessLoginScreen extends StatelessWidget {
  final String username;

  // Constructor to receive the username
  SuccessLoginScreen({super.key, required this.username});

  // Get the current user
  final user = FirebaseAuth.instance.currentUser!;

  // Function to sign out the user and navigate back to the welcome screen
  Future<void> signUserOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        // Navigate to the welcome screen
        builder: (context) => const WelcomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        actions: [
          IconButton(
            onPressed: () => signUserOut(context),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Text(
          "Hope to see you soon, $username !\n\nEmail: ${user.email}\n\nClick the buttons on the left and right sides to return to the login page.",
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
