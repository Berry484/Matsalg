import 'package:rxdart/rxdart.dart';

import 'custom_auth_manager.dart';

class MatSalgAuthUser {
  MatSalgAuthUser({required this.loggedIn, this.uid});

  bool loggedIn;
  String? uid;
}

/// Generates a stream of the authenticated user.
BehaviorSubject<MatSalgAuthUser> matSalgAuthUserSubject =
    BehaviorSubject.seeded(MatSalgAuthUser(loggedIn: false));
Stream<MatSalgAuthUser> matSalgAuthUserStream() => matSalgAuthUserSubject
    .asBroadcastStream()
    .map((user) => currentUser = user);
