import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:mat_salg/logging.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential?> loginWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      final googleAuth = await googleUser?.authentication;

      final cred = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);

      return await _auth.signInWithCredential(cred);
    } catch (e) {
      logger.d(e.toString());
    }
    return null;
  }

  // Apple Sign-In
  Future<UserCredential?> signInWithApple() async {
    try {
      // 1. Request Apple credentials
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email],
      );

      // 2. Create Firebase OAuth credential
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // 3. Sign in with Firebase using the OAuth credential
      final userCredential =
          await _firebaseAuth.signInWithCredential(oauthCredential);
      return userCredential;
    } catch (e) {
      logger.d('Apple sign-in error: ${e.toString()}');
      return null;
    }
  }

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw (Exception('email-taken'));
      } else {
        return null;
      }
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        return null;
      } else {
        return null;
      }
    }
  }

  Future<String?> getToken(BuildContext? context) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        if (context != null) {
          context.go('/registrer');
        }
        FFAppState().login = false;
        return null;
      }

      final idToken = await user.getIdToken();

      if (idToken == null || idToken.isEmpty) {
        if (context != null) {
          context.go('/registrer');
        }
        FFAppState().login = false;
        return null;
      }

      return idToken;
    } catch (e) {
      if (context != null) {
        context.go('/registrer');
      }
      FFAppState().login = false;
      return null;
    }
  }
}
