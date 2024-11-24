import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:mat_salg/MyIP.dart';
import 'package:mat_salg/app_main/vanlig_bruker/legg_ut/velg_kategori/velg_kategori_widget.dart';
import 'package:mat_salg/matvarer.dart';

import '/app_main/vanlig_bruker/legg_ut/velg_pos/velg_pos_widget.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:mat_salg/ApiCalls.dart';
import 'package:mat_salg/SecureStorage.dart';
import 'legg_ut_matvare_model.dart';
export 'legg_ut_matvare_model.dart';

class LeggUtMatvareWidget extends StatefulWidget {
  const LeggUtMatvareWidget({
    super.key,
    bool? rediger,
    this.matinfo,
  }) : rediger = rediger ?? false;

  final bool rediger;
  final dynamic matinfo;

  @override
  State<LeggUtMatvareWidget> createState() => _LeggUtMatvareWidgetState();
}

class DecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text;

    // Prevent starting with a dot
    if (newText.startsWith('.')) {
      return oldValue;
    }

    // Prevent multiple dots or consecutive dots
    if (newText.indexOf('.') != newText.lastIndexOf('.') ||
        newText.contains('..')) {
      return oldValue;
    }

    // If all conditions are met, return the new value
    return newValue;
  }
}

class _LeggUtMatvareWidgetState extends State<LeggUtMatvareWidget>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late LeggUtMatvareModel _model;
  double _selectedValue = 0.0;
  final FocusNode _hiddenFocusNode = FocusNode();
  late Matvarer matvare;

  final ApiCalls apiCalls = ApiCalls();

  final ApiUploadFood apiUploadFood = ApiUploadFood();
  final Securestorage securestorage = Securestorage();
  final ApiMultiplePics apiMultiplePics = ApiMultiplePics();
  bool _leggUtLoading = false;
  bool _oppdaterLoading = false;
  bool isFocused = false;
  String? kommune;
  String? kategori;
  String? velgkategori;
  LatLng? selectedLatLng;
  LatLng? currentselectedLatLng =
      (FFAppState().brukerLat != null && FFAppState().brukerLng != null)
          ? LatLng(FFAppState().brukerLat!, FFAppState().brukerLng!)
          : const LatLng(0, 0);
  bool test = true;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _scrollController = ScrollController();

    // Add a listener to the scroll controller to monitor user scroll
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection !=
          ScrollDirection.idle) {
        // This means the user is scrolling (not idle)
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });
    super.initState();
    _model = createModel(context, () => LeggUtMatvareModel());

    _model.produktNavnTextController ??= TextEditingController();
    _model.produktNavnFocusNode ??= FocusNode();

    _model.produktBeskrivelseTextController ??= TextEditingController();
    _model.produktBeskrivelseFocusNode ??= FocusNode();

    _model.produktPrisSTKTextController ??= TextEditingController();
    _model.produktPrisSTKFocusNode ??= FocusNode();

    _model.antallStkTextController ??= TextEditingController();
    _model.antallStkFocusNode ??= FocusNode();

    if (widget.matinfo != null) {
      matvare = Matvarer.fromJson1(widget.matinfo);

      if (matvare.antall != null) {
        _selectedValue = matvare.antall!;
      }
      while (matvare.imgUrls!.length <= 4) {
        matvare.imgUrls?.add(''); // Add empty string placeholders
      }
      _model.produktNavnTextController.text = matvare.name ?? '';
      kategori = matvare.kategorier!.first;
      _model.produktBeskrivelseTextController.text = matvare.description ?? '';
      if (matvare.antall.toString() == 'null') {
        _model.antallStkTextController.text = '0';
      } else {
        _model.antallStkTextController.text =
            matvare.antall!.toStringAsFixed(0);
      }
      _model.produktPrisSTKTextController.text = matvare.price.toString();
      leggutgetKommune(matvare.lat ?? 0, matvare.lng ?? 0);
      selectedLatLng = LatLng(matvare.lat ?? 0, matvare.lng ?? 0);
    } else {
      matvare = Matvarer.fromJson1({'imgUrl': []});
      while (matvare.imgUrls!.length <= 4) {
        matvare.imgUrls?.add('');
      }
    }
  }

  void showErrorToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        left: 16.0,
        right: 16.0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8)
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
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  Future<void> leggutgetKommune(double lat, double lng) async {
    try {
      if (lat == 0 || lng == 0) {
        return;
      }
      String? token = await Securestorage().readToken();

      if (token == null) {
        FFAppState().login = false;
        context.pushNamed('registrer');
        return;
      } else {
        String? response = await apiCalls.leggutgetKommune(token, lat, lng);

        if (response.isNotEmpty) {
          // Convert the response to lowercase and then capitalize the first letter
          String formattedResponse =
              response[0].toUpperCase() + response.substring(1).toLowerCase();

          FFAppState().kommune = formattedResponse;
          setState(() {
            print(formattedResponse);
            kommune = formattedResponse;
          });
        }
      }
    } on SocketException {
      showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      showErrorToast(context, 'En feil oppstod');
    }
  }

  void updateSelectedLatLng(LatLng? newLatLng) {
    try {
      setState(() {
        selectedLatLng = null;
      });

      Timer(const Duration(milliseconds: 100), () {
        setState(() {
          selectedLatLng = newLatLng;
        });
      });
    } on SocketException {
      showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      showErrorToast(context, 'En feil oppstod');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _model.dispose();
    _hiddenFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primary,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            // iconTheme:
            //     IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0.0,
            // leading: Align(
            //   alignment: const AlignmentDirectional(0, 0),
            //   child: Padding(
            //     padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
            //     child: InkWell(
            //       splashColor: Colors.transparent,
            //       focusColor: Colors.transparent,
            //       hoverColor: Colors.transparent,
            //       highlightColor: Colors.transparent,
            //       onTap: () async {
            //         try {
            //           context.safePop();
            //         } on SocketException {
            //           showErrorToast(context, 'Ingen internettforbindelse');
            //         } catch (e) {
            //           showErrorToast(context, 'En feil oppstod');
            //         }
            //       },
            //       child: Row(
            //         mainAxisSize: MainAxisSize.max,
            //         children: [
            //           Icon(
            //             Icons.arrow_back_ios,
            //             color: FlutterFlowTheme.of(context).secondaryText,
            //             size: 28,
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                  child: GestureDetector(
                    onTap: () async {
                      try {
                        context.safePop();
                      } on SocketException {
                        showErrorToast(context, 'Ingen internettforbindelse');
                      } catch (e) {
                        showErrorToast(context, 'En feil oppstod');
                      }
                    },
                    child: Text(
                      'Avbryt',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Nunito',
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 16,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                Text(
                  'Ny matvare',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Nunito',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 20,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                  child: Text(
                    'Avbryt',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Nunito',
                          color: Colors.transparent,
                          fontSize: 16,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            actions: const [],
            centerTitle: true,
            elevation: 0.0,
          ),
          body: SafeArea(
            top: true,
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController, // Set the controller here
                    primary: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Form(
                                    key: _model.formKey,
                                    autovalidateMode: AutovalidateMode.disabled,
                                    child: GestureDetector(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                    -1.0, 0.0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      20.0, 40.0, 0.0, 20.0),
                                              child: Text(
                                                'Legg til bilder',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 19.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                              ),
                                            ),
                                          ),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if ((_model.uploadedLocalFile1
                                                            .bytes?.isEmpty ??
                                                        true) &&
                                                    (matvare
                                                        .imgUrls![0].isEmpty))
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(20.0, 0.0,
                                                            0.0, 12.0),
                                                    child:
                                                        FlutterFlowIconButton(
                                                      borderColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      borderRadius: 15.0,
                                                      buttonSize: 92.0,
                                                      fillColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      icon: Icon(
                                                        CupertinoIcons.camera,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        size: 27.0,
                                                      ),
                                                      onPressed: () async {
                                                        try {
                                                          final selectedMedia =
                                                              await selectMediaWithSourceBottomSheet(
                                                            context: context,
                                                            maxWidth: 500.00,
                                                            maxHeight: 500.00,
                                                            allowPhoto: true,
                                                          );
                                                          if (selectedMedia !=
                                                                  null &&
                                                              selectedMedia.every((m) =>
                                                                  validateFileFormat(
                                                                      m.storagePath,
                                                                      context))) {
                                                            safeSetState(() =>
                                                                _model.isDataUploading1 =
                                                                    true);
                                                            var selectedUploadedFiles =
                                                                <FFUploadedFile>[];

                                                            try {
                                                              selectedUploadedFiles =
                                                                  selectedMedia
                                                                      .map((m) =>
                                                                          FFUploadedFile(
                                                                            name:
                                                                                m.storagePath.split('/').last,
                                                                            bytes:
                                                                                m.bytes,
                                                                            height:
                                                                                m.dimensions?.height,
                                                                            width:
                                                                                m.dimensions?.width,
                                                                            blurHash:
                                                                                m.blurHash,
                                                                          ))
                                                                      .toList();
                                                            } finally {
                                                              _model.isDataUploading1 =
                                                                  false;
                                                            }
                                                            if (selectedUploadedFiles
                                                                    .length ==
                                                                selectedMedia
                                                                    .length) {
                                                              safeSetState(() {
                                                                _model.uploadedLocalFile1 =
                                                                    selectedUploadedFiles
                                                                        .first;
                                                              });
                                                            } else {
                                                              safeSetState(
                                                                  () {});
                                                              return;
                                                            }
                                                          }
                                                        } on SocketException {
                                                          showErrorToast(
                                                              context,
                                                              'Ingen internettforbindelse');
                                                        } catch (e) {
                                                          showErrorToast(
                                                              context,
                                                              'En feil oppstod');
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0.0, 0.0, 10.0, 0.0),
                                                  child: Stack(
                                                    alignment:
                                                        const AlignmentDirectional(
                                                            1.0, -1.0),
                                                    children: [
                                                      if (widget.matinfo !=
                                                              null &&
                                                          matvare.imgUrls![0]
                                                              .isNotEmpty)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 15.0),
                                                          child: Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              child:
                                                                  Image.network(
                                                                '${ApiConstants.baseUrl}${matvare.imgUrls![0]}',
                                                                width: 100.0,
                                                                height: 100.0,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      if (widget.matinfo !=
                                                              null &&
                                                          matvare.imgUrls![0]
                                                              .isNotEmpty)
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  1.22, -1.2),
                                                          child:
                                                              FlutterFlowIconButton(
                                                            borderRadius: 100.0,
                                                            buttonSize: 29.0,
                                                            fillColor:
                                                                const Color(
                                                                    0xB3262C2D),
                                                            icon: FaIcon(
                                                              FontAwesomeIcons
                                                                  .times,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondary,
                                                              size: 16.0,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              try {
                                                                matvare.imgUrls![
                                                                    0] = '';
                                                                safeSetState(
                                                                    () {});
                                                              } on SocketException {
                                                                showErrorToast(
                                                                    context,
                                                                    'Ingen internettforbindelse');
                                                              } catch (e) {
                                                                showErrorToast(
                                                                    context,
                                                                    'En feil oppstod');
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      if ((_model
                                                              .uploadedLocalFile1
                                                              .bytes
                                                              ?.isNotEmpty ??
                                                          false))
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 15.0),
                                                          child: Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              child:
                                                                  Image.memory(
                                                                _model.uploadedLocalFile1
                                                                        .bytes ??
                                                                    Uint8List
                                                                        .fromList(
                                                                            []),
                                                                width: 100.0,
                                                                height: 100.0,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      if ((_model
                                                              .uploadedLocalFile1
                                                              .bytes
                                                              ?.isNotEmpty ??
                                                          false))
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  1.22, -1.2),
                                                          child:
                                                              FlutterFlowIconButton(
                                                            borderRadius: 100.0,
                                                            buttonSize: 29.0,
                                                            fillColor:
                                                                const Color(
                                                                    0xB3262C2D),
                                                            icon: FaIcon(
                                                              FontAwesomeIcons
                                                                  .times,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondary,
                                                              size: 16.0,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              try {
                                                                safeSetState(
                                                                    () {
                                                                  _model.isDataUploading1 =
                                                                      false;
                                                                  _model.uploadedLocalFile1 =
                                                                      FFUploadedFile(
                                                                          bytes:
                                                                              Uint8List.fromList([]));
                                                                });
                                                              } on SocketException {
                                                                showErrorToast(
                                                                    context,
                                                                    'Ingen internettforbindelse');
                                                              } catch (e) {
                                                                showErrorToast(
                                                                    context,
                                                                    'En feil oppstod');
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0.0, 0.0, 10.0, 0.0),
                                                  child: Stack(
                                                    alignment:
                                                        const AlignmentDirectional(
                                                            1.0, -1.0),
                                                    children: [
                                                      if (widget.matinfo !=
                                                              null &&
                                                          matvare.imgUrls![1]
                                                              .isNotEmpty)
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  0.0, 0.0),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            child:
                                                                Image.network(
                                                              '${ApiConstants.baseUrl}${matvare.imgUrls![1]}',
                                                              width: 100.0,
                                                              height: 100.0,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      if (widget.matinfo !=
                                                              null &&
                                                          matvare.imgUrls![1]
                                                              .isNotEmpty)
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  1.22, -1.2),
                                                          child:
                                                              FlutterFlowIconButton(
                                                            borderRadius: 100.0,
                                                            buttonSize: 29.0,
                                                            fillColor:
                                                                const Color(
                                                                    0xB3262C2D),
                                                            icon: FaIcon(
                                                              FontAwesomeIcons
                                                                  .times,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondary,
                                                              size: 16.0,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              try {
                                                                matvare.imgUrls![
                                                                    1] = '';
                                                                safeSetState(
                                                                    () {});
                                                              } on SocketException {
                                                                showErrorToast(
                                                                    context,
                                                                    'Ingen internettforbindelse');
                                                              } catch (e) {
                                                                showErrorToast(
                                                                    context,
                                                                    'En feil oppstod');
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      if ((_model
                                                              .uploadedLocalFile2
                                                              .bytes
                                                              ?.isNotEmpty ??
                                                          false))
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  0.0, 0.0),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            child: Image.memory(
                                                              _model.uploadedLocalFile2
                                                                      .bytes ??
                                                                  Uint8List
                                                                      .fromList(
                                                                          []),
                                                              width: 100.0,
                                                              height: 100.0,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      if ((_model
                                                              .uploadedLocalFile2
                                                              .bytes
                                                              ?.isNotEmpty ??
                                                          false))
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  1.22, -1.2),
                                                          child:
                                                              FlutterFlowIconButton(
                                                            borderColor: Colors
                                                                .transparent,
                                                            borderRadius: 100.0,
                                                            buttonSize: 29.0,
                                                            fillColor:
                                                                const Color(
                                                                    0xB3262C2D),
                                                            icon: FaIcon(
                                                              FontAwesomeIcons
                                                                  .times,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondary,
                                                              size: 16.0,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              try {
                                                                safeSetState(
                                                                    () {
                                                                  _model.isDataUploading2 =
                                                                      false;
                                                                  _model.uploadedLocalFile2 =
                                                                      FFUploadedFile(
                                                                          bytes:
                                                                              Uint8List.fromList([]));
                                                                });
                                                              } on SocketException {
                                                                showErrorToast(
                                                                    context,
                                                                    'Ingen internettforbindelse');
                                                              } catch (e) {
                                                                showErrorToast(
                                                                    context,
                                                                    'En feil oppstod');
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                if ((_model.uploadedLocalFile2
                                                            .bytes?.isEmpty ??
                                                        true) &&
                                                    (matvare
                                                        .imgUrls![1].isEmpty))
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                            0.0, 12.0),
                                                    child:
                                                        FlutterFlowIconButton(
                                                      borderColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      borderRadius: 15.0,
                                                      buttonSize: 92.0,
                                                      fillColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      icon: Icon(
                                                        CupertinoIcons.camera,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        size: 27.0,
                                                      ),
                                                      onPressed: () async {
                                                        try {
                                                          final selectedMedia =
                                                              await selectMediaWithSourceBottomSheet(
                                                            context: context,
                                                            maxWidth: 500.00,
                                                            maxHeight: 500.00,
                                                            allowPhoto: true,
                                                          );
                                                          if (selectedMedia !=
                                                                  null &&
                                                              selectedMedia.every((m) =>
                                                                  validateFileFormat(
                                                                      m.storagePath,
                                                                      context))) {
                                                            safeSetState(() =>
                                                                _model.isDataUploading2 =
                                                                    true);
                                                            var selectedUploadedFiles =
                                                                <FFUploadedFile>[];

                                                            try {
                                                              selectedUploadedFiles =
                                                                  selectedMedia
                                                                      .map((m) =>
                                                                          FFUploadedFile(
                                                                            name:
                                                                                m.storagePath.split('/').last,
                                                                            bytes:
                                                                                m.bytes,
                                                                            height:
                                                                                m.dimensions?.height,
                                                                            width:
                                                                                m.dimensions?.width,
                                                                            blurHash:
                                                                                m.blurHash,
                                                                          ))
                                                                      .toList();
                                                            } finally {
                                                              _model.isDataUploading2 =
                                                                  false;
                                                            }
                                                            if (selectedUploadedFiles
                                                                    .length ==
                                                                selectedMedia
                                                                    .length) {
                                                              safeSetState(() {
                                                                _model.uploadedLocalFile2 =
                                                                    selectedUploadedFiles
                                                                        .first;
                                                              });
                                                            } else {
                                                              safeSetState(
                                                                  () {});
                                                              return;
                                                            }
                                                          }
                                                        } on SocketException {
                                                          showErrorToast(
                                                              context,
                                                              'Ingen internettforbindelse');
                                                        } catch (e) {
                                                          showErrorToast(
                                                              context,
                                                              'En feil oppstod');
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0.0, 0.0, 10.0, 0.0),
                                                  child: Stack(
                                                    alignment:
                                                        const AlignmentDirectional(
                                                            1.0, -1.0),
                                                    children: [
                                                      if (widget.matinfo !=
                                                              null &&
                                                          matvare.imgUrls![2]
                                                              .isNotEmpty)
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  0.0, 0.0),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            child:
                                                                Image.network(
                                                              '${ApiConstants.baseUrl}${matvare.imgUrls![2]}',
                                                              width: 100.0,
                                                              height: 100.0,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      if (widget.matinfo !=
                                                              null &&
                                                          matvare.imgUrls![2]
                                                              .isNotEmpty)
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  1.22, -1.2),
                                                          child:
                                                              FlutterFlowIconButton(
                                                            borderRadius: 100.0,
                                                            buttonSize: 29.0,
                                                            fillColor:
                                                                const Color(
                                                                    0xB3262C2D),
                                                            icon: FaIcon(
                                                              FontAwesomeIcons
                                                                  .times,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondary,
                                                              size: 16.0,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              try {
                                                                matvare.imgUrls![
                                                                    2] = '';
                                                                safeSetState(
                                                                    () {});
                                                              } on SocketException {
                                                                showErrorToast(
                                                                    context,
                                                                    'Ingen internettforbindelse');
                                                              } catch (e) {
                                                                showErrorToast(
                                                                    context,
                                                                    'En feil oppstod');
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      if ((_model
                                                              .uploadedLocalFile3
                                                              .bytes
                                                              ?.isNotEmpty ??
                                                          false))
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  0.0, 0.0),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            child: Image.memory(
                                                              _model.uploadedLocalFile3
                                                                      .bytes ??
                                                                  Uint8List
                                                                      .fromList(
                                                                          []),
                                                              width: 100.0,
                                                              height: 100.0,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      if ((_model
                                                              .uploadedLocalFile3
                                                              .bytes
                                                              ?.isNotEmpty ??
                                                          false))
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  1.22, -1.2),
                                                          child:
                                                              FlutterFlowIconButton(
                                                            borderColor: Colors
                                                                .transparent,
                                                            borderRadius: 100.0,
                                                            buttonSize: 29.0,
                                                            fillColor:
                                                                const Color(
                                                                    0xB3262C2D),
                                                            icon: FaIcon(
                                                              FontAwesomeIcons
                                                                  .times,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondary,
                                                              size: 16.0,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              try {
                                                                safeSetState(
                                                                    () {
                                                                  _model.isDataUploading3 =
                                                                      false;
                                                                  _model.uploadedLocalFile3 =
                                                                      FFUploadedFile(
                                                                          bytes:
                                                                              Uint8List.fromList([]));
                                                                });
                                                              } on SocketException {
                                                                showErrorToast(
                                                                    context,
                                                                    'Ingen internettforbindelse');
                                                              } catch (e) {
                                                                showErrorToast(
                                                                    context,
                                                                    'En feil oppstod');
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                if ((_model.uploadedLocalFile3
                                                            .bytes?.isEmpty ??
                                                        true) &&
                                                    (matvare
                                                        .imgUrls![2].isEmpty))
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(8.0, 0.0,
                                                            0.0, 12.0),
                                                    child:
                                                        FlutterFlowIconButton(
                                                      borderColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      borderRadius: 15.0,
                                                      buttonSize: 92.0,
                                                      fillColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      icon: Icon(
                                                        CupertinoIcons.camera,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        size: 27.0,
                                                      ),
                                                      onPressed: () async {
                                                        try {
                                                          final selectedMedia =
                                                              await selectMediaWithSourceBottomSheet(
                                                            context: context,
                                                            maxWidth: 500.00,
                                                            maxHeight: 500.00,
                                                            allowPhoto: true,
                                                          );
                                                          if (selectedMedia !=
                                                                  null &&
                                                              selectedMedia.every((m) =>
                                                                  validateFileFormat(
                                                                      m.storagePath,
                                                                      context))) {
                                                            safeSetState(() =>
                                                                _model.isDataUploading3 =
                                                                    true);
                                                            var selectedUploadedFiles =
                                                                <FFUploadedFile>[];

                                                            try {
                                                              selectedUploadedFiles =
                                                                  selectedMedia
                                                                      .map((m) =>
                                                                          FFUploadedFile(
                                                                            name:
                                                                                m.storagePath.split('/').last,
                                                                            bytes:
                                                                                m.bytes,
                                                                            height:
                                                                                m.dimensions?.height,
                                                                            width:
                                                                                m.dimensions?.width,
                                                                            blurHash:
                                                                                m.blurHash,
                                                                          ))
                                                                      .toList();
                                                            } finally {
                                                              _model.isDataUploading3 =
                                                                  false;
                                                            }
                                                            if (selectedUploadedFiles
                                                                    .length ==
                                                                selectedMedia
                                                                    .length) {
                                                              safeSetState(() {
                                                                _model.uploadedLocalFile3 =
                                                                    selectedUploadedFiles
                                                                        .first;
                                                              });
                                                            } else {
                                                              safeSetState(
                                                                  () {});
                                                              return;
                                                            }
                                                          }
                                                        } on SocketException {
                                                          showErrorToast(
                                                              context,
                                                              'Ingen internettforbindelse');
                                                        } catch (e) {
                                                          showErrorToast(
                                                              context,
                                                              'En feil oppstod');
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0.0, 0.0, 10.0, 0.0),
                                                  child: Stack(
                                                    alignment:
                                                        const AlignmentDirectional(
                                                            1.0, -1.0),
                                                    children: [
                                                      if (widget.matinfo !=
                                                              null &&
                                                          matvare.imgUrls![3]
                                                              .isNotEmpty)
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  0.0, 0.0),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            child:
                                                                Image.network(
                                                              '${ApiConstants.baseUrl}${matvare.imgUrls![3]}',
                                                              width: 100.0,
                                                              height: 100.0,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      if (widget.matinfo !=
                                                              null &&
                                                          matvare.imgUrls![3]
                                                              .isNotEmpty)
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  1.22, -1.2),
                                                          child:
                                                              FlutterFlowIconButton(
                                                            borderRadius: 100.0,
                                                            buttonSize: 29.0,
                                                            fillColor:
                                                                const Color(
                                                                    0xB3262C2D),
                                                            icon: FaIcon(
                                                              FontAwesomeIcons
                                                                  .times,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondary,
                                                              size: 16.0,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              try {
                                                                matvare.imgUrls![
                                                                    3] = '';
                                                                safeSetState(
                                                                    () {});
                                                              } on SocketException {
                                                                showErrorToast(
                                                                    context,
                                                                    'Ingen internettforbindelse');
                                                              } catch (e) {
                                                                showErrorToast(
                                                                    context,
                                                                    'En feil oppstod');
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      if ((_model
                                                              .uploadedLocalFile4
                                                              .bytes
                                                              ?.isNotEmpty ??
                                                          false))
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  0.0, 0.0),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            child: Image.memory(
                                                              _model.uploadedLocalFile4
                                                                      .bytes ??
                                                                  Uint8List
                                                                      .fromList(
                                                                          []),
                                                              width: 100.0,
                                                              height: 100.0,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      if ((_model
                                                              .uploadedLocalFile4
                                                              .bytes
                                                              ?.isNotEmpty ??
                                                          false))
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  1.22, -1.2),
                                                          child:
                                                              FlutterFlowIconButton(
                                                            borderColor: Colors
                                                                .transparent,
                                                            borderRadius: 100.0,
                                                            buttonSize: 29.0,
                                                            fillColor:
                                                                const Color(
                                                                    0xB3262C2D),
                                                            icon: FaIcon(
                                                              FontAwesomeIcons
                                                                  .times,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondary,
                                                              size: 16.0,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              try {
                                                                safeSetState(
                                                                    () {
                                                                  _model.isDataUploading4 =
                                                                      false;
                                                                  _model.uploadedLocalFile4 =
                                                                      FFUploadedFile(
                                                                          bytes:
                                                                              Uint8List.fromList([]));
                                                                });
                                                              } on SocketException {
                                                                showErrorToast(
                                                                    context,
                                                                    'Ingen internettforbindelse');
                                                              } catch (e) {
                                                                showErrorToast(
                                                                    context,
                                                                    'En feil oppstod');
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                if ((_model.uploadedLocalFile4
                                                            .bytes?.isEmpty ??
                                                        true) &&
                                                    (matvare
                                                        .imgUrls![3].isEmpty))
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(8.0, 0.0,
                                                            0.0, 12.0),
                                                    child:
                                                        FlutterFlowIconButton(
                                                      borderColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      borderRadius: 15.0,
                                                      buttonSize: 92.0,
                                                      fillColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      icon: Icon(
                                                        CupertinoIcons.camera,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        size: 27.0,
                                                      ),
                                                      onPressed: () async {
                                                        try {
                                                          final selectedMedia =
                                                              await selectMediaWithSourceBottomSheet(
                                                            context: context,
                                                            maxWidth: 500.00,
                                                            maxHeight: 500.00,
                                                            allowPhoto: true,
                                                          );
                                                          if (selectedMedia !=
                                                                  null &&
                                                              selectedMedia.every((m) =>
                                                                  validateFileFormat(
                                                                      m.storagePath,
                                                                      context))) {
                                                            safeSetState(() =>
                                                                _model.isDataUploading4 =
                                                                    true);
                                                            var selectedUploadedFiles =
                                                                <FFUploadedFile>[];

                                                            try {
                                                              selectedUploadedFiles =
                                                                  selectedMedia
                                                                      .map((m) =>
                                                                          FFUploadedFile(
                                                                            name:
                                                                                m.storagePath.split('/').last,
                                                                            bytes:
                                                                                m.bytes,
                                                                            height:
                                                                                m.dimensions?.height,
                                                                            width:
                                                                                m.dimensions?.width,
                                                                            blurHash:
                                                                                m.blurHash,
                                                                          ))
                                                                      .toList();
                                                            } finally {
                                                              _model.isDataUploading4 =
                                                                  false;
                                                            }
                                                            if (selectedUploadedFiles
                                                                    .length ==
                                                                selectedMedia
                                                                    .length) {
                                                              safeSetState(() {
                                                                _model.uploadedLocalFile4 =
                                                                    selectedUploadedFiles
                                                                        .first;
                                                              });
                                                            } else {
                                                              safeSetState(
                                                                  () {});
                                                              return;
                                                            }
                                                          }
                                                        } on SocketException {
                                                          showErrorToast(
                                                              context,
                                                              'Ingen internettforbindelse');
                                                        } catch (e) {
                                                          showErrorToast(
                                                              context,
                                                              'En feil oppstod');
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0.0, 0.0, 10.0, 0.0),
                                                  child: Stack(
                                                    alignment:
                                                        const AlignmentDirectional(
                                                            1.0, -1.0),
                                                    children: [
                                                      if (widget.matinfo !=
                                                              null &&
                                                          matvare.imgUrls![4]
                                                              .isNotEmpty)
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  0.0, 0.0),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            child:
                                                                Image.network(
                                                              '${ApiConstants.baseUrl}${matvare.imgUrls![4]}',
                                                              width: 100.0,
                                                              height: 100.0,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      if (widget.matinfo !=
                                                              null &&
                                                          matvare.imgUrls![4]
                                                              .isNotEmpty)
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  1.22, -1.2),
                                                          child:
                                                              FlutterFlowIconButton(
                                                            borderRadius: 100.0,
                                                            buttonSize: 29.0,
                                                            fillColor:
                                                                const Color(
                                                                    0xB3262C2D),
                                                            icon: FaIcon(
                                                              FontAwesomeIcons
                                                                  .times,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondary,
                                                              size: 16.0,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              try {
                                                                matvare.imgUrls![
                                                                    4] = '';
                                                                safeSetState(
                                                                    () {});
                                                              } on SocketException {
                                                                showErrorToast(
                                                                    context,
                                                                    'Ingen internettforbindelse');
                                                              } catch (e) {
                                                                showErrorToast(
                                                                    context,
                                                                    'En feil oppstod');
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      if ((_model
                                                              .uploadedLocalFile5
                                                              .bytes
                                                              ?.isNotEmpty ??
                                                          false))
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  0.0, 0.0),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            child: Image.memory(
                                                              _model.uploadedLocalFile5
                                                                      .bytes ??
                                                                  Uint8List
                                                                      .fromList(
                                                                          []),
                                                              width: 100.0,
                                                              height: 100.0,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      if ((_model
                                                              .uploadedLocalFile5
                                                              .bytes
                                                              ?.isNotEmpty ??
                                                          false))
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  1.22, -1.2),
                                                          child:
                                                              FlutterFlowIconButton(
                                                            borderColor: Colors
                                                                .transparent,
                                                            borderRadius: 100.0,
                                                            buttonSize: 29.0,
                                                            fillColor:
                                                                const Color(
                                                                    0xB3262C2D),
                                                            icon: FaIcon(
                                                              FontAwesomeIcons
                                                                  .times,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondary,
                                                              size: 16.0,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              try {
                                                                safeSetState(
                                                                    () {
                                                                  _model.isDataUploading5 =
                                                                      false;
                                                                  _model.uploadedLocalFile5 =
                                                                      FFUploadedFile(
                                                                          bytes:
                                                                              Uint8List.fromList([]));
                                                                });
                                                              } on SocketException {
                                                                showErrorToast(
                                                                    context,
                                                                    'Ingen internettforbindelse');
                                                              } catch (e) {
                                                                showErrorToast(
                                                                    context,
                                                                    'En feil oppstod');
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                if ((_model.uploadedLocalFile5
                                                            .bytes?.isEmpty ??
                                                        true) &&
                                                    (matvare
                                                        .imgUrls![4].isEmpty))
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(8.0, 0.0,
                                                            20.0, 12.0),
                                                    child:
                                                        FlutterFlowIconButton(
                                                      borderColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      borderRadius: 15.0,
                                                      buttonSize: 92.0,
                                                      fillColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      icon: Icon(
                                                        CupertinoIcons.camera,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        size: 27.0,
                                                      ),
                                                      onPressed: () async {
                                                        try {
                                                          final selectedMedia =
                                                              await selectMediaWithSourceBottomSheet(
                                                            context: context,
                                                            maxWidth: 500.00,
                                                            maxHeight: 500.00,
                                                            allowPhoto: true,
                                                          );
                                                          if (selectedMedia !=
                                                                  null &&
                                                              selectedMedia.every((m) =>
                                                                  validateFileFormat(
                                                                      m.storagePath,
                                                                      context))) {
                                                            safeSetState(() =>
                                                                _model.isDataUploading5 =
                                                                    true);
                                                            var selectedUploadedFiles =
                                                                <FFUploadedFile>[];

                                                            try {
                                                              selectedUploadedFiles =
                                                                  selectedMedia
                                                                      .map((m) =>
                                                                          FFUploadedFile(
                                                                            name:
                                                                                m.storagePath.split('/').last,
                                                                            bytes:
                                                                                m.bytes,
                                                                            height:
                                                                                m.dimensions?.height,
                                                                            width:
                                                                                m.dimensions?.width,
                                                                            blurHash:
                                                                                m.blurHash,
                                                                          ))
                                                                      .toList();
                                                            } finally {
                                                              _model.isDataUploading5 =
                                                                  false;
                                                            }
                                                            if (selectedUploadedFiles
                                                                    .length ==
                                                                selectedMedia
                                                                    .length) {
                                                              safeSetState(() {
                                                                _model.uploadedLocalFile5 =
                                                                    selectedUploadedFiles
                                                                        .first;
                                                              });
                                                            } else {
                                                              safeSetState(
                                                                  () {});
                                                              return;
                                                            }
                                                          }
                                                        } on SocketException {
                                                          showErrorToast(
                                                              context,
                                                              'Ingen internettforbindelse');
                                                        } catch (e) {
                                                          showErrorToast(
                                                              context,
                                                              'En feil oppstod');
                                                        }
                                                      },
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 1.2,
                                            indent: 30,
                                            endIndent: 30,
                                            color: Color.fromRGBO(
                                                234, 234, 234, 0.898),
                                          ),
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                    -1.0, 0.0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      20.0, 20.0, 0.0, 10.0),
                                              child: Text(
                                                'Hva skal du selge?',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 18.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(
                                                20.0, 0.0, 20.0, 16.0),
                                            child: TextFormField(
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              controller: _model
                                                  .produktNavnTextController,
                                              focusNode:
                                                  _model.produktNavnFocusNode,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                labelText: 'Tittel',
                                                labelStyle: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Nunito',
                                                      color:
                                                          const Color.fromRGBO(
                                                              113,
                                                              113,
                                                              113,
                                                              1.0),
                                                      fontSize: 17.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                hintStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          letterSpacing: 0.0,
                                                        ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondary,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                filled: true,
                                                fillColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                contentPadding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        20.0, 15.0, 0.0, 24.0),
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Nunito',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontSize: 16,
                                                        letterSpacing: 0.0,
                                                      ),
                                              maxLength: 24,
                                              maxLengthEnforcement:
                                                  MaxLengthEnforcement.enforced,
                                              buildCounter: (context,
                                                      {required currentLength,
                                                      required isFocused,
                                                      maxLength}) =>
                                                  null,
                                              validator: _model
                                                  .produktNavnTextControllerValidator
                                                  .asValidator(context),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              try {
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                                String? velgkategori =
                                                    await showModalBottomSheet<
                                                        String>(
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  barrierColor:
                                                      const Color.fromARGB(
                                                          60, 17, 0, 0),
                                                  context: context,
                                                  builder: (context) {
                                                    return GestureDetector(
                                                      onTap: () =>
                                                          FocusScope.of(context)
                                                              .unfocus(),
                                                      child: Padding(
                                                        padding: MediaQuery
                                                            .viewInsetsOf(
                                                                context),
                                                        child:
                                                            VelgKategoriWidget(
                                                                kategori:
                                                                    kategori),
                                                      ),
                                                    );
                                                  },
                                                );

                                                setState(() {
                                                  if (velgkategori != null) {
                                                    kategori = velgkategori;
                                                    isFocused = true;
                                                  }
                                                });
                                              } catch (e) {
                                                showErrorToast(
                                                    context, 'En feil oppstod');
                                              }
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 0, 20, 16),
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.sizeOf(
                                                            context)
                                                        .width,
                                                    height: 60,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      border: Border.all(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              CupertinoIcons
                                                                  .square_grid_2x2,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryText,
                                                              size: 25,
                                                            ),
                                                            const SizedBox(
                                                                width: 15),
                                                            Text(
                                                              kategori ??
                                                                  'kategori',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Nunito',
                                                                    color: kategori !=
                                                                            null
                                                                        ? FlutterFlowTheme.of(context)
                                                                            .primaryText
                                                                        : const Color
                                                                            .fromRGBO(
                                                                            113,
                                                                            113,
                                                                            113,
                                                                            1.0),
                                                                    fontSize:
                                                                        17.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                        Icon(
                                                          CupertinoIcons
                                                              .chevron_forward,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          size: 22,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (isFocused ||
                                                      kategori != null)
                                                    Positioned(
                                                      top: -10,
                                                      left: 18,
                                                      child: Container(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    4.0),
                                                        child: Text(
                                                          'kategori',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodySmall
                                                              .override(
                                                                fontFamily:
                                                                    'Nunito',
                                                                fontSize: 13.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: const Color
                                                                    .fromRGBO(
                                                                    113,
                                                                    113,
                                                                    113,
                                                                    1.0),
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 1.2,
                                            indent: 30,
                                            endIndent: 30,
                                            color: Color.fromRGBO(
                                                234, 234, 234, 0.898),
                                          ),
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                    -1.0, 0.0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      20.0, 20.0, 0.0, 5.0),
                                              child: Text(
                                                'Beskriv matvaren',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 18.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                    -1.0, 0.0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      20.0, 0.0, 20.0, 10.0),
                                              child: Text(
                                                'Fortell litt om matvaren, hvor fersk er den, \ner maten fryst ned og mengde osv.',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 15.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(
                                                20.0, 0.0, 20.0, 16.0),
                                            child: TextFormField(
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              controller: _model
                                                  .produktBeskrivelseTextController,
                                              focusNode: _model
                                                  .produktBeskrivelseFocusNode,
                                              textCapitalization:
                                                  TextCapitalization.sentences,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                labelStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 14.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                hintText: 'Beskrivelse',
                                                hintStyle: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Nunito',
                                                      color:
                                                          const Color.fromRGBO(
                                                              113,
                                                              113,
                                                              113,
                                                              1.0),
                                                      fontSize: 17.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondary,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                filled: true,
                                                fillColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                contentPadding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        20.0, 15.0, 0.0, 24.0),
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Nunito',
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        letterSpacing: 0.0,
                                                      ),
                                              textAlign: TextAlign.start,
                                              minLines: 3,
                                              maxLines: 7,
                                              validator: _model
                                                  .produktBeskrivelseTextControllerValidator
                                                  .asValidator(context),
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    200),
                                                TextInputFormatter.withFunction(
                                                    (oldValue, newValue) {
                                                  final lineCount = '\n'
                                                          .allMatches(
                                                              newValue.text)
                                                          .length +
                                                      1;
                                                  if (lineCount > 7) {
                                                    return oldValue;
                                                  }
                                                  return newValue;
                                                }),
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 1.2,
                                            indent: 30,
                                            endIndent: 30,
                                            color: Color.fromRGBO(
                                                234, 234, 234, 0.898),
                                          ),
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                    -1.0, 0.0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      20.0, 20.0, 0.0, 10.0),
                                              child: Text(
                                                'Pris',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 18.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0.0, 0.0, 0.0, 16.0),
                                            child: Stack(
                                              alignment:
                                                  const AlignmentDirectional(
                                                      1.0, -0.3),
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          20.0, 0.0, 20.0, 0.0),
                                                  child: TextFormField(
                                                    controller: _model
                                                        .produktPrisSTKTextController,
                                                    focusNode: _model
                                                        .produktPrisSTKFocusNode,
                                                    onChanged: (_) =>
                                                        EasyDebounce.debounce(
                                                      '_model.produktPrisSTKTextController',
                                                      const Duration(
                                                          milliseconds: 300),
                                                      () => safeSetState(() {}),
                                                    ),
                                                    textCapitalization:
                                                        TextCapitalization.none,
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      labelText: 'Pris',
                                                      labelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Nunito',
                                                                color: const Color
                                                                    .fromRGBO(
                                                                    113,
                                                                    113,
                                                                    113,
                                                                    1.0),
                                                                fontSize: 17.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                      alignLabelWithHint: false,
                                                      hintStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Nunito',
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color:
                                                              Color(0x00000000),
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      filled: true,
                                                      fillColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      contentPadding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(20.0,
                                                              15.0, 0.0, 24.0),
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 17.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                    maxLength: 5,
                                                    maxLengthEnforcement:
                                                        MaxLengthEnforcement
                                                            .enforced,
                                                    buildCounter: (context,
                                                            {required currentLength,
                                                            required isFocused,
                                                            maxLength}) =>
                                                        null,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    validator: _model
                                                        .produktPrisSTKTextControllerValidator
                                                        .asValidator(context),
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(
                                                              RegExp('[0-9]'))
                                                    ],
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0.8, -0.19),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0, 8, 0, 0),
                                                    child: Text(
                                                      'NOK',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'Nunito',
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                            fontSize: 17.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 1.2,
                                            indent: 30,
                                            endIndent: 30,
                                            color: Color.fromRGBO(
                                                234, 234, 234, 0.898),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        -1.0, 0.0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(20.0, 20.0,
                                                          0.0, 10.0),
                                                  child: Text(
                                                    'Velg antall',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 18.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        -1.0, 0.0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          20.0, 0.0, 0.0, 0.0),
                                                  child: Text(
                                                    'Hvor mange pakker/stykk skal være tilgjengelig for kjøperen? Antallet justeres ned automatisk når noen kjøper',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 15.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 16.0, 0.0, 20.0),
                                                child: Stack(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          1.0, -0.3),
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          const AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                20.0,
                                                                0.0,
                                                                20.0,
                                                                16.0),
                                                        child: TextFormField(
                                                          autovalidateMode:
                                                              AutovalidateMode
                                                                  .onUserInteraction,
                                                          controller: _model
                                                              .antallStkTextController,
                                                          focusNode: _model
                                                              .antallStkFocusNode,
                                                          onChanged: (_) =>
                                                              EasyDebounce
                                                                  .debounce(
                                                            '_model.antallStkTextController',
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                            () => safeSetState(
                                                                () {}),
                                                          ),
                                                          textCapitalization:
                                                              TextCapitalization
                                                                  .none,
                                                          obscureText: false,
                                                          readOnly:
                                                              true, // Disable the keyboard
                                                          decoration:
                                                              InputDecoration(
                                                            labelText: 'Antall',
                                                            labelStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Nunito',
                                                                      color: const Color
                                                                          .fromRGBO(
                                                                          113,
                                                                          113,
                                                                          113,
                                                                          1.0),
                                                                      fontSize:
                                                                          17.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                    ),
                                                            alignLabelWithHint:
                                                                false,
                                                            hintText:
                                                                'Skriv inn antall',
                                                            hintStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Nunito',
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Color(
                                                                    0x00000000),
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary,
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                            errorBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .error,
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                            focusedErrorBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .error,
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                            filled: true,
                                                            fillColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary,
                                                            contentPadding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    20.0,
                                                                    15.0,
                                                                    0.0,
                                                                    24.0),
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Nunito',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontSize: 17.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                          maxLength: 5,
                                                          maxLengthEnforcement:
                                                              MaxLengthEnforcement
                                                                  .enforced,
                                                          buildCounter: (context,
                                                                  {required currentLength,
                                                                  required isFocused,
                                                                  maxLength}) =>
                                                              null,
                                                          keyboardType:
                                                              const TextInputType
                                                                  .numberWithOptions(
                                                                  decimal:
                                                                      true),
                                                          validator: _model
                                                              .antallStkTextControllerValidator
                                                              .asValidator(
                                                                  context),
                                                          onTap: () {
                                                            List<double>
                                                                getPickerValues() {
                                                              List<double>
                                                                  values = [];
                                                              double step;

                                                              step = 1.0;
                                                              for (double i =
                                                                      1.0;
                                                                  i <= 50;
                                                                  i += step) {
                                                                values.add(i);
                                                              }

                                                              return values;
                                                            }

                                                            showCupertinoModalPopup(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return CupertinoActionSheet(
                                                                  title: const Text(
                                                                      'Velg antall'),
                                                                  message:
                                                                      Column(
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            200, // Set a fixed height for the picker
                                                                        child:
                                                                            CupertinoPicker(
                                                                          itemExtent:
                                                                              32.0, // Height of each item
                                                                          scrollController:
                                                                              FixedExtentScrollController(
                                                                            initialItem:
                                                                                getPickerValues().indexOf(_selectedValue), // Set initial value
                                                                          ),
                                                                          onSelectedItemChanged:
                                                                              (index) {
                                                                            setState(() {
                                                                              _selectedValue = getPickerValues()[index];
                                                                              // Update the TextFormField value with the selected value
                                                                              _model.antallStkTextController.text = _selectedValue.toStringAsFixed(0);

                                                                              // Trigger light haptic feedback on each tick/value change
                                                                              HapticFeedback.lightImpact();
                                                                            });
                                                                          },
                                                                          children: getPickerValues()
                                                                              .map((value) => Center(
                                                                                    child: Text(value.toStringAsFixed(0)),
                                                                                  ))
                                                                              .toList(),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  cancelButton:
                                                                      CupertinoActionSheetAction(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: const Text(
                                                                        'Velg',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              19,
                                                                          color:
                                                                              CupertinoColors.systemBlue,
                                                                        )),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          const AlignmentDirectional(
                                                              0.8, -0.19),
                                                      child: Text(
                                                        'Stk',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontSize:
                                                                      17.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                      ),
                                                    ),
                                                    // if (_model.tabBarController!
                                                    //         .index !=
                                                    //     0)
                                                    //   Align(
                                                    //     alignment:
                                                    //         const AlignmentDirectional(
                                                    //             0.8, -0.19),
                                                    //     child: Text(
                                                    //       'Kg',
                                                    //       style: FlutterFlowTheme
                                                    //               .of(context)
                                                    //           .bodyMedium
                                                    //           .override(
                                                    //             fontFamily:
                                                    //                 'Nunito',
                                                    //             color: FlutterFlowTheme.of(
                                                    //                     context)
                                                    //                 .primaryText,
                                                    //             fontSize: 17.0,
                                                    //             letterSpacing:
                                                    //                 0.0,
                                                    //             fontWeight:
                                                    //                 FontWeight
                                                    //                     .w600,
                                                    //           ),
                                                    //     ),
                                                    //   ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Divider(
                                            thickness: 1.2,
                                            indent: 30,
                                            endIndent: 30,
                                            color: Color.fromRGBO(
                                                234, 234, 234, 0.898),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        -1.0, 0.0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(20.0, 20.0,
                                                          0.0, 10.0),
                                                  child: Text(
                                                    'Velg din posisjon',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 18.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        -1.0, 0.0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          20.0, 0.0, 0.0, 10.0),
                                                  child: Text(
                                                    'Andre vil ikke kunne se din nøyaktige posisjon.',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 15.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        -1, 0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          20, 0, 20, 16),
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      try {
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                FocusNode());

                                                        // Capture the returned LatLng from the modal bottom sheet
                                                        selectedLatLng =
                                                            await showModalBottomSheet<
                                                                LatLng>(
                                                          isScrollControlled:
                                                              true,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          barrierColor:
                                                              const Color
                                                                  .fromARGB(
                                                                  60, 17, 0, 0),
                                                          context: context,
                                                          builder: (context) {
                                                            return GestureDetector(
                                                              onTap: () =>
                                                                  FocusScope.of(
                                                                          context)
                                                                      .unfocus(),
                                                              child: Padding(
                                                                padding: MediaQuery
                                                                    .viewInsetsOf(
                                                                        context),
                                                                child:
                                                                    VelgPosWidget(
                                                                  currentLocation:
                                                                      currentselectedLatLng,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                        setState(() {
                                                          if (selectedLatLng ==
                                                              const LatLng(
                                                                  0, 0)) {
                                                            selectedLatLng =
                                                                null;
                                                          } else {
                                                            leggutgetKommune(
                                                                selectedLatLng
                                                                        ?.latitude ??
                                                                    0,
                                                                selectedLatLng
                                                                        ?.longitude ??
                                                                    0);
                                                            currentselectedLatLng =
                                                                selectedLatLng;
                                                            updateSelectedLatLng(
                                                                selectedLatLng);
                                                          }
                                                        });
                                                      } on SocketException {
                                                        showErrorToast(context,
                                                            'Ingen internettforbindelse');
                                                      } catch (e) {
                                                        showErrorToast(context,
                                                            'En feil oppstod');
                                                      }
                                                    },
                                                    child: Container(
                                                      width: MediaQuery.sizeOf(
                                                              context)
                                                          .width,
                                                      height: 60,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        border: Border.all(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary,
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                12, 0, 12, 0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Icon(
                                                                  CupertinoIcons
                                                                      .placemark,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  size: 25,
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          15,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    kommune !=
                                                                            null
                                                                        ? '$kommune'
                                                                        : 'Velg posisjon',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Nunito',
                                                                          color: kommune != null
                                                                              ? FlutterFlowTheme.of(context).primaryText
                                                                              : const Color.fromRGBO(113, 113, 113, 1.0),
                                                                          fontSize:
                                                                              17.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Icon(
                                                              CupertinoIcons
                                                                  .chevron_forward,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryText,
                                                              size: 22,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // if (selectedLatLng != null)
                                              //   Padding(
                                              //     padding:
                                              //         const EdgeInsetsDirectional
                                              //             .fromSTEB(
                                              //             30, 0, 30, 16),
                                              //     child: Stack(
                                              //       children: [
                                              //         // The map widget wrapped in a Container for consistent sizing
                                              //         Container(
                                              //           width:
                                              //               500, // Set this to the desired width
                                              //           height:
                                              //               200, // Set this to the desired height
                                              //           child: FFAppState()
                                              //                       .bonde ==
                                              //                   true
                                              //               ? custom_widgets
                                              //                   .MyOsmKartBedrift(
                                              //                   width:
                                              //                       500, // Using the same size
                                              //                   height: 200,
                                              //                   center: selectedLatLng ??
                                              //                       const LatLng(
                                              //                           58.940090,
                                              //                           11.634092),
                                              //                   matsted: selectedLatLng ??
                                              //                       const LatLng(
                                              //                           58.940090,
                                              //                           11.634092),
                                              //                 )
                                              //               : custom_widgets
                                              //                   .MyOsmKart(
                                              //                   width:
                                              //                       500, // Using the same size
                                              //                   height: 200,
                                              //                   center: selectedLatLng ??
                                              //                       const LatLng(
                                              //                           58.940090,
                                              //                           11.634092),
                                              //                 ),
                                              //         ),

                                              //         // Overlay to disable interactions
                                              //         Positioned.fill(
                                              //           child: GestureDetector(
                                              //             onTap:
                                              //                 () {}, // Consuming tap interactions
                                              //             onPanUpdate:
                                              //                 (_) {}, // Consuming drag interactions
                                              //             child: Container(
                                              //               color: Colors
                                              //                   .transparent, // Keeps the overlay invisible
                                              //             ),
                                              //           ),
                                              //         ),
                                              //       ],
                                              //     ),
                                              //   ),
                                            ],
                                          ),
                                          if (_model.checkboxValue == true)
                                            Align(
                                              alignment:
                                                  const AlignmentDirectional(
                                                      0.0, 0.05),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 20.0, 0.0, 50.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    try {
                                                      context.pushNamed(
                                                          'Utbetalingsinfo1');
                                                    } on SocketException {
                                                      showErrorToast(context,
                                                          'Ingen internettforbindelse');
                                                    } catch (e) {
                                                      showErrorToast(context,
                                                          'En feil oppstod');
                                                    }
                                                  },
                                                  text:
                                                      'Legg til utbetalingsinformasjon',
                                                  icon: const FaIcon(
                                                    FontAwesomeIcons
                                                        .solidCreditCard,
                                                    size: 20.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 320.0,
                                                    height: 40.0,
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                    iconPadding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondary,
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                    elevation: 0.0,
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          if (widget.rediger == false)
                                            Align(
                                              alignment:
                                                  const AlignmentDirectional(
                                                      0.0, 0.05),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        25.0, 40.0, 25.0, 30.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    try {
                                                      if (_model.formKey
                                                                  .currentState ==
                                                              null ||
                                                          !_model.formKey
                                                              .currentState!
                                                              .validate()) {
                                                        return;
                                                      }
                                                      if (_oppdaterLoading) {
                                                        return;
                                                      }
                                                      if ((_model.uploadedLocalFile1.bytes ?? []).isEmpty &&
                                                          (_model.uploadedLocalFile2
                                                                      .bytes ??
                                                                  [])
                                                              .isEmpty &&
                                                          (_model.uploadedLocalFile3
                                                                      .bytes ??
                                                                  [])
                                                              .isEmpty &&
                                                          (_model.uploadedLocalFile4
                                                                      .bytes ??
                                                                  [])
                                                              .isEmpty &&
                                                          (_model.uploadedLocalFile5
                                                                      .bytes ??
                                                                  [])
                                                              .isEmpty) {
                                                        await showDialog(
                                                          context: context,
                                                          builder:
                                                              (alertDialogContext) {
                                                            return CupertinoAlertDialog(
                                                              title: const Text(
                                                                  'Bilde mangler'),
                                                              content: const Text(
                                                                  'Last opp minst 1 bilde.'),
                                                              actions: [
                                                                CupertinoDialogAction(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          alertDialogContext),
                                                                  child:
                                                                      const Text(
                                                                          'Ok'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                        return;
                                                      }

                                                      if (kategori == null) {
                                                        await showDialog(
                                                          context: context,
                                                          builder:
                                                              (alertDialogContext) {
                                                            return CupertinoAlertDialog(
                                                              title: const Text(
                                                                  'Mangler kategori'),
                                                              content: const Text(
                                                                  'Velg minst 1 kategori.'),
                                                              actions: [
                                                                CupertinoDialogAction(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          alertDialogContext),
                                                                  child:
                                                                      const Text(
                                                                          'Ok'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                        return;
                                                      }

                                                      if (_model
                                                          .produktPrisSTKTextController
                                                          .text
                                                          .isEmpty) {
                                                        await showDialog(
                                                          context: context,
                                                          builder:
                                                              (alertDialogContext) {
                                                            return CupertinoAlertDialog(
                                                              title: const Text(
                                                                  'Velg pris'),
                                                              content: const Text(
                                                                  'Velg en pris på matvaren'),
                                                              actions: [
                                                                CupertinoDialogAction(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          alertDialogContext),
                                                                  child:
                                                                      const Text(
                                                                          'Ok'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                        return;
                                                      }

                                                      if (selectedLatLng ==
                                                          null) {
                                                        await showDialog(
                                                          context: context,
                                                          builder:
                                                              (alertDialogContext) {
                                                            return CupertinoAlertDialog(
                                                              title: const Text(
                                                                  'Velg posisjon'),
                                                              content: const Text(
                                                                  'Mangler posisjon'),
                                                              actions: [
                                                                CupertinoDialogAction(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          alertDialogContext),
                                                                  child:
                                                                      const Text(
                                                                          'Ok'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                        return null;
                                                      }

                                                      _oppdaterLoading = true;
                                                      final token =
                                                          await securestorage
                                                              .readToken();
                                                      if (token == null) {
                                                        FFAppState().login =
                                                            false;
                                                        context.pushNamed(
                                                            'registrer');
                                                      } else {
                                                        final List<Uint8List?>
                                                            filesData = [
                                                          _model
                                                              .uploadedLocalFile1
                                                              .bytes,
                                                          _model
                                                              .uploadedLocalFile2
                                                              .bytes,
                                                          _model
                                                              .uploadedLocalFile3
                                                              .bytes,
                                                          _model
                                                              .uploadedLocalFile4
                                                              .bytes,
                                                          _model
                                                              .uploadedLocalFile5
                                                              .bytes,
                                                        ];

                                                        final List<Uint8List>
                                                            filteredFilesData =
                                                            filesData
                                                                .where((file) =>
                                                                    file !=
                                                                        null &&
                                                                    file
                                                                        .isNotEmpty)
                                                                .cast<
                                                                    Uint8List>()
                                                                .toList();

                                                        final filelinks =
                                                            await apiMultiplePics
                                                                .uploadPictures(
                                                                    token:
                                                                        token,
                                                                    filesData:
                                                                        filteredFilesData);
                                                        String pris;
                                                        bool kg;

                                                        pris = _model
                                                            .produktPrisSTKTextController
                                                            .text;
                                                        kg = false;

                                                        _selectedValue = double
                                                            .parse(_selectedValue
                                                                .toStringAsFixed(
                                                                    2));
                                                        if (filelinks != null &&
                                                            filelinks
                                                                .isNotEmpty) {
                                                          final response =
                                                              await apiUploadFood
                                                                  .uploadfood(
                                                            token: token,
                                                            name: _model
                                                                .produktNavnTextController
                                                                .text,
                                                            imgUrl: filelinks,
                                                            description: _model
                                                                .produktBeskrivelseTextController
                                                                .text,
                                                            price: pris,
                                                            kategorier:
                                                                kategori,
                                                            posisjon:
                                                                selectedLatLng,
                                                            antall:
                                                                _selectedValue
                                                                    .toString(),
                                                            betaling: _model
                                                                .checkboxValue,
                                                            kg: kg,
                                                          );

                                                          if (response
                                                                  .statusCode ==
                                                              200) {
                                                            _oppdaterLoading =
                                                                false;
                                                            context.pushNamed(
                                                              'BrukerLagtUtInfo',
                                                              extra: <String,
                                                                  dynamic>{
                                                                kTransitionInfoKey:
                                                                    const TransitionInfo(
                                                                  hasTransition:
                                                                      true,
                                                                  transitionType:
                                                                      PageTransitionType
                                                                          .rightToLeft,
                                                                ),
                                                              },
                                                            );
                                                          }
                                                          if (response.statusCode == 401 ||
                                                              response.statusCode ==
                                                                  404 ||
                                                              response.statusCode ==
                                                                  500) {
                                                            _oppdaterLoading =
                                                                false;
                                                            FFAppState().login =
                                                                false;
                                                            context.pushNamed(
                                                                'registrer');
                                                            return;
                                                          }
                                                        } else {
                                                          _oppdaterLoading =
                                                              false;
                                                          throw (Exception);
                                                        }
                                                      }
                                                    } on SocketException {
                                                      showErrorToast(context,
                                                          'Ingen internettforbindelse');
                                                    } catch (e) {
                                                      showErrorToast(context,
                                                          'En feil oppstod');
                                                    }
                                                  },
                                                  text: 'Publiser',
                                                  options: FFButtonOptions(
                                                    width: double.infinity,
                                                    height: 50.0,
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                    iconPadding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary,
                                                          fontSize: 17.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                    elevation: 0.0,
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          if (widget.rediger == true)
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0.0, 0.05),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(25.0,
                                                            80.0, 25.0, 0.0),
                                                    child: FFButtonWidget(
                                                      onPressed: () async {
                                                        try {
                                                          if (_model.formKey
                                                                      .currentState ==
                                                                  null ||
                                                              !_model.formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                            return;
                                                          }
                                                          if (_leggUtLoading ==
                                                              true) {
                                                            return;
                                                          }
                                                          if (_model
                                                              .produktPrisSTKTextController
                                                              .text
                                                              .isEmpty) {
                                                            await showDialog(
                                                              context: context,
                                                              builder:
                                                                  (alertDialogContext) {
                                                                return CupertinoAlertDialog(
                                                                  title: const Text(
                                                                      'Velg pris'),
                                                                  content:
                                                                      const Text(
                                                                          'Velg en pris på matvaren'),
                                                                  actions: [
                                                                    CupertinoDialogAction(
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.pop(alertDialogContext),
                                                                      child: const Text(
                                                                          'Ok'),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                            return;
                                                          }

                                                          if (selectedLatLng ==
                                                              null) {
                                                            await showDialog(
                                                              context: context,
                                                              builder:
                                                                  (alertDialogContext) {
                                                                return CupertinoAlertDialog(
                                                                  title: const Text(
                                                                      'Velg posisjon'),
                                                                  content:
                                                                      const Text(
                                                                          'Mangler posisjon'),
                                                                  actions: [
                                                                    CupertinoDialogAction(
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.pop(alertDialogContext),
                                                                      child: const Text(
                                                                          'Ok'),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                            return null;
                                                          }
                                                          _leggUtLoading = true;
                                                          String? token =
                                                              await Securestorage()
                                                                  .readToken();
                                                          if (token == null) {
                                                            FFAppState().login =
                                                                false;
                                                            context.pushNamed(
                                                                'registrer');
                                                            return;
                                                          } else {
                                                            final List<
                                                                    Uint8List?>
                                                                filesData = [
                                                              _model
                                                                  .uploadedLocalFile1
                                                                  .bytes,
                                                              _model
                                                                  .uploadedLocalFile2
                                                                  .bytes,
                                                              _model
                                                                  .uploadedLocalFile3
                                                                  .bytes,
                                                              _model
                                                                  .uploadedLocalFile4
                                                                  .bytes,
                                                              _model
                                                                  .uploadedLocalFile5
                                                                  .bytes,
                                                            ];

                                                            final List<
                                                                    Uint8List>
                                                                filteredFilesData =
                                                                filesData
                                                                    .where((file) =>
                                                                        file !=
                                                                            null &&
                                                                        file
                                                                            .isNotEmpty)
                                                                    .cast<
                                                                        Uint8List>()
                                                                    .toList();

                                                            final filelinks =
                                                                await apiMultiplePics
                                                                    .uploadPictures(
                                                                        token:
                                                                            token,
                                                                        filesData:
                                                                            filteredFilesData);
                                                            final List<String>
                                                                combinedLinks =
                                                                [
                                                              ...matvare
                                                                  .imgUrls!
                                                                  .where((url) =>
                                                                      url.isNotEmpty) // Filters out both null and empty strings
                                                            ];

                                                            if (filelinks !=
                                                                    null &&
                                                                filelinks
                                                                    .isNotEmpty) {
                                                              combinedLinks
                                                                  .addAll(
                                                                      filelinks);
                                                            }

                                                            if (combinedLinks
                                                                .isEmpty) {
                                                              await showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (alertDialogContext) {
                                                                  return CupertinoAlertDialog(
                                                                    title: const Text(
                                                                        'Mangler bilder'),
                                                                    content:
                                                                        const Text(
                                                                            'Last opp minst 1 bilde'),
                                                                    actions: [
                                                                      CupertinoDialogAction(
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.pop(alertDialogContext),
                                                                        child: const Text(
                                                                            'Ok'),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                              return null;
                                                            }

                                                            String pris = _model
                                                                .produktPrisSTKTextController
                                                                .text;
                                                            bool kg =
                                                                false; // KG is disabled if STK is set

                                                            bool? kjopt;
                                                            _selectedValue =
                                                                double.parse(
                                                                    _selectedValue
                                                                        .toStringAsFixed(
                                                                            2));
                                                            if (_selectedValue ==
                                                                0.0) {
                                                              kjopt = true;
                                                            } else {
                                                              kjopt = false;
                                                            }
                                                            ApiUpdateFood
                                                                apiUpdateFood =
                                                                ApiUpdateFood();
                                                            final response =
                                                                await apiUpdateFood
                                                                    .updateFood(
                                                              token: token,
                                                              id: matvare.matId,
                                                              name: _model
                                                                  .produktNavnTextController
                                                                  .text,
                                                              imgUrl:
                                                                  combinedLinks,
                                                              description: _model
                                                                  .produktBeskrivelseTextController
                                                                  .text,
                                                              price: pris,
                                                              kategorier:
                                                                  kategori,
                                                              posisjon:
                                                                  selectedLatLng,
                                                              antall:
                                                                  _selectedValue
                                                                      .toString(),
                                                              betaling: _model
                                                                  .checkboxValue,
                                                              kg: kg,
                                                              kjopt: kjopt,
                                                            );

                                                            if (response
                                                                    .statusCode ==
                                                                200) {
                                                              setState(() {});
                                                              _leggUtLoading =
                                                                  false;
                                                              setState(() {});
                                                              Navigator.pop(
                                                                  context);
                                                              context.pushNamed(
                                                                  'Profil');
                                                            } else {
                                                              _leggUtLoading =
                                                                  false;
                                                            }
                                                            setState(() {});
                                                          }
                                                        } on SocketException {
                                                          showErrorToast(
                                                              context,
                                                              'Ingen internettforbindelse');
                                                        } catch (e) {
                                                          showErrorToast(
                                                              context,
                                                              'En feil oppstod');
                                                        }
                                                      },
                                                      text: 'Oppdater',
                                                      options: FFButtonOptions(
                                                        width: double.infinity,
                                                        height: 50.0,
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(0.0,
                                                                0.0, 0.0, 0.0),
                                                        iconPadding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(0.0,
                                                                0.0, 0.0, 0.0),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary,
                                                                  fontSize:
                                                                      17.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                ),
                                                        elevation: 0.0,
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ].addToEnd(
                                            const SizedBox(height: 30.0)),
                                      ),
                                    ),
                                  ),
                                ],
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
      ),
    );
  }
}
