import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mat_salg/ApiCalls.dart';
import 'package:mat_salg/User.dart';
import 'package:mat_salg/MyIP.dart';
import 'package:mat_salg/SecureStorage.dart';
import 'package:mat_salg/app_main/vanlig_bruker/hjem/bruker_page/folg_bruker/folg_bruker_widget.dart';
import 'package:mat_salg/app_main/vanlig_bruker/hjem/bruker_rating/bruker_rating_widget.dart';
import 'package:mat_salg/app_main/vanlig_bruker/hjem/rapporter/rapporter_widget.dart';
import 'package:shimmer/shimmer.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'bruker_page_model.dart';
export 'bruker_page_model.dart';

class BrukerPageWidget extends StatefulWidget {
  const BrukerPageWidget({this.bruker, this.username, super.key});

  final dynamic bruker;
  final String? username;

  @override
  State<BrukerPageWidget> createState() => _BrukerPageWidgetState();
}

class _BrukerPageWidgetState extends State<BrukerPageWidget>
    with TickerProviderStateMixin {
  late BrukerPageModel _model;
  bool _isLoading = true;
  bool _empty = false;
  List<User>? _brukerinfo;
  List<Matvarer>? _matvarer;
  bool _matisLoading = true;
  User? bruker;
  bool? brukerFolger = false;
  bool _folgerLoading = false;
  bool _isExpanded = false;
  bool _messageIsLoading = false;
  final Securestorage securestorage = Securestorage();
  final ApiFolg apiFolg = ApiFolg();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BrukerPageModel());
    _checkUser();

    getUserFood();
    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
  }

  void showErrorToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        left: 16.0,
        right: 16.0,
        child: Material(
          color: Colors.transparent,
          child: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.up, // Allow dismissing upwards
            onDismissed: (_) =>
                overlayEntry.remove(), // Remove overlay on dismiss
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.solidTimesCircle,
                    color: Colors.black,
                    size: 30.0,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Auto-remove the toast after 3 seconds if not dismissed
    Future.delayed(const Duration(seconds: 3), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  Future<void> _checkUser() async {
    try {
      String? token = await Securestorage().readToken();
      if (token == null) {
        FFAppState().login = false;
        context.goNamed('registrer');
        return;
      } else {
        // Fetch user info only if bruker is null
        if (widget.bruker != 1) {
          _brukerinfo = await ApiGetUser.checkUser(token, widget.username);
          if (_brukerinfo != null && _brukerinfo!.isNotEmpty) {
            bruker = _brukerinfo![0]; // Get the first User object

            _isLoading = false;
          } else {
            // Fallback values
            bruker = User(
              username: '',
              firstname: '',
              lastname: '',
              profilepic: '', // Default image
              email: '',
              bio: '',
              phoneNumber: '',
              lat: null,
              lng: null,
              bonde: null,
              gardsnavn: '',
            );
          }
        } else {
          // Initialize bruker from passed parameter
          bruker = User.fromJson(widget.bruker);
          _isLoading = false;
        }
        setState(() {
          _isLoading = false; // Update loading state after data is fetched
          _model.folger = bruker!.isFollowing ?? false;
        });
      }
    } on SocketException {
      HapticFeedback.lightImpact();
      showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      HapticFeedback.lightImpact();
      showErrorToast(context, 'En feil oppstod');
    }
  }

  // Haversine formula to calculate distance between two lat/lng points
  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const earthRadius = 6371.0; // Earth's radius in kilometers
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLng = _degreesToRadians(lng2 - lng1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  Future<void> unFolg() async {
    try {
      await apiFolg.unfolgBruker(Securestorage.authToken, bruker?.username);
      safeSetState(() {
        _checkUser();
      });
    } on SocketException {
      HapticFeedback.lightImpact();
      showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      HapticFeedback.lightImpact();
      showErrorToast(context, 'En feil oppstod');
    }
  }

  Future<void> folgBruker() async {
    try {
      await apiFolg.folgbruker(Securestorage.authToken, bruker?.username);
      safeSetState(() {
        _checkUser();
      });
    } on SocketException {
      HapticFeedback.lightImpact();
      showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      HapticFeedback.lightImpact();
      showErrorToast(context, 'En feil oppstod');
    }
  }

  Future<void> getUserFood() async {
    try {
      String? token = await Securestorage().readToken();
      if (token == null) {
        FFAppState().login = false;
        context.goNamed('registrer');
        return;
      } else {
        _matvarer = await ApiGetUserFood.getUserFood(token, widget.username);
        setState(() {
          if (_matvarer != null && _matvarer!.isNotEmpty) {
            _matisLoading = false;
            return;
          } else {
            _empty = true;
            _matisLoading = false;
          }
        });
      }
    } on SocketException {
      HapticFeedback.lightImpact();
      showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      HapticFeedback.lightImpact();
      showErrorToast(context, 'En feil oppstod');
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primary,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context)
                .primary, // Set to your primary color, e.g., Colors.white
            elevation: 0, // Removes shadow to keep it flat
            scrolledUnderElevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle
                .dark, // Adjusts status bar icons for light background
            leading: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(2, 0, 0, 0),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 28.0,
                ),
                onPressed: () {
                  context.safePop();
                },
              ),
            ),
            centerTitle: true,
            title: Text(
              '@${widget.username ?? 'Profil'}',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Nunito',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 18,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 2, 0),
                child: IconButton(
                  icon: Icon(
                    CupertinoIcons.ellipsis,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 28.0,
                  ),
                  onPressed: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoActionSheet(
                          actions: <Widget>[
                            CupertinoActionSheetAction(
                              onPressed: () async {
                                try {
                                  // Prevent multiple submissions while loading
                                  if (_messageIsLoading) return;
                                  _messageIsLoading = true;

                                  Conversation existingConversation =
                                      FFAppState().conversations.firstWhere(
                                    (conv) => conv.user == widget.username,
                                    orElse: () {
                                      final newConversation = Conversation(
                                        user: widget.username ?? '',
                                        profilePic: bruker!.profilepic ?? '',
                                        messages: [],
                                      );

                                      FFAppState()
                                          .conversations
                                          .add(newConversation);

                                      // Return the new conversation
                                      return newConversation;
                                    },
                                  );

                                  String? serializedConversation =
                                      serializeParam(
                                    existingConversation.toJson(),
                                    ParamType.JSON,
                                  );

                                  _messageIsLoading = false;
                                  if (serializedConversation != null) {
                                    Navigator.pop(context);
                                    context.pushNamed(
                                      'message',
                                      queryParameters: {
                                        'conversation': serializedConversation,
                                      },
                                    );
                                  }
                                } on SocketException {
                                  _messageIsLoading = false;
                                  HapticFeedback.lightImpact();
                                  showErrorToast(
                                      context, 'Ingen internettforbindelse');
                                } catch (e) {
                                  _messageIsLoading = false;
                                  HapticFeedback.lightImpact();
                                  showErrorToast(context, 'En feil oppstod');
                                }
                              },
                              child: const Text(
                                'Send melding',
                                style: TextStyle(
                                  fontSize: 19,
                                  color: CupertinoColors.systemBlue,
                                ),
                              ),
                            ),
                            CupertinoActionSheetAction(
                              onPressed: () async {
                                await showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  barrierColor:
                                      const Color.fromARGB(60, 17, 0, 0),
                                  useRootNavigator: true,
                                  context: context,
                                  builder: (context) {
                                    return GestureDetector(
                                      onTap: () =>
                                          FocusScope.of(context).unfocus(),
                                      child: Padding(
                                        padding:
                                            MediaQuery.viewInsetsOf(context),
                                        child: RapporterWidget(
                                          username: widget.username,
                                          matId: null,
                                        ),
                                      ),
                                    );
                                  },
                                ).then((value) => setState(() {}));
                                return;
                              },
                              child: const Text(
                                'Rapporter',
                                style: TextStyle(
                                  fontSize: 19,
                                  color: Colors
                                      .red, // Red text for 'Slett annonse'
                                ),
                              ),
                            ),
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.pop(context); // Close the action sheet
                            },
                            isDefaultAction: true,
                            child: const Text(
                              'Avbryt',
                              style: TextStyle(
                                fontSize: 19,
                                color: CupertinoColors.systemBlue,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          body: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: RefreshIndicator.adaptive(
                    color: FlutterFlowTheme.of(context).alternate,
                    onRefresh: () async {
                      HapticFeedback.lightImpact();
                      _checkUser();
                      getUserFood();
                    },
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      primary: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              SingleChildScrollView(
                                primary: false,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 10, 0, 10),
                                        child: SafeArea(
                                          child: Container(
                                            width: valueOrDefault<double>(
                                              MediaQuery.sizeOf(context).width,
                                              500.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (_isLoading != true)
                                      ListView(
                                        padding: EdgeInsets.zero,
                                        primary: false,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 0, 30),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0, 0),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            24, 0, 0, 5),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: 85,
                                                          height: 85,
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          decoration:
                                                              const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child:
                                                              CachedNetworkImage(
                                                            fadeInDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        0),
                                                            fadeOutDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        0),
                                                            imageUrl: _isLoading
                                                                ? ''
                                                                : '${ApiConstants.baseUrl}${bruker?.profilepic}',
                                                            fit: BoxFit.cover,
                                                            errorWidget: (context,
                                                                    error,
                                                                    stackTrace) =>
                                                                Image.asset(
                                                              'assets/images/profile_pic.png',
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  7, 0, 0, 0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        10,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              5,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                70,
                                                                            height:
                                                                                50,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Text(
                                                                                  _matvarer?.length.toString() ?? '',
                                                                                  textAlign: TextAlign.center,
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Nunito',
                                                                                        fontSize: 16,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w600,
                                                                                      ),
                                                                                ),
                                                                                Text(
                                                                                  'matvarer',
                                                                                  textAlign: TextAlign.center,
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Nunito',
                                                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                                                        fontSize: 13,
                                                                                        letterSpacing: 0.0,
                                                                                      ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              5,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                70,
                                                                            height:
                                                                                50,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child:
                                                                                InkWell(
                                                                              splashColor: Colors.transparent,
                                                                              focusColor: Colors.transparent,
                                                                              hoverColor: Colors.transparent,
                                                                              highlightColor: Colors.transparent,
                                                                              onTap: () async {
                                                                                if ((bruker?.followersCount) != 0) {
                                                                                  context.pushNamed(
                                                                                    'Folgere',
                                                                                    queryParameters: {
                                                                                      'username': serializeParam(widget.username, ParamType.String),
                                                                                      'folger': serializeParam('Følgere', ParamType.String),
                                                                                    }.withoutNulls,
                                                                                  );
                                                                                }
                                                                              },
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Text(
                                                                                    bruker!.followersCount.toString(),
                                                                                    textAlign: TextAlign.center,
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: 'Nunito',
                                                                                          fontSize: 16,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                  ),
                                                                                  Text(
                                                                                    'følgere',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: 'Nunito',
                                                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                                                          fontSize: 13,
                                                                                          letterSpacing: 0.0,
                                                                                        ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              5,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                70,
                                                                            height:
                                                                                50,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child:
                                                                                InkWell(
                                                                              splashColor: Colors.transparent,
                                                                              focusColor: Colors.transparent,
                                                                              hoverColor: Colors.transparent,
                                                                              highlightColor: Colors.transparent,
                                                                              onTap: () async {
                                                                                if (bruker!.followingCount != 0) {
                                                                                  context.pushNamed(
                                                                                    'Folgere',
                                                                                    queryParameters: {
                                                                                      'username': serializeParam(widget.username, ParamType.String),
                                                                                      'folger': serializeParam(
                                                                                        'Følger',
                                                                                        ParamType.String,
                                                                                      ),
                                                                                    }.withoutNulls,
                                                                                  );
                                                                                }
                                                                              },
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Text(
                                                                                    bruker!.followingCount.toString(),
                                                                                    textAlign: TextAlign.center,
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: 'Nunito',
                                                                                          fontSize: 16,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                  ),
                                                                                  Text(
                                                                                    'følger',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: 'Nunito',
                                                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                                                          fontSize: 13,
                                                                                          letterSpacing: 0.0,
                                                                                        ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0,
                                                                        10,
                                                                        0,
                                                                        0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    if (_model
                                                                            .folger ==
                                                                        true)
                                                                      // FFButtonWidget(
                                                                      //   onPressed:
                                                                      //       () async {
                                                                      //     if (_folgerLoading)
                                                                      //       return;
                                                                      //     _folgerLoading =
                                                                      //         true;
                                                                      //     await showModalBottomSheet(
                                                                      //       isScrollControlled:
                                                                      //           true,
                                                                      //       backgroundColor:
                                                                      //           Colors.transparent,
                                                                      //       barrierColor: const Color.fromARGB(
                                                                      //           60,
                                                                      //           17,
                                                                      //           0,
                                                                      //           0),
                                                                      //       useRootNavigator:
                                                                      //           true,
                                                                      //       context:
                                                                      //           context,
                                                                      //       builder:
                                                                      //           (context) {
                                                                      //         return GestureDetector(
                                                                      //           onTap: () => FocusScope.of(context).unfocus(),
                                                                      //           child: Padding(
                                                                      //             padding: MediaQuery.viewInsetsOf(context),
                                                                      //             child: FolgBrukerWidget(
                                                                      //               username: widget.username,
                                                                      //             ),
                                                                      //           ),
                                                                      //         );
                                                                      //       },
                                                                      //     ).then((value) =>
                                                                      //         setState(() {
                                                                      //           if (value == true) {
                                                                      //             _model.folger = false;
                                                                      //             safeSetState(() {});
                                                                      //             unFolg();
                                                                      //             _folgerLoading = false;
                                                                      //           }
                                                                      //           _folgerLoading = false;
                                                                      //         }));
                                                                      //     return;
                                                                      //   },
                                                                      //   text:
                                                                      //       'Følger',
                                                                      //   options:
                                                                      //       FFButtonOptions(
                                                                      //     width: ((bruker!.ratingTotalCount ?? 0) != 0)
                                                                      //         ? 130
                                                                      //         : 215,
                                                                      //     height:
                                                                      //         35,
                                                                      //     padding: const EdgeInsetsDirectional
                                                                      //         .fromSTEB(
                                                                      //         16,
                                                                      //         0,
                                                                      //         16,
                                                                      //         0),
                                                                      //     color:
                                                                      //         FlutterFlowTheme.of(context).primary,
                                                                      //     textStyle: FlutterFlowTheme.of(context)
                                                                      //         .titleSmall
                                                                      //         .override(
                                                                      //           fontFamily: 'Nunito',
                                                                      //           color: FlutterFlowTheme.of(context).primaryText,
                                                                      //           fontSize: 14,
                                                                      //           letterSpacing: 0.0,
                                                                      //           fontWeight: FontWeight.bold,
                                                                      //         ),
                                                                      //     elevation:
                                                                      //         0,
                                                                      //     borderSide:
                                                                      //         const BorderSide(
                                                                      //       color: const Color.fromARGB(
                                                                      //           32,
                                                                      //           87,
                                                                      //           99,
                                                                      //           108),
                                                                      //       width:
                                                                      //           1.3,
                                                                      //     ),
                                                                      //     borderRadius:
                                                                      //         BorderRadius.circular(9),
                                                                      //   ),
                                                                      // ),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () async {
                                                                          if (_folgerLoading)
                                                                            return;
                                                                          _folgerLoading =
                                                                              true;
                                                                          await showModalBottomSheet(
                                                                            isScrollControlled:
                                                                                true,
                                                                            backgroundColor:
                                                                                Colors.transparent,
                                                                            barrierColor: const Color.fromARGB(
                                                                                60,
                                                                                17,
                                                                                0,
                                                                                0),
                                                                            useRootNavigator:
                                                                                true,
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (context) {
                                                                              return GestureDetector(
                                                                                onTap: () => FocusScope.of(context).unfocus(),
                                                                                child: Padding(
                                                                                  padding: MediaQuery.viewInsetsOf(context),
                                                                                  child: FolgBrukerWidget(
                                                                                    username: widget.username,
                                                                                    pushEnabled: bruker!.getPush ?? false,
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                          ).then((value) =>
                                                                              setState(() {
                                                                                if (value == true) {
                                                                                  _model.folger = false;
                                                                                  safeSetState(() {});
                                                                                  unFolg();
                                                                                  _folgerLoading = false;
                                                                                }
                                                                                _folgerLoading = false;
                                                                              }));
                                                                          return;
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          width: ((bruker!.ratingTotalCount ?? 0) != 0)
                                                                              ? 130
                                                                              : 215,
                                                                          height:
                                                                              35,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primary,
                                                                            borderRadius:
                                                                                BorderRadius.circular(9),
                                                                            border:
                                                                                Border.all(
                                                                              color: const Color.fromARGB(32, 87, 99, 108),
                                                                              width: 1.3,
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                'Følger',
                                                                                style: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                      fontFamily: 'Nunito',
                                                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                                                      fontSize: 14,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              Icon(
                                                                                CupertinoIcons.chevron_down,
                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                size: 17,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    if (_model
                                                                            .folger !=
                                                                        true)
                                                                      FFButtonWidget(
                                                                        onPressed:
                                                                            () async {
                                                                          if (_folgerLoading) {
                                                                            return;
                                                                          }
                                                                          _folgerLoading =
                                                                              true;
                                                                          HapticFeedback
                                                                              .mediumImpact();
                                                                          _model.folger =
                                                                              true;
                                                                          safeSetState(
                                                                              () {});
                                                                          folgBruker();
                                                                          _folgerLoading =
                                                                              false;
                                                                          await showModalBottomSheet(
                                                                            isScrollControlled:
                                                                                true,
                                                                            backgroundColor:
                                                                                Colors.transparent,
                                                                            barrierColor: const Color.fromARGB(
                                                                                60,
                                                                                17,
                                                                                0,
                                                                                0),
                                                                            useRootNavigator:
                                                                                true,
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (context) {
                                                                              return GestureDetector(
                                                                                onTap: () => FocusScope.of(context).unfocus(),
                                                                                child: Padding(
                                                                                  padding: MediaQuery.viewInsetsOf(context),
                                                                                  child: FolgBrukerWidget(
                                                                                    username: widget.username,
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                          ).then((value) =>
                                                                              setState(() {
                                                                                if (value == true) {
                                                                                  _model.folger = false;
                                                                                  safeSetState(() {});
                                                                                  unFolg();
                                                                                  _folgerLoading = false;
                                                                                }
                                                                                _folgerLoading = false;
                                                                              }));
                                                                          return;
                                                                        },
                                                                        text:
                                                                            'Følg',
                                                                        options:
                                                                            FFButtonOptions(
                                                                          width: ((bruker!.ratingTotalCount ?? 0) != 0)
                                                                              ? 130
                                                                              : 215,
                                                                          height:
                                                                              35,
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              16,
                                                                              0,
                                                                              16,
                                                                              0),
                                                                          iconPadding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          color:
                                                                              FlutterFlowTheme.of(context).alternate,
                                                                          textStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .override(
                                                                                fontFamily: 'Nunito',
                                                                                color: Colors.white,
                                                                                letterSpacing: 0.0,
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                          elevation:
                                                                              0,
                                                                          borderRadius:
                                                                              BorderRadius.circular(9),
                                                                        ),
                                                                      ),
                                                                    if (((bruker!.ratingTotalCount ??
                                                                            0) !=
                                                                        0))
                                                                      Padding(
                                                                        padding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            9,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            InkWell(
                                                                          splashColor:
                                                                              Colors.transparent,
                                                                          focusColor:
                                                                              Colors.transparent,
                                                                          hoverColor:
                                                                              Colors.transparent,
                                                                          highlightColor:
                                                                              Colors.transparent,
                                                                          onTap:
                                                                              () async {
                                                                            await showModalBottomSheet(
                                                                              isScrollControlled: true,
                                                                              backgroundColor: Colors.transparent,
                                                                              barrierColor: const Color.fromARGB(60, 17, 0, 0),
                                                                              useRootNavigator: true,
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return GestureDetector(
                                                                                  onTap: () => FocusScope.of(context).unfocus(),
                                                                                  child: Padding(
                                                                                    padding: MediaQuery.viewInsetsOf(context),
                                                                                    child: BrukerRatingWidget(
                                                                                      username: widget.username,
                                                                                      mine: false,
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ).then((value) =>
                                                                                setState(() {}));
                                                                            return;
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                105,
                                                                            height:
                                                                                36,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                              borderRadius: BorderRadius.circular(8),
                                                                              border: Border.all(
                                                                                color: const Color.fromARGB(32, 87, 99, 108),
                                                                                width: 1.3,
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                FaIcon(
                                                                                  FontAwesomeIcons.solidStar,
                                                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                                                  size: 16,
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(1, 0, 0, 0),
                                                                                  child: Text(
                                                                                    bruker!.ratingAverageValue.toString(),
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: 'Nunito',
                                                                                          fontSize: 14,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(1, 0, 0, 0),
                                                                                  child: Text(
                                                                                    ' (${bruker!.ratingTotalCount.toString()})',
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: 'Nunito',
                                                                                          color: const Color(0xB0262C2D),
                                                                                          fontSize: 14,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.w500,
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(0, 5, 0, 0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                24, 0, 0, 0),
                                                        child: Text(
                                                          _isLoading
                                                              ? '' // Show an empty string while loading
                                                              : (bruker?.bonde ==
                                                                      true
                                                                  ? bruker!
                                                                      .gardsnavn
                                                                      .toString()
                                                                  : '${bruker?.firstname} ${bruker?.lastname}'), // Show gardsnavn if bonde is true, otherwise show username
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .headlineLarge
                                                              .override(
                                                                fontFamily:
                                                                    'Nunito',
                                                                fontSize: 17,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if ((bruker?.bio ?? '')
                                                    .isNotEmpty)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            24, 4, 40, 0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                          ),
                                                          child: Text(
                                                            _isLoading
                                                                ? ''
                                                                : bruker?.bio ??
                                                                    '',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  fontSize: 14,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                            maxLines: _isExpanded
                                                                ? null
                                                                : 2, // Show limited lines if not expanded
                                                            overflow: _isExpanded
                                                                ? TextOverflow
                                                                    .visible
                                                                : TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        if (FFAppState()
                                                                    .bio
                                                                    .length >
                                                                50 ||
                                                            '\n'
                                                                    .allMatches(
                                                                        FFAppState()
                                                                            .bio)
                                                                    .length >=
                                                                2)
                                                          const SizedBox(
                                                              height: 2),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              _isExpanded =
                                                                  !_isExpanded; // Toggle the expanded state
                                                            });
                                                          },
                                                          child: Text(
                                                            _isExpanded
                                                                ? 'Se mindre'
                                                                : 'Se mer',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodySmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: const Color
                                                                      .fromRGBO(
                                                                      113,
                                                                      113,
                                                                      113,
                                                                      1.0),
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 20, 0, 0),
                                              child: Column(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        const Alignment(0, 0),
                                                    child: TabBar(
                                                      labelColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      unselectedLabelColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      labelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Nunito',
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                      unselectedLabelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Nunito',
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                      indicatorColor:
                                                          const Color(
                                                              0x00F6F6F6),
                                                      dividerColor:
                                                          const Color.fromARGB(
                                                              10, 0, 0, 0),
                                                      indicatorWeight: 1,
                                                      tabs: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              CupertinoIcons
                                                                  .square_grid_2x2,
                                                              color: _model
                                                                          .tabBarCurrentIndex ==
                                                                      0
                                                                  ? FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText
                                                                  : Colors.grey,
                                                              size: 32,
                                                            ),
                                                            const Tab(
                                                              text: '',
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            FaIcon(
                                                              FontAwesomeIcons
                                                                  .bars,
                                                              color: _model
                                                                          .tabBarCurrentIndex ==
                                                                      1
                                                                  ? FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText
                                                                  : Colors.grey,
                                                              size: 27,
                                                            ),
                                                            const Tab(
                                                              text: '',
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                      controller: _model
                                                          .tabBarController,
                                                      onTap: (i) async {
                                                        [
                                                          () async {},
                                                          () async {}
                                                        ][i]();
                                                      },
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: TabBarView(
                                                      controller: _model
                                                          .tabBarController,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      children: [
                                                        Container(),
                                                        Container(),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (_isLoading != true && _empty == true)
                                      Container(
                                        width: MediaQuery.sizeOf(context).width,
                                        height:
                                            MediaQuery.sizeOf(context).height -
                                                550,
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize
                                                .min, // Use min to fit content
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                CupertinoIcons
                                                    .camera_on_rectangle,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                size: 56,
                                              ),
                                              const SizedBox(height: 16),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Ingen annonser ennå',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLarge
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 19,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    if (_isLoading != true)
                                      if (_model.tabBarCurrentIndex == 0)
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(5, 0, 5, 70),
                                          child: RefreshIndicator(
                                            onRefresh: () async {},
                                            child: GridView.builder(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                0,
                                                0,
                                                0,
                                                70,
                                              ),
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                childAspectRatio: 0.68,
                                              ),
                                              primary: false,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount: _matisLoading
                                                  ? 1
                                                  : _matvarer?.length ?? 1,
                                              itemBuilder: (context, index) {
                                                if (_matisLoading || _empty) {
                                                  return Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey[300]!,
                                                    highlightColor:
                                                        Colors.grey[100]!,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          width: 200.0,
                                                          height: 230.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color
                                                                .fromARGB(127,
                                                                255, 255, 255),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16.0), // Rounded corners
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 8.0),
                                                        Container(
                                                          width: 200,
                                                          height: 15,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color
                                                                .fromARGB(127,
                                                                255, 255, 255),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }

                                                final matvarer =
                                                    _matvarer![index];

                                                return Stack(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          const AlignmentDirectional(
                                                              0, -1),
                                                      child: InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          context.pushNamed(
                                                            'MatDetaljBondegard',
                                                            queryParameters: {
                                                              'matvare':
                                                                  serializeParam(
                                                                matvarer
                                                                    .toJson(), // Convert to JSON before passing
                                                                ParamType.JSON,
                                                              ),
                                                            },
                                                          );
                                                        },
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          elevation: 0,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16),
                                                          ),
                                                          child: Container(
                                                            width: 235,
                                                            height: 290,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16),
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .transparent,
                                                              ),
                                                            ),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      const AlignmentDirectional(
                                                                          0, 0),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            3,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              17),
                                                                      child: Image
                                                                          .network(
                                                                        '${ApiConstants.baseUrl}${matvarer.imgUrls![0]}',
                                                                        width:
                                                                            200,
                                                                        height:
                                                                            229,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        errorBuilder: (BuildContext context,
                                                                            Object
                                                                                error,
                                                                            StackTrace?
                                                                                stackTrace) {
                                                                          return Image
                                                                              .asset(
                                                                            'assets/images/error_image.jpg',
                                                                            width:
                                                                                200,
                                                                            height:
                                                                                229,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          5,
                                                                          0,
                                                                          5,
                                                                          0),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Align(
                                                                        alignment: const AlignmentDirectional(
                                                                            -1,
                                                                            0),
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              7,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              AutoSizeText(
                                                                            matvarer.name ??
                                                                                '',
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            minFontSize:
                                                                                11,
                                                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                  fontFamily: 'Nunito',
                                                                                  fontSize: 14,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          4),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Flexible(
                                                                        child:
                                                                            Align(
                                                                          alignment: const AlignmentDirectional(
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                5,
                                                                                0,
                                                                                5,
                                                                                0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsetsDirectional.fromSTEB(7, 0, 0, 0),
                                                                                        child: Text(
                                                                                          '${matvarer.price} Kr',
                                                                                          textAlign: TextAlign.end,
                                                                                          style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                                fontFamily: 'Nunito',
                                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                fontSize: 14,
                                                                                                letterSpacing: 0.0,
                                                                                                fontWeight: FontWeight.bold,
                                                                                              ),
                                                                                        ),
                                                                                      ),
                                                                                      if (matvarer.kg == true)
                                                                                        Text(
                                                                                          '/kg',
                                                                                          textAlign: TextAlign.end,
                                                                                          style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                                fontFamily: 'Nunito',
                                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                fontSize: 14,
                                                                                                letterSpacing: 0.0,
                                                                                                fontWeight: FontWeight.bold,
                                                                                              ),
                                                                                        ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 7, 0),
                                                                                      child: Text(
                                                                                        (calculateDistance(FFAppState().brukerLat, FFAppState().brukerLng, matvarer.lat ?? 0.0, matvarer.lng ?? 0.0) < 1) ? '<1 Km' : '${calculateDistance(FFAppState().brukerLat, FFAppState().brukerLng, matvarer.lat ?? 0.0, matvarer.lng ?? 0.0).toStringAsFixed(0)} Km',
                                                                                        textAlign: TextAlign.start,
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: 'Nunito',
                                                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                                                              fontSize: 14,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.bold,
                                                                                            ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    if (matvarer.kjopt == true)
                                                      Positioned(
                                                        top:
                                                            15, // Slight offset from the top edge
                                                        right:
                                                            -29, // Fine-tune the positioning (shift it to the right edge)
                                                        child: Transform.rotate(
                                                          angle:
                                                              0.600, // 45-degree angle (approx.)
                                                          child: Container(
                                                            width:
                                                                140, // Adjusted width to avoid overflow after rotation
                                                            height: 23,
                                                            color: Colors
                                                                .redAccent,
                                                            alignment: Alignment
                                                                .center,
                                                            child: const Text(
                                                              'Utsolgt',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    14, // Font size adjusted to fit the banner
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (_model.tabBarCurrentIndex == 1)
                            ListView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                0,
                                0,
                                0,
                                170,
                              ),
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount:
                                  _matisLoading ? 1 : _matvarer?.length ?? 1,
                              itemBuilder: (context, index) {
                                if (_matisLoading || _empty) {
                                  return Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            17, 20, 0, 0),
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Row(
                                        children: [
                                          // Shimmer for Image
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: Container(
                                              width: 60,
                                              height: 60,
                                              color: const Color.fromARGB(
                                                  127,
                                                  255,
                                                  255,
                                                  255), // Background color
                                            ),
                                          ),
                                          const SizedBox(width: 16.0),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Shimmer.fromColors(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor:
                                                      Colors.grey[100]!,
                                                  child: Container(
                                                    width: 120,
                                                    height: 16.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              127,
                                                              255,
                                                              255,
                                                              255),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8.0),
                                                Shimmer.fromColors(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor:
                                                      Colors.grey[100]!,
                                                  child: Container(
                                                    width:
                                                        90.0, // Narrower width for second line
                                                    height: 16.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              127,
                                                              255,
                                                              255,
                                                              255),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                final matvarer = _matvarer![index];

                                return Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      10, 10, 10, 0),
                                  child: Stack(
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed(
                                            'MatDetaljBondegard',
                                            queryParameters: {
                                              'matvare': serializeParam(
                                                matvarer
                                                    .toJson(), // Convert to JSON before passing
                                                ParamType.JSON,
                                              ),
                                            },
                                          );
                                        },
                                        child: Material(
                                          color: Colors.transparent,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(8, 0, 8, 8),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0, 1, 1, 1),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      child: Image.network(
                                                        '${ApiConstants.baseUrl}${matvarer.imgUrls![0].toString()}',
                                                        width: 64,
                                                        height: 64,
                                                        fit: BoxFit.cover,
                                                        errorBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Object error,
                                                                StackTrace?
                                                                    stackTrace) {
                                                          return Image.asset(
                                                            'assets/images/error_image.jpg', // Path to your local error image
                                                            height: 64,
                                                            width: 64,
                                                            fit: BoxFit.cover,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              12, 0, 4, 0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                child: Text(
                                                                  matvarer.name ??
                                                                      '',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineSmall
                                                                      .override(
                                                                        fontFamily:
                                                                            'Nunito',
                                                                        fontSize:
                                                                            16,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                      ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0,
                                                                        3,
                                                                        0,
                                                                        0),
                                                                child: Text(
                                                                  'Tilgjengelig: ${matvarer.antall!.toStringAsFixed(0)} Stk',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineSmall
                                                                      .override(
                                                                        fontFamily:
                                                                            'Nunito',
                                                                        fontSize:
                                                                            14,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    0, 0, 0, 0),
                                                            child: Text(
                                                              '${matvarer.price} Kr',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .headlineSmall
                                                                  .override(
                                                                    fontFamily:
                                                                        'Nunito',
                                                                    fontSize:
                                                                        15,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (matvarer.kjopt == true)
                                        Positioned(
                                          top:
                                              15, // Slight offset from the top edge
                                          left:
                                              -29, // Fine-tune the positioning (shift it to the right edge)
                                          child: Transform.rotate(
                                            angle:
                                                -0.600, // 45-degree angle (approx.)
                                            child: Container(
                                              width:
                                                  140, // Adjusted width to avoid overflow after rotation
                                              height: 23,
                                              color: Colors.redAccent,
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'Utsolgt',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      13, // Font size adjusted to fit the banner
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
