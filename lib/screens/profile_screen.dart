import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

import 'package:voice_assistant/screens/widgets/build_logger_style.dart';
import 'package:voice_assistant/screens/widgets/build_dialog_box.dart';
import 'package:voice_assistant/screens/widgets/change_avatar.dart';
import 'package:voice_assistant/screens/widgets/styles.dart';
import 'package:voice_assistant/screens/widgets/build_text_box.dart';

import 'package:voice_assistant/services/change_password.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection('users');
  final changeUserAvatar = ChangeUserAvatar();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final Logger logger = LoggerStyle.getLogger();

  late String newPassword;

  Future<void> editField(String field) async {
    String newField = await _showEditFieldDialog(field);

    if (newField.trim().isNotEmpty) {
      await userCollection.doc(currentUser.uid).update({field: newField});
      //// The second way to notify user of successful update
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('$field updated successfully')),
      // );
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialogBox(
              title: 'Success $successEmoji',
              content: '$field updated successfully.',
            );
          },
        );
      }
    } else {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialogBox(
              title: 'Error',
              content: 'Field cannot be empty.',
            );
          },
        );
      }
    }
  }

  Future _showEditFieldDialog(String field) {
    return showDialog(
      context: context,
      builder: (context) {
        String newField = '';
        return AlertDialog(
          title: Text('Edit $field',style: headingPoppinsFontStyle().copyWith(color: Colors.black),),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter new $field',
              hintStyle: sidenotePoppinsFontStyle().copyWith(fontSize: 15),
            ),
            onChanged: (value) {
              newField = value;
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancel', style:sidenotePoppinsFontStyle().copyWith(color:Colors.deepPurple)),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Save',style:sidenotePoppinsFontStyle().copyWith(color: Colors.deepPurple)),
              onPressed: () => Navigator.of(context).pop(newField),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: scaffoldKey,
      backgroundColor: backgroundColorPink,
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: backgroundColorPink,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<DocumentSnapshot>(
      stream: userCollection.doc(currentUser.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildProfile(snapshot.data!);
        } else if (snapshot.hasError) {
          return _buildErrorUI(snapshot.error);
        } else {
          return _buildLoadingUI();
        }
      },
    );
  }

  Widget _buildProfile(DocumentSnapshot snapshot) {
    final userData = snapshot.data() as Map<String, dynamic>;
    final avatarUrl = userData['avatar'] as String?;

    return ListView(
      children: [
        const SizedBox(height: 50.0),
        if (avatarUrl != null)
          Image.network(avatarUrl, width: 120.0, height: 120.0)
        else
          Container(
            width: 120.0,
            height: 120.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('images/avatar.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),

        // Buttons container
        Container(
          margin: const EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Change avatar button
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 15.0),
                  child: OutlinedButton(
                    style: transparentButtonStyle(),
                    onPressed: () => changeUserAvatar.pickImage(currentUser, userCollection),
                    child: Text(
                      'Change',
                      style: poppinsFontStyle(),
                    ),
                  ),
                ),
              ),
              // Reset avatar button
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 30.0),
                  child: OutlinedButton(
                    style: transparentButtonStyle(),
                    onPressed: () async {
                      try {
                        await userCollection.doc(currentUser.uid).update({'avatar': null});
                      } catch (e) {
                        logger.e('Error resetting avatar: $e');
                      }
                    },
                    child: Text(
                      'Reset',
                      style: poppinsFontStyle(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 50),

        // Profile Header
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'My Profile',
                      style: headingPoppinsFontStyle(),
                    ),
                  ],
                ),
              ),

              // Do not allow editing of email
              ProfileTextBoxStyle(
                text: userData['email'],
                section: 'Email',
                onPressed: null,
              ),

              // Edit username
              ProfileTextBoxStyle(
                text: userData['username'],
                section: 'Username',
                onPressed: () => editField('username'),
              ),

              ProfileTextBoxStyle(
                text: '********',
                section: 'Password',
                onPressed: () async {
                  final bool passwordChanged = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) => const ChangePassword(),
                      ) ??
                      false;

                  if (!passwordChanged) {
                    if (mounted) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AlertDialogBox(
                            title: 'Error',
                            content: 'Password must be at least 6 characters long.',
                          );
                        },
                      );
                    }
                  } else {
                    if (mounted) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AlertDialogBox(
                            title: 'Success $successEmoji',
                            content: 'Password updated successfully.',
                          );
                        },
                      );
                    }
                    //// The third way to notify user of successful update
                    //   showToast(
                    //   msg: 'Password updated successfully',
                    // );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorUI(Object? error) {
    return Center(
      child: Text('Error loading profile $error'),
    );
  }

  Widget _buildLoadingUI() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
