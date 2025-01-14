import 'package:cached_network_image/cached_network_image.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_theme.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:mat_salg/models/notification_info.dart';
import 'package:mat_salg/my_ip.dart';
import 'package:flutter/material.dart';
import 'notification_preview_model.dart';
export 'notification_preview_model.dart';

class NotificationPreviewWidget extends StatefulWidget {
  const NotificationPreviewWidget({super.key, required this.notificationInfo});

  final NotificationInfo notificationInfo;

  @override
  State<NotificationPreviewWidget> createState() =>
      _MessagePreviewWidgetState();
}

class _MessagePreviewWidgetState extends State<NotificationPreviewWidget> {
  late NotificationPreviewModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationPreviewModel());
  }

  static String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays >= 365) {
      // If it's over a year ago
      int years = difference.inDays ~/ 365;
      return '  $years år';
    } else if (difference.inDays >= 7) {
      // If it's over a week ago (7+ days)
      int weeks = difference.inDays ~/ 7;
      return '  $weeks u';
    } else if (difference.inDays >= 1) {
      // If it's over 24 hours ago
      return '  ${difference.inDays} d';
    } else if (difference.inHours >= 1) {
      // If it's less than 24 hours but more than 1 hour ago
      return '  ${difference.inHours} t';
    } else if (difference.inMinutes >= 1) {
      // If it's less than 1 hour but more than 1 minute ago
      return '  ${difference.inMinutes} m';
    } else {
      // If it's less than 1 minute ago
      return '  nå';
    }
  }

  String textType() {
    //rating-given
    //new-product
    //product-available
    //new-follower
    if (widget.notificationInfo.type == 'new-product') {
      return ' har nylig lagt ut en ny annonse';
    }
    if (widget.notificationInfo.type == 'product-available') {
      return ' har gjort en utsolgt vare tilgjengelig';
    }
    if (widget.notificationInfo.type == 'rating-given') {
      return ' du kan legge igjen en rating på kjøpet ditt';
    }
    if (widget.notificationInfo.type == 'new-follower') {
      return ' har begynt å \nfølge deg';
    }
    return '';
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
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
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                child: Container(
                  width: 43,
                  height: 43,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CachedNetworkImage(
                    fadeInDuration: Duration.zero,
                    imageUrl:
                        '${ApiConstants.baseUrl}${widget.notificationInfo.profilepic}',
                    width: 43,
                    height: 43,
                    fit: BoxFit.cover,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        width: 43,
                        height: 43,
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
                      width: 43,
                      height: 43,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: widget.notificationInfo.profilepic == null
                      ? const EdgeInsetsDirectional.fromSTEB(8, 14, 5, 0)
                      : const EdgeInsetsDirectional.fromSTEB(8, 8, 5, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                              child: RichText(
                                softWrap: true, // Allow the text to wrap
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
                                      text: widget.notificationInfo.username,
                                    ),
                                    TextSpan(
                                      text: textType(),
                                      style: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            fontFamily: 'Inter',
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500,
                                            lineHeight: 1.3,
                                          ),
                                    ),
                                    TextSpan(
                                      text: formatTimeAgo(
                                          widget.notificationInfo.time),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (widget.notificationInfo.productImage != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: CachedNetworkImage(
                                fadeInDuration: Duration.zero,
                                imageUrl:
                                    '${ApiConstants.baseUrl}${widget.notificationInfo.productImage}',
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const SizedBox(),
                              ),
                            ),
                        ],
                      ),
                    ],
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
