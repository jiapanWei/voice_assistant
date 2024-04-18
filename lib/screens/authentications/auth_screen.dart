import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:voice_assistant/screens/widgets/build_divider_line.dart';
import 'package:voice_assistant/screens/widgets/entry_point.dart';
import 'package:voice_assistant/screens/widgets/google_sign_in_button.dart';
import 'package:voice_assistant/screens/widgets/microsoft_sign_in_button.dart';
import 'package:voice_assistant/screens/widgets/styles.dart';
import 'package:voice_assistant/screens/authentications/reset_password_screen.dart';
import 'package:voice_assistant/screens/authentications/welcome_screen.dart';
import 'package:voice_assistant/services/auth_service.dart';

// Define AuthScreen Widget
class AuthScreen extends StatefulWidget {
  final bool isNewUser;
  const AuthScreen({super.key, required this.isNewUser});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

// Define AuthScreen state
class _AuthScreenState extends State<AuthScreen> {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Initialize varibles
  bool _isLogin = false;
  String _inputUsername = '';
  String _inputEmail = '';
  String _inputPassword = '';

  // @override
  // void initState() {
  //   super.initState();
  //   _isLogin = !widget.isNewUser;
  // }

  // Submit authentication form
  Future<void> _submitAuthForm() async {
    // Validate form input
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Save form state
    _formKey.currentState!.save();

    UserCredential userCredentials;

    try {
      // Check if user is signing in or signing up
      if (_isLogin) {
        // Sign in
        userCredentials =
            await _authService.signIn(_inputEmail, _inputPassword);
      } else {
        // Sign up
        userCredentials =
            await _authService.signUp(_inputEmail, _inputPassword);
        _authService.addUserDetails(_inputUsername, _inputEmail);
      }

      // Check if user credentials are not null
      if (userCredentials.user != null) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const EntryPoint(),
            ),
          );
        }
      }
      // Notify user of successful sign in or sign up
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isLogin ? 'Login successful!' : 'Account created successfully!',
            style: sidenotePoppinsFontStyle()
                .copyWith(color: Colors.black, fontSize: 15),
          ),
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          backgroundColor: snackBarColorPink,
        ),
      );
    } on FirebaseAuthException catch (error) {
      // Handle authentication failure
      String errorMessage = 'Authentication failed.';
      if (mounted) {
        // Clear the previous SnackBars and show an error message
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? errorMessage),
          ),
        );
      }
    }
  }

  // Build method for widget
  @override
  Widget build(BuildContext context) {
    _isLogin = !widget.isNewUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColorPink,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Navigate to the welcome screen when the back button is pressed
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
                shadowColor: Colors.white,
                surfaceTintColor: Colors.white,
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, bottom: 16, top: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _isLogin ? 'Sign In' : 'Create Account',
                            style: headingPoppinsFontStyle()
                                .copyWith(color: Colors.black, fontSize: 20),
                          ),
                          const SizedBox(height: 30),

                          // Username and related validation
                          if (!_isLogin)
                            TextFormField(
                              decoration: userInputDecoration(
                                  labelText: 'Username', icon: Icons.person),
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

                          // Email and related validation
                          TextFormField(
                            decoration: userInputDecoration(
                                labelText: 'Email', icon: Icons.email),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            obscureText: false,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email (must contain @).';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _inputEmail = value!;
                            },
                          ),
                          const SizedBox(height: 15),

                          // Password and related validation
                          TextFormField(
                            decoration: userInputDecoration(
                                labelText: 'password', icon: Icons.password),
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            obscureText: true,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  value.trim().length < 6) {
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
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 6.0),
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side:
                                          const BorderSide(color: Colors.grey),
                                      minimumSize: const Size(300, 37),
                                    ),
                                    onPressed: _submitAuthForm,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Text changes based on whether the user is signing in or signing up
                                        Text(
                                          _isLogin
                                              ? 'Sign In'
                                              : 'Create Account',
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
                              // Text changes based on whether the user is signing in or signing up
                              _isLogin
                                  ? "Don't have an account? Create Account"
                                  : 'Already have an account? Sign In',
                              style: sidenotePoppinsFontStyle(),
                            ),
                          ),

                          // Forgot Password
                          if (_isLogin)
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PasswordResetScreen(),
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
              // Add Google and Microsoft sign-in authentication buttons
              const DividerLine(),
              const GoogleAuthButton(),
              const SizedBox(height: 5),
              const MicrosoftAuthButton(),
            ],
          ),
        ),
      ),
    );
  }
}
