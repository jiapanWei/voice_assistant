import "dart:math";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:voice_assistant/screens/home_screen.dart";
import "package:voice_assistant/screens/widgets/build_app_drawer.dart";
import "package:voice_assistant/screens/widgets/build_drawer_btn.dart";
import 'package:voice_assistant/screens/widgets/styles.dart';

// Define EntryPoint widget
class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

// Define EntryPoint state
class _EntryPointState extends State<EntryPoint> with SingleTickerProviderStateMixin {
  bool isDrawerOpen = false;
  bool isAppDrawerOpen = false;
  late AnimationController _animationController;
  late Animation<double> animation;
  late Animation<double> scaleAnimation;
  String username = '';

  // Method to toggle app drawer
  void setOpenDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      if (!isAppDrawerOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
      isAppDrawerOpen = !isAppDrawerOpen;
    });
  }

  // Initialize animation controller and animations
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        setState(() {});
      });
    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
  }

  // Dispose animation controller
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        // Retrieve use data from Firestore
        if (snapshot.hasData && snapshot.data != null) {
          final userData = snapshot.data!.data();
          if (userData is Map<String, dynamic>) {
            username = userData['username'] ?? 'user';
          }
        }

        return Scaffold(
          backgroundColor: backgroundColorPurple,
          body: Stack(
            children: [
              // App drawer widget
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                width: 240,
                left: isAppDrawerOpen ? 0 : -288,
                height: MediaQuery.of(context).size.height,
                child: AppDrawer(username: username),
              ),

              // Main content with animation
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(animation.value - 20 * animation.value * pi / 180),
                child: Transform.translate(
                  offset: Offset(animation.value * 240, 0),
                  child: Transform.scale(
                    scale: scaleAnimation.value,
                    child: const ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      child: HomeScreen(),
                    ),
                  ),
                ),
              ),

              // Drawer button
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                top: 12,
                left: isAppDrawerOpen ? 180 : 0,
                child: DrawerBtn(
                  press: () {
                    setOpenDrawer();
                  },
                  isDrawerOpen: isDrawerOpen,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
