import 'package:flutter/material.dart';
import 'package:voice_assistant/screens/profile_screen.dart';

import 'package:voice_assistant/screens/widgets/styles.dart';

import 'package:voice_assistant/screens/splash_screen.dart';
import 'package:voice_assistant/screens/home_screen.dart';
import 'package:voice_assistant/screens/success_login_screen.dart';

class AppDrawer extends StatelessWidget {
  final String username;

  AppDrawer({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              children: [
                DrawerHeader(
                  child: Icon(
                    Icons.account_circle,
                    size: 80,
                    color: Colors.pink[100],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('H O M E'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('P R O F I L E'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('T E S T I N G'),
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 40.0),
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('L O G O U T'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SplashScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
