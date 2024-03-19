import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voice_assistant/screens/start_screen.dart';

class SuccessLoginScreen extends StatelessWidget {
  SuccessLoginScreen({super.key});

  final user = FirebaseAuth.instance.currentUser!;

// sign user out method
  Future<void> signUserOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
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
      body: const Center(
        child: Text(
          "LOGGED IN SUCCESSFULLY",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
