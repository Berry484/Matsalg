import 'package:flutter/cupertino.dart';
import 'package:ionicons/ionicons.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profil_nav_bar_model.dart';
export 'profil_nav_bar_model.dart';

class ProfilNavBarWidget extends StatefulWidget {
  const ProfilNavBarWidget({super.key});

  @override
  State<ProfilNavBarWidget> createState() => _ProfilNavBarWidgetState();
}

class _ProfilNavBarWidgetState extends State<ProfilNavBarWidget> {
  late ProfilNavBarModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfilNavBarModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return SafeArea(
      child: Container(
        width: double.infinity,
        height: 61.0,
        decoration: const BoxDecoration(
          color: Colors.transparent,
          border: Border(
            top: BorderSide(
              color: Color.fromARGB(30, 87, 99, 108),
              width: 1.0, // Adjust width as needed for a thin line
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
                  color: Colors.transparent,
                  elevation: 0.0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0.0),
                      bottomRight: Radius.circular(0.0),
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 10.0,
                          color: Colors.transparent,
                          offset: Offset(
                            0.0,
                            -10.0,
                          ),
                          spreadRadius: 0.1,
                        )
                      ],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(0.0),
                        bottomRight: Radius.circular(0.0),
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
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
                    icon: const Icon(
                      Ionicons.home_outline,
                      color: Color(0xFF9299A1),
                      size: 30.0,
                    ),
                    onPressed: () async {
                      context.pushNamed(
                        'Hjem',
                        extra: <String, dynamic>{
                          kTransitionInfoKey: const TransitionInfo(
                            hasTransition: true,
                            transitionType: PageTransitionType.fade,
                            duration: Duration(milliseconds: 0),
                          ),
                        },
                      );
                    },
                  ),
                  FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30.0,
                    borderWidth: 1.0,
                    buttonSize: 50.0,
                    icon: const Icon(
                      Ionicons.bag_check_outline,
                      color: Color(0xFF9299A1),
                      size: 31.0,
                    ),
                    onPressed: () async {
                      context.pushNamed(
                        'MineKjop',
                        extra: <String, dynamic>{
                          kTransitionInfoKey: const TransitionInfo(
                            hasTransition: true,
                            transitionType: PageTransitionType.fade,
                            duration: Duration(milliseconds: 0),
                          ),
                        },
                      );
                    },
                  ),
                  FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30.0,
                    borderWidth: 1.0,
                    buttonSize: 50.0,
                    icon: const Icon(
                      CupertinoIcons.add,
                      color: Color(0xFF9299A1),
                      size: 30.0,
                    ),
                    onPressed: () async {
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
                    },
                  ),
                  FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30.0,
                    borderWidth: 1.0,
                    buttonSize: 50.0,
                    icon: const Icon(
                      CupertinoIcons.chat_bubble,
                      color: Color(0xFF9299A1),
                      size: 30.0,
                    ),
                    onPressed: () async {
                      context.pushNamed(
                        'ChatMain',
                        extra: <String, dynamic>{
                          kTransitionInfoKey: const TransitionInfo(
                            hasTransition: true,
                            transitionType: PageTransitionType.fade,
                            duration: Duration(milliseconds: 0),
                          ),
                        },
                      );
                    },
                  ),
                  FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30.0,
                    borderWidth: 1.0,
                    buttonSize: 50.0,
                    icon: Icon(
                      CupertinoIcons.person,
                      color: FlutterFlowTheme.of(context).alternate,
                      size: 30.0,
                    ),
                    onPressed: () {
                      print('IconButton pressed ...');
                    },
                  ),
                ],
              ),
            ),
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
      ),
    );
  }
}
