import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'avbryt_ikon_model.dart';
export 'avbryt_ikon_model.dart';

class AvbrytIkonWidget extends StatefulWidget {
  const AvbrytIkonWidget({super.key});

  @override
  State<AvbrytIkonWidget> createState() => _AvbrytIkonWidgetState();
}

class _AvbrytIkonWidgetState extends State<AvbrytIkonWidget> {
  late AvbrytIkonModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AvbrytIkonModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
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
              'Avslått',
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
