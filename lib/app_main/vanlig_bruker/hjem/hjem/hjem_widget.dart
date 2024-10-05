import 'dart:convert';

import 'package:mat_salg/Bonder.dart';
import 'package:mat_salg/matvarer.dart';

import '/app_main/vanlig_bruker/custom_nav_bar_user/home_nav_bar/home_nav_bar_widget.dart';
import '/app_main/vanlig_bruker/hjem/filtrer_sok/filtrer_sok_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:mat_salg/ApiCalls.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mat_salg/SecureStorage.dart';
import 'hjem_model.dart';
export 'hjem_model.dart';

class HjemWidget extends StatefulWidget {
  const HjemWidget({super.key});

  @override
  State<HjemWidget> createState() => _HjemWidgetState();
}

class _HjemWidgetState extends State<HjemWidget> {
  late HjemModel _model;

  List<Matvarer>? _matvarer;
  List<Bonder>? _bonder;
  bool _isloading = true;
  bool _bondeisloading = true;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ApiCalls apicalls = ApiCalls();
  final Securestorage securestorage = Securestorage();

  LatLng? currentUserLocationValue;
  Map<String, dynamic>? userInfo;

  @override
  void initState() {
    super.initState();
    fetchData(); // This initiates the API call
    getAllFoods();
    getAllBonder();
    _model = createModel(context, () => HjemModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      currentUserLocationValue =
          await getCurrentUserLocation(defaultLocation: const LatLng(0.0, 0.0));
      FFAppState().brukersted = currentUserLocationValue;
      FFAppState().bonde = false;
      safeSetState(() {});
    });

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _model.textFieldFocusNode!.addListener(() => safeSetState(() {}));
  }

  Future<void> getAllFoods() async {
    String? token = await Securestorage().readToken();
    if (token == null) {
      FFAppState().login = false;
      context.pushNamed('registrer');
      return;
    } else {
      _matvarer = await ApiGetAllFoods.getAllFoods(token);
      setState(() {
        if (_matvarer != null && _matvarer!.isEmpty) {
          return;
        } else {
          _isloading = false;
        }
      });
    }
  }

  Future<void> getAllBonder() async {
    String? token = await Securestorage().readToken();
    if (token == null) {
      FFAppState().login = false;
      context.pushNamed('registrer');
      return;
    } else {
      _bonder = await ApiGetBonder.getAllBonder(token);
      setState(() {
        if (_bonder != null && _bonder!.isEmpty) {
          return;
        } else {
          _bondeisloading = false;
        }
      });
    }
  }

  Future<void> fetchData() async {
    try {
      String? token = await Securestorage().readToken();
      if (token == null) {
        FFAppState().login = false;
        context.pushNamed('registrer');
        return;
      } else {
        final response = await apicalls.checkUserInfo(Securestorage.authToken);
        if (response.statusCode == 200) {
          final decodedResponse = jsonDecode(response.body);
          userInfo = decodedResponse; // Update userInfo with fetched data
          FFAppState().brukernavn = decodedResponse['brukernavn'] ?? '';
          FFAppState().firstname = decodedResponse['firstname'] ?? '';
          FFAppState().lastname = decodedResponse['lastname'] ?? '';
          FFAppState().brukernavn = decodedResponse['brukernavn'] ?? '';
          FFAppState().bio = decodedResponse['bio'] ?? '';
          FFAppState().profilepic = decodedResponse['profilepic'] ?? '';
        }
        if (response.statusCode == 401 ||
            response.statusCode == 404 ||
            response.statusCode == 500) {
          FFAppState().login = false;
          context.pushNamed('registrer');
          return;
        }
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Oops, noe gikk galt'),
            content: const Text(
                'Sjekk internettforbindelsen din og prøv igjen.\nHvis problemet vedvarer, vennligst kontakt oss for hjelp.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).secondary,
          body: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    primary: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 10.0, 0.0, 17.0),
                                child: SafeArea(
                                  child: Container(
                                    width: valueOrDefault<double>(
                                      MediaQuery.sizeOf(context).width,
                                      500.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Align(
                                          alignment: const AlignmentDirectional(
                                              -1.0, 0.0),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(
                                                10.0, 0.0, 10.0, 15.0),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                context.pushNamed(
                                                  'VelgPosisjon',
                                                  queryParameters: {
                                                    'bonde': serializeParam(
                                                      false,
                                                      ParamType.bool,
                                                    ),
                                                    'endrepos': serializeParam(
                                                      true,
                                                      ParamType.bool,
                                                    ),
                                                  }.withoutNulls,
                                                );
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons.location_on,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                    size: 24.0,
                                                  ),
                                                  Text(
                                                    'Halden',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Open Sans',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                          fontSize: 17.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                  Icon(
                                                    Icons.keyboard_arrow_down,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                    size: 24.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(20.0, 0.0, 20.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  controller:
                                                      _model.textController,
                                                  focusNode:
                                                      _model.textFieldFocusNode,
                                                  autofocus: false,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    alignLabelWithHint: false,
                                                    hintText: 'Søk',
                                                    hintStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              'Open Sans',
                                                          color: const Color(
                                                              0x8F101213),
                                                          fontSize: 13.0,
                                                          letterSpacing: 0.0,
                                                        ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0x6357636C),
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              13.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0x00000000),
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              13.0),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              13.0),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              13.0),
                                                    ),
                                                    filled: true,
                                                    fillColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .primary,
                                                    prefixIcon: const Icon(
                                                      Icons.search_outlined,
                                                    ),
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Open Sans',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        fontSize: 13.0,
                                                        letterSpacing: 0.0,
                                                      ),
                                                  textAlign: TextAlign.start,
                                                  cursorColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primaryText,
                                                  validator: _model
                                                      .textControllerValidator
                                                      .asValidator(context),
                                                ),
                                              ),
                                              // Row(
                                              //   mainAxisSize: MainAxisSize.max,
                                              //   children: [
                                              //     Align(
                                              //       alignment:
                                              //           const AlignmentDirectional(
                                              //               -1.0, 0.0),
                                              //       child: Padding(
                                              //         padding:
                                              //             const EdgeInsetsDirectional
                                              //                 .fromSTEB(10.0,
                                              //                 0.0, 10.0, 0.0),
                                              //         child:
                                              //             FlutterFlowDropDown<
                                              //                 String>(
                                              //           controller: _model
                                              //                   .dropDownValueController ??=
                                              //               FormFieldController<
                                              //                   String>(null),
                                              //           options: const [
                                              //             'Pris - lav høy',
                                              //             'Pris - høy lav',
                                              //             'Avstand - lav høy'
                                              //           ],
                                              //           onChanged: (val) async {
                                              //             safeSetState(() =>
                                              //                 _model.dropDownValue =
                                              //                     val);
                                              //             if (_model
                                              //                     .dropDownValue ==
                                              //                 'Pris') {
                                              //               return;
                                              //             }
                                              //             if (_model
                                              //                     .dropDownValue ==
                                              //                 'Avstand') {
                                              //               return;
                                              //             }
                                              //             safeSetState(() {
                                              //               _model
                                              //                   .dropDownValueController
                                              //                   ?.reset();
                                              //             });
                                              //           },
                                              //           width: 70.0,
                                              //           height: 35.0,
                                              //           textStyle:
                                              //               FlutterFlowTheme.of(
                                              //                       context)
                                              //                   .bodyMedium
                                              //                   .override(
                                              //                     fontFamily:
                                              //                         'Open Sans',
                                              //                     color: FlutterFlowTheme.of(
                                              //                             context)
                                              //                         .alternate,
                                              //                     fontSize:
                                              //                         14.0,
                                              //                     letterSpacing:
                                              //                         0.0,
                                              //                     fontWeight:
                                              //                         FontWeight
                                              //                             .bold,
                                              //                   ),
                                              //           hintText: 'Sorter',
                                              //           icon: FaIcon(
                                              //             FontAwesomeIcons
                                              //                 .arrowsAltV,
                                              //             color: FlutterFlowTheme
                                              //                     .of(context)
                                              //                 .alternate,
                                              //             size: 17.0,
                                              //           ),
                                              //           fillColor:
                                              //               FlutterFlowTheme.of(
                                              //                       context)
                                              //                   .primary,
                                              //           elevation: 4.0,
                                              //           borderColor:
                                              //               const Color(
                                              //                   0x6357636C),
                                              //           borderWidth: 1.0,
                                              //           borderRadius: 8.0,
                                              //           margin:
                                              //               const EdgeInsetsDirectional
                                              //                   .fromSTEB(7.0,
                                              //                   4.0, 5.0, 4.0),
                                              //           hidesUnderline: true,
                                              //           isOverButton: false,
                                              //           isSearchable: false,
                                              //           isMultiSelect: false,
                                              //         ),
                                              //       ),
                                              //     ),
                                              //     Align(
                                              //       alignment:
                                              //           const AlignmentDirectional(
                                              //               -1.0, 0.0),
                                              //       child: Builder(
                                              //         builder: (context) =>
                                              //             FlutterFlowIconButton(
                                              //           borderColor:
                                              //               const Color(
                                              //                   0x6357636C),
                                              //           borderRadius: 8.0,
                                              //           borderWidth: 1.0,
                                              //           buttonSize: 35.0,
                                              //           fillColor:
                                              //               FlutterFlowTheme.of(
                                              //                       context)
                                              //                   .primary,
                                              //           icon: FaIcon(
                                              //             FontAwesomeIcons
                                              //                 .slidersH,
                                              //             color: FlutterFlowTheme
                                              //                     .of(context)
                                              //                 .alternate,
                                              //             size: 20.0,
                                              //           ),
                                              //           onPressed: () async {
                                              //             FFAppState()
                                              //                 .kjopAlert = true;
                                              //             FFAppState()
                                              //                 .chatAlert = true;
                                              //             safeSetState(() {});
                                              //             await showDialog(
                                              //               barrierColor:
                                              //                   const Color(
                                              //                       0x1A000000),
                                              //               context: context,
                                              //               builder:
                                              //                   (dialogContext) {
                                              //                 return Dialog(
                                              //                   elevation: 0,
                                              //                   insetPadding:
                                              //                       EdgeInsets
                                              //                           .zero,
                                              //                   backgroundColor:
                                              //                       Colors
                                              //                           .transparent,
                                              //                   alignment: const AlignmentDirectional(
                                              //                           1.0,
                                              //                           -0.8)
                                              //                       .resolve(
                                              //                           Directionality.of(
                                              //                               context)),
                                              //                   child:
                                              //                       GestureDetector(
                                              //                     onTap: () =>
                                              //                         FocusScope.of(
                                              //                                 dialogContext)
                                              //                             .unfocus(),
                                              //                     child:
                                              //                         const FiltrerSokWidget(),
                                              //                   ),
                                              //                 );
                                              //               },
                                              //             );
                                              //           },
                                              //         ),
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 100.0, 0.0, 0.0),
                              child: SingleChildScrollView(
                                primary: false,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ListView(
                                      padding: EdgeInsets.zero,
                                      primary: false,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      children: [
                                        Align(
                                          alignment: const AlignmentDirectional(
                                              0.0, -1.0),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          -0.76, -0.61),
                                                  child: Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        1.0,
                                                    height: 50.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      border: Border.all(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  7.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                          child: Text(
                                                            'Bondegårder i nærheten',
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Open Sans',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontSize:
                                                                      18.0,
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
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          7, 0, 0, 55),
                                                  child: Builder(
                                                    builder: (context) {
                                                      return SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: List.generate(
                                                              _bondeisloading
                                                                  ? 3
                                                                  : _bonder
                                                                          ?.length ??
                                                                      0,
                                                              (index) {
                                                            if (_bondeisloading) {
                                                              return Shimmer
                                                                  .fromColors(
                                                                baseColor: Colors
                                                                        .grey[
                                                                    300]!, // Base color for the shimmer
                                                                highlightColor:
                                                                    Colors.grey[
                                                                        100]!, // Highlight color for the shimmer
                                                                child:
                                                                    Container(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          5.0),
                                                                  width: 288.0,
                                                                  height: 230.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white, // Background color of the shimmer box
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16.0), // Rounded corners
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            final bonder =
                                                                _bonder![index];

                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      0,
                                                                      0,
                                                                      15,
                                                                      0),
                                                              child: InkWell(
                                                                splashColor: Colors
                                                                    .transparent,
                                                                focusColor: Colors
                                                                    .transparent,
                                                                hoverColor: Colors
                                                                    .transparent,
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                onTap:
                                                                    () async {
                                                                  context
                                                                      .pushNamed(
                                                                    'BrukerPage',
                                                                    queryParameters: {
                                                                      'bruker':
                                                                          serializeParam(
                                                                        bonder
                                                                            .toJson(), // Convert to JSON before passing
                                                                        ParamType
                                                                            .JSON,
                                                                      ),
                                                                      'username':
                                                                          serializeParam(
                                                                        bonder
                                                                            .username,
                                                                        ParamType
                                                                            .String,
                                                                      ),
                                                                    },
                                                                  );
                                                                },
                                                                child: Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  elevation:
                                                                      1.2,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16),
                                                                  ),
                                                                  child:
                                                                      Container(
                                                                    width: 288,
                                                                    height: 230,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              16),
                                                                    ),
                                                                    child:
                                                                        Column(
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
                                                                          alignment: const AlignmentDirectional(
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                12),
                                                                            child:
                                                                                ClipRRect(
                                                                              borderRadius: const BorderRadius.only(
                                                                                bottomLeft: Radius.circular(0),
                                                                                bottomRight: Radius.circular(0),
                                                                                topLeft: Radius.circular(16),
                                                                                topRight: Radius.circular(16),
                                                                              ),
                                                                              child: Image.network(
                                                                                bonder.profilepic.toString(),
                                                                                width: double.infinity,
                                                                                height: 149,
                                                                                fit: BoxFit.cover,
                                                                                cacheWidth: 210,
                                                                                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                                                                  return Image.asset(
                                                                                    'assets/images/error_image.jpg', // Path to your local error image
                                                                                    fit: BoxFit.cover,
                                                                                  );
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Align(
                                                                          alignment: const AlignmentDirectional(
                                                                              -1,
                                                                              0),
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                10,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            child:
                                                                                AutoSizeText(
                                                                              bonder.gardsnavn ?? '',
                                                                              textAlign: TextAlign.start,
                                                                              minFontSize: 11,
                                                                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                    fontFamily: 'Open Sans',
                                                                                    fontSize: 16,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              0,
                                                                              10,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                children: [
                                                                                  const Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 2),
                                                                                    child: FaIcon(
                                                                                      FontAwesomeIcons.solidStar,
                                                                                      color: Color(0x94FFCD3C),
                                                                                      size: 17,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    '4.6',
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: 'Open Sans',
                                                                                          fontSize: 14,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.w500,
                                                                                        ),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    height: 20,
                                                                                    child: VerticalDivider(
                                                                                      thickness: 1,
                                                                                      color: Color(0x6B616161),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                children: [
                                                                                  Icon(
                                                                                    Icons.place,
                                                                                    color: FlutterFlowTheme.of(context).alternate,
                                                                                    size: 17,
                                                                                  ),
                                                                                  Text(
                                                                                    '3',
                                                                                    textAlign: TextAlign.start,
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: 'Open Sans',
                                                                                          color: FlutterFlowTheme.of(context).primaryText,
                                                                                          fontSize: 14,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                                                                                    child: Text(
                                                                                      'Km',
                                                                                      textAlign: TextAlign.start,
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: 'Open Sans',
                                                                                            color: FlutterFlowTheme.of(context).primaryText,
                                                                                            fontSize: 14,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.w600,
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
                                                              ),
                                                            );
                                                          }),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          -0.76, -0.61),
                                                  child: Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        1.0,
                                                    height: 50.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      border: Border.all(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  7.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                          child: Text(
                                                            'Lokale matvarer',
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Open Sans',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontSize:
                                                                      18.0,
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
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              5.0, 0.0, 5.0, 0.0),
                                      child: RefreshIndicator(
                                        onRefresh: () async {
                                          await getAllFoods();
                                        },
                                        child: GridView.builder(
                                          padding: const EdgeInsets.fromLTRB(
                                            0,
                                            0,
                                            0,
                                            63.0,
                                          ),
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 10.0,
                                            childAspectRatio: 0.69,
                                          ),
                                          primary: false,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount: _isloading
                                              ? 6
                                              : _matvarer?.length ?? 0,
                                          itemBuilder: (context, index) {
                                            if (_isloading) {
                                              return Shimmer.fromColors(
                                                baseColor: Colors.grey[
                                                    300]!, // Base color for the shimmer
                                                highlightColor: Colors.grey[
                                                    100]!, // Highlight color for the shimmer
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.all(5.0),
                                                  width: 225.0,
                                                  height: 235.0,
                                                  decoration: BoxDecoration(
                                                    color: Colors
                                                        .white, // Background color of the shimmer box
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0), // Rounded corners
                                                  ),
                                                ),
                                              );
                                            }
                                            final matvare = _matvarer![index];
                                            return Stack(children: [
                                              Stack(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        const AlignmentDirectional(
                                                            0.0, -1.0),
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
                                                              matvare
                                                                  .toJson(), // Convert to JSON before passing
                                                              ParamType.JSON,
                                                            ),
                                                          },
                                                        );
                                                      },
                                                      child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        elevation: 0.3,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      16.0),
                                                        ),
                                                        child: Container(
                                                          width: 225.0,
                                                          height: 235.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16.0),
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
                                                                        0.0,
                                                                        0.0),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          12.0),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              0.0),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              0.0),
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              16.0),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              16.0),
                                                                    ),
                                                                    child: Image
                                                                        .network(
                                                                      matvare
                                                                          .imgUrls![
                                                                              0]
                                                                          .toString(),
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          151.0,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      errorBuilder: (BuildContext context,
                                                                          Object
                                                                              error,
                                                                          StackTrace?
                                                                              stackTrace) {
                                                                        return Image
                                                                            .asset(
                                                                          'assets/images/error_image.jpg', // Path to your local error image
                                                                          fit: BoxFit
                                                                              .cover,
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
                                                                        5.0,
                                                                        0.0,
                                                                        5.0,
                                                                        0.0),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Align(
                                                                      alignment:
                                                                          const AlignmentDirectional(
                                                                              -1.0,
                                                                              0.0),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            7.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            AutoSizeText(
                                                                          matvare.name ??
                                                                              '',
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                          minFontSize:
                                                                              11.0,
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyLarge
                                                                              .override(
                                                                                fontFamily: 'Open Sans',
                                                                                fontSize: 16.0,
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
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        4.0),
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
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              5.0,
                                                                              5.0,
                                                                              5.0,
                                                                              0.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.end,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                                                                                child: Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsetsDirectional.fromSTEB(7.0, 0.0, 0.0, 0.0),
                                                                                      child: Text(
                                                                                        '${matvare.price ?? 0} Kr',
                                                                                        textAlign: TextAlign.end,
                                                                                        style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                              fontFamily: 'Open Sans',
                                                                                              color: FlutterFlowTheme.of(context).alternate,
                                                                                              fontSize: 16.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.bold,
                                                                                            ),
                                                                                      ),
                                                                                    ),
                                                                                    if (matvare.kg == true)
                                                                                      Text(
                                                                                        '/kg',
                                                                                        textAlign: TextAlign.end,
                                                                                        style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                              fontFamily: 'Open Sans',
                                                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                                                              fontSize: 16.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.w600,
                                                                                            ),
                                                                                      ),
                                                                                    if (matvare.kg != true)
                                                                                      Text(
                                                                                        '/stk',
                                                                                        textAlign: TextAlign.end,
                                                                                        style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                              fontFamily: 'Open Sans',
                                                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                                                              fontSize: 16.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.w600,
                                                                                            ),
                                                                                      ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                children: [
                                                                                  Icon(
                                                                                    Icons.place,
                                                                                    color: FlutterFlowTheme.of(context).alternate,
                                                                                    size: 17.0,
                                                                                  ),
                                                                                  Text(
                                                                                    '3',
                                                                                    textAlign: TextAlign.start,
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: 'Open Sans',
                                                                                          color: FlutterFlowTheme.of(context).primaryText,
                                                                                          fontSize: 14.0,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 0.0),
                                                                                    child: Text(
                                                                                      'Km',
                                                                                      textAlign: TextAlign.start,
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: 'Open Sans',
                                                                                            color: FlutterFlowTheme.of(context).primaryText,
                                                                                            fontSize: 14.0,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.w600,
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
                                                ],
                                              ),
                                            ]);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                wrapWithModel(
                  model: _model.homeNavBarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: const HomeNavBarWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
