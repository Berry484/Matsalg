import 'package:flutter/material.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_theme.dart';

class NoResultsWidget extends StatelessWidget {
  const NoResultsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = 'assets/images/no-results.png';
    final message = 'Ingen treff';
    final paddingBottom = 110.0;
    return SizedBox(
      height: MediaQuery.sizeOf(context).height - 150,
      child: Align(
        alignment: const AlignmentDirectional(0, -1),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, paddingBottom),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imageUrl,
                  width: 180,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: Text(
                  message,
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
