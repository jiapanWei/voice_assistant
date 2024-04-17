import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voice_assistant/screens/authentications/welcome_screen.dart';
import 'package:voice_assistant/screens/profile_screen.dart';
import 'package:voice_assistant/screens/storyboard_screen.dart';
import 'package:voice_assistant/screens/widgets/entry_point.dart';
import 'package:voice_assistant/screens/widgets/styles.dart';

class AppDrawer extends StatefulWidget {
  final String username;
  const AppDrawer({super.key, required this.username});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String activeTitle = "";

  void setActiveTitle(String title) {
    setState(() {
      activeTitle = title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: 288,
      height: double.infinity,
      color: backgroundColorPurple,
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 0),
            ),
            InfoCard(username: widget.username),
            const SizedBox(
              height: 40,
            ),
            SideMenuTitle(
              title: "Home",
              press: () async {
                setActiveTitle("Home");
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EntryPoint(),
                  ),
                );
                setActiveTitle("");
              },
              isActive: activeTitle == "Home",
              icondata: CupertinoIcons.home,
            ),
            SideMenuTitle(
              title: "My Profile",
              press: () async {
                setActiveTitle("My Profile");
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
                setActiveTitle("");
              },
              isActive: activeTitle == "My Profile",
              icondata: CupertinoIcons.person,
            ),
            SideMenuTitle(
              title: "Help",
              press: () async {
                setActiveTitle("Help");
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StoryboardScreen(),
                  ),
                );
                setActiveTitle("");
              },
              isActive: activeTitle == "Help",
              icondata: CupertinoIcons.info,
            ),
            const SizedBox(
              height: 450,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomeScreen(),
                  ),
                );
              },
              leading: const SizedBox(
                height: 34,
                width: 34,
                child: Icon(
                  CupertinoIcons.arrow_up_right,
                  color: Colors.white,
                ),
              ),
              title: Text(
                "log out",
                style: poppinsFontStyle().copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class SideMenuTitle extends StatefulWidget {
  const SideMenuTitle({
    super.key,
    required this.title,
    required this.press,
    required this.isActive,
    required this.icondata,
  });

  final String title;
  final IconData icondata;
  final Future<void> Function() press;
  final bool isActive;

  @override
  State<SideMenuTitle> createState() => _SideMenuTitleState();
}

class _SideMenuTitleState extends State<SideMenuTitle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTap() async {
    if (!widget.isActive) {
      setState(() {
        _isExpanded = true;
      });
      await _animationController.forward();
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _isExpanded = false;
      });
      widget.press();
    } else {
      widget.press();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Divider(
            color: Colors.white24,
            height: 1,
          ),
        ),
        Stack(
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Positioned(
                  left: 0,
                  height: 56,
                  width: _isExpanded
                      ? 288 * _animation.value
                      : widget.isActive
                          ? 288 * _animation.value
                          : 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: backgroundColorLightPurple,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                );
              },
            ),
            ListTile(
              onTap: _onTap,
              leading: SizedBox(
                height: 34,
                width: 34,
                child: Icon(
                  widget.icondata,
                  color: Colors.white,
                ),
              ),
              title: Text(
                widget.title,
                style: poppinsFontStyle().copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.username,
  });

  final String username;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.white24,
        child: Icon(
          CupertinoIcons.person,
          color: Colors.white,
        ),
      ),
      title: Text(
        username,
        style: headingPoppinsFontStyle().copyWith(color: Colors.white, fontSize: 17),
      ),
    );
  }
}
