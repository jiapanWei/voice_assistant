import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

import 'package:voice_assistant/screens/widgets/build_logger_style.dart';

// Define AuthService class to handle authentication
class AuthService {
  // Create a logger to log messages
  final Logger logger = LoggerStyle.getLogger();

  // Create an instance of FirebaseAuth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Sign in with email and password
  Future<UserCredential> signIn(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  // Sign up with email and password
  Future<UserCredential> signUp(String email, String password) {
    return _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  // Add user data to Firestore
  Future addUserDetails(String username, String email) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    String uid = _firebaseAuth.currentUser!.uid;
    users
        .doc(uid)
        .set({
          'username': username,
          'email': email,
        })
        .then((value) => logger.i('User Added'))
        .catchError((error) => logger.e('Failed to add user: $error'));
  }

  // Get the username of the user
  Future<String> getUsername(UserCredential userCredentials) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredentials.user?.uid)
        .get();

    return userDoc['username'];
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // If the sign in was unsuccessful, return null
      if (googleUser == null) {
        return null;
      }

      // Get the Google sign-in authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new Google credential with the access token and ID token
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Get the user from the userCredential
      User? user = userCredential.user;
      if (user != null) {
        String? displayName;
        String? avatarUrl = user.photoURL;
        String? email = user.email;

        // Get the user data from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        // If the user document exists, get the username and avatar
        if (userDoc.exists) {
          displayName = userDoc.get('username');
          avatarUrl = userDoc.get('avatar');
        } else {
          displayName = user.displayName ?? '';
          avatarUrl = user.photoURL;
        }

        // Set the user data in Firestore with the username, avatar, and email
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'username': displayName,
          'avatar': avatarUrl,
          'email': email,
        }, SetOptions(merge: true));
      }
      return userCredential;
    } catch (e) {
      logger.e('Google sign-in failed: $e');
      return null;
    }
  }

  // Sign in with Microsoft
  Future<UserCredential?> signInWithMicrosoft() async {
    try {
      // Create an OAuthProvider for Microsoft
      OAuthProvider oAuthProvider = OAuthProvider('microsoft.com');
      oAuthProvider.setCustomParameters({
        'tenant': 'a8eec281-aaa3-4dae-ac9b-9a398b9215e7',
      });

      // Sign in to Firebase with the Microsoft credentials
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithProvider(oAuthProvider);

      // Get the user from the userCredential
      User? user = userCredential.user;

      // If the user is not null
      if (user != null) {
        String? displayName;
        String? avatarUrl = user.photoURL;
        String? email = user.email;

        // Get the user data from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        // If the user document exists, get the username and avatar
        if (userDoc.exists) {
          displayName = userDoc.get('username');
          avatarUrl = userDoc.get('avatar');
        } else {
          displayName = user.displayName ?? '';
          avatarUrl = user.photoURL;
        }

        // Set the user data in Firestore with the username, avatar, and email
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'username': displayName,
          'avatar': avatarUrl,
          'email': email,
        }, SetOptions(merge: true));
      }
      return userCredential;
    } catch (e) {
      logger.e('Microsoft sign-in failed: $e');
      return null;
    }
  }
}
