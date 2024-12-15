import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mat_salg/flutter_flow/flutter_flow_util.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
