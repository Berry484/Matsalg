import 'dart:async';
import 'package:mat_salg/pages/app_pages/profile/contact/contact_page.dart';
import 'package:mat_salg/pages/app_pages/profile/product_stats/product_stats_page.dart';

import '/index.dart';
import 'package:flutter/material.dart';
import 'package:mat_salg/nav_bar.dart';
import 'package:mat_salg/pages/app_pages/profile/settings/account/account_page.dart';
import '/auth/custom_auth/custom_auth_user_provider.dart';
import '../helper_components/flutter_flow/flutter_flow_util.dart';
export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  MatSalgAuthUser? initialUser;
  MatSalgAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(MatSalgAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

final GlobalKey<NavigatorState> _parentKey = GlobalKey<NavigatorState>();
final _shellNavigatorHome = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _mineKjopNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellSettings');

GoRouter createRouter(AppStateNotifier appStateNotifier) {
  return GoRouter(
    initialLocation: FFAppState().login ? '/home' : '/registrer',
    navigatorKey: _parentKey,
    debugLogDiagnostics: true,
    refreshListenable: appStateNotifier,
    errorBuilder: (context, state) {
      return const RegisterWidget();
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(child: navigationShell);
        },
        branches: <StatefulShellBranch>[
          // MineKjop Branch
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHome,
            routes: <RouteBase>[
              GoRoute(
                path: '/home',
                name: 'Home',
                builder: (context, state) {
                  return HomeWidget();
                },
                pageBuilder: (context, state) {
                  return MaterialPage<void>(child: HomeWidget());
                },
                routes: [
                  GoRoute(
                    path: 'prdouctDetail',
                    name: 'ProductDetail',
                    builder: (context, state) {
                      // Retrieve parameters safely using FFParameters
                      final params = FFParameters(state);
                      final matvare = params.getParam<Map<String, dynamic>>(
                          'matvare', ParamType.JSON);
                      final fromChat =
                          params.getParam<bool>('fromChat', ParamType.bool);
                      final matId =
                          params.getParam<int>('matId', ParamType.int);

                      // Directly return the widget with the retrieved parameters
                      return DetailsWidget(
                          matvare: matvare, fromChat: fromChat, matId: matId);
                    },
                  ),
                  GoRoute(
                    path: 'brukerPage',
                    name: 'BrukerPage',
                    builder: (context, state) {
                      final params = FFParameters(state);
                      final bruker =
                          params.getParam<String>('bruker', ParamType.String);
                      final uid =
                          params.getParam<String>('uid', ParamType.String);
                      final username =
                          params.getParam<String>('username', ParamType.String);
                      return UserWidget(
                          bruker: bruker, uid: uid, username: username);
                    },
                  ),
                  GoRoute(
                    path: 'folgere',
                    name: 'Folgere',
                    builder: (context, state) {
                      // Use FFParameters to retrieve the parameters safely
                      final params = FFParameters(state);

                      // Retrieve the 'username' and 'folger' parameters
                      final username =
                          params.getParam<String>('username', ParamType.String);
                      final folger =
                          params.getParam<String>('folger', ParamType.String);

                      // Return the FollowersWidget with the retrieved parameters
                      return FollowersWidget(
                          username: username, folger: folger);
                    },
                  ),
                  GoRoute(
                    path: 'bondeGardPage', // Relative path, no leading '/'
                    name: 'BondeGardPage',
                    builder: (context, state) {
                      // Use FFParameters to get the query parameters safely
                      final params = FFParameters(state);

                      // Retrieve the parameters using getParam
                      final kategori =
                          params.getParam<String>('kategori', ParamType.String);
                      final query =
                          params.getParam<String>('query', ParamType.String);

                      // Return the widget with the parameters
                      return CategoryWidget(kategori: kategori, query: query);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _mineKjopNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: '/notifications',
                name: 'Notifications',
                builder: (context, state) {
                  return const NotificationsWidget();
                },
                pageBuilder: (context, state) {
                  return const NoTransitionPage(child: NotificationsWidget());
                },
                routes: [
                  GoRoute(
                    path: 'prdouctDetailNotification',
                    name: 'ProductDetailNotification',
                    builder: (context, state) {
                      final params = FFParameters(state);
                      final matvare = params.getParam<Map<String, dynamic>>(
                          'matvare', ParamType.JSON);
                      final fromChat =
                          params.getParam<bool>('fromChat', ParamType.bool);
                      final matId =
                          params.getParam<int>('matId', ParamType.int);

                      return DetailsWidget(
                          matvare: matvare, fromChat: fromChat, matId: matId);
                    },
                  ),
                  GoRoute(
                    path: 'brukerPageNotification',
                    name: 'BrukerPageNotification',
                    builder: (context, state) {
                      final params = FFParameters(state);
                      final bruker =
                          params.getParam<String>('bruker', ParamType.String);
                      final uid =
                          params.getParam<String>('uid', ParamType.String);
                      final username =
                          params.getParam<String>('username', ParamType.String);
                      return UserWidget(
                          bruker: bruker, uid: uid, username: username);
                    },
                  ),
                  GoRoute(
                    path: 'folgereNotification',
                    name: 'FolgereNotification',
                    builder: (context, state) {
                      final params = FFParameters(state);
                      final username =
                          params.getParam<String>('username', ParamType.String);
                      final folger =
                          params.getParam<String>('folger', ParamType.String);

                      return FollowersWidget(
                          username: username, folger: folger);
                    },
                  ),
                ],
              ),
            ],
          ),

          // ChatMain Branch
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/chatMain',
                name: 'ChatMain',
                pageBuilder: (context, state) {
                  final transitionInfo = state.extra as Map<String, dynamic>?;
                  final transition =
                      transitionInfo?['transition'] as TransitionInfo?;
                  if (transition != null) {
                    return CustomTransitionPage(
                      transitionDuration: const Duration(milliseconds: 0),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                      child: const ChatMainWidget(),
                    );
                  }
                  return const MaterialPage<void>(child: ChatMainWidget());
                },
              ),
            ],
          ),

          // Profil Branch
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                  path: '/profil',
                  name: 'Profil',
                  pageBuilder: (context, state) {
                    final transitionInfo = state.extra as Map<String, dynamic>?;
                    final transition =
                        transitionInfo?['transition'] as TransitionInfo?;
                    if (transition != null) {
                      return CustomTransitionPage(
                        transitionDuration: const Duration(milliseconds: 0),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: ProfilePage(),
                      );
                    }
                    return MaterialPage<void>(child: ProfilePage());
                  },
                  routes: [
                    GoRoute(
                      path: 'minMatvareDetalj',
                      name: 'MinMatvareDetalj',
                      builder: (context, state) {
                        // Use FFParameters to retrieve the parameters safely
                        final params = FFParameters(state);

                        // Retrieve the 'matvare' parameter as JSON
                        final matvare = params.getParam<Map<String, dynamic>>(
                            'matvare', ParamType.JSON);

                        // Return the ProductPage with the retrieved parameter
                        return ProductPage(matvare: matvare);
                      },
                    ),
                    GoRoute(
                      path: 'matDetaljBondegard1',
                      name: 'MatDetaljBondegard1',
                      builder: (context, state) {
                        final params = FFParameters(state);
                        final liked =
                            params.getParam<bool>('liked', ParamType.bool);
                        final matvare = params.getParam<Map<String, dynamic>>(
                            'matvare', ParamType.JSON);
                        return DetailsWidget(matvare: matvare, liked: liked);
                      },
                    ),
                    GoRoute(
                      path: 'folgereProfile',
                      name: 'FolgereProfile',
                      builder: (context, state) {
                        // Use FFParameters to retrieve the parameters safely
                        final params = FFParameters(state);

                        // Retrieve the 'username' and 'folger' parameters
                        final username = params.getParam<String>(
                            'username', ParamType.String);
                        final folger =
                            params.getParam<String>('folger', ParamType.String);

                        // Return the FollowersWidget with the retrieved parameters
                        return FollowersWidget(
                            username: username, folger: folger);
                      },
                    ),
                    GoRoute(
                      path: 'brukerPage3',
                      name: 'BrukerPage3',
                      builder: (context, state) {
                        final params = FFParameters(state);
                        final bruker =
                            params.getParam<String>('bruker', ParamType.String);
                        final uid =
                            params.getParam<String>('uid', ParamType.String);
                        final username = params.getParam<String>(
                            'username', ParamType.String);
                        return UserWidget(
                            bruker: bruker, uid: uid, username: username);
                      },
                    ),
                    GoRoute(
                      path: 'innstillinger',
                      name: 'innstillinger',
                      builder: (context, state) {
                        // Return the widget for the settings page
                        return const SettingsPage();
                      },
                    ),
                    GoRoute(
                      path: 'konto',
                      name: 'Konto',
                      builder: (context, state) {
                        // Return the widget for the settings page
                        return const AccountPage();
                      },
                    ),
                  ]),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/profilRediger',
        name: 'ProfilRediger',
        builder: (context, state) {
          final params = FFParameters(state);
          final konto = params.getParam<String>('konto', ParamType.String);
          return EditPage(konto: konto);
        },
        parentNavigatorKey: _parentKey,
      ),
      GoRoute(
        path: '/howItWorksWidget',
        name: 'HowItWorksWidget',
        builder: (context, state) {
          return const HowItWorksWidget();
        },
        parentNavigatorKey: _parentKey,
      ),
      GoRoute(
        path: '/brukerLagtUtInfo',
        name: 'BrukerLagtUtInfo',
        builder: (context, state) {
          final params = FFParameters(state);
          final picture = params.getParam<String>('picture', ParamType.String);
          return PublishedPage(
            picture: picture,
          );
        },
        parentNavigatorKey: _parentKey,
      ),
      GoRoute(
        path: '/kart',
        name: 'Kart',
        builder: (context, state) {
          final params = FFParameters(state);

          // Retrieve parameters and handle nulls/defaults
          final double? startLat =
              params.getParam<double>('startLat', ParamType.double);
          final double? startLng =
              params.getParam<double>('startLng', ParamType.double);
          final bool? accuratePosition =
              params.getParam<bool>('accuratePosition', ParamType.bool);

          return KartPopUpWidget(
            startLat: startLat,
            startLng: startLng,
            accuratePosition: accuratePosition,
          );
        },
        parentNavigatorKey: _parentKey,
      ),
      GoRoute(
        path: '/brukerPage2',
        name: 'BrukerPage2',
        builder: (context, state) {
          final params = FFParameters(state);

          final uid = params.getParam<String>('uid', ParamType.String);
          final username =
              params.getParam<String>('username', ParamType.String);
          final fromChat = params.getParam<bool>('fromChat', ParamType.bool);

          return UserWidget(
            uid: uid,
            username: username,
            fromChat: fromChat,
          );
        },
        parentNavigatorKey: _parentKey,
      ),
      GoRoute(
        path: '/matDetaljBondegard2',
        name: 'MatDetaljBondegard2',
        builder: (context, state) {
          // Retrieve parameters safely using FFParameters
          final params = FFParameters(state);
          final matvare =
              params.getParam<Map<String, dynamic>>('matvare', ParamType.JSON);
          final fromChat = params.getParam<bool>('fromChat', ParamType.bool);
          final matId = params.getParam<int>('matId', ParamType.int);
          return DetailsWidget(
              matvare: matvare, fromChat: fromChat, matId: matId);
        },
        parentNavigatorKey: _parentKey,
      ),
      GoRoute(
        path: '/folgere1',
        name: 'Folgere1',
        builder: (context, state) {
          // Retrieve parameters safely using FFParameters
          final params = FFParameters(state);

          final username =
              params.getParam<String>('username', ParamType.String);
          final folger = params.getParam<String>('folger', ParamType.String);
          final fromChat = params.getParam<bool>('fromChat', ParamType.bool);

          // Wrap the widget with the transition wrapper
          return FollowersWidget(
              username: username, folger: folger, fromChat: fromChat);
        },
        parentNavigatorKey: _parentKey,
      ),
      GoRoute(
        path: '/legguTMatvare',
        name:
            'LeggUtMatvare', // Ensure this name matches the one used in `pushNamed`
        pageBuilder: (context, state) {
          final params = FFParameters(state);
          final rediger = params.getParam<bool>('rediger', ParamType.bool);
          final matinfo = params.getParam<dynamic>('matinfo', ParamType.JSON);
          final fromChat = params.getParam<bool>('fromChat', ParamType.bool);

          return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1), // Start from the bottom
                  end: Offset.zero, // End at normal position
                ).animate(animation),
                child: child,
              );
            },
            child: PublishPage(
              rediger: rediger,
              matinfo: matinfo,
              fromChat: fromChat,
            ),
          );
        },
        parentNavigatorKey: _parentKey,
      ),
      GoRoute(
        path: '/message',
        name: 'message',
        builder: (context, state) {
          final params = FFParameters(state);
          final conversation = params.getParam<Map<String, dynamic>>(
              'conversation', ParamType.JSON);
          return MessageWidget(conversation: conversation);
        },
        parentNavigatorKey: _parentKey,
      ),
      GoRoute(
        path: '/minMatvareDetaljChat',
        name: 'MinMatvareDetaljChat',
        builder: (context, state) {
          final params = FFParameters(state);
          final matvare =
              params.getParam<Map<String, dynamic>>('matvare', ParamType.JSON);
          final matId = params.getParam<int>('matId', ParamType.int);
          return ProductPage(matvare: matvare, matId: matId);
        },
        parentNavigatorKey: _parentKey,
      ),
      GoRoute(
        path: '/productStatsChat',
        name: 'ProductStatsChat',
        builder: (context, state) {
          final params = FFParameters(state);
          final matId = params.getParam<int>('matId', ParamType.int);
          final otherUid =
              params.getParam<String>('otherUid', ParamType.String);
          return ProductStatsPage(matId: matId, otherUid: otherUid);
        },
        parentNavigatorKey: _parentKey,
      ),
      GoRoute(
        path: '/registrer',
        name: 'registrer',
        builder: (context, state) => const RegisterWidget(),
        parentNavigatorKey: _parentKey,
      ),
      GoRoute(
        path: '/opprettProfil',
        name: 'opprettProfil',
        builder: (context, state) {
          final params = FFParameters(state);
          final phone = params.getParam<String>('phone', ParamType.String)!;

          return OpprettProfilWidget(phone: phone);
        },
        parentNavigatorKey: _parentKey,
      ),
      GoRoute(
        path: '/addProfilepic',
        name: 'AddProfilepic',
        builder: (context, state) => const AddProfilePicWidget(),
        parentNavigatorKey: _parentKey,
      ),
      GoRoute(
        path: '/requestLocation',
        name: 'RequestLocation',
        builder: (context, state) => const RequestLocationWidget(),
        parentNavigatorKey: _parentKey,
      ),
      GoRoute(
        path: '/requestPush',
        name: 'RequestPush',
        builder: (context, state) => const RequestPushWidget(),
        parentNavigatorKey: _parentKey,
      ),
      GoRoute(
        path: '/requestTerms',
        name: 'RequestTerms',
        builder: (context, state) => const RequestTermsWidget(),
        parentNavigatorKey: _parentKey,
      ),
      GoRoute(
        path: '/support',
        name: 'Support',
        builder: (context, state) => const ContactPage(),
        parentNavigatorKey: _parentKey,
      ),
    ],
  );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState.updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
    );
  }
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 0),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() =>
      const TransitionInfo(hasTransition: false);
}
