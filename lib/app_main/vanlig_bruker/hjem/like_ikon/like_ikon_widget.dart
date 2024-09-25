import 'package:flutter/services.dart';

import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'like_ikon_model.dart';
export 'like_ikon_model.dart';

class LikeIkonWidget extends StatefulWidget {
  const LikeIkonWidget({super.key});

  @override
  State<LikeIkonWidget> createState() => _LikeIkonWidgetState();
}

class _LikeIkonWidgetState extends State<LikeIkonWidget>
    with TickerProviderStateMixin {
  late LikeIkonModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LikeIkonModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 700));
      Navigator.pop(context);
    });

    animationsMap.addAll({
      'iconOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.bounceOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: const Offset(1.2, 1.2),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.0, 0.0),
      child: FaIcon(
        FontAwesomeIcons.solidHeart,
        color: FlutterFlowTheme.of(context).alternate,
        size: 145.0,
      ).animateOnPageLoad(animationsMap['iconOnPageLoadAnimation']!),
    );
  }
}
