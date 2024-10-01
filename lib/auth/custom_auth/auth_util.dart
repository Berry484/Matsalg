import 'custom_auth_manager.dart';

export 'custom_auth_manager.dart';

final _authManager = CustomAuthManager();
CustomAuthManager get authManager => _authManager;

String? get currentAuthenticationToken => authManager.authenticationToken;
