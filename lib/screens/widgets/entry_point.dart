import "dart:math";
import "dart:ui";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:voice_assistant/screens/home_screen.dart";
import "package:voice_assistant/screens/widgets/build_app_drawer.dart";
import 'package:voice_assistant/screens/widgets/styles.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> with SingleTickerProviderStateMixin {
  bool isDrawerOpen = false;
  bool isAppDrawerOpen = false;
  late AnimationController _animationController;
  late Animation<double> animation;
  late Animation<double> scaleAnimation;
  String username = '';

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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
      builder: (context, snapshot) {
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
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                width: 240,
                left: isAppDrawerOpen ? 0 : -288,
                height: MediaQuery.of(context).size.height,
                child: AppDrawer(username: username),
              ),
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
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
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

class DrawerBtn extends StatelessWidget {
  const DrawerBtn({
    super.key,
    required this.press,
    this.isDrawerOpen,
  });

  final VoidCallback press;
  final isDrawerOpen;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: press,
        child: Container(
          margin: EdgeInsets.only(left: 16),
          height: 35,
          width: 35,
          decoration: const BoxDecoration(
            color: backgroundColorPink,
            shape: BoxShape.circle,
          ),
          child: isDrawerOpen
              ? Icon(CupertinoIcons.clear_thick)
              : const Icon(
                  CupertinoIcons.list_dash,
                  color: Colors.black,
                ),
        ),
      ),
    );
  }
}
