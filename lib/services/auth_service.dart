import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print('Google sign-in failed: $e');
      rethrow;
    }
  }

  Future<UserCredential> signInWithMicrosoft() async {
    try {
      OAuthProvider oAuthProvider = OAuthProvider('microsoft.com');
      oAuthProvider.setCustomParameters(
          {'tenant': 'a8eec281-aaa3-4dae-ac9b-9a398b9215e7'});
      return await FirebaseAuth.instance.signInWithProvider(oAuthProvider);
    } catch (e) {
      print('Microsoft sign-in failed: $e');
      rethrow;
    }
  }
}
