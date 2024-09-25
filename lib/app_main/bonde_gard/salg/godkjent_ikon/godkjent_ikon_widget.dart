import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'godkjent_ikon_model.dart';
export 'godkjent_ikon_model.dart';
import 'package:flutter/services.dart';

class GodkjentIkonWidget extends StatefulWidget {
  const GodkjentIkonWidget({super.key});

  @override
  State<GodkjentIkonWidget> createState() => _GodkjentIkonWidgetState();
}

class _GodkjentIkonWidgetState extends State<GodkjentIkonWidget> {
  late GodkjentIkonModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GodkjentIkonModel());

    // On component load action.    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 1200));
      Navigator.pop(context);
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
      child: Container(
        width: 195.0,
        height: 210.0,
        decoration: BoxDecoration(
          color: const Color(0x92262C2D),
          borderRadius: BorderRadius.circular(24.0),
        ),
        alignment: const AlignmentDirectional(0.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: const AlignmentDirectional(0.0, 0.0),
              child: FaIcon(
                FontAwesomeIcons.checkSquare,
                color: FlutterFlowTheme.of(context).primary,
                size: 128.0,
              ),
            ),
            Text(
              'Godkjent',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Open Sans',
                    color: FlutterFlowTheme.of(context).primary,
                    fontSize: 23.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
