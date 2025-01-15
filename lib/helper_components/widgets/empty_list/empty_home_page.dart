import 'package:flutter/material.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_theme.dart';

class EmptyHomePage extends StatelessWidget {
  const EmptyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Align(
        alignment: const AlignmentDirectional(0, -1),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 110),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/no-results.png',
                  width: 180,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: Text(
                  'Ingen treff',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        fontFamily: 'Nunito',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 22,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
