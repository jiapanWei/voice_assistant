import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:voice_assistant/services/auth_service.dart';
import 'package:voice_assistant/screens/main_screen.dart';
import 'package:voice_assistant/screens/start_screen.dart';
import 'package:voice_assistant/screens/authentications/auth_sign_in_providers.dart';

final _firebaseAuth = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  final bool isNewUser;

  const AuthScreen({Key? key, required this.isNewUser}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late bool _isLogin;
  var _isAuthenticating = false;

  String _inputUsername = '';
  String _inputEmail = '';
  String _inputPassword = '';

  @override
  void initState() {
    super.initState();
    _isLogin = !widget.isNewUser;
  }

  ButtonStyle transparentButtonStyle() {
    return OutlinedButton.styleFrom(
      side: const BorderSide(color: Colors.grey),
      minimumSize: const Size(300, 37),
    );
  }

  TextStyle buttonPoppinsFontStyle() {
    return GoogleFonts.poppins(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: const Color.fromRGBO(119, 111, 105, 1.0),
    );
  }

  Widget buildInputField(String label, TextEditingController controller,
      String? Function(String?) validator,
      {bool isObscure = false}) {
    final focusNode = FocusNode();

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 12.0),
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
          ),
          TextFormField(
            focusNode: focusNode,
            controller: controller,
            obscureText: isObscure,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 12.0),
            ),
            validator: validator,
            onChanged: (value) {
              if (label == 'Username') {
                _inputUsername = value!;
              } else if (label == 'Email') {
                _inputEmail = value!;
              } else if (label == 'Password') {
                _inputPassword = value!;
              }
            },
          ),
        ],
      ),
    );
  }

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      // show error message ...
      return;
    }

    _formKey.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        final userCredentials = await _firebaseAuth.signInWithEmailAndPassword(
            email: _inputEmail, password: _inputPassword);
      } else {
        final userCredentials =
            await _firebaseAuth.createUserWithEmailAndPassword(
                email: _inputEmail, password: _inputPassword);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'username': _inputUsername,
        });

        if (userCredentials.user != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                inputUsername: _inputUsername,
              ),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        // ...
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 239, 252, 1.0),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ),
      ),
      backgroundColor: const Color.fromRGBO(255, 239, 252, 1.0),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isLogin ? SizedBox(height: 80) : SizedBox(height: 50),
            Card(
              color: Colors.white,
              margin: const EdgeInsets.only(
                  top: 0, bottom: 20, left: 20, right: 20),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 8.0, bottom: 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            // Login/Sign up Text Lable
                            child: Text(
                              _isLogin ? 'Login' : 'Sign up',
                              style: GoogleFonts.poppins(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        // Username
                        if (!_isLogin)
                          buildInputField(
                            'Username',
                            _usernameController,
                            (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a valid username.';
                              }
                              return null;
                            },
                          ),
                        const SizedBox(height: 10),

                        // Email
                        buildInputField(
                          'Email',
                          _emailController,
                          (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'Please enter a valid email address.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),

                        // Password
                        buildInputField(
                          'Password',
                          _passwordController,
                          (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim().length < 6) {
                              return 'Password must be at least 6 characters long.';
                            }
                            return null;
                          },
                          isObscure: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Login/Sign up button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 30.0),
              child: OutlinedButton(
                style: transparentButtonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(
                        inputUsername: _inputUsername,
                      ),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isLogin ? 'Login' : 'Sign up',
                      style: buttonPoppinsFontStyle(),
                    ),
                  ],
                ),
              ),
            ),
            dividerLine(),
            googleAuthButton(),
            const SizedBox(height: 5),
            microsoftAuthButton(),
          ],
        ),
      ),
    );
  }
}