import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:voice_assistant/screens/widgets/build_divider_line.dart';
import 'package:voice_assistant/screens/widgets/google_sign_in_button.dart';
import 'package:voice_assistant/screens/widgets/microsoft_sign_in_button.dart';
import 'package:voice_assistant/screens/widgets/show_toast.dart';
import 'package:voice_assistant/screens/widgets/styles.dart';
import 'package:voice_assistant/screens/widgets/build_input_decoration.dart';

import 'package:voice_assistant/screens/authentications/reset_password_screen.dart';
import 'package:voice_assistant/screens/authentications/welcome_screen.dart';

import 'package:voice_assistant/screens/home_screen.dart';
import 'package:voice_assistant/services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  final bool isNewUser;
  const AuthScreen({super.key, required this.isNewUser});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late bool _isLogin;
  String _inputUsername = '';
  String _inputEmail = '';
  String _inputPassword = '';

  @override
  void initState() {
    super.initState();
    _isLogin = !widget.isNewUser;
  }

  Future<void> _submitAuthForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    UserCredential userCredentials;

    try {
      if (_isLogin) {
        userCredentials = await _authService.signIn(_inputEmail, _inputPassword);
      } else {
        userCredentials = await _authService.signUp(_inputEmail, _inputPassword);
        _authService.addUserDetails(_inputUsername, _inputEmail);
      }

      if (userCredentials.user != null) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        }
      }
      // Notify user of successful login or account creation
      showToastBox(
        msg: _isLogin ? 'Login successful!' : 'Account created successfully!',
      );
    } on FirebaseAuthException catch (error) {
      String errorMessage = 'Authentication failed.';
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? errorMessage),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColorPink,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              );
            },
          ),
        ),
      ),
      backgroundColor: backgroundColorPink,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: Colors.white,
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _isLogin ? 'Login' : 'Create an account',
                            style: poppinsFontStyle(),
                          ),
                          const SizedBox(height: 15),

                          // Username
                          if (!_isLogin)
                            TextFormField(
                              decoration: userInputDecoration(labelText: 'Username', icon: Icons.person),
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              obscureText: false,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a valid username.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _inputUsername = value!;
                              },
                            ),
                          const SizedBox(height: 15),

                          // Email
                          TextFormField(
                            decoration: userInputDecoration(labelText: 'Email', icon: Icons.email),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            obscureText: false,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty || !value.contains('@')) {
                                return 'Please enter a valid email address.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _inputEmail = value!;
                            },
                          ),
                          const SizedBox(height: 15),

                          // Password
                          TextFormField(
                            decoration: userInputDecoration(labelText: 'password', icon: Icons.password),
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty || value.trim().length < 6) {
                                return 'Password must be at least 6 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _inputPassword = value!;
                            },
                          ),
                          const SizedBox(height: 15),

                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 6.0),
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: Colors.grey),
                                      minimumSize: const Size(300, 37),
                                    ),
                                    onPressed: _submitAuthForm,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _isLogin ? 'Login' : 'Signup',
                                          style: poppinsFontStyle(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(
                              _isLogin ? "Don't have an account? Sign Up" : 'Already have an account? Login',
                              style: sidenotePoppinsFontStyle(),
                            ),
                          ),

                          //Forgot Password
                          if (_isLogin)
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PasswordResetScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                style: sidenotePoppinsFontStyle(),
                              ),
                            ),
                        ],
                      ),
                    ),
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
      ),
    );
  }
}
