import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_assistant/screens/authentications/password_reset_screen.dart';
import 'package:voice_assistant/screens/authentications/success_login_screen.dart';

import 'package:voice_assistant/screens/main_screen.dart';
import 'package:voice_assistant/screens/start_screen.dart';
import 'package:voice_assistant/screens/authentications/auth_sign_in_providers.dart';
import 'package:voice_assistant/screens/widgets/input_decoration.dart';

class AuthScreen extends StatefulWidget {
  final bool isNewUser;

  const AuthScreen({required this.isNewUser});

  TextStyle poppinsFontStyle() {
    return GoogleFonts.poppins(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: const Color.fromRGBO(119, 111, 105, 1.0),
    );
  }

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    UserCredential userCredentials;
    String username;

    try {
      if (_isLogin) {
        userCredentials = await _firebaseAuth.signInWithEmailAndPassword(
            email: _inputEmail, password: _inputPassword);

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user?.uid)
            .get();
        username = userDoc['username'];
      } else {
        userCredentials = await _firebaseAuth.createUserWithEmailAndPassword(
            email: _inputEmail, password: _inputPassword);

        addUserDetails(_inputUsername, _inputEmail);
        username = _inputUsername;
      }

      if (userCredentials.user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SuccessLoginScreen(username: username),
          ),
        );
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
    }
  }

  Future addUserDetails(String usrname, String email) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    users
        .doc(uid)
        .set({
          'username': usrname,
          'email': email,
        })
        .then((value) => print('User Added'))
        .catchError((error) => print('Failed to add user: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 239, 252, 1.0),
        leading: Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back),
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

                          // Email
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
                                      side: BorderSide(color: Colors.grey),
                                      minimumSize: const Size(300, 37),
                                    ),
                                    onPressed: _submit,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                              _isLogin
                                  ? "Don't have an account? Sign Up"
                                  : 'Already have an account? Login',
                              style: poppinsFontStyle(),
                            ),
                          ),

                          //Forgot Password
                          if (_isLogin)
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PasswordResetScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                style: poppinsFontStyle(),
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
