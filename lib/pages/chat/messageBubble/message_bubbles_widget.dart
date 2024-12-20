import 'package:mat_salg/logging.dart';

import '../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'message_bubbles_model.dart';
export 'message_bubbles_model.dart';

class MessageBubblesWidget extends StatefulWidget {
  const MessageBubblesWidget({
    super.key,
    this.mesageText,
    this.blueBubble,
    this.showDelivered,
    this.showTail,
    this.showLest,
    this.messageTime,
  });

  final String? mesageText;
  final bool? blueBubble;
  final bool? showDelivered;
  final bool? showTail;
  final bool? showLest;
  final String? messageTime;

  @override
  State<MessageBubblesWidget> createState() => _MessageBubblesWidgetState();
}

class _MessageBubblesWidgetState extends State<MessageBubblesWidget> {
  late MessageBubblesModel _model;
  late DateTime? time; // Declare time as DateTime

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    time = null;
    if (widget.messageTime != null) {
      try {
        // Attempt to parse the messageTime using DateTime.parse()
        time = DateTime.parse(widget.messageTime ?? '');
      } catch (e) {
        // Handle parsing error (optional)
        time = DateTime.now(); // Set to current time as fallback
        logger.d("Error parsing messageTime: $e");
      }
    }
    _model = createModel(context, () => MessageBubblesModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (time != null)
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 6, 0, 10),
                  child: RichText(
                    text: TextSpan(
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 12,
                            letterSpacing: 0.0,
                          ),
                      children: [
                        TextSpan(
                          text: DateFormat("HH:mm", "nb_NO").format(time!),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(text: " "),
                        TextSpan(
                          text: DateFormat("d. MMM", "nb_NO").format(time!),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          if (!widget.blueBubble!)
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    FFAppState().update(() {});
                  },
                  child: Stack(
                    alignment: const AlignmentDirectional(-1, 1),
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.sizeOf(context).width *
                              0.6, // Max width of 60% of the screen width
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9E9EB),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              13, 12, 13, 12),
                          child: Text(
                            widget.mesageText!,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ),
                      if (widget.showTail ?? true)
                        Align(
                          alignment: const AlignmentDirectional(-1, 1),
                          child: Image.asset(
                            'assets/images/messageTail.png',
                            width: 8,
                            height: 8,
                            fit: BoxFit.cover,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          if (widget.blueBubble ?? true)
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    FFAppState().update(() {});
                  },
                  child: Stack(
                    alignment: const AlignmentDirectional(1, 1),
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.sizeOf(context).width *
                              0.6, // Max width of 60% of the screen width
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF357BF7),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              13, 12, 13, 12),
                          child: Text(
                            widget.mesageText!,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Inter',
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ),
                      if (widget.showTail ?? true)
                        Align(
                          alignment: const AlignmentDirectional(1, 1),
                          child: Image.asset(
                            'assets/images/messageTailBlue.png',
                            width: 8,
                            height: 8,
                            fit: BoxFit.cover,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          if (widget.showDelivered == true)
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
                  child: Text(
                    'Levert',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 12,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
          if (widget.showLest == true)
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
                  child: Text(
                    'Lest',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 12,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
