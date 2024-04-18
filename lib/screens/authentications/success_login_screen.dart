// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import 'package:voice_assistant/screens/authentications/welcome_screen.dart';

// // Define SuccessLoginScreen Widget
// class SuccessLoginScreen extends StatelessWidget {
//   final String username;
//   SuccessLoginScreen({super.key, required this.username});

//   // Get the current user
//   final user = FirebaseAuth.instance.currentUser!;

//   // Sign the user out and navigate to the welcome screen
//   Future<void> signUserOut(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const WelcomeScreen(),
//       ),
//     );
//   }

//   // Build method for widget
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[300],
//       appBar: AppBar(
//         backgroundColor: Colors.grey[200],
//         actions: [
//           // Add logout button that signs out the user and navigates to the welcome screen
//           IconButton(
//             onPressed: () => signUserOut(context),
//             icon: const Icon(Icons.logout),
//           )
//         ],
//       ),
//       body: Center(
//         // Display a welcome message with the user's email
//         child: Text(
//           "Hope to see you soon, $username !\n\nEmail: ${user.email}\n\nClick the buttons on the left and right sides to return to the login page.",
//           style: const TextStyle(fontSize: 20),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
// }
