import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'ingen_kjop_matvarer_model.dart';
export 'ingen_kjop_matvarer_model.dart';

class IngenKjopMatvarerWidget extends StatefulWidget {
  const IngenKjopMatvarerWidget({
    super.key,
    this.icon,
    String? title,
    String? body,
  })  : title = title ?? 'No Comments',
        body = body ?? 'There are no comments associated with this post.';

  final Widget? icon;
  final String title;
  final String body;

  @override
  State<IngenKjopMatvarerWidget> createState() =>
      _IngenKjopMatvarerWidgetState();
}

class _IngenKjopMatvarerWidgetState extends State<IngenKjopMatvarerWidget>
    with TickerProviderStateMixin {
  late IngenKjopMatvarerModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => IngenKjopMatvarerModel());

    animationsMap.addAll({
      'columnOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 100.0.ms,
            begin: const Offset(0.0, 13.999999999999986),
            end: const Offset(0.0, 0.0),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.435,
            end: 1.0,
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
      alignment: const AlignmentDirectional(0.0, -1.0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 110.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/images/In_no_time-rafiki.png',
                width: 274.0,
                height: 214.0,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
              child: Text(
                'Her kan du se matvarer du har fått kjøpsforespørsler på',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      fontFamily: 'Open Sans',
                      color: const Color(0xFF2D9D4B),
                      fontSize: 22.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ).animateOnPageLoad(animationsMap['columnOnPageLoadAnimation']!),
      ),
    );
  }
}
