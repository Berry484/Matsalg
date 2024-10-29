import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mat_salg/MyIP.dart';
import 'package:mat_salg/matvarer.dart';

import '/app_main/vanlig_bruker/legg_ut/velg_pos/velg_pos_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:mat_salg/ApiCalls.dart';
import 'package:mat_salg/SecureStorage.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
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
  late LeggUtMatvareModel _model;
  final FocusNode _hiddenFocusNode = FocusNode();
  late Matvarer matvare;

  final ApiCalls apiCalls = ApiCalls();

  final ApiUploadFood apiUploadFood = ApiUploadFood();
  final Securestorage securestorage = Securestorage();
  final ApiMultiplePics apiMultiplePics = ApiMultiplePics();

  LatLng? selectedLatLng;
  LatLng? currentselectedLatLng =
      (FFAppState().brukerLat != null && FFAppState().brukerLng != null)
          ? LatLng(FFAppState().brukerLat!, FFAppState().brukerLng!)
          : const LatLng(0, 0);
  bool test = true;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LeggUtMatvareModel());

    _model.produktNavnTextController ??= TextEditingController();
    _model.produktNavnFocusNode ??= FocusNode();

    _model.produktBeskrivelseTextController ??= TextEditingController();
    _model.produktBeskrivelseFocusNode ??= FocusNode();

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
    _model.produktPrisSTKTextController ??= TextEditingController();
    _model.produktPrisSTKFocusNode ??= FocusNode();

    _model.produktPrisKgTextController ??= TextEditingController();
    _model.produktPrisKgFocusNode ??= FocusNode();

    _model.antallStkTextController ??= TextEditingController();
    _model.antallStkFocusNode ??= FocusNode();
    _model.dropDownValueController ??= FormFieldController<String>(null);

    if (widget.matinfo != null) {
      matvare = Matvarer.fromJson1(widget.matinfo);

      while (matvare.imgUrls!.length <= 4) {
        matvare.imgUrls?.add(''); // Add empty string placeholders
      }
      _model.produktNavnTextController.text = matvare.name ?? '';
      _model.dropDownValueController!.value = matvare.kategorier!.first;
      _model.produktBeskrivelseTextController.text = matvare.description ?? '';
      if (matvare.antall.toString() == 'null') {
        _model.antallStkTextController.text = '0';
      } else {
        _model.antallStkTextController.text = matvare.antall.toString();
      }
      if (matvare.kg == true) {
        _model.tabBarController!.index = 1;
        _model.produktPrisKgTextController.text = matvare.price.toString();
      } else {
        _model.produktPrisSTKTextController.text = matvare.price.toString();
      }
      selectedLatLng = LatLng(matvare.lat ?? 0, matvare.lng ?? 0);
    } else {
      matvare = Matvarer.fromJson1({'imgUrl': []});
      while (matvare.imgUrls!.length <= 4) {
        matvare.imgUrls?.add('');
      }
    }
  }

  void updateSelectedLatLng(LatLng? newLatLng) {
    setState(() {
      selectedLatLng = null;
    });

    Timer(const Duration(milliseconds: 100), () {
      setState(() {
        selectedLatLng = newLatLng;
      });
    });
  }

  @override
  void dispose() {
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
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
            automaticallyImplyLeading: true,
            leading: Align(
              alignment: AlignmentDirectional(0, 0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(9, 0, 0, 0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.safePop();
                  },
                  child: Text(
                    'Avbryt',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Open Sans',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 14,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
            title: Text(
              'Ny matvare',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Montserrat',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 20.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            actions: const [],
            centerTitle: true,
            elevation: 0.0,
          ),
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
                            SingleChildScrollView(
                              primary: false,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Form(
                                    key: _model.formKey,
                                    autovalidateMode: AutovalidateMode.disabled,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                    0.0, 0.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0.0, 80.0, 0.0, 2.0),
                                                  child: Text(
                                                    'Legg til bilde av matvaren',
                                                    textAlign: TextAlign.start,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Open Sans',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 17.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0.0, 0.0, 0.0, 30.0),
                                                  child: Text(
                                                    'Last opp minst 3 bilder',
                                                    textAlign: TextAlign.start,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Open Sans',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 13.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                  ),
                                                ),
                                              ],
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
                                                            10.0, 20.0),
                                                    child:
                                                        FlutterFlowIconButton(
                                                      borderColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      borderRadius: 10.0,
                                                      buttonSize: 100.0,
                                                      fillColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      icon: Icon(
                                                        Icons
                                                            .photo_camera_outlined,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        size: 30.0,
                                                      ),
                                                      onPressed: () async {
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
                                                                          name: m
                                                                              .storagePath
                                                                              .split('/')
                                                                              .last,
                                                                          bytes:
                                                                              m.bytes,
                                                                          height: m
                                                                              .dimensions
                                                                              ?.height,
                                                                          width: m
                                                                              .dimensions
                                                                              ?.width,
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
                                                            safeSetState(() {});
                                                            return;
                                                          }
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
                                                                  left: 20.0),
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
                                                              matvare.imgUrls![
                                                                  0] = '';
                                                              safeSetState(
                                                                  () {});
                                                            },
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
                                                                  0.0, 0.0),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            child: Image.memory(
                                                              _model.uploadedLocalFile1
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
                                                              safeSetState(() {
                                                                _model.isDataUploading1 =
                                                                    false;
                                                                _model.uploadedLocalFile1 =
                                                                    FFUploadedFile(
                                                                        bytes: Uint8List.fromList(
                                                                            []));
                                                              });
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
                                                              matvare.imgUrls![
                                                                  1] = '';
                                                              safeSetState(
                                                                  () {});
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
                                                              safeSetState(() {
                                                                _model.isDataUploading2 =
                                                                    false;
                                                                _model.uploadedLocalFile2 =
                                                                    FFUploadedFile(
                                                                        bytes: Uint8List.fromList(
                                                                            []));
                                                              });
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
                                                            10.0, 20.0),
                                                    child:
                                                        FlutterFlowIconButton(
                                                      borderColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      borderRadius: 10.0,
                                                      buttonSize: 100.0,
                                                      fillColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      icon: Icon(
                                                        Icons
                                                            .photo_camera_outlined,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        size: 30.0,
                                                      ),
                                                      onPressed: () async {
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
                                                                          name: m
                                                                              .storagePath
                                                                              .split('/')
                                                                              .last,
                                                                          bytes:
                                                                              m.bytes,
                                                                          height: m
                                                                              .dimensions
                                                                              ?.height,
                                                                          width: m
                                                                              .dimensions
                                                                              ?.width,
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
                                                            safeSetState(() {});
                                                            return;
                                                          }
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
                                                              matvare.imgUrls![
                                                                  2] = '';
                                                              safeSetState(
                                                                  () {});
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
                                                              safeSetState(() {
                                                                _model.isDataUploading3 =
                                                                    false;
                                                                _model.uploadedLocalFile3 =
                                                                    FFUploadedFile(
                                                                        bytes: Uint8List.fromList(
                                                                            []));
                                                              });
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
                                                            .fromSTEB(0.0, 0.0,
                                                            10.0, 20.0),
                                                    child:
                                                        FlutterFlowIconButton(
                                                      borderColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      borderRadius: 10.0,
                                                      buttonSize: 100.0,
                                                      fillColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      icon: Icon(
                                                        Icons
                                                            .photo_camera_outlined,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        size: 30.0,
                                                      ),
                                                      onPressed: () async {
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
                                                                          name: m
                                                                              .storagePath
                                                                              .split('/')
                                                                              .last,
                                                                          bytes:
                                                                              m.bytes,
                                                                          height: m
                                                                              .dimensions
                                                                              ?.height,
                                                                          width: m
                                                                              .dimensions
                                                                              ?.width,
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
                                                            safeSetState(() {});
                                                            return;
                                                          }
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
                                                              matvare.imgUrls![
                                                                  3] = '';
                                                              safeSetState(
                                                                  () {});
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
                                                              safeSetState(() {
                                                                _model.isDataUploading4 =
                                                                    false;
                                                                _model.uploadedLocalFile4 =
                                                                    FFUploadedFile(
                                                                        bytes: Uint8List.fromList(
                                                                            []));
                                                              });
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
                                                            .fromSTEB(0.0, 0.0,
                                                            10.0, 20.0),
                                                    child:
                                                        FlutterFlowIconButton(
                                                      borderColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      borderRadius: 10.0,
                                                      buttonSize: 100.0,
                                                      fillColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      icon: Icon(
                                                        Icons
                                                            .photo_camera_outlined,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        size: 30.0,
                                                      ),
                                                      onPressed: () async {
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
                                                                          name: m
                                                                              .storagePath
                                                                              .split('/')
                                                                              .last,
                                                                          bytes:
                                                                              m.bytes,
                                                                          height: m
                                                                              .dimensions
                                                                              ?.height,
                                                                          width: m
                                                                              .dimensions
                                                                              ?.width,
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
                                                            safeSetState(() {});
                                                            return;
                                                          }
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
                                                              matvare.imgUrls![
                                                                  4] = '';
                                                              safeSetState(
                                                                  () {});
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
                                                              safeSetState(() {
                                                                _model.isDataUploading5 =
                                                                    false;
                                                                _model.uploadedLocalFile5 =
                                                                    FFUploadedFile(
                                                                        bytes: Uint8List.fromList(
                                                                            []));
                                                              });
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
                                                            .fromSTEB(0.0, 0.0,
                                                            20.0, 20.0),
                                                    child:
                                                        FlutterFlowIconButton(
                                                      borderColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      borderRadius: 10.0,
                                                      buttonSize: 100.0,
                                                      fillColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      icon: Icon(
                                                        Icons
                                                            .photo_camera_outlined,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        size: 30.0,
                                                      ),
                                                      onPressed: () async {
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
                                                                          name: m
                                                                              .storagePath
                                                                              .split('/')
                                                                              .last,
                                                                          bytes:
                                                                              m.bytes,
                                                                          height: m
                                                                              .dimensions
                                                                              ?.height,
                                                                          width: m
                                                                              .dimensions
                                                                              ?.width,
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
                                                            safeSetState(() {});
                                                            return;
                                                          }
                                                        }
                                                      },
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 1.0,
                                            indent: 30.0,
                                            endIndent: 30.0,
                                            color: Color(0x62757575),
                                          ),
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                    -1.0, 0.0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      20.0, 50.0, 0.0, 10.0),
                                              child: Text(
                                                'Hva skal du selge?',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Open Sans',
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      fontSize: 17.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(
                                                20.0, 0.0, 20.0, 20.0),
                                            child: TextFormField(
                                              controller: _model
                                                  .produktNavnTextController,
                                              focusNode:
                                                  _model.produktNavnFocusNode,
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                labelText: 'Tittel',
                                                labelStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Open Sans',
                                                          fontSize: 14.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                hintStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              'Open Sans',
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
                                                        20.0, 24.0, 0.0, 24.0),
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Open Sans',
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                              maxLength: 16,
                                              maxLengthEnforcement:
                                                  MaxLengthEnforcement.enforced,
                                              validator: _model
                                                  .produktNavnTextControllerValidator
                                                  .asValidator(context),
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 1.0,
                                            indent: 30.0,
                                            endIndent: 30.0,
                                            color: Color(0x62757575),
                                          ),
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                    -1.0, 0.0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      20.0, 50.0, 0.0, 10.0),
                                              child: Text(
                                                'Velg Kategori',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Open Sans',
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      fontSize: 17.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                AlignmentDirectional(-1, 0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(20, 0, 20, 40),
                                              child:
                                                  FlutterFlowDropDown<String>(
                                                controller: _model
                                                        .dropDownValueController ??=
                                                    FormFieldController<String>(
                                                        null),
                                                options: const [
                                                  'kjøtt',
                                                  'Grønnt',
                                                  'Meieri',
                                                  'Sjømat',
                                                  'Bakverk'
                                                ],
                                                onChanged: (val) =>
                                                    safeSetState(() => _model
                                                        .dropDownValue = val),
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                        .width,
                                                height: 60,
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Open Sans',
                                                          fontSize: 14.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                hintText: 'Kategori',
                                                icon: Icon(
                                                  Icons
                                                      .keyboard_arrow_down_rounded,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  size: 23,
                                                ),
                                                fillColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                elevation: 6,
                                                borderColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                borderWidth: 1,
                                                borderRadius: 8,
                                                margin: EdgeInsetsDirectional
                                                    .fromSTEB(12, 0, 12, 0),
                                                hidesUnderline: true,
                                                isOverButton: false,
                                                isSearchable: false,
                                                isMultiSelect: false,
                                              ),
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 1.0,
                                            indent: 30.0,
                                            endIndent: 30.0,
                                            color: Color(0x62757575),
                                          ),
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                    -1.0, 0.0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      20.0, 50.0, 0.0, 5.0),
                                              child: Text(
                                                'Beskriv matvaren',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Open Sans',
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      fontSize: 17.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                'Fortell litt om matvaren, hvor fersk er den, er maten fryst ned og mengde osv.',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Open Sans',
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      fontSize: 13.0,
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
                                                20.0, 0.0, 20.0, 40.0),
                                            child: TextFormField(
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
                                                          fontFamily:
                                                              'Open Sans',
                                                          fontSize: 14.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                hintText: 'Beskrivelse',
                                                hintStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              'Open Sans',
                                                          fontSize: 13.0,
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
                                                        20.0, 24.0, 0.0, 24.0),
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Open Sans',
                                                        letterSpacing: 0.0,
                                                      ),
                                              textAlign: TextAlign.start,
                                              maxLines: 3,
                                              maxLength: 200,
                                              maxLengthEnforcement:
                                                  MaxLengthEnforcement.enforced,
                                              validator: _model
                                                  .produktBeskrivelseTextControllerValidator
                                                  .asValidator(context),
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 1.0,
                                            indent: 30.0,
                                            endIndent: 30.0,
                                            color: Color(0x62757575),
                                          ),
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                    -1.0, 0.0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      20.0, 30.0, 0.0, 10.0),
                                              child: Text(
                                                'Pris',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Open Sans',
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      fontSize: 17.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 325.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                            ),
                                            child: Column(
                                              children: [
                                                Align(
                                                  alignment:
                                                      const Alignment(0.0, 0),
                                                  child: TabBar(
                                                    dividerColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .primary,
                                                    labelColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .alternate,
                                                    unselectedLabelColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .secondaryText,
                                                    labelStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleMedium
                                                        .override(
                                                          fontFamily:
                                                              'Open Sans',
                                                          fontSize: 17.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                    unselectedLabelStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Open Sans',
                                                              letterSpacing:
                                                                  0.0,
                                                            ),
                                                    indicatorColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .primaryText,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    tabs: const [
                                                      Tab(
                                                        text: 'Pris pr stk',
                                                      ),
                                                      Tab(
                                                        text: 'pris pr kg',
                                                      ),
                                                    ],
                                                    controller:
                                                        _model.tabBarController,
                                                    onTap: (i) async {
                                                      [
                                                        () async {
                                                          safeSetState(() {
                                                            _model
                                                                .produktPrisKgTextController
                                                                ?.clear();
                                                            _model
                                                                .antallStkTextController
                                                                ?.clear();
                                                          });
                                                        },
                                                        () async {
                                                          safeSetState(() {
                                                            _model
                                                                .produktPrisSTKTextController
                                                                ?.clear();
                                                            _model
                                                                .antallStkTextController
                                                                ?.clear();
                                                          });
                                                        }
                                                      ][i]();
                                                    },
                                                  ),
                                                ),
                                                Expanded(
                                                  child: TabBarView(
                                                    controller:
                                                        _model.tabBarController,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    children: [
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    -1.0, 0.0),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          20.0,
                                                                          30.0,
                                                                          0.0,
                                                                          5.0),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    0.0,
                                                                    20.0),
                                                            child: Stack(
                                                              alignment:
                                                                  const AlignmentDirectional(
                                                                      1.0,
                                                                      -0.3),
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          20.0,
                                                                          0.0,
                                                                          20.0,
                                                                          20.0),
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        _model
                                                                            .produktPrisSTKTextController,
                                                                    focusNode:
                                                                        _model
                                                                            .produktPrisSTKFocusNode,
                                                                    onChanged: (_) =>
                                                                        EasyDebounce
                                                                            .debounce(
                                                                      '_model.produktPrisSTKTextController',
                                                                      const Duration(
                                                                          milliseconds:
                                                                              300),
                                                                      () => safeSetState(
                                                                          () {}),
                                                                    ),
                                                                    textCapitalization:
                                                                        TextCapitalization
                                                                            .none,
                                                                    obscureText:
                                                                        false,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          'Pris',
                                                                      labelStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Open Sans',
                                                                            fontSize:
                                                                                14.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                      alignLabelWithHint:
                                                                          false,
                                                                      hintStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Open Sans',
                                                                            letterSpacing:
                                                                                0.0,
                                                                          ),
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            const BorderSide(
                                                                          color:
                                                                              Color(0x00000000),
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                      ),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondary,
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                      ),
                                                                      errorBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).error,
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                      ),
                                                                      focusedErrorBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).error,
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                      ),
                                                                      filled:
                                                                          true,
                                                                      fillColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .secondary,
                                                                      contentPadding: const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          20.0,
                                                                          24.0,
                                                                          0.0,
                                                                          24.0),
                                                                    ),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Open Sans',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          fontSize:
                                                                              17.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                    maxLength:
                                                                        5,
                                                                    maxLengthEnforcement:
                                                                        MaxLengthEnforcement
                                                                            .enforced,
                                                                    buildCounter: (context,
                                                                            {required currentLength,
                                                                            required isFocused,
                                                                            maxLength}) =>
                                                                        null,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    validator: _model
                                                                        .produktPrisSTKTextControllerValidator
                                                                        .asValidator(
                                                                            context),
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
                                                                          0.8,
                                                                          -0.19),
                                                                  child: Text(
                                                                    'NOK',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Open Sans',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          fontSize:
                                                                              17.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w600,
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
                                                                    40.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      const AlignmentDirectional(
                                                                          0.0,
                                                                          -1.0),
                                                                  child: Text(
                                                                    valueOrDefault<
                                                                        String>(
                                                                      _model
                                                                          .produktPrisSTKTextController
                                                                          .text,
                                                                      '0',
                                                                    ),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Open Sans',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          fontSize:
                                                                              17.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                  ),
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      const AlignmentDirectional(
                                                                          0.0,
                                                                          -1.0),
                                                                  child: Text(
                                                                    ' Kr  pr stk',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Open Sans',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          fontSize:
                                                                              17.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        20.0),
                                                                child: Stack(
                                                                  alignment:
                                                                      const AlignmentDirectional(
                                                                          1.0,
                                                                          -0.3),
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          20.0,
                                                                          30.0,
                                                                          20.0,
                                                                          0.0),
                                                                      child:
                                                                          TextFormField(
                                                                        controller:
                                                                            _model.produktPrisKgTextController,
                                                                        focusNode:
                                                                            _model.produktPrisKgFocusNode,
                                                                        onChanged:
                                                                            (_) =>
                                                                                EasyDebounce.debounce(
                                                                          '_model.produktPrisKgTextController',
                                                                          const Duration(
                                                                              milliseconds: 300),
                                                                          () =>
                                                                              safeSetState(() {}),
                                                                        ),
                                                                        textCapitalization:
                                                                            TextCapitalization.none,
                                                                        obscureText:
                                                                            false,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          labelText:
                                                                              'Pris',
                                                                          labelStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: 'Open Sans',
                                                                                fontSize: 14.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                          alignLabelWithHint:
                                                                              false,
                                                                          hintStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .override(
                                                                                fontFamily: 'Open Sans',
                                                                                letterSpacing: 0.0,
                                                                              ),
                                                                          enabledBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                const BorderSide(
                                                                              color: Color(0x00000000),
                                                                              width: 1.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          focusedBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: FlutterFlowTheme.of(context).secondary,
                                                                              width: 1.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          errorBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: FlutterFlowTheme.of(context).error,
                                                                              width: 1.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          focusedErrorBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: FlutterFlowTheme.of(context).error,
                                                                              width: 1.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          filled:
                                                                              true,
                                                                          fillColor:
                                                                              FlutterFlowTheme.of(context).secondary,
                                                                          contentPadding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              20.0,
                                                                              24.0,
                                                                              0.0,
                                                                              24.0),
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Open Sans',
                                                                              color: FlutterFlowTheme.of(context).primaryText,
                                                                              fontSize: 17.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                        maxLength:
                                                                            5,
                                                                        maxLengthEnforcement:
                                                                            MaxLengthEnforcement.enforced,
                                                                        buildCounter: (context,
                                                                                {required currentLength,
                                                                                required isFocused,
                                                                                maxLength}) =>
                                                                            null,
                                                                        keyboardType:
                                                                            TextInputType.number,
                                                                        validator: _model
                                                                            .produktPrisKgTextControllerValidator
                                                                            .asValidator(context),
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter.allow(
                                                                              RegExp('[0-9]'))
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          const AlignmentDirectional(
                                                                              0.8,
                                                                              -0.19),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            0.0,
                                                                            40.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Text(
                                                                          'NOK',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: 'Open Sans',
                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                fontSize: 17.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.w600,
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
                                                                        40.0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Align(
                                                                      alignment:
                                                                          const AlignmentDirectional(
                                                                              0.0,
                                                                              -1.0),
                                                                      child:
                                                                          Text(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          _model
                                                                              .produktPrisKgTextController
                                                                              .text,
                                                                          '0',
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Montserrat',
                                                                              color: FlutterFlowTheme.of(context).primaryText,
                                                                              fontSize: 17.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          const AlignmentDirectional(
                                                                              0.0,
                                                                              -1.0),
                                                                      child:
                                                                          Text(
                                                                        ' Kr pr kg',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Montserrat',
                                                                              color: FlutterFlowTheme.of(context).primaryText,
                                                                              fontSize: 17.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.bold,
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
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 1.0,
                                            indent: 30.0,
                                            endIndent: 30.0,
                                            color: Color(0x62757575),
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
                                                          .fromSTEB(20.0, 30.0,
                                                          0.0, 10.0),
                                                  child: Text(
                                                    'Velg antall',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Open Sans',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 17.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                    'hvor mye selger du av matvaren?',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Open Sans',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 13.0,
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
                                                        0.0, 50.0, 0.0, 20.0),
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
                                                                20.0),
                                                        child: TextFormField(
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
                                                          decoration:
                                                              InputDecoration(
                                                            labelText: 'Antall',
                                                            labelStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Open Sans',
                                                                      fontSize:
                                                                          14.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
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
                                                                          'Open Sans',
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
                                                                    24.0,
                                                                    0.0,
                                                                    24.0),
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Open Sans',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontSize: 17.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
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
                                                          keyboardType: _model
                                                                      .tabBarController!
                                                                      .index !=
                                                                  0
                                                              ? const TextInputType
                                                                  .numberWithOptions(
                                                                  decimal:
                                                                      true) // Enable decimal (.)
                                                              : TextInputType
                                                                  .number, // Regular number keyboard (no decimal)
                                                          validator: _model
                                                              .antallStkTextControllerValidator
                                                              .asValidator(
                                                                  context),
                                                          // Change input formatters based on index
                                                          inputFormatters: [
                                                            _model.tabBarController!
                                                                        .index !=
                                                                    0
                                                                ? DecimalInputFormatter() // Custom formatter for numbers and one dot
                                                                : FilteringTextInputFormatter
                                                                    .allow(RegExp(
                                                                        r'[0-9]')), // Allow only numbers
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    if (_model.tabBarController!
                                                            .index ==
                                                        0)
                                                      Align(
                                                        alignment:
                                                            const AlignmentDirectional(
                                                                0.8, -0.19),
                                                        child: Text(
                                                          'Stk',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Open Sans',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontSize: 17.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                        ),
                                                      ),
                                                    if (_model.tabBarController!
                                                            .index !=
                                                        0)
                                                      Align(
                                                        alignment:
                                                            const AlignmentDirectional(
                                                                0.8, -0.19),
                                                        child: Text(
                                                          'Kg',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Open Sans',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontSize: 17.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Divider(
                                            thickness: 1.0,
                                            indent: 30.0,
                                            endIndent: 30.0,
                                            color: Color(0x62757575),
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
                                                          .fromSTEB(20.0, 50.0,
                                                          0.0, 10.0),
                                                  child: Text(
                                                    'Velg din posisjon',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Open Sans',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 17.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                          fontFamily:
                                                              'Open Sans',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 13.0,
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
                                                        0.0, 0.05),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0.0, 24.0, 0.0, 80.0),
                                                  child: FFButtonWidget(
                                                    onPressed: () async {
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
                                                            Colors.transparent,
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
                                                          selectedLatLng = null;
                                                        } else {
                                                          currentselectedLatLng =
                                                              selectedLatLng;
                                                          updateSelectedLatLng(
                                                              selectedLatLng);
                                                        }
                                                      });
                                                    },
                                                    text: 'Velg posisjon',
                                                    options: FFButtonOptions(
                                                      width: 270.0,
                                                      height: 40.0,
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
                                                              .primary,
                                                      textStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Open Sans',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .alternate,
                                                                fontSize: 18.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                      elevation: 2.0,
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Colors.transparent,
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              if (selectedLatLng != null)
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(30, 0, 30, 80),
                                                  child: Stack(
                                                    children: [
                                                      // The map widget wrapped in a Container for consistent sizing
                                                      Container(
                                                        width:
                                                            500, // Set this to the desired width
                                                        height:
                                                            200, // Set this to the desired height
                                                        child: FFAppState()
                                                                    .bonde ==
                                                                true
                                                            ? custom_widgets
                                                                .MyOsmKartBedrift(
                                                                width:
                                                                    500, // Using the same size
                                                                height: 200,
                                                                center: selectedLatLng ??
                                                                    LatLng(
                                                                        58.940090,
                                                                        11.634092),
                                                                matsted: selectedLatLng ??
                                                                    LatLng(
                                                                        58.940090,
                                                                        11.634092),
                                                              )
                                                            : custom_widgets
                                                                .MyOsmKart(
                                                                width:
                                                                    500, // Using the same size
                                                                height: 200,
                                                                center: selectedLatLng ??
                                                                    LatLng(
                                                                        58.940090,
                                                                        11.634092),
                                                              ),
                                                      ),

                                                      // Overlay to disable interactions
                                                      Positioned.fill(
                                                        child: GestureDetector(
                                                          onTap:
                                                              () {}, // Consuming tap interactions
                                                          onPanUpdate:
                                                              (_) {}, // Consuming drag interactions
                                                          child: Container(
                                                            color: Colors
                                                                .transparent, // Keeps the overlay invisible
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
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
                                                        0.0, 24.0, 0.0, 50.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    context.pushNamed(
                                                        'Utbetalingsinfo1');
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
                                                          fontFamily:
                                                              'Open Sans',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                    elevation: 3.0,
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
                                          const Divider(
                                            thickness: 1.0,
                                            indent: 30.0,
                                            endIndent: 30.0,
                                            color: Color(0x62757575),
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
                                                        0.0, 70.0, 0.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    if (_model.formKey
                                                                .currentState ==
                                                            null ||
                                                        !_model.formKey
                                                            .currentState!
                                                            .validate()) {
                                                      return;
                                                    }
                                                    if ((_model.uploadedLocalFile1
                                                                .bytes ??
                                                            [])
                                                        .isEmpty) {
                                                      await showDialog(
                                                        context: context,
                                                        builder:
                                                            (alertDialogContext) {
                                                          return CupertinoAlertDialog(
                                                            title: const Text(
                                                                'Bilder mangler'),
                                                            content: const Text(
                                                                'Last opp minst 3 bilder.'),
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
                                                    if ((_model.uploadedLocalFile1
                                                                .bytes ??
                                                            [])
                                                        .isEmpty) {
                                                      await showDialog(
                                                        context: context,
                                                        builder:
                                                            (alertDialogContext) {
                                                          return CupertinoAlertDialog(
                                                            title: const Text(
                                                                'Bilder mangler'),
                                                            content: const Text(
                                                                'Last opp minst 3 bilder.'),
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

                                                    if ((_model.uploadedLocalFile2
                                                                .bytes ??
                                                            [])
                                                        .isEmpty) {
                                                      await showDialog(
                                                        context: context,
                                                        builder:
                                                            (alertDialogContext) {
                                                          return CupertinoAlertDialog(
                                                            title: const Text(
                                                                'Felt mangler'),
                                                            content: const Text(
                                                                'Last opp minst 3 bilder.'),
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

                                                    if ((_model.uploadedLocalFile3
                                                                .bytes ??
                                                            [])
                                                        .isEmpty) {
                                                      await showDialog(
                                                        context: context,
                                                        builder:
                                                            (alertDialogContext) {
                                                          return CupertinoAlertDialog(
                                                            title: const Text(
                                                                'Felt mangler'),
                                                            content: const Text(
                                                                'Last opp minst 3 bilder.'),
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

                                                    if (_model.dropDownValue ==
                                                        null) {
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

                                                    if (_model.tabBarCurrentIndex ==
                                                            0 &&
                                                        _model
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

                                                    if (_model.tabBarCurrentIndex !=
                                                            0 &&
                                                        _model
                                                            .produktPrisKgTextController
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
                                                      return null;
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

                                                    try {
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
                                                        if (_model
                                                            .produktPrisSTKTextController
                                                            .text
                                                            .isNotEmpty) {
                                                          // If STK is set, use its value and set KG to false
                                                          pris = _model
                                                              .produktPrisSTKTextController
                                                              .text;
                                                          kg =
                                                              false; // KG is disabled if STK is set
                                                        } else if (_model
                                                            .produktPrisKgTextController
                                                            .text
                                                            .isNotEmpty) {
                                                          // If STK is not set, use KG and set KG to true
                                                          pris = _model
                                                              .produktPrisKgTextController
                                                              .text;
                                                          kg =
                                                              true; // KG is enabled if STK is not set
                                                        } else {
                                                          // If neither is set, you can set a default value (empty string in this case)
                                                          pris = '';
                                                          kg =
                                                              true; // By default, KG is enabled if STK is not set
                                                        }
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
                                                            kategorier: _model
                                                                .dropDownValueController
                                                                ?.value,
                                                            posisjon:
                                                                selectedLatLng,
                                                            antall: _model
                                                                .antallStkTextController
                                                                .text,
                                                            betaling: _model
                                                                .checkboxValue,
                                                            kg: kg,
                                                          );

                                                          if (response
                                                                  .statusCode ==
                                                              200) {
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
                                                            FFAppState().login =
                                                                false;
                                                            context.pushNamed(
                                                                'registrer');
                                                            return;
                                                          }
                                                        } else {
                                                          throw (Exception);
                                                        }
                                                      }
                                                    } catch (e) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Oops, noe gikk galt'),
                                                            content: const Text(
                                                                'Sjekk internettforbindelsen din og prøv igjen.\nHvis problemet vedvarer, vennligst kontakt oss for hjelp.'),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child:
                                                                    Text('OK'),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(); // Close the dialog
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                                  text: 'Publiser',
                                                  icon: const FaIcon(
                                                    FontAwesomeIcons.check,
                                                    size: 20.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 220.0,
                                                    height: 45.0,
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
                                                          fontFamily:
                                                              'Open Sans',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary,
                                                          fontSize: 17.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                    elevation: 1.0,
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
                                                            .fromSTEB(0.0, 80.0,
                                                            0.0, 0.0),
                                                    child: FFButtonWidget(
                                                      onPressed: () async {
                                                        if (_model.formKey
                                                                    .currentState ==
                                                                null ||
                                                            !_model.formKey
                                                                .currentState!
                                                                .validate()) {
                                                          return;
                                                        }

                                                        if (_model.tabBarCurrentIndex ==
                                                                0 &&
                                                            _model
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

                                                        if (_model.tabBarCurrentIndex !=
                                                                0 &&
                                                            _model
                                                                .produktPrisKgTextController
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
                                                          return null;
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
                                                          final List<String>
                                                              combinedLinks = [
                                                            ...matvare.imgUrls!
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
                                                              context: context,
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
                                                          String pris;
                                                          bool kg;
                                                          if (_model
                                                              .produktPrisSTKTextController
                                                              .text
                                                              .isNotEmpty) {
                                                            pris = _model
                                                                .produktPrisSTKTextController
                                                                .text;
                                                            kg =
                                                                false; // KG is disabled if STK is set
                                                          } else if (_model
                                                              .produktPrisKgTextController
                                                              .text
                                                              .isNotEmpty) {
                                                            // If STK is not set, use KG and set KG to true
                                                            pris = _model
                                                                .produktPrisKgTextController
                                                                .text;
                                                            kg =
                                                                true; // KG is enabled if STK is not set
                                                          } else {
                                                            // If neither is set, you can set a default value (empty string in this case)
                                                            pris = '';
                                                            kg =
                                                                true; // By default, KG is enabled if STK is not set
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
                                                            kategorier: _model
                                                                .dropDownValueController
                                                                ?.value,
                                                            posisjon:
                                                                selectedLatLng,
                                                            antall: _model
                                                                .antallStkTextController
                                                                .text,
                                                            betaling: _model
                                                                .checkboxValue,
                                                            kg: kg,
                                                          );

                                                          if (response
                                                                  .statusCode ==
                                                              200) {
                                                            setState(() {});
                                                            print(
                                                                "this code ran??");
                                                            context.goNamed(
                                                              'Hjem',
                                                              extra: <String,
                                                                  dynamic>{
                                                                kTransitionInfoKey:
                                                                    const TransitionInfo(
                                                                  hasTransition:
                                                                      true,
                                                                  transitionType:
                                                                      PageTransitionType
                                                                          .fade,
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          0),
                                                                ),
                                                              },
                                                            );
                                                          } else {}
                                                          setState(() {});
                                                        }
                                                      },
                                                      text: 'Oppdater',
                                                      options: FFButtonOptions(
                                                        width: 170.0,
                                                        height: 45.0,
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
                                                                      'Open Sans',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary,
                                                                  fontSize:
                                                                      18.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                        elevation: 3.0,
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ].addToEnd(
                                            const SizedBox(height: 200.0)),
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
