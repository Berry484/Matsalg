import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/logging.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//-----------------------------------------------------------------------------------------------------------------------
//--------------------Sings in using Google------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------
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

//-----------------------------------------------------------------------------------------------------------------------
//--------------------Sings in using Apple-------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------
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

//-----------------------------------------------------------------------------------------------------------------------
//--------------------Creates a user in firebase using Email and Password------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------
  Future<User?> linkEmailAndPasswordToPhoneUser(
      String email, String password) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        throw Exception('No user is currently logged in');
      }

      AuthCredential emailCredential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      UserCredential linkedCredential =
          await currentUser.linkWithCredential(emailCredential);

      return linkedCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        throw (Exception('email-taken'));
      }
      if (e.code == 'email-already-in-use') {
        throw (Exception('email-taken'));
      }
      {
        logger.d("FirebaseAuthException: ${e.message}");
        return null;
      }
    } catch (e) {
      logger.d("Unexpected error with linking credential: $e");
      return null;
    }
  }

//-----------------------------------------------------------------------------------------------------------------------
//--------------------Sings in using Email and Password------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------
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

//-----------------------------------------------------------------------------------------------------------------------
//--------------------Gets the token from firebase. It also auto renews or loggs out if its invalid----------------------
//-----------------------------------------------------------------------------------------------------------------------
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
          if (!context.mounted) return null;
          context.go('/registrer');
        }
        FFAppState().login = false;
        return null;
      }

      return idToken;
    } catch (e) {
      if (context != null) {
        if (!context.mounted) return null;
        context.go('/registrer');
      }
      FFAppState().login = false;
      return null;
    }
  }

//-----------------------------------------------------------------------------------------------------------------------
//--------------------Updates users password in firebase-----------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------
  Future<bool> updatePassword(String password) async {
    try {
      await _auth.currentUser!.updatePassword(password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        logger.d('Error: ${e.message}');
      } else {
        logger.d('Error: ${e.message}');
      }
      return false;
    } catch (e) {
      logger.e('Unexpected error: $e');
      return false;
    }
  }

//-----------------------------------------------------------------------------------------------------------------------
//--------------------ReAuthenticate-------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------
  Future<bool> reAuthenticate(BuildContext context, String password) async {
    try {
      // Get the current user's email
      final String email = _auth.currentUser!.email!;

      // Create credentials using the user's email and the provided password
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);

      // Reauthenticate the user with the credentials
      await _auth.currentUser!.reauthenticateWithCredential(credential);
      return true; // Reauthentication succeeded
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
        if (!context.mounted) return false;
        Toasts.showErrorToast(context, 'Feil innlogging eller passord');
      } else {
        if (!context.mounted) return false;
        Toasts.showErrorToast(context, 'En uforventet feil oppstod');
        logger.d('Error: ${e.message}');
      }
      return false; // Reauthentication failed
    } catch (e) {
      logger.e('Unexpected error: $e');
      return false; // Catch-all failure
    }
  }

//-----------------------------------------------------------------------------------------------------------------------
//--------------------ReAuthenticate with google-------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------
  Future<bool> reauthenticateWithGoogle(BuildContext context) async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.currentUser!
            .reauthenticateWithCredential(credential);

        logger.d('Reauthenticated with Google');
        return true;
      } else {
        logger.d('Google sign-in canceled.');
        return false;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
        if (!context.mounted) return false;
        Toasts.showErrorToast(context, 'Feil innlogging eller passord');
        return false;
      }
      if (e.code == 'user-mismatch') {
        if (!context.mounted) return false;
        Toasts.showErrorToast(
            context, 'Du er ikke logget inn med denne brukeren.');
        return false;
      } else {
        if (!context.mounted) return false;
        Toasts.showErrorToast(context, 'En uforventet feil oppstod');
        logger.d('Error: ${e.message}');
        return false;
      }
    } catch (e) {
      logger.d('Error during Google reauthentication: $e');
      return false;
    }
  }

//-----------------------------------------------------------------------------------------------------------------------
//--------------------ReAuthenticate with apple--------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------
  Future<bool> reauthenticateWithApple(BuildContext context) async {
    try {
      // Start the Apple sign-in process
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName
        ],
      );

      // Create the OAuth credential for Apple
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Reauthenticate the user with Firebase
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(oauthCredential);

      logger.d('Reauthenticated with Apple');
      return true;
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuth-specific exceptions
      if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
        if (!context.mounted) return false;
        Toasts.showErrorToast(context, 'Feil legitimasjon eller passord');
        return false;
      }
      if (e.code == 'user-mismatch') {
        if (!context.mounted) return false;
        Toasts.showErrorToast(
            context, 'Du er ikke logget inn med denne brukeren.');
        return false;
      } else {
        if (!context.mounted) return false;
        Toasts.showErrorToast(context, 'En uforventet feil oppstod');
        logger.d('Error: ${e.message}');
        return false;
      }
    } catch (e) {
      // Handle generic errors
      logger.d('Error during Apple reauthentication: $e');
      return false;
    }
  }

//
}
