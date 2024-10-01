import 'dart:async';

import 'custom_auth_user_provider.dart';

export 'custom_auth_manager.dart';

class CustomAuthManager {
  // Auth session attributes
  String? authenticationToken;

  Future signOut() async {
    authenticationToken = null;

    // Update the current user.
    matSalgAuthUserSubject.add(
      MatSalgAuthUser(loggedIn: false),
    );
  }

  Future<MatSalgAuthUser?> signIn({
    String? authenticationToken,
  }) async =>
      _updateCurrentUser(
        authenticationToken: authenticationToken,
      );

  void updateAuthUserData({
    String? authenticationToken,
  }) {
    assert(
      currentUser?.loggedIn ?? false,
      'User must be logged in to update auth user data.',
    );

    _updateCurrentUser(
      authenticationToken: authenticationToken,
    );
  }

  MatSalgAuthUser? _updateCurrentUser({
    String? authenticationToken,
  }) {
    this.authenticationToken = authenticationToken;

    // Update the current user stream.
    final updatedUser = MatSalgAuthUser(
      loggedIn: true,
    );
    matSalgAuthUserSubject.add(updatedUser);

    return updatedUser;
  }
}

MatSalgAuthUser? currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
