import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mat_salg/BottomNavWrapper.dart';
import 'package:provider/provider.dart';

import '/auth/custom_auth/custom_auth_user_provider.dart';

import '/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

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
final GlobalKey<NavigatorState> _shellKey = GlobalKey<NavigatorState>();

GoRouter createRouter(AppStateNotifier appStateNotifier) {
  return GoRouter(
    initialLocation: FFAppState().login ? '/hjem' : '/registrer',
    navigatorKey: _parentKey, // Root navigator key
    debugLogDiagnostics: true,
    refreshListenable: appStateNotifier, // Listen for changes in app state
    errorBuilder: (context, state) {
      // Fallback widget
      return FFAppState().login
          ? MainWrapper(
              child: const HjemWidget()) // Show home with navbar if logged in
          : const RegistrerWidget(); // Show registration screen if not logged in
    },
    routes: [
      // Root route that checks login status and redirects accordingly
      // GoRoute(
      //   path: '/',
      //   builder: (context, state) {
      //     return FFAppState().login
      //         ? MainWrapper(child: const HjemWidget()) // Show home if logged in
      //         : const RegistrerWidget(); // Show registration if not logged in
      //   },
      // ),

      // ShellRoute for routes that need the persistent navbar
      ShellRoute(
        navigatorKey: _shellKey, // Shell navigator key
        builder: (context, state, child) {
          return MainWrapper(child: child); // Wrap with MainWrapper for navbar
        },
        routes: [
          GoRoute(
            path: '/hjem',
            name: 'Hjem',
            builder: (context, state) {
              return const HjemWidget();
            },
            parentNavigatorKey: _shellKey,
            pageBuilder: (context, state) {
              // Check if there's any transition info passed as part of the navigation
              final transitionInfo = state.extra as Map<String, dynamic>?;
              final transition =
                  transitionInfo?['transition'] as TransitionInfo?;

              if (transition != null) {
                // If transition info exists, use it
                return CustomTransitionPage(
                  transitionDuration: const Duration(milliseconds: 0),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: const HjemWidget(),
                );
              }

              return const MaterialPage<void>(child: HjemWidget());
            },
          ),
          GoRoute(
            path: '/mineKjop',
            name: 'MineKjop',
            builder: (context, state) {
              final params = FFParameters(state);
              final kjopt =
                  params.getParam<bool>('kjopt', ParamType.bool) ?? false;
              return MineKjopWidget(kjopt: kjopt);
            },
            pageBuilder: (context, state) {
              final transitionInfo = state.extra as Map<String, dynamic>?;
              final transition =
                  transitionInfo?['transition'] as TransitionInfo?;
              final params = FFParameters(state);
              final kjopt =
                  params.getParam<bool>('kjopt', ParamType.bool) ?? false;
              if (transition != null) {
                // If transition info exists, use it
                return CustomTransitionPage(
                  transitionDuration: const Duration(milliseconds: 0),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: MineKjopWidget(kjopt: kjopt),
                );
              }

              return MaterialPage<void>(child: MineKjopWidget(kjopt: kjopt));
            },
            parentNavigatorKey: _shellKey,
          ),
          GoRoute(
            path: '/bondeGardPage',
            name: 'BondeGardPage',
            builder: (context, state) {
              // Use FFParameters to get the query parameters safely
              final params = FFParameters(state);

              // Retrieve the parameters using getParam
              final kategori =
                  params.getParam<String>('kategori', ParamType.String);
              final query = params.getParam<String>('query', ParamType.String);

              // Return the widget with the parameters
              return BondeGardPageWidget(kategori: kategori, query: query);
            },
            parentNavigatorKey: _shellKey,
          ),
          GoRoute(
            path: '/chatMain',
            name: 'ChatMain',
            pageBuilder: (context, state) {
              // Check if there's any transition info passed as part of the navigation
              final transitionInfo = state.extra as Map<String, dynamic>?;
              final transition =
                  transitionInfo?['transition'] as TransitionInfo?;

              if (transition != null) {
                // If transition info exists, use it
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
          GoRoute(
            path: '/profil',
            name: 'Profil',
            parentNavigatorKey: _shellKey,
            pageBuilder: (context, state) {
              // Check if there's any transition info passed as part of the navigation
              final transitionInfo = state.extra as Map<String, dynamic>?;
              final transition =
                  transitionInfo?['transition'] as TransitionInfo?;

              if (transition != null) {
                // If transition info exists, use it
                return CustomTransitionPage(
                  transitionDuration: const Duration(milliseconds: 0),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: const ProfilWidget(),
                );
              }

              return const MaterialPage<void>(child: ProfilWidget());
            },
          ),
          GoRoute(
            path: '/matDetaljBondegard',
            name: 'MatDetaljBondegard',
            builder: (context, state) {
              final params = FFParameters(state);
              final matvare = params.getParam<Map<String, dynamic>>(
                  'matvare', ParamType.JSON);
              return MatDetaljBondegardWidget(matvare: matvare);
            },
            parentNavigatorKey: _shellKey,
          ),
          GoRoute(
            path: '/minMatvareDetalj',
            name: 'MinMatvareDetalj',
            builder: (context, state) {
              final params = FFParameters(state);
              final matvare = params.getParam<Map<String, dynamic>>(
                  'matvare', ParamType.JSON);
              return MinMatvareDetaljWidget(matvare: matvare);
            },
            parentNavigatorKey: _shellKey,
          ),
          GoRoute(
            path: '/brukerPage',
            name: 'BrukerPage',
            builder: (context, state) {
              final params = FFParameters(state);
              final bruker =
                  params.getParam<String>('bruker', ParamType.String);
              final username =
                  params.getParam<String>('username', ParamType.String);
              return BrukerPageWidget(bruker: bruker, username: username);
            },
            parentNavigatorKey: _shellKey,
          ),
          GoRoute(
            path: '/solgteMatvarer',
            name: 'solgteMatvarer',
            builder: (context, state) {
              return const SolgteMatvarerWidget();
            },
            parentNavigatorKey: _shellKey,
          ),
          GoRoute(
            path: '/innstillinger',
            name: 'innstillinger',
            builder: (context, state) {
              return const InnstillingerWidget();
            },
            parentNavigatorKey: _shellKey,
          ),
          GoRoute(
            path: '/folgere',
            name: 'Folgere',
            builder: (context, state) {
              // Use FFParameters to retrieve the parameters safely
              final params = FFParameters(state);

              // Retrieve the 'username' and 'folger' parameters
              final username =
                  params.getParam<String>('username', ParamType.String);
              final folger =
                  params.getParam<String>('folger', ParamType.String);

              // Return the FolgereWidget with the retrieved parameters
              return FolgereWidget(username: username, folger: folger);
            },
            parentNavigatorKey: _shellKey,
          ),
          GoRoute(
            path: '/kjopDetaljVentende',
            name: 'KjopDetaljVentende',
            builder: (context, state) {
              // Directly accessing the passed object from `state.extra`

              // Return your widget, passing the `ordre` directly
              return KjopDetaljVentendeWidget(ordre: state.extra);
            },
            parentNavigatorKey: _shellKey,
          ),
        ],
      ),
      GoRoute(
        path: '/godkjentbetaling',
        name: 'Godkjentbetaling',
        builder: (context, state) {
          // Directly return the GodkjentbetalingWidget as there are no parameters
          return const GodkjentbetalingWidget();
        },
        parentNavigatorKey: _parentKey,
      ),
      GoRoute(
        path: '/profilRediger',
        name: 'ProfilRediger',
        builder: (context, state) {
          return const ProfilRedigerWidget();
        },
        parentNavigatorKey: _parentKey,
      ),
      GoRoute(
        path: '/brukerLagtUtInfo',
        name: 'BrukerLagtUtInfo',
        builder: (context, state) {
          // Directly return the BrukerLagtUtInfoWidget as there are no parameters
          return const BrukerLagtUtInfoWidget();
        },
        parentNavigatorKey: _parentKey,
      ),

      GoRoute(
        path: '/leggIgjenRating',
        name: 'LeggIgjenRating',
        builder: (context, state) {
          // Use FFParameters to retrieve the parameters safely
          final params = FFParameters(state);

          // Retrieve the 'kjop' (boolean) and 'username' (string) parameters
          final kjop = params.getParam<bool>('kjop', ParamType.bool);
          final username =
              params.getParam<String>('username', ParamType.String);

          // Return the LeggIgjenRatingWidget with the retrieved parameters
          return LeggIgjenRatingWidget(kjop: kjop, username: username);
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
            child: LeggUtMatvareWidget(
              rediger: rediger,
              matinfo: matinfo,
            ),
          );
        },
        parentNavigatorKey: _parentKey,
      ),
      GoRoute(
        path: '/message',
        name: 'message',
        builder: (context, state) {
          // Use FFParameters to retrieve the parameters safely
          final params = FFParameters(state);

          // Retrieve the 'conversation' parameter using ParamType.JSON
          final conversation = params.getParam<Map<String, dynamic>>(
              'conversation', ParamType.JSON);

          // Return the MessageWidget with the retrieved 'conversation' parameter
          return MessageWidget(conversation: conversation);
        },
        parentNavigatorKey: _parentKey,
      ),
      GoRoute(
        path: '/brukerRating',
        name: 'BrukerRating',
        builder: (context, state) {
          // Use FFParameters to retrieve the parameters safely
          final params = FFParameters(state);

          // Retrieve the parameters using getParam with the appropriate ParamType
          final username =
              params.getParam<String>('username', ParamType.String);
          final mine = params.getParam<bool>('mine', ParamType.bool);

          // Return the BrukerRatingWidget with the retrieved parameters
          return BrukerRatingWidget(
            username: username,
            mine: mine,
          );
        },
        parentNavigatorKey: _parentKey,
      ),

      GoRoute(
        path: '/velgPosisjon',
        name: 'VelgPosisjon',
        builder: (context, state) {
          // Use FFParameters to retrieve the parameters safely
          final params = FFParameters(state);

          // Retrieve the parameters using getParam with the appropriate ParamType
          final bonde = params.getParam<bool>('bonde', ParamType.bool);
          final endrepos = params.getParam<bool>('endrepos', ParamType.bool);
          final email = params.getParam<String>('email', ParamType.String);
          final password =
              params.getParam<String>('password', ParamType.String);
          final phone = params.getParam<String>('phone', ParamType.String);

          // Return the VelgPosisjonWidget with the retrieved parameters
          return VelgPosisjonWidget(
            bonde: bonde,
            endrepos: endrepos,
            email: email,
            password: password,
            phone: phone,
          );
        },
        parentNavigatorKey: _parentKey,
      ),

      GoRoute(
        path: '/brukerOnboarding',
        name: 'brukerOnboarding',
        builder: (context, state) {
          return const BrukerOnboardingWidget();
        },
        parentNavigatorKey: _parentKey,
      ),
      GoRoute(
        path: '/betaling',
        name: 'Betaling',
        builder: (context, state) {
          final params = FFParameters(state);
          final matinfo =
              params.getParam<Map<String, dynamic>>('matinfo', ParamType.JSON);
          return BetalingWidget(matinfo: matinfo);
        },
        parentNavigatorKey: _parentKey,
      ),
      GoRoute(
        path: '/registrer',
        name: 'registrer',
        builder: (context, state) => const RegistrerWidget(),
        parentNavigatorKey: _parentKey,
      ),
      GoRoute(
        path: '/opprettProfil',
        name: 'opprettProfil',
        builder: (context, state) {
          final params = FFParameters(state);

          // You can use `params.getParam` to safely get parameters.
          final phone = params.getParam<String>('phone', ParamType.String)!;
          final posisjon =
              params.getParam<LatLng>('posisjon', ParamType.LatLng)!;

          return OpprettProfilWidget(phone: phone, posisjon: posisjon);
        },
        parentNavigatorKey: _parentKey,
      ),
    ],
  );
}

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
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
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
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

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
            return '/registrer';
          }
          return null;
        },
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);

          final child = appStateNotifier.loading
              ? Container(
                  color: FlutterFlowTheme.of(context).primary,
                  child: Image.asset(
                    'assets/images/white.jpg',
                    fit: BoxFit.cover,
                  ),
                )
              : page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
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

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
