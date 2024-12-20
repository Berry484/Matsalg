import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_icon_button.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_theme.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_util.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({Key? key, required this.child}) : super(key: key);

  final StatefulNavigationShell child;

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
      return 2;
    } else if (location.startsWith('/profil')) {
      return 3;
    }
    return _selectedIndex; // Default to current index for unmatched routes
  }

  void _onItemTapped(int index) {
    const kTransitionInfoKey = 'transitionInfo';

    if (_selectedIndex == index) {
      switch (GoRouterState.of(context).uri.toString()) {
        case '/hjem':
          return;
        case '/mineKjop':
          return;
        case '/chatMain':
          return;
        case '/profil':
          return;
      }

      GoRouter.of(context).pop();
      return; // Exit early, no need to change the selected index or navigate
    }

    // Update the selected index for pages other than the special case
    setState(() {
      _selectedIndex = index;
    });

    // Navigate based on the index
    switch (index) {
      case 0:
        widget.child.goBranch(index);
        break;
      case 1:
        widget.child.goBranch(index);
        break;
      case 2:
        widget.child.goBranch(index);
        break;
      case 3:
        widget.child.goBranch(index);
        break;
      case 4:
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
    }
  }

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
                            icon: const Icon(
                              CupertinoIcons.add,
                              color: Color(0xFF262626),
                              size: 29.0,
                            ),
                            onPressed: () => _onItemTapped(4),
                          ),
                          Stack(
                            clipBehavior:
                                Clip.none, // Ensures the red dot isn't clipped
                            children: [
                              FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 30.0,
                                borderWidth: 1.0,
                                buttonSize: 50.0,
                                icon: Icon(
                                  CupertinoIcons.chat_bubble,
                                  color: _selectedIndex == 2
                                      ? FlutterFlowTheme.of(context).alternate
                                      : const Color(0xFF262626),
                                  size: 29.0,
                                ),
                                onPressed: () => _onItemTapped(2),
                              ),
                              ValueListenableBuilder<bool>(
                                valueListenable: FFAppState().chatAlert,
                                builder: (context, chatAlert, _) {
                                  if (!chatAlert) {
                                    return const SizedBox
                                        .shrink(); // No dot if `chatAlert` is false
                                  }
                                  return Positioned(
                                    top: 9,
                                    right: 7,
                                    child: Container(
                                      width: 8.0,
                                      height: 8.0,
                                      decoration: BoxDecoration(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          FlutterFlowIconButton(
                            borderColor: Colors.transparent,
                            borderRadius: 30.0,
                            borderWidth: 1.0,
                            buttonSize: 50.0,
                            icon: Icon(
                              CupertinoIcons.person,
                              color: _selectedIndex == 3
                                  ? FlutterFlowTheme.of(context).alternate
                                  : const Color(0xFF262626),
                              size: 29.0,
                            ),
                            onPressed: () => _onItemTapped(3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
