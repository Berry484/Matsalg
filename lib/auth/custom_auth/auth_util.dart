import 'custom_auth_manager.dart';

export 'custom_auth_manager.dart';

final _authManager = CustomAuthManager();
CustomAuthManager get authManager => _authManager;

String get currentUserUid => currentUser?.uid ?? '';
String? get currentAuthenticationToken => authManager.authenticationToken;
String? get currentAuthRefreshToken => authManager.refreshToken;
DateTime? get currentAuthTokenExpiration => authManager.tokenExpiration;
