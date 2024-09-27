import 'dart:async';

import 'package:flutter/material.dart';
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

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      errorBuilder: (context, state) => appStateNotifier.loggedIn
          ? const HjemWidget()
          : const RegistrerWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.loggedIn
              ? const HjemWidget()
              : const RegistrerWidget(),
        ),
        FFRoute(
          name: 'registrer',
          path: '/registrer',
          builder: (context, params) => const RegistrerWidget(),
        ),
        FFRoute(
          name: 'MineKjop',
          path: '/mineKjop',
          builder: (context, params) => MineKjopWidget(
            kjopt: params.getParam(
              'kjopt',
              ParamType.bool,
            ),
          ),
        ),
        FFRoute(
          name: 'MatDetalj',
          path: '/matDetalj',
          builder: (context, params) => MatDetaljWidget(
            matinfo: params.getParam(
              'matinfo',
              ParamType.JSON,
            ),
          ),
        ),
        FFRoute(
          name: 'Godkjentbetaling',
          path: '/godkjentbetaling',
          builder: (context, params) => const GodkjentbetalingWidget(),
        ),
        FFRoute(
          name: 'Profil',
          path: '/profil',
          builder: (context, params) => const ProfilWidget(),
        ),
        FFRoute(
          name: 'ProfilRediger',
          path: '/profilRediger',
          builder: (context, params) => const ProfilRedigerWidget(),
        ),
        FFRoute(
          name: 'LeggUtMatvare',
          path: '/leggUtMatvare',
          builder: (context, params) => LeggUtMatvareWidget(
            rediger: params.getParam(
              'rediger',
              ParamType.bool,
            ),
            matinfo: params.getParam(
              'matinfo',
              ParamType.JSON,
            ),
          ),
        ),
        FFRoute(
          name: 'KjopDetaljGodkjent',
          path: '/kjopDetaljGodkjent',
          builder: (context, params) => KjopDetaljGodkjentWidget(
            matinfo: params.getParam(
              'matinfo',
              ParamType.JSON,
            ),
          ),
        ),
        FFRoute(
          name: 'BrukerLagtUtInfo',
          path: '/brukerLagtUtInfo',
          builder: (context, params) => const BrukerLagtUtInfoWidget(),
        ),
        FFRoute(
          name: 'ChatMain',
          path: '/chatMain',
          builder: (context, params) => const ChatMainWidget(),
        ),
        FFRoute(
          name: 'Hjem',
          path: '/hjem',
          builder: (context, params) => const HjemWidget(),
        ),
        FFRoute(
          name: 'MinMatvareDetalj',
          path: '/minMatvareDetalj',
          builder: (context, params) => MinMatvareDetaljWidget(
            matinfo: params.getParam(
              'matinfo',
              ParamType.JSON,
            ),
          ),
        ),
        FFRoute(
          name: 'MatDetaljBondegard',
          path: '/matDetaljBondegard',
          builder: (context, params) => MatDetaljBondegardWidget(
            matinfo: params.getParam(
              'matinfo',
              ParamType.JSON,
            ),
          ),
        ),
        FFRoute(
          name: 'SolgteMatvarer',
          path: '/solgteMatvarer',
          builder: (context, params) => const SolgteMatvarerWidget(),
        ),
        FFRoute(
          name: 'BekreftTLF',
          path: '/bekreftTLF',
          builder: (context, params) => BekreftTLFWidget(
            bonde: params.getParam(
              'bonde',
              ParamType.bool,
            ),
            email: params.getParam(
              'email',
              ParamType.String,
            ),
            password: params.getParam(
              'password',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'RegistrerBonde',
          path: '/registrerBonde',
          builder: (context, params) => RegistrerBondeWidget(
            email: params.getParam(
              'email',
              ParamType.String,
            ),
            password: params.getParam(
              'password',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'BrukerOnboarding',
          path: '/brukerOnboarding',
          builder: (context, params) => const BrukerOnboardingWidget(),
        ),
        FFRoute(
          name: 'BondeGardPage',
          path: '/bondeGardPage',
          builder: (context, params) => const BondeGardPageWidget(),
        ),
        FFRoute(
          name: 'Hjem2',
          path: '/hjem2',
          builder: (context, params) => const Hjem2Widget(),
        ),
        FFRoute(
          name: 'MinMatDetalj2',
          path: '/minMatDetalj2',
          builder: (context, params) => MinMatDetalj2Widget(
            matinfo: params.getParam(
              'matinfo',
              ParamType.JSON,
            ),
          ),
        ),
        FFRoute(
          name: 'Salg',
          path: '/salg',
          builder: (context, params) => const SalgWidget(),
        ),
        FFRoute(
          name: 'Profil2',
          path: '/profil2',
          builder: (context, params) => const Profil2Widget(),
        ),
        FFRoute(
          name: 'BekreftetHentet',
          path: '/MatvareHentet',
          builder: (context, params) => const BekreftetHentetWidget(),
        ),
        FFRoute(
          name: 'LeggIgjenRating',
          path: '/leggIgjenRating',
          builder: (context, params) => const LeggIgjenRatingWidget(),
        ),
        FFRoute(
          name: 'VelgPosisjon',
          path: '/velgPosisjon',
          builder: (context, params) => VelgPosisjonWidget(
            bonde: params.getParam(
              'bonde',
              ParamType.bool,
            ),
            endrepos: params.getParam(
              'endrepos',
              ParamType.bool,
            ),
            email: params.getParam(
              'email',
              ParamType.String,
            ),
            password: params.getParam(
              'password',
              ParamType.String,
            ),
            phone: params.getParam(
              'phone',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'BrukerPage',
          path: '/brukerPage',
          builder: (context, params) => const BrukerPageWidget(),
        ),
        FFRoute(
          name: 'Folgere',
          path: '/folgere',
          builder: (context, params) => FolgereWidget(
            folger: params.getParam(
              'folger',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'BrukerRating',
          path: '/brukerRating',
          builder: (context, params) => const BrukerRatingWidget(),
        ),
        FFRoute(
          name: 'SalgsHistorikk2',
          path: '/salgsHistorikk2',
          builder: (context, params) => const SalgsHistorikk2Widget(),
        ),
        FFRoute(
          name: 'BekreftOTP',
          path: '/bekreftOTP',
          builder: (context, params) => BekreftOTPWidget(
            bonde: params.getParam(
              'bonde',
              ParamType.bool,
            ),
            email: params.getParam(
              'email',
              ParamType.String,
            ),
            password: params.getParam(
              'password',
              ParamType.String,
            ),
            phone: params.getParam(
              'phone',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'OpprettProfil',
          path: '/opprettProfil',
          builder: (context, params) => OpprettProfilWidget(
            bonde: params.getParam(
              'bonde',
              ParamType.bool,
            ),
            email: params.getParam(
              'email',
              ParamType.String,
            ),
            password: params.getParam(
              'password',
              ParamType.String,
            ),
            phone: params.getParam(
              'phone',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'BondeOnboarding',
          path: '/bondeOnboarding',
          builder: (context, params) => const BondeOnboardingWidget(),
        ),
        FFRoute(
          name: 'Se',
          path: '/se',
          builder: (context, params) => const SeWidget(),
        ),
        FFRoute(
          name: 'BondeChat',
          path: '/bondeChat',
          builder: (context, params) => const BondeChatWidget(),
        ),
        FFRoute(
          name: 'KjopDetaljVentende',
          path: '/kjopDetaljVentende',
          builder: (context, params) => KjopDetaljVentendeWidget(
            matinfo: params.getParam(
              'matinfo',
              ParamType.JSON,
            ),
          ),
        ),
        FFRoute(
          name: 'Betaling',
          path: '/betaling',
          builder: (context, params) => BetalingWidget(
            matinfo: params.getParam(
              'matinfo',
              ParamType.JSON,
            ),
          ),
        ),
        FFRoute(
          name: 'innstillinger',
          path: '/innstillinger',
          builder: (context, params) => const InnstillingerWidget(),
        ),
        FFRoute(
          name: 'Utbetalingsinfo1',
          path: '/utbetalingsinfo1',
          builder: (context, params) => const Utbetalingsinfo1Widget(),
        ),
        FFRoute(
          name: 'MatPostInfo',
          path: '/matPostInfo',
          builder: (context, params) => const MatPostInfoWidget(),
        ),
        FFRoute(
          name: 'GodkjentbudInfo',
          path: '/godkjentbudInfo',
          builder: (context, params) => const GodkjentbudInfoWidget(),
        ),
        FFRoute(
          name: 'BondeLagtUtInfo',
          path: '/bondeLagtUtInfo',
          builder: (context, params) => const BondeLagtUtInfoWidget(),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

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
    this.duration = const Duration(milliseconds: 300),
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
