import 'package:cached_network_image/cached_network_image.dart';
import 'package:mat_salg/my_ip.dart';
import 'package:mat_salg/logging.dart';

import '../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'message_preview_model.dart';
export 'message_preview_model.dart';

class MessagePreviewWidget extends StatefulWidget {
  const MessagePreviewWidget({
    super.key,
    this.messageTitle,
    this.messageContent,
    this.messageImage,
    this.isUnread,
    required this.messageTime,
  });

  final String? messageTitle;
  final String? messageContent;
  final String? messageImage;
  final bool? isUnread;
  final String messageTime;

  @override
  State<MessagePreviewWidget> createState() => _MessagePreviewWidgetState();
}

class _MessagePreviewWidgetState extends State<MessagePreviewWidget> {
  late MessagePreviewModel _model;
  late DateTime time; // Declare time as DateTime

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    // Parse the messageTime string into DateTime if it's not null
    try {
      // Attempt to parse the messageTime using DateTime.parse()
      time = DateTime.parse(widget.messageTime);
    } catch (e) {
      // Handle parsing error (optional)
      time = DateTime.now(); // Set to current time as fallback
      logger.d("Error parsing messageTime: $e");
    }

    _model = createModel(context, () => MessagePreviewModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 3, 0, 0),
      child: Container(
        width: double.infinity,
        height: 75,
        decoration: const BoxDecoration(),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.isUnread ?? true)
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFF357BF7),
                    shape: BoxShape.circle,
                  ),
                ),
              if (widget.messageImage != null &&
                  widget.messageImage!.isNotEmpty)
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                  child: Container(
                      width: 53,
                      height: 53,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: CachedNetworkImage(
                        fadeInDuration: Duration.zero,
                        imageUrl:
                            '${ApiConstants.baseUrl}${widget.messageImage}',
                        width: 53,
                        height: 53,
                        fit: BoxFit.cover,
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            width: 53,
                            height: 53,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/profile_pic.png',
                          width: 53,
                          height: 53,
                          fit: BoxFit.cover,
                        ),
                      )),
                ),
              if (widget.messageImage == null || widget.messageImage!.isEmpty)
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 12, 0),
                  child: Container(
                    width: 53,
                    height: 53,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/profile_pic.png',
                      width: 53,
                      height: 53,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return Image.asset(
                          'assets/images/profile_pic.png',
                          width: 53,
                          height: 53,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
              Expanded(
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 8, 12, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.messageTitle!
                                            .maybeHandleOverflow(
                                          maxChars: 14,
                                          replacement: '…',
                                        ),
                                        maxLines: 1,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Inter',
                                              fontSize: 16,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                              lineHeight: 1.2,
                                            ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          DateFormat("HH:mm d. MMM", "nb_NO")
                                              .format(time),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 14,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        const Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 0, 0),
                                          child: Icon(
                                            Icons.chevron_right_rounded,
                                            color: Color(0xFF357BF7),
                                            size: 26,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 22, 0),
                                  child: Text(
                                    widget.messageContent!,
                                    maxLines: 2,
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                          lineHeight: 1.3,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.sizeOf(context).width,
                          height: 1,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE8E8E8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
