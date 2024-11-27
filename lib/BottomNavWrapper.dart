import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mat_salg/flutter_flow/flutter_flow_icon_button.dart';
import 'package:mat_salg/flutter_flow/flutter_flow_theme.dart';
import 'package:mat_salg/flutter_flow/flutter_flow_util.dart';
import 'package:mat_salg/flutter_flow/nav/nav.dart';

class MainWrapper extends StatefulWidget {
  final Widget child;

  MainWrapper({required this.child});

  @override
  _MainWrapperState createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  // Function to map route to the correct index
  int _getIndexForRoute(String location) {
    if (location.startsWith('/hjem')) {
      return 0;
    } else if (location.startsWith('/mineKjop')) {
      return 1;
    } else if (location.startsWith('/chatMain')) {
      return 3;
    } else if (location.startsWith('/profil')) {
      return 4;
    }
    return _selectedIndex; // Default to current index for unmatched routes
  }

  // Function to change the selected index and navigate to the respective page
  void _onItemTapped(int index) {
    // Don't update the navbar color if we're navigating to 'LeggUtMatvare'
    if (index != 2) {
      setState(() {
        _selectedIndex = index;
      });
    }
    const kTransitionInfoKey = 'transitionInfo';
    switch (index) {
      case 0:
        GoRouter.of(context).go(
          '/hjem',
          extra: <String, dynamic>{
            // Pass the transition information
            kTransitionInfoKey: const TransitionInfo(
              hasTransition: true, // Trigger the transition
              transitionType: PageTransitionType.fade, // Fade transition
              duration: Duration(milliseconds: 0), // Instant transition
            ),
          },
        );
        break;
      case 1:
        GoRouter.of(context).go(
          '/mineKjop',
          extra: <String, dynamic>{
            kTransitionInfoKey: const TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.fade, // Using fade transition
              duration: Duration(
                  milliseconds:
                      0), // Set duration to 0ms for no transition time
            ),
          },
        );
        break;
      case 2:
        context.pushNamed(
          'LeggUtMatvare',
          extra: <String, dynamic>{
            kTransitionInfoKey: const TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.bottomToTop,
              duration: Duration(milliseconds: 200),
            ),
          },
        );
        break;
      case 3:
        GoRouter.of(context).go(
          '/chatMain',
          extra: <String, dynamic>{
            kTransitionInfoKey: const TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.fade, // Using fade transition
              duration: Duration(
                  milliseconds:
                      0), // Set duration to 0ms for no transition time
            ),
          },
        );
        break;
      case 4:
        GoRouter.of(context).go(
          '/profil',
          extra: <String, dynamic>{
            kTransitionInfoKey: const TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.fade, // Using fade transition
              duration: Duration(
                  milliseconds:
                      0), // Set duration to 0ms for no transition time
            ),
          },
        );
        break;
    }
  }

  // void _updateSelectedIndex(BuildContext context) {
  //   final location = GoRouterState.of(context).uri.toString();

  //   if (location.startsWith('/hjem')) {
  //     _selectedIndex = 0;
  //   } else if (location.startsWith('/mineKjop')) {
  //     _selectedIndex = 1;
  //   } else if (location.startsWith('/chatMain')) {
  //     _selectedIndex = 3;
  //   } else if (location.startsWith('/profil')) {
  //     _selectedIndex = 4;
  //   }
  //   // Don't update the index for 'LeggUtMatvare'
  // }

  @override
  void initState() {
    super.initState();
    // Update selected index based on the current route on initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getIndexForRoute(GoRouterState.of(context).uri.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    // Update the selected index based on the current location
    final location = GoRouterState.of(context).uri.toString();
    final newIndex = _getIndexForRoute(location);

    if (newIndex != _selectedIndex) {
      _selectedIndex = newIndex;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: widget.child, // Main content (child widget)

      // Bottom Navigation Bar

      bottomNavigationBar: Stack(
        children: [
          // Bottom Navigation Bar
          Container(
            color: Colors.white,
            child: SafeArea(
              child: Container(
                width: double.infinity,
                height: 61.0,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Color.fromARGB(50, 87, 99, 108),
                      width: 1.0,
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Material(
                          color: Colors.white,
                          elevation: 0.0,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(0.0),
                              bottomRight: Radius.circular(0.0),
                            ),
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 60.0,
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10.0,
                                  color: Color.fromARGB(0, 87, 99, 108),
                                  offset: Offset(0.0, -10.0),
                                  spreadRadius: 0.1,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: const AlignmentDirectional(0.0, 0.4),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FlutterFlowIconButton(
                            borderColor: Colors.transparent,
                            borderRadius: 30.0,
                            borderWidth: 1.0,
                            buttonSize: 50.0,
                            icon: Icon(
                              Ionicons.home_outline,
                              color: _selectedIndex == 0
                                  ? FlutterFlowTheme.of(context).alternate
                                  : const Color(0xFF262626),
                              size: 29.0,
                            ),
                            onPressed: () => _onItemTapped(0),
                          ),
                          FlutterFlowIconButton(
                            borderColor: Colors.transparent,
                            borderRadius: 30.0,
                            borderWidth: 1.0,
                            buttonSize: 50.0,
                            icon: Icon(
                              Ionicons.bag_check_outline,
                              color: _selectedIndex == 1
                                  ? FlutterFlowTheme.of(context).alternate
                                  : const Color(0xFF262626),
                              size: 30.0,
                            ),
                            onPressed: () => _onItemTapped(1),
                          ),
                          FlutterFlowIconButton(
                            borderColor: Colors.transparent,
                            borderRadius: 30.0,
                            borderWidth: 1.0,
                            buttonSize: 50.0,
                            icon: Icon(
                              CupertinoIcons.add,
                              color: _selectedIndex == 2
                                  ? FlutterFlowTheme.of(context).alternate
                                  : const Color(0xFF262626),
                              size: 29.0,
                            ),
                            onPressed: () => _onItemTapped(2),
                          ),
                          FlutterFlowIconButton(
                            borderColor: Colors.transparent,
                            borderRadius: 30.0,
                            borderWidth: 1.0,
                            buttonSize: 50.0,
                            icon: Icon(
                              CupertinoIcons.chat_bubble,
                              color: _selectedIndex == 3
                                  ? FlutterFlowTheme.of(context).alternate
                                  : const Color(0xFF262626),
                              size: 29.0,
                            ),
                            onPressed: () => _onItemTapped(3),
                          ),
                          FlutterFlowIconButton(
                            borderColor: Colors.transparent,
                            borderRadius: 30.0,
                            borderWidth: 1.0,
                            buttonSize: 50.0,
                            icon: Icon(
                              CupertinoIcons.person,
                              color: _selectedIndex == 4
                                  ? FlutterFlowTheme.of(context).alternate
                                  : const Color(0xFF262626),
                              size: 29.0,
                            ),
                            onPressed: () => _onItemTapped(4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Optional: Add the BottomSheet as a separate stack layer if you need to show custom content
          if (FFAppState().kjopAlert == true)
            Align(
              alignment: const AlignmentDirectional(-0.3, -0.18),
              child: Container(
                width: 10.0,
                height: 10.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).error,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          if (FFAppState().chatAlert == true)
            Align(
              alignment: const AlignmentDirectional(0.45, -0.15),
              child: Container(
                width: 10.0,
                height: 10.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).error,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
