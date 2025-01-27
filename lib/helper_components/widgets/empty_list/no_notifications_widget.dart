import 'package:flutter/material.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_theme.dart';
import 'package:shimmer/shimmer.dart';

class NotificationPlaceholder extends StatelessWidget {
  const NotificationPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return SizedBox(
      width: screenSize.width,
      height: screenSize.height - 350,
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: const AlignmentDirectional(0, 1),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Profile outlines
                    buildProfileOutline(
                      context,
                      100,
                      Colors.grey[300]?.withOpacity(1) ??
                          Colors.grey.withOpacity(0.3),
                      Colors.grey[300]?.withOpacity(1) ??
                          Colors.grey.withOpacity(0.3),
                    ),
                    buildProfileOutline(
                      context,
                      80,
                      Colors.grey[300]?.withOpacity(1) ??
                          Colors.grey.withOpacity(1),
                      Colors.grey[300]?.withOpacity(1) ??
                          Colors.grey.withOpacity(1),
                    ),
                    buildProfileOutline(
                      context,
                      50,
                      Colors.grey[300]?.withOpacity(1) ??
                          Colors.grey.withOpacity(1),
                      Colors.grey[300]?.withOpacity(1) ??
                          Colors.grey.withOpacity(1),
                    ),
                    buildProfileOutline(
                      context,
                      38,
                      Colors.grey[300]?.withOpacity(1) ??
                          Colors.grey.withOpacity(1),
                      Colors.grey[300]?.withOpacity(1) ??
                          Colors.grey.withOpacity(1),
                    ),
                    const SizedBox(height: 8.0),
                    // Heading
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      child: Text(
                        'Velkommen til varslinger',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context)
                            .headlineSmall
                            .override(
                              fontFamily: 'Nunito',
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 22,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                    // Subheading
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(25, 0, 25, 0),
                      child: Text(
                        'Her vil du få beskjed når vi har nytt for deg, eller når noe du ønsker blir tilgjengelig.',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context)
                            .headlineSmall
                            .override(
                              fontFamily: 'Nunito',
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 16,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Moved buildProfileOutline into this widget
  Widget buildProfileOutline(
    BuildContext context,
    int opacity,
    Color baseColor,
    Color highlightColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              width: 65.0,
              height: 65.0,
              decoration: BoxDecoration(
                color: Color.fromARGB(opacity, 255, 255, 255),
                borderRadius: BorderRadius.circular(14.0),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  child: Container(
                    width: 75.0,
                    height: 13.0,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(opacity, 255, 255, 255),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  child: Container(
                    width: 200,
                    height: 13.0,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(opacity, 255, 255, 255),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
