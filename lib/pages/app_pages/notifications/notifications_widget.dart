import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/helper_components/widgets/shimmer_widgets/shimmer_profiles.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/logging.dart';
import 'package:mat_salg/pages/app_pages/notifications/NotificationPreview/notification_preview_widget.dart';
import 'package:mat_salg/pages/chat/give_rating/rating_page.dart';
import 'package:mat_salg/services/firebase_service.dart';
import 'package:mat_salg/services/notifications_service.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'notifications_model.dart';
export 'notifications_model.dart';

class NotificationsWidget extends StatefulWidget {
  const NotificationsWidget({super.key});

  @override
  State<NotificationsWidget> createState() => _HjemWidgetState();
}

class _HjemWidgetState extends State<NotificationsWidget>
    with TickerProviderStateMixin {
  late NotificationsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationsModel());
    markRead();
    getNotifications();
    checkPushPermission();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> checkPushPermission() async {
    final settings = await _firebaseMessaging.getNotificationSettings();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await Future.delayed(Duration(seconds: 1));
      FirebaseApi().initNotifications();
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return;
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.notDetermined) {
      await Future.delayed(Duration(seconds: 1));
      if (!mounted) return;
      context.pushNamed('RequestPush');
    }
  }

  Future<void> markRead() async {
    try {
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return;
      } else {
        await NotificationsService.markRead(token);
        FFAppState().notificationAlert.value = false;
      }
    } on SocketException {
      if (!mounted) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      logger.d(e);
      if (!mounted) return;
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

  Future<void> getNotifications() async {
    try {
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return;
      } else {
        _model.notificationInfo =
            await NotificationsService.getAllNotifications(token);
        setState(() {
          if (_model.notificationInfo!.isEmpty) {
          } else {
            _model.isloading = false;
          }
        });
        markRead();
      }
    } on SocketException {
      if (!mounted) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      logger.d(e);
      if (!mounted) return;
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

  String getTimeCategory(DateTime notificationTime) {
    final now = DateTime.now();
    final difference = now.difference(notificationTime).inDays;

    if (difference == 0) {
      return 'I dag';
    } else if (difference <= 7) {
      return 'Siste 7 dager';
    } else if (difference <= 30) {
      return 'Siste 30 dager';
    } else {
      return 'Eldre';
    }
  }

  List<int> getDisplayIndexes() {
    final displayIndexes = <int>[];
    final displayedCategories =
        <String>{}; // Track which categories are already shown

    // Iterate through notifications
    for (int i = 0; i < _model.notificationInfo!.length; i++) {
      final notification = _model.notificationInfo![i];
      final timeCategory = getTimeCategory(notification.time);

      // If category has not been displayed, add its index
      if (!displayedCategories.contains(timeCategory)) {
        displayIndexes.add(i);
        displayedCategories.add(timeCategory);

        // Break early if all categories are displayed
        if (displayedCategories.length == 4) {
          break;
        }
      }
    }

    return displayIndexes;
  }

  Widget buildProfileOutline(BuildContext context, int opacity, Color baseColor,
      Color highlightColor) {
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

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) {
                return;
              }
            },
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: FlutterFlowTheme.of(context).primary,
              appBar: AppBar(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                iconTheme: IconThemeData(
                    color: FlutterFlowTheme.of(context).alternate),
                automaticallyImplyLeading: false,
                title: Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Text(
                    'Varslinger',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Nunito',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 18,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                centerTitle: true,
                elevation: 0,
                scrolledUnderElevation: 0,
                bottom: PreferredSize(
                    preferredSize: Size.fromHeight(1),
                    child: Container(
                      color: Color.fromARGB(109, 87, 99, 108),
                      child: Container(
                        height: 0.3,
                      ),
                    )),
              ),
              body: SafeArea(
                top: true,
                child: RefreshIndicator.adaptive(
                  color: FlutterFlowTheme.of(context).alternate,
                  onRefresh: () async {
                    HapticFeedback.selectionClick();
                    getNotifications();
                  },
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(
                              0,
                              16,
                              0,
                              0,
                            ),
                            physics: AlwaysScrollableScrollPhysics(),
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: _model.isloading
                                ? 1
                                : _model.notificationInfo?.length ?? 0,
                            itemBuilder: (context, index) {
                              if (_model.isloading) {
                                if (((((_model.notificationInfo == null ||
                                                    _model.notificationInfo!
                                                        .isEmpty) &&
                                                _model.isloading == false) ||
                                            FFAppState().hasNotification ==
                                                false) &&
                                        _model.notificationInfo!.isEmpty) ||
                                    (_model.notificationInfo!.isEmpty &&
                                        _model.isloading == false)) {
                                  return SizedBox(
                                    width: MediaQuery.sizeOf(context).width,
                                    height:
                                        MediaQuery.sizeOf(context).height - 350,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 40, 0, 0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment:
                                                  const AlignmentDirectional(
                                                      0, 1),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  // First Profile Outline
                                                  buildProfileOutline(
                                                    context,
                                                    100,
                                                    Colors.grey[300]
                                                            ?.withOpacity(1) ??
                                                        Colors.grey.withOpacity(
                                                            0.3), // Reduce opacity
                                                    Colors.grey[300]
                                                            ?.withOpacity(1) ??
                                                        Colors.grey.withOpacity(
                                                            0.3), // Reduce opacity
                                                  ),

                                                  // Second Profile Outline
                                                  buildProfileOutline(
                                                    context,
                                                    80,
                                                    Colors.grey[300]
                                                            ?.withOpacity(1) ??
                                                        Colors.grey
                                                            .withOpacity(1),
                                                    Colors.grey[300]
                                                            ?.withOpacity(1) ??
                                                        Colors.grey
                                                            .withOpacity(1),
                                                  ),

                                                  // Third Profile Outline
                                                  buildProfileOutline(
                                                    context,
                                                    50,
                                                    Colors.grey[300]
                                                            ?.withOpacity(1) ??
                                                        Colors.grey
                                                            .withOpacity(1),
                                                    Colors.grey[300]
                                                            ?.withOpacity(1) ??
                                                        Colors.grey
                                                            .withOpacity(1),
                                                  ),

                                                  // Fourth Profile Outline
                                                  buildProfileOutline(
                                                    context,
                                                    38,
                                                    Colors.grey[300]
                                                            ?.withOpacity(1) ??
                                                        Colors.grey
                                                            .withOpacity(1),
                                                    Colors.grey[300]
                                                            ?.withOpacity(1) ??
                                                        Colors.grey
                                                            .withOpacity(1),
                                                  ),

                                                  const SizedBox(height: 8.0),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0, 0, 0, 0),
                                                    child: Text(
                                                      'Velkommen til varslinger',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .headlineSmall
                                                          .override(
                                                            fontFamily:
                                                                'Nunito',
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                            fontSize: 22,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            25, 0, 25, 0),
                                                    child: Text(
                                                      'Her vil du få beskjed når vi har nytt for deg, eller når noe du ønsker blir tilgjengelig.',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .headlineSmall
                                                          .override(
                                                            fontFamily:
                                                                'Nunito',
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText,
                                                            fontSize: 16,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                return FFAppState().hasNotification == false
                                    ? const SizedBox()
                                    : const ShimmerProfiles();
                              }
                              final notification =
                                  _model.notificationInfo![index];
                              return Column(
                                children: [
                                  if (getDisplayIndexes().contains(index))
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(-1.0, 0.0),
                                      child: Padding(
                                        padding: getTimeCategory(
                                                    notification.time) ==
                                                'I dag'
                                            ? const EdgeInsetsDirectional
                                                .fromSTEB(20.0, 0.0, 0.0, 0.0)
                                            : const EdgeInsetsDirectional
                                                .fromSTEB(20.0, 30.0, 0.0, 0.0),
                                        child: Text(
                                          getTimeCategory(notification.time),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Nunito',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontSize: 22.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                      ),
                                    ),
                                  InkWell(
                                    splashFactory: InkRipple.splashFactory,
                                    splashColor: Colors.grey[100],
                                    onTap: () {
                                      if (notification.type == 'new-product' ||
                                          notification.type ==
                                              'product-available') {
                                        context.pushNamed(
                                          'ProductDetailNotification',
                                          queryParameters: {
                                            'fromChat': serializeParam(
                                              false,
                                              ParamType.bool,
                                            ),
                                            'matId': serializeParam(
                                              notification.matId,
                                              ParamType.int,
                                            ),
                                          },
                                        );
                                        return;
                                      }
                                      if (notification.type == 'new-follower') {
                                        context.pushNamed(
                                          'BrukerPageNotification',
                                          queryParameters: {
                                            'uid': serializeParam(
                                              notification.sender,
                                              ParamType.String,
                                            ),
                                            'username': serializeParam(
                                              notification.username,
                                              ParamType.String,
                                            ),
                                          },
                                        );
                                        return;
                                      }
                                      if (notification.type == 'rating-given') {
                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          barrierColor: const Color.fromARGB(
                                              60, 17, 0, 0),
                                          useRootNavigator: true,
                                          context: context,
                                          builder: (context) {
                                            return GestureDetector(
                                              onTap: () =>
                                                  FocusScope.of(context)
                                                      .unfocus(),
                                              child: Padding(
                                                padding:
                                                    MediaQuery.viewInsetsOf(
                                                        context),
                                                child: RatingPage(
                                                  user: notification.sender,
                                                  kjop: true,
                                                  matId: notification.matId,
                                                  username:
                                                      notification.username,
                                                ),
                                              ),
                                            );
                                          },
                                        ).then((value) => setState(() {
                                              if (value == true) {
                                                _model.notificationInfo!
                                                    .removeAt(index);
                                              }
                                            }));
                                        return;
                                      }
                                    },
                                    child: wrapWithModel(
                                        model: _model.notificationPreviewModel,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: NotificationPreviewWidget(
                                          notificationInfo: notification,
                                        )),
                                  )
                                ],
                              );
                            },
                          ),
                        )
                      ]),
                ),
              ),
            )));
  }
}
