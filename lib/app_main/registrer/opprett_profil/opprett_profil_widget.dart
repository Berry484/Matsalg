import 'dart:ffi';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mat_salg/app_main/registrer/ApiCalls.dart';
import 'package:mat_salg/SecureStorage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'opprett_profil_model.dart';
export 'opprett_profil_model.dart';

class OpprettProfilWidget extends StatefulWidget {
  const OpprettProfilWidget({
    super.key,
    bool? bonde,
    required this.email,
    required this.password,
    required this.phone,
    required this.posisjon,
  }) : this.bonde = bonde ?? false;

  final bool bonde;
  final String? email;
  final String? password;
  final String? phone;
  final LatLng posisjon;

  @override
  State<OpprettProfilWidget> createState() => _OpprettProfilWidgetState();
}

class _OpprettProfilWidgetState extends State<OpprettProfilWidget> {
  late OpprettProfilModel _model;
  final ApiCalls apiCalls = ApiCalls(); // Instantiate the ApiCalls class
  final ApiUserSQL apiUserSQL = ApiUserSQL();
  final ApiGetToken apiGetToken = ApiGetToken();
  final Securestorage secureStorage = Securestorage();
  final ApiUploadProfilePic apiUploadProfilePic = ApiUploadProfilePic();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OpprettProfilModel());

    _model.brukernavnTextController ??= TextEditingController();
    _model.brukernavnFocusNode ??= FocusNode();

    _model.fornavnTextController ??= TextEditingController();
    _model.fornavnFocusNode ??= FocusNode();

    _model.etternavnTextController ??= TextEditingController();
    _model.etternavnFocusNode ??= FocusNode();

    _model.bioTextController ??= TextEditingController();
    _model.bioFocusNode ??= FocusNode();
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
          backgroundColor: FlutterFlowTheme.of(context).secondary,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondary,
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).alternate),
            automaticallyImplyLeading: true,
            leading: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                context.safePop();
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: FlutterFlowTheme.of(context).alternate,
                size: 28,
              ),
            ),
            actions: [],
            centerTitle: true,
            elevation: 0,
          ),
          body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Form(
                    key: _model.formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(-1, 0),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(30, 40, 0, 0),
                            child: Text(
                              'Legg til profilbilde',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Open Sans',
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    fontSize: 19,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(1, -1),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  final selectedMedia =
                                      await selectMediaWithSourceBottomSheet(
                                    context: context,
                                    maxWidth: 1000.00,
                                    maxHeight: 1000.00,
                                    allowPhoto: true,
                                    pickerFontFamily: 'Open Sans',
                                  );
                                  if (selectedMedia != null &&
                                      selectedMedia.every((m) =>
                                          validateFileFormat(
                                              m.storagePath, context))) {
                                    safeSetState(
                                        () => _model.isDataUploading = true);
                                    var selectedUploadedFiles =
                                        <FFUploadedFile>[];

                                    try {
                                      selectedUploadedFiles = selectedMedia
                                          .map((m) => FFUploadedFile(
                                                name: m.storagePath
                                                    .split('/')
                                                    .last,
                                                bytes: m.bytes,
                                                height: m.dimensions?.height,
                                                width: m.dimensions?.width,
                                                blurHash: m.blurHash,
                                              ))
                                          .toList();
                                    } finally {
                                      _model.isDataUploading = false;
                                    }
                                    if (selectedUploadedFiles.length ==
                                        selectedMedia.length) {
                                      safeSetState(() {
                                        _model.uploadedLocalFile =
                                            selectedUploadedFiles.first;
                                      });
                                    } else {
                                      safeSetState(() {});
                                      return;
                                    }
                                  }
                                },
                                child: Stack(
                                  alignment: AlignmentDirectional(1, -1),
                                  children: [
                                    if (_model.uploadedLocalFile != null &&
                                        (_model.uploadedLocalFile.bytes
                                                ?.isNotEmpty ??
                                            false))
                                      Align(
                                        alignment:
                                            AlignmentDirectional(-0.39, 0.03),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(2, 24, 2, 0),
                                              child: Container(
                                                width: 120,
                                                height: 120,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Image.memory(
                                                  _model.uploadedLocalFile
                                                          .bytes ??
                                                      Uint8List.fromList([]),
                                                  fit: BoxFit.fill,
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      Image.asset(
                                                    'assets/images/error_image.jpg',
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'Last opp bilde',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily: 'Open Sans',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                    fontSize: 16,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (_model.uploadedLocalFile != null &&
                                        (_model.uploadedLocalFile.bytes
                                                ?.isNotEmpty ??
                                            false))
                                      Align(
                                        alignment: AlignmentDirectional(1, -1),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 23, 7, 0),
                                          child: FlutterFlowIconButton(
                                            borderColor: Colors.transparent,
                                            borderRadius: 100,
                                            buttonSize: 29,
                                            fillColor: Color(0xB3262C2D),
                                            icon: FaIcon(
                                              FontAwesomeIcons.times,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              size: 16,
                                            ),
                                            onPressed: () async {
                                              safeSetState(() {
                                                _model.isDataUploading = false;
                                                _model.uploadedLocalFile =
                                                    FFUploadedFile(
                                                        bytes:
                                                            Uint8List.fromList(
                                                                []));
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    if (_model.uploadedLocalFile == null ||
                                        (_model.uploadedLocalFile.bytes
                                                ?.isEmpty ??
                                            true))
                                      Align(
                                        alignment:
                                            AlignmentDirectional(-0.39, 0.03),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(2, 24, 2, 0),
                                              child: Container(
                                                width: 120,
                                                height: 120,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Image.asset(
                                                  'assets/images/add-profile-picture-icon-upload-photo-of-social-media-user-vector-removebg-preview.png',
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'Last opp bilde',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily: 'Open Sans',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                    fontSize: 16,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20, 20, 20, 0),
                                  child: TextFormField(
                                    controller: _model.brukernavnTextController,
                                    focusNode: _model.brukernavnFocusNode,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    textInputAction: TextInputAction.done,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'Brukernavn',
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            fontFamily: 'Open Sans',
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                          ),
                                      hintText: 'Brukernavn',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            fontFamily: 'Open Sans',
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x4257636C),
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      filled: true,
                                      fillColor:
                                          FlutterFlowTheme.of(context).primary,
                                      contentPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              20, 24, 20, 24),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Open Sans',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 15,
                                          letterSpacing: 0.0,
                                        ),
                                    maxLines: null,
                                    maxLength: 25,
                                    maxLengthEnforcement:
                                        MaxLengthEnforcement.enforced,
                                    buildCounter: (context,
                                            {required currentLength,
                                            required isFocused,
                                            maxLength}) =>
                                        null,
                                    validator: _model
                                        .brukernavnTextControllerValidator
                                        .asValidator(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20, 20, 10, 0),
                                  child: TextFormField(
                                    controller: _model.fornavnTextController,
                                    focusNode: _model.fornavnFocusNode,
                                    textInputAction: TextInputAction.done,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'Fornavn',
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            fontFamily: 'Open Sans',
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                          ),
                                      hintText: 'Fornavn',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            fontFamily: 'Open Sans',
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x4257636C),
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      filled: true,
                                      fillColor:
                                          FlutterFlowTheme.of(context).primary,
                                      contentPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              20, 24, 20, 24),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Open Sans',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 15,
                                          letterSpacing: 0.0,
                                        ),
                                    maxLines: null,
                                    validator: _model
                                        .fornavnTextControllerValidator
                                        .asValidator(context),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10, 20, 20, 0),
                                  child: TextFormField(
                                    controller: _model.etternavnTextController,
                                    focusNode: _model.etternavnFocusNode,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    textInputAction: TextInputAction.done,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'Etternavn',
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            fontFamily: 'Open Sans',
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                          ),
                                      hintText: 'Etternavn',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            fontFamily: 'Open Sans',
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x4257636C),
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      filled: true,
                                      fillColor:
                                          FlutterFlowTheme.of(context).primary,
                                      contentPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              20, 24, 20, 24),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Open Sans',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 15,
                                          letterSpacing: 0.0,
                                        ),
                                    maxLines: null,
                                    validator: _model
                                        .etternavnTextControllerValidator
                                        .asValidator(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(20, 30, 20, 12),
                          child: TextFormField(
                            controller: _model.bioTextController,
                            focusNode: _model.bioFocusNode,
                            textCapitalization: TextCapitalization.sentences,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: 'Plus Jakarta Sans',
                                    color: Color(0xFF57636C),
                                    fontSize: 14,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                              hintText: 'Din bio',
                              hintStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: 'Plus Jakarta Sans',
                                    color: Color(0xFF57636C),
                                    fontSize: 14,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x4257636C),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFFF5963),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFFF5963),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding:
                                  EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Open Sans',
                                  color: Color(0xFF14181B),
                                  fontSize: 14,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                ),
                            textAlign: TextAlign.start,
                            maxLines: 3,
                            maxLength: 210,
                            validator: _model.bioTextControllerValidator
                                .asValidator(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0, 0.05),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          if (_model.formKey.currentState == null ||
                              !_model.formKey.currentState!.validate()) {
                            return;
                          }
                          try {
                            final response = await apiCalls.checkUsernameTaken(
                                _model.brukernavnTextController.text);

                            // Check the response and display a message
                            if (response.statusCode == 200) {
                              String username =
                                  _model.brukernavnTextController.text.trim();
                              String firstName =
                                  _model.fornavnTextController.text.trim();
                              String lastName =
                                  _model.etternavnTextController.text.trim();

                              // Call the createUser method
                              final response = await apiCalls.createUser(
                                username: username,
                                email: widget.email,
                                firstName: firstName,
                                lastName: lastName,
                                phoneNumber: widget.phone,
                                password: widget.password,
                              );
                              // Handle the response
                              if (response.statusCode == 200) {
                                String? accessToken =
                                    await apiGetToken.getAuthToken(
                                  username: username,
                                  password: widget.password,
                                  phoneNumber: widget.phone,
                                );
                                if (accessToken == null) {
                                  throw (Exception());
                                }
                                if (_model.uploadedLocalFile != null &&
                                    (_model.uploadedLocalFile.bytes
                                            ?.isNotEmpty ??
                                        false)) {
                                  Uint8List? image =
                                      _model.uploadedLocalFile.bytes;
                                  String? profilepic = await apiUploadProfilePic
                                      .uploadProfilePic(fileData: image);

                                  String bio =
                                      _model.bioTextController.text.trim();
                                  final response =
                                      await apiUserSQL.createOrUpdateUserInfo(
                                    username: username,
                                    profilepic: profilepic,
                                    bio: bio,
                                    posisjon: widget.posisjon,
                                    token: accessToken,
                                  );
                                  if (response.statusCode == 200) {
                                    final token = await secureStorage
                                        .writeToken(accessToken);
                                    if (token == null) {
                                      throw (Exception());
                                    }
                                    if (response.statusCode != 200) {
                                      throw (Exception());
                                    }
                                    FFAppState().brukernavn = username;
                                  }
                                } else {
                                  String bio =
                                      _model.bioTextController.text.trim();
                                  final response =
                                      await apiUserSQL.createOrUpdateUserInfo(
                                    username: username,
                                    bio: bio,
                                    posisjon: widget.posisjon,
                                    token: accessToken,
                                  );
                                  if (response.statusCode == 200) {
                                    final token = await secureStorage
                                        .writeToken(accessToken);
                                    if (token == null) {
                                      throw (Exception());
                                    }
                                    if (response.statusCode != 200) {
                                      throw (Exception());
                                    }
                                  }
                                  FFAppState().brukernavn = username;
                                }

                                if (response.statusCode != 200) {
                                  safeSetState(() {
                                    _model.brukernavnTextController?.clear();
                                  });
                                }
                              } else {
                                throw (Exception());
                              }
                            } else {
                              safeSetState(() {
                                _model.brukernavnTextController?.clear();
                              });
                            }

                            if (_model.formKey.currentState == null ||
                                !_model.formKey.currentState!.validate()) {
                              return;
                            }
                            if (widget!.bonde == true) {
                              context.goNamed('BondeOnboarding');
                            } else {
                              context.goNamed('BrukerOnboarding');
                            }
                          } catch (e) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Feil'),
                                  content: const Text(
                                      'En uforvented feil oppstod. Prøv igjen senere eller kontakt oss igjennom nettsiden.'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        text: 'Opprett profil',
                        options: FFButtonOptions(
                          width: 270,
                          height: 50,
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          iconPadding:
                              EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: FlutterFlowTheme.of(context).alternate,
                          textStyle:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    fontFamily: 'Open Sans',
                                    color: Colors.white,
                                    fontSize: 18,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                          elevation: 3,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ].addToEnd(SizedBox(height: 100)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
