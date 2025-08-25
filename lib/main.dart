import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:mat_salg/services/user_service.dart';
import 'package:mat_salg/services/web_socket.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/logging.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter/services.dart';
import 'auth/custom_auth/custom_auth_user_provider.dart';
import 'helper_components/flutter_flow/flutter_flow_util.dart';
import 'helper_components/flutter_flow/internationalization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  try {
    await Firebase.initializeApp();
    logger.d("Firebase Initialized Successfully");
  } catch (e) {
    logger.d("Error initializing Firebase: $e");
  }

  final appState = FFAppState();
  await appState.initializePersistedState();

  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();

  static MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>()!;
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Locale? _locale;
  final ThemeMode _themeMode = ThemeMode.system;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  late WebSocketService _webSocketService;
  late Stream<MatSalgAuthUser> userStream;
  final UserInfoService userInfoService = UserInfoService();
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();

  @override
  void initState() {
    super.initState();

    // Add observer to listen for app lifecycle changes
    WidgetsBinding.instance.addObserver(this);
    _webSocketService = WebSocketService();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);

    userStream = matSalgAuthUserStream()
      ..listen((user) {
        _appStateNotifier.update(user);
      });

    if (FFAppState().login) {
      _webSocketService.connect(retrying: true);
      userInfoService.updateUserStats(context, false);
    }
    Future.delayed(
      const Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.inactive) {
      _webSocketService.close();
      logger.d("WebSocket closed as app is in the background.");
    } else if (state == AppLifecycleState.resumed) {
      _webSocketService.connect(retrying: true);
      logger.d("App resumed, checking connectivity...");
    }
  }

// I Changed this line: Duration get transitionDuration => const Duration(milliseconds: 490); in the MaterialPageRoute package it was originally 300 but I found it too slow so I changed it to 490
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'MatSalg',
      localizationsDelegates: const [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('nb'),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          },
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: CupertinoColors.activeBlue,
          selectionColor: CupertinoColors.activeBlue.withOpacity(0.3),
          selectionHandleColor: CupertinoColors.activeBlue,
        ),
        cupertinoOverrideTheme: CupertinoThemeData(
          primaryColor: CupertinoColors.activeBlue,
        ),
      ),
      themeMode: _themeMode,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
              textScaler: Platform.isIOS
                  ? TextScaler.linear(1)
                  : TextScaler.linear(0.95)),
          child: child!,
        );
      },
      routerConfig: _router,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _webSocketService.close();
    super.dispose();
  }
}
