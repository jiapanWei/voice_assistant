import 'package:flutter/material.dart';

import 'package:voice_assistant/screens/widgets/styles.dart';

import 'package:voice_assistant/screens/splash_screen.dart';
import 'package:voice_assistant/screens/home_screen.dart';
import 'package:voice_assistant/screens/authentications/success_login_screen.dart';

class AppDrawer extends StatelessWidget {
  final String username;

  AppDrawer({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.deepPurple[200],
        child: ListView(
          children: [
            DrawerHeader(
              child: Text(
                'L O G O',
                style: headingPoppinsFontStyle(),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(username: username),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SuccessLoginScreen(username: username),
                  ),
                );
              },
            ),
            // add logout
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SplashScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
