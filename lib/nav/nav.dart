import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mat_salg/bottomNavWrapper.dart';
import 'package:mat_salg/pages/app_pages/profile/settings/account/account_page.dart';
import 'package:provider/provider.dart';

import '/auth/custom_auth/custom_auth_user_provider.dart';

import '/index.dart';
import '../helper_components/flutter_flow/flutter_flow_theme.dart';
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
    initialLocation: FFAppState().login ? '/hjem' : '/registrer',
    navigatorKey: _parentKey, // Root navigator key
    debugLogDiagnostics: true,
    refreshListenable: appStateNotifier, // Listen for changes in app state
    errorBuilder: (context, state) {
      return const RegistrerWidget();
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(child: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey:
                _shellNavigatorHome, // Keep a separate navigator for Hjem
            routes: <RouteBase>[
              GoRoute(
                path: '/hjem',
                name: 'Hjem',
                builder: (context, state) {
                  return const HjemWidget();
                },
                pageBuilder: (context, state) {
                  return const NoTransitionPage(child: HjemWidget());
                },
                routes: [
                  GoRoute(
                    path: 'matDetaljBondegard',
                    name: 'MatDetaljBondegard',
                    builder: (context, state) {
                      final params = FFParameters(state);
                      final matvare = params.getParam<Map<String, dynamic>>(
                          'matvare', ParamType.JSON);
                      return MatDetaljBondegardWidget(matvare: matvare);
                    },
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey, // Maintain page state
                        child: MatDetaljBondegardWidget(
                          matvare: FFParameters(state)
                              .getParam<Map<String, dynamic>>(
                                  'matvare', ParamType.JSON),
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const Offset begin =
                              Offset(1.0, 0.0); // Slide in from right
                          const Offset end = Offset.zero;
                          const Curve curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      );
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
                      return BrukerPageWidget(
                          bruker: bruker, uid: uid, username: username);
                    },
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: BrukerPageWidget(
                          bruker: FFParameters(state)
                              .getParam<String>('bruker', ParamType.String),
                          uid: FFParameters(state)
                              .getParam<String>('uid', ParamType.String),
                          username: FFParameters(state)
                              .getParam<String>('username', ParamType.String),
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const Offset begin =
                              Offset(1.0, 0.0); // Slide in from right
                          const Offset end = Offset.zero;
                          const Curve curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      );
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

                      // Return the FolgereWidget with the retrieved parameters
                      return FolgereWidget(username: username, folger: folger);
                    },
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey, // Maintain the page state
                        child: FolgereWidget(
                          username: FFParameters(state)
                              .getParam<String>('username', ParamType.String),
                          folger: FFParameters(state)
                              .getParam<String>('folger', ParamType.String),
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const Offset begin =
                              Offset(1.0, 0.0); // Slide in from the right
                          const Offset end = Offset.zero;
                          const Curve curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      );
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
                      return BondeGardPageWidget(
                          kategori: kategori, query: query);
                    },
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey, // Maintain page state
                        child: BondeGardPageWidget(
                          kategori: FFParameters(state)
                              .getParam<String>('kategori', ParamType.String),
                          query: FFParameters(state)
                              .getParam<String>('query', ParamType.String),
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const Offset begin =
                              Offset(1.0, 0.0); // Slide in from right
                          const Offset end = Offset.zero;
                          const Curve curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          // MineKjop Branch
          StatefulShellBranch(
            navigatorKey: _mineKjopNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: '/mineKjop',
                name: 'MineKjop',
                builder: (context, state) {
                  final params = FFParameters(state);
                  final kjopt =
                      params.getParam<bool>('kjopt', ParamType.bool) ?? false;
                  return OrdersPage(kjopt: kjopt);
                },
                pageBuilder: (context, state) {
                  final params = FFParameters(state);
                  final kjopt =
                      params.getParam<bool>('kjopt', ParamType.bool) ?? false;
                  return MaterialPage<void>(child: OrdersPage(kjopt: kjopt));
                },
                routes: [
                  GoRoute(
                    path: 'kjopDetaljVentende',
                    name: 'KjopDetaljVentende',
                    builder: (context, state) {
                      // Accessing the passed object from `state.extra`
                      final ordre = state.extra;

                      // Return the widget, passing `ordre` directly
                      return KjopDetaljVentendeWidget(ordre: ordre);
                    },
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey, // Maintain the page state
                        child: KjopDetaljVentendeWidget(ordre: state.extra),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const Offset begin =
                              Offset(1.0, 0.0); // Slide in from the right
                          const Offset end = Offset.zero;
                          const Curve curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      );
                    },
                  ),
                  GoRoute(
                    path: 'brukerPage1',
                    name: 'BrukerPage1',
                    builder: (context, state) {
                      final params = FFParameters(state);
                      final bruker =
                          params.getParam<String>('bruker', ParamType.String);
                      final uid =
                          params.getParam<String>('uid', ParamType.String);
                      final username =
                          params.getParam<String>('username', ParamType.String);
                      return BrukerPageWidget(
                          bruker: bruker, uid: uid, username: username);
                    },
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: BrukerPageWidget(
                          bruker: FFParameters(state)
                              .getParam<String>('bruker', ParamType.String),
                          uid: FFParameters(state)
                              .getParam<String>('uid', ParamType.String),
                          username: FFParameters(state)
                              .getParam<String>('username', ParamType.String),
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const Offset begin =
                              Offset(1.0, 0.0); // Slide in from right
                          const Offset end = Offset.zero;
                          const Curve curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      );
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
                        child: const ProfilePage(),
                      );
                    }
                    return const MaterialPage<void>(child: ProfilePage());
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
                      pageBuilder: (context, state) {
                        return CustomTransitionPage<void>(
                          key: state.pageKey, // Maintain the page state
                          child: ProductPage(
                            matvare: FFParameters(state)
                                .getParam<Map<String, dynamic>>(
                                    'matvare', ParamType.JSON),
                          ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const Offset begin =
                                Offset(1.0, 0.0); // Slide in from the right
                            const Offset end = Offset.zero;
                            const Curve curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        );
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
                        return MatDetaljBondegardWidget(
                            matvare: matvare, liked: liked);
                      },
                      pageBuilder: (context, state) {
                        return CustomTransitionPage<void>(
                          key: state.pageKey, // Maintain page state
                          child: MatDetaljBondegardWidget(
                            matvare: FFParameters(state)
                                .getParam<Map<String, dynamic>>(
                                    'matvare', ParamType.JSON),
                            liked: FFParameters(state)
                                .getParam<bool>('liked', ParamType.bool),
                          ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const Offset begin =
                                Offset(1.0, 0.0); // Slide in from right
                            const Offset end = Offset.zero;
                            const Curve curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        );
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
                        return BrukerPageWidget(
                            bruker: bruker, uid: uid, username: username);
                      },
                      pageBuilder: (context, state) {
                        return CustomTransitionPage<void>(
                          key: state.pageKey,
                          child: BrukerPageWidget(
                            bruker: FFParameters(state)
                                .getParam<String>('bruker', ParamType.String),
                            uid: FFParameters(state)
                                .getParam<String>('uid', ParamType.String),
                            username: FFParameters(state)
                                .getParam<String>('username', ParamType.String),
                          ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const Offset begin =
                                Offset(1.0, 0.0); // Slide in from right
                            const Offset end = Offset.zero;
                            const Curve curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        );
                      },
                    ),
                    GoRoute(
                      path: 'innstillinger',
                      name: 'innstillinger',
                      builder: (context, state) {
                        // Return the widget for the settings page
                        return const SettingsPage();
                      },
                      pageBuilder: (context, state) {
                        return CustomTransitionPage<void>(
                          key: state.pageKey, // Maintain the page state
                          child: const SettingsPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const Offset begin =
                                Offset(1.0, 0.0); // Slide in from the right
                            const Offset end = Offset.zero;
                            const Curve curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        );
                      },
                    ),
                    GoRoute(
                      path: 'konto',
                      name: 'Konto',
                      builder: (context, state) {
                        // Return the widget for the settings page
                        return const AccountPage();
                      },
                      pageBuilder: (context, state) {
                        return CustomTransitionPage<void>(
                          key: state.pageKey, // Maintain the page state
                          child: const AccountPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const Offset begin =
                                Offset(1.0, 0.0); // Slide in from the right
                            const Offset end = Offset.zero;
                            const Curve curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        );
                      },
                    ),
                  ]),
            ],
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
          final params = FFParameters(state);
          final konto = params.getParam<String>('konto', ParamType.String);
          return EditPage(konto: konto);
        },
        parentNavigatorKey: _parentKey,
      ),
      GoRoute(
        path: '/brukerLagtUtInfo',
        name: 'BrukerLagtUtInfo',
        builder: (context, state) {
          return const PublishedPage();
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

          return BrukerPageWidget(
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

          // Directly return the widget with the retrieved parameters
          return MatDetaljBondegardWidget(matvare: matvare, fromChat: fromChat);
        },
        parentNavigatorKey: _parentKey,
      ),
      GoRoute(
        path: '/kjopDetaljVentende1',
        name: 'KjopDetaljVentende1',
        builder: (context, state) {
          // Extract 'mine' and 'ordre' from state.extra, assuming it's a Map
          final extraData = state.extra as Map<String, dynamic>;

          final mine = extraData['mine']; // Get 'mine'
          final ordre = extraData['ordre']; // Get 'ordre'

          return KjopDetaljVentendeWidget(
            ordre: ordre,
            mine: mine,
          );
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
          return FolgereWidget(
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
      GoRoute(
        path: '/addProfilepic',
        name: 'AddProfilepic',
        builder: (context, state) => const AddProfilePicWidget(),
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
