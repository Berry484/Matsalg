import 'package:flutter/services.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/logging.dart';
import '../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'message_bubbles_model.dart';
export 'message_bubbles_model.dart';

class MessageBubblesWidget extends StatefulWidget {
  const MessageBubblesWidget({
    super.key,
    this.messageText,
    this.blueBubble,
    this.showDelivered,
    this.showTail,
    this.showLest,
    this.messageTime,
  });

  final String? messageText;
  final bool? blueBubble;
  final bool? showDelivered;
  final bool? showTail;
  final bool? showLest;
  final String? messageTime;

  @override
  State<MessageBubblesWidget> createState() => _MessageBubblesWidgetState();
}

class _MessageBubblesWidgetState extends State<MessageBubblesWidget> {
  final parser = EmojiParser();
  late MessageBubblesModel _model;
  DateTime? time;
  late final ImageProvider tailImage;
  late final ImageProvider tailBlueImage;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MessageBubblesModel());

    // Preload images
    tailImage = AssetImage('assets/images/messageTail.png');
    tailBlueImage = AssetImage('assets/images/messageTailBlue.png');

    // Parse time efficiently
    if (widget.messageTime?.isNotEmpty ?? false) {
      try {
        time = DateTime.parse(widget.messageTime!);
      } catch (_) {
        time = DateTime.now(); // Fallback to prevent crashes
        logger.d("Invalid messageTime format: ${widget.messageTime}");
      }
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  bool isEmojiOnly(String text) {
    if (text.isEmpty) return false;
    final chars = text.characters;
    if (chars.length > 3) return false;
    for (final rune in text.runes) {
      if (!isEmoji(rune)) return false;
    }
    return true;
  }

  bool isEmoji(int codePoint) {
    String char = String.fromCharCode(codePoint);
    return parser.hasEmoji(char);
  }

  double calculateFontSize(String text) {
    return isEmojiOnly(text) ? 45 : 15.85;
  }

  @override
  Widget build(BuildContext context) {
    final isBlue = widget.blueBubble ?? true;
    final isEmojiMessage = isEmojiOnly(widget.messageText ?? "");
    final textStyle = TextStyle(
      fontSize: calculateFontSize(widget.messageText ?? ""),
      color: isEmojiMessage || !isBlue ? Colors.black : Colors.white,
      fontWeight: FontWeight.w500,
    );

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (time != null) _buildTimestamp(time!, context),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment:
                isBlue ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onLongPress: () => FFAppState().update(() {
                  Clipboard.setData(
                      ClipboardData(text: widget.messageText ?? ''));
                  Toasts.showAccepted(context, 'Kopiert');
                }),
                child: Stack(
                  alignment: isBlue
                      ? AlignmentDirectional(1, 1)
                      : AlignmentDirectional(-1, 1),
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width *
                            (isBlue ? 0.77 : 0.72),
                      ),
                      decoration: BoxDecoration(
                        color: isEmojiMessage
                            ? Colors.transparent
                            : (isBlue
                                ? const Color(0xFF357BF7)
                                : Colors.grey[100]),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13, vertical: 12),
                        child: Text(widget.messageText ?? "", style: textStyle),
                      ),
                    ),
                    if ((widget.showTail ?? true) && !isEmojiMessage)
                      Align(
                        alignment: isBlue
                            ? AlignmentDirectional(1, 1)
                            : AlignmentDirectional(-1, 1),
                        child: Image(
                          image: isBlue ? tailBlueImage : tailImage,
                          width: 8,
                          height: 8,
                          fit: BoxFit.cover,
                          color: isBlue ? null : Colors.grey[100],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (widget.showDelivered == true) _buildStatusText("Levert", context),
          if (widget.showLest == true) _buildStatusText("Lest", context),
        ],
      ),
    );
  }

  Widget _buildTimestamp(DateTime time, BuildContext context) {
    return Row(
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
                  text: DateFormat("HH:mm", "nb_NO").format(time),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const TextSpan(text: " "),
                TextSpan(
                  text: DateFormat("d. MMM", "nb_NO").format(time),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusText(String text, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
          child: Text(
            text,
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
    );
  }
}
