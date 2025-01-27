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
    required this.purchased,
    required this.messageTime,
    this.productImage,
    this.slettet,
  });

  final String? messageTitle;
  final String? messageContent;
  final String? messageImage;
  final bool? isUnread;
  final bool purchased;
  final String messageTime;
  final String? productImage;
  final dynamic slettet;

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
      padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
      child: Container(
        width: double.infinity,
        height: 72,
        decoration: const BoxDecoration(),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.isUnread ?? true)
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFF357BF7),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                child: Container(
                    width: 46,
                    height: 46,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: CachedNetworkImage(
                      fadeInDuration: Duration.zero,
                      imageUrl: '${ApiConstants.baseUrl}${widget.messageImage}',
                      width: 46,
                      height: 46,
                      fit: BoxFit.cover,
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          width: 46,
                          height: 46,
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
                        width: 46,
                        height: 46,
                        fit: BoxFit.cover,
                      ),
                    )),
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
                            padding: widget.productImage == null
                                ? const EdgeInsetsDirectional.fromSTEB(
                                    8, 14, 5, 0)
                                : const EdgeInsetsDirectional.fromSTEB(
                                    8, 8, 5, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Inter',
                                              fontSize: 16,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              lineHeight: 1.2,
                                            ),
                                        children: [
                                          TextSpan(
                                            text: widget.messageTitle!
                                                .maybeHandleOverflow(
                                              maxChars: 14,
                                              replacement: '…',
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                DateFormat("  d. MMM", "nb_NO")
                                                    .format(time),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Inter',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  fontSize: 13,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          TextSpan(
                                            text: '\n${widget.messageContent!}'
                                                .maybeHandleOverflow(
                                              maxChars: 25,
                                              replacement: '…',
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  fontFamily: 'Inter',
                                                  fontSize: 15,
                                                  letterSpacing: 0.0,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w500,
                                                  lineHeight: 1.3,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        if (widget.purchased == true)
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 8, 0),
                                            child: Container(
                                              height: 20.0,
                                              width: 50.0,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Solgt',
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (widget.productImage != null &&
                                            widget.slettet != true)
                                          CachedNetworkImage(
                                            fadeInDuration: Duration.zero,
                                            imageUrl:
                                                '${ApiConstants.baseUrl}${widget.productImage}',
                                            width: 47,
                                            height: 47,
                                            fit: BoxFit.cover,
                                            imageBuilder:
                                                (context, imageProvider) {
                                              return Container(
                                                width: 47,
                                                height: 47,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                              );
                                            },
                                            placeholder: (context, url) =>
                                                const SizedBox(),
                                          ),
                                        if (widget.productImage != null &&
                                            widget.slettet == true)
                                          Container(
                                            width: 47,
                                            height: 47,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
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
