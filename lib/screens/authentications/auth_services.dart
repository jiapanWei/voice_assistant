import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:voice_assistant/screens/home_screen.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> signIn(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential> signUp(String email, String password) {
    return _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future addUserDetails(String username, String email) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    String uid = _firebaseAuth.currentUser!.uid;
    users
        .doc(uid)
        .set({
          'username': username,
          'email': email,
        })
        .then((value) => print('User Added'))
        .catchError((error) => print('Failed to add user: $error'));
  }

  Future<String> getUsername(UserCredential userCredentials) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredentials.user?.uid)
        .get();

    return userDoc['username'];
  }
}
