import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

import 'package:voice_assistant/screens/widgets/build_logger_style.dart';

class AuthService {
  final Logger logger = LoggerStyle.getLogger();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> signIn(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signUp(String email, String password) {
    return _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
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
        .then((value) => logger.i('User Added'))
        .catchError((error) => logger.e('Failed to add user: $error'));
  }

  Future<String> getUsername(UserCredential userCredentials) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userCredentials.user?.uid).get();

    return userDoc['username'];
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
        String? displayName;
        String? avatarUrl = user.photoURL;
        String? email = user.email;

        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          displayName = userDoc.get('username');
          avatarUrl = userDoc.get('avatar');
        } else {
          displayName = user.displayName ?? '';
          avatarUrl = user.photoURL;
        }

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

  Future<UserCredential?> signInWithMicrosoft() async {
    try {
      OAuthProvider oAuthProvider = OAuthProvider('microsoft.com');
      oAuthProvider.setCustomParameters({
        'tenant': 'a8eec281-aaa3-4dae-ac9b-9a398b9215e7',
      });
      UserCredential userCredential = await FirebaseAuth.instance.signInWithProvider(oAuthProvider);
      User? user = userCredential.user;
      if (user != null) {
        String? displayName;
        String? avatarUrl = user.photoURL;
        String? email = user.email;

        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          displayName = userDoc.get('username');
          avatarUrl = userDoc.get('avatar');
        } else {
          displayName = user.displayName ?? '';
          avatarUrl = user.photoURL;
        }

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
