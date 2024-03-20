import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voice_assistant/screens/widgets/avatar.dart';

import 'package:voice_assistant/screens/widgets/styles.dart';
import 'package:voice_assistant/screens/widgets/build_text_box.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection('users');
  final avatarSelected = AvatarSelected();

  Future<void> editField(String field) async {
    String newField = '';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $field'),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter new $field',
            ),
            onChanged: (value) {
              newField = value;
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () => Navigator.of(context).pop(newField),
            ),
          ],
        );
      },
    );

    if (newField.trim().length > 0) {
      await userCollection.doc(currentUser.uid).update({field: newField});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorPink,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: backgroundColorPink,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final avatarUrl = userData['avatar'] as String?;

            return ListView(
              children: [
                const SizedBox(height: 50),
                if (avatarUrl != null)
                  Image.network(avatarUrl, width: 70, height: 70)
                else
                  const Icon(Icons.person, size: 70, color: Colors.black),
                Container(
                  margin:
                      const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),

                  // Upload avatar
                  child: OutlinedButton(
                    style: transparentButtonStyle(),
                    onPressed: () => avatarSelected.pickImage(
                      currentUser,
                      userCollection,
                    ),
                    child: const Text('Upload Avatar'),
                  ),
                ),
                const SizedBox(height: 50),

                // Profile Header
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Profile', style: sidenotePoppinsFontStyle()),

                      // Edit username
                      TextBoxStyle(
                        text: userData['username'],
                        section: 'Username',
                        onPressed: () => editField('username'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading profile ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
