import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mat_salg/ApiCalls.dart';
import 'package:mat_salg/SecureStorage.dart';

import 'opprett_profil_model.dart';
export 'opprett_profil_model.dart';

class OpprettProfilWidget extends StatefulWidget {
  const OpprettProfilWidget({
    super.key,
    required this.phone,
    required this.posisjon,
  });

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
  final RegisterUser registerUser = RegisterUser();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void>? _activeRequest;
  Future<void>? _activeEmailRequest;
  String? _errorMessage;
  String? _emailTatt;
  bool _isloading = false;

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

    _model.emailTextController ??= TextEditingController();
    _model.emailFocusNode ??= FocusNode();

    _model.passordTextController ??= TextEditingController();
    _model.passordFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scaffoldKey,
          resizeToAvoidBottomInset: false,
          backgroundColor: FlutterFlowTheme.of(context).primary,
          body: SafeArea(
            top: true,
            bottom: false,
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Form(
                          key: _model.formKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 0, 20, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Column(
                                  children: [
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(-1, 0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 10, 0, 0),
                                        child: Text(
                                          'Sett opp profilen din',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Nunito',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontSize: 23,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(-1, 0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 0),
                                        child: Text(
                                          'Tusen takk for at du bidrar til å skape en grønnere og mer bærekraftig fremtid.',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Nunito',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Row(
                                //   mainAxisSize: MainAxisSize.max,
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     Align(
                                //       alignment:
                                //           const AlignmentDirectional(1, -1),
                                //       child: InkWell(
                                //         splashColor: Colors.transparent,
                                //         focusColor: Colors.transparent,
                                //         hoverColor: Colors.transparent,
                                //         highlightColor: Colors.transparent,
                                //         onTap: () async {
                                //           final selectedMedia =
                                //               await selectMediaWithSourceBottomSheet(
                                //             context: context,
                                //             maxWidth: 1000.00,
                                //             maxHeight: 1000.00,
                                //             allowPhoto: true,
                                //             pickerFontFamily: 'Nunito',
                                //           );
                                //           if (selectedMedia != null &&
                                //               selectedMedia.every((m) =>
                                //                   validateFileFormat(
                                //                       m.storagePath,
                                //                       context))) {
                                //             safeSetState(() =>
                                //                 _model.isDataUploading = true);
                                //             var selectedUploadedFiles =
                                //                 <FFUploadedFile>[];

                                //             try {
                                //               selectedUploadedFiles =
                                //                   selectedMedia
                                //                       .map(
                                //                           (m) => FFUploadedFile(
                                //                                 name: m
                                //                                     .storagePath
                                //                                     .split('/')
                                //                                     .last,
                                //                                 bytes: m.bytes,
                                //                                 height: m
                                //                                     .dimensions
                                //                                     ?.height,
                                //                                 width: m
                                //                                     .dimensions
                                //                                     ?.width,
                                //                                 blurHash:
                                //                                     m.blurHash,
                                //                               ))
                                //                       .toList();
                                //             } finally {
                                //               _model.isDataUploading = false;
                                //             }
                                //             if (selectedUploadedFiles.length ==
                                //                 selectedMedia.length) {
                                //               safeSetState(() {
                                //                 _model.uploadedLocalFile =
                                //                     selectedUploadedFiles.first;
                                //               });
                                //             } else {
                                //               safeSetState(() {});
                                //               return;
                                //             }
                                //           }
                                //         },
                                //         child: Stack(
                                //           alignment:
                                //               const AlignmentDirectional(1, -1),
                                //           children: [
                                //             if ((_model.uploadedLocalFile.bytes
                                //                     ?.isNotEmpty ??
                                //                 false))
                                //               Align(
                                //                 alignment:
                                //                     const AlignmentDirectional(
                                //                         -0.39, 0),
                                //                 child: Column(
                                //                   mainAxisSize:
                                //                       MainAxisSize.min,
                                //                   mainAxisAlignment:
                                //                       MainAxisAlignment.center,
                                //                   children: [
                                //                     Padding(
                                //                       padding:
                                //                           const EdgeInsetsDirectional
                                //                               .fromSTEB(
                                //                               2, 13, 2, 0),
                                //                       child: Container(
                                //                         width: 90,
                                //                         height: 90,
                                //                         clipBehavior:
                                //                             Clip.antiAlias,
                                //                         decoration:
                                //                             const BoxDecoration(
                                //                           shape:
                                //                               BoxShape.circle,
                                //                         ),
                                //                         child: Image.memory(
                                //                           _model.uploadedLocalFile
                                //                                   .bytes ??
                                //                               Uint8List
                                //                                   .fromList([]),
                                //                           fit: BoxFit.fill,
                                //                           errorBuilder: (context,
                                //                                   error,
                                //                                   stackTrace) =>
                                //                               Image.asset(
                                //                             'assets/images/error_image.jpg',
                                //                             fit: BoxFit.fill,
                                //                           ),
                                //                         ),
                                //                       ),
                                //                     ),
                                //                   ],
                                //                 ),
                                //               ),
                                //             if ((_model.uploadedLocalFile.bytes
                                //                     ?.isNotEmpty ??
                                //                 false))
                                //               Align(
                                //                 alignment:
                                //                     const AlignmentDirectional(
                                //                         1, -1),
                                //                 child: Padding(
                                //                   padding:
                                //                       const EdgeInsetsDirectional
                                //                           .fromSTEB(
                                //                           0, 13, 0, 0),
                                //                   child: FlutterFlowIconButton(
                                //                     borderColor:
                                //                         Colors.transparent,
                                //                     borderRadius: 100,
                                //                     buttonSize: 29,
                                //                     fillColor:
                                //                         const Color(0xB3262C2D),
                                //                     icon: FaIcon(
                                //                       FontAwesomeIcons.times,
                                //                       color:
                                //                           FlutterFlowTheme.of(
                                //                                   context)
                                //                               .primary,
                                //                       size: 16,
                                //                     ),
                                //                     onPressed: () async {
                                //                       safeSetState(() {
                                //                         _model.isDataUploading =
                                //                             false;
                                //                         _model.uploadedLocalFile =
                                //                             FFUploadedFile(
                                //                                 bytes: Uint8List
                                //                                     .fromList(
                                //                                         []));
                                //                       });
                                //                     },
                                //                   ),
                                //                 ),
                                //               ),
                                //             if ((_model.uploadedLocalFile.bytes
                                //                     ?.isEmpty ??
                                //                 true))
                                //               Align(
                                //                 alignment:
                                //                     const AlignmentDirectional(
                                //                         -0.39, 0.03),
                                //                 child: Column(
                                //                   mainAxisSize:
                                //                       MainAxisSize.min,
                                //                   mainAxisAlignment:
                                //                       MainAxisAlignment.center,
                                //                   children: [
                                //                     Padding(
                                //                       padding:
                                //                           const EdgeInsetsDirectional
                                //                               .fromSTEB(
                                //                               2, 5, 2, 0),
                                //                       child: Container(
                                //                         width: 140,
                                //                         height: 140,
                                //                         clipBehavior:
                                //                             Clip.antiAlias,
                                //                         decoration:
                                //                             const BoxDecoration(
                                //                           shape:
                                //                               BoxShape.circle,
                                //                         ),
                                //                         child: Image.asset(
                                //                           'assets/images/add-profile-picture-icon-upload-photo-of-social-media-user-vector-removebg-preview.png',
                                //                           fit: BoxFit.fill,
                                //                         ),
                                //                       ),
                                //                     ),
                                //                   ],
                                //                 ),
                                //               ),
                                //           ],
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 15, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 16, 0, 0),
                                          child: TextFormField(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            controller:
                                                _model.brukernavnTextController,
                                            focusNode:
                                                _model.brukernavnFocusNode,
                                            textInputAction:
                                                TextInputAction.done,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              labelText: 'Brukernavn',
                                              labelStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily: 'Nunito',
                                                    color: const Color.fromRGBO(
                                                        113, 113, 113, 1.0),
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                              hintStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily: 'Nunito',
                                                        letterSpacing: 0.0,
                                                      ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondary,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                              filled: true,
                                              fillColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
                                              errorText: _errorMessage,
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Nunito',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  fontSize: 15,
                                                  letterSpacing: 0.0,
                                                ),
                                            textAlign: TextAlign.start,
                                            validator: _model
                                                .brukernavnTextControllerValidator
                                                .asValidator(context),
                                            onChanged: (username) {
                                              // Check if username is less than 4 characters
                                              if (username.length < 4) {
                                                // Clear the error message and cancel any ongoing request
                                                setState(() {
                                                  _errorMessage = null;
                                                });
                                                _activeRequest?.ignore();
                                                return; // Exit early if username is too short
                                              }

                                              // Cancel the previous request if it exists
                                              _activeRequest?.ignore();

                                              // Start a new request if the username is at least 4 characters
                                              _activeRequest = apiCalls
                                                  .checkUsernameTaken(username)
                                                  .then((response) {
                                                setState(() {
                                                  if (response.statusCode !=
                                                      200) {
                                                    _errorMessage =
                                                        "Brukernavnet er allerede i bruk";
                                                  } else {
                                                    _errorMessage =
                                                        null; // Clear error message if username is available
                                                  }
                                                });
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 16, 10, 0),
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          controller:
                                              _model.fornavnTextController,
                                          focusNode: _model.fornavnFocusNode,
                                          textInputAction: TextInputAction.done,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Fornavn',
                                            labelStyle: FlutterFlowTheme.of(
                                                    context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Nunito',
                                                  color: const Color.fromRGBO(
                                                      113, 113, 113, 1.0),
                                                  fontSize: 16.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                      fontFamily: 'Nunito',
                                                      letterSpacing: 0.0,
                                                    ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Colors.transparent,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            filled: true,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondary,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Nunito',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontSize: 15,
                                                letterSpacing: 0.0,
                                              ),
                                          textAlign: TextAlign.start,
                                          validator: _model
                                              .fornavnTextControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(10, 16, 0, 0),
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          controller:
                                              _model.etternavnTextController,
                                          focusNode: _model.etternavnFocusNode,
                                          textInputAction: TextInputAction.done,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Etternavn',
                                            labelStyle: FlutterFlowTheme.of(
                                                    context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Nunito',
                                                  color: const Color.fromRGBO(
                                                      113, 113, 113, 1.0),
                                                  fontSize: 16.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                      fontFamily: 'Nunito',
                                                      letterSpacing: 0.0,
                                                    ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Colors.transparent,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            filled: true,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondary,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Nunito',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontSize: 15,
                                                letterSpacing: 0.0,
                                              ),
                                          textAlign: TextAlign.start,
                                          validator: _model
                                              .etternavnTextControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 16, 0, 0),
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          controller:
                                              _model.emailTextController,
                                          focusNode: _model.emailFocusNode,
                                          textInputAction: TextInputAction.done,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'E-post',
                                            labelStyle: FlutterFlowTheme.of(
                                                    context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Nunito',
                                                  color: const Color.fromRGBO(
                                                      113, 113, 113, 1.0),
                                                  fontSize: 16.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                      fontFamily: 'Nunito',
                                                      letterSpacing: 0.0,
                                                    ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Colors.transparent,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            filled: true,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondary,
                                            errorText: _emailTatt,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Nunito',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontSize: 15,
                                                letterSpacing: 0.0,
                                              ),
                                          textAlign: TextAlign.start,
                                          validator: _model
                                              .emailTextControllerValidator
                                              .asValidator(context),
                                          onChanged: (email) {
                                            if (email.length < 4) {
                                              setState(() {
                                                _emailTatt = null;
                                              });
                                              _activeEmailRequest?.ignore();
                                              return;
                                            }
                                            _activeEmailRequest?.ignore();
                                            _activeEmailRequest = apiCalls
                                                .checkEmailTaken(email)
                                                .then((response) {
                                              setState(() {
                                                if (response.statusCode !=
                                                    200) {
                                                  _emailTatt =
                                                      "E-posten er allerede i bruk";
                                                } else {
                                                  _emailTatt = null;
                                                }
                                              });
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 16, 0, 0),
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          controller:
                                              _model.passordTextController,
                                          focusNode: _model.passordFocusNode,
                                          textInputAction: TextInputAction.done,
                                          obscureText:
                                              !_model.passordVisibility,
                                          decoration: InputDecoration(
                                            labelText: 'Passord',
                                            labelStyle: FlutterFlowTheme.of(
                                                    context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Nunito',
                                                  color: const Color.fromRGBO(
                                                      113, 113, 113, 1.0),
                                                  fontSize: 16.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                      fontFamily: 'Nunito',
                                                      letterSpacing: 0.0,
                                                    ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Colors.transparent,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            filled: true,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondary,
                                            suffixIcon: InkWell(
                                              onTap: () => safeSetState(
                                                () => _model.passordVisibility =
                                                    !_model.passordVisibility,
                                              ),
                                              focusNode: FocusNode(
                                                  skipTraversal: true),
                                              child: Icon(
                                                _model.passordVisibility
                                                    ? Icons.visibility_outlined
                                                    : Icons
                                                        .visibility_off_outlined,
                                                color: const Color(0xFF757575),
                                                size: 22,
                                              ),
                                            ),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Nunito',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontSize: 15,
                                                letterSpacing: 0.0,
                                              ),
                                          textAlign: TextAlign.start,
                                          validator: _model
                                              .passordTextControllerValidator
                                              .asValidator(context),
                                        ),
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
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // First rectangle
                          Container(
                            width: 30,
                            height: 5.5,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).alternate,
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          const SizedBox(width: 10), // Space between rectangles
                          // Second rectangle
                          Container(
                            width: 30,
                            height: 5.5,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20, 0, 20, 40),
                          child: FFButtonWidget(
                            onPressed: () async {
                              if (_isloading == true) {
                                return;
                              }
                              if (_model.formKey.currentState == null ||
                                  !_model.formKey.currentState!.validate()) {
                                return;
                              }

                              if (_errorMessage != null || _emailTatt != null) {
                                return;
                              }

                              try {
                                _isloading = true;
                                await apiCalls
                                    .checkEmailTaken(
                                        _model.emailTextController.text)
                                    .then((response1) {
                                  setState(() {
                                    if (response1.statusCode != 200) {
                                      _emailTatt =
                                          "E-posten er allerede i bruk";
                                    } else {
                                      _emailTatt = null;
                                    }
                                  });
                                  return;
                                });
                                String username =
                                    _model.brukernavnTextController.text.trim();
                                String firstName =
                                    _model.fornavnTextController.text.trim();
                                String lastName =
                                    _model.etternavnTextController.text.trim();
                                String email =
                                    _model.emailTextController.text.trim();
                                String password =
                                    _model.passordTextController.text.trim();

                                // Call the createUser method
                                final response = await registerUser.createUser1(
                                  username: username,
                                  email: email,
                                  firstName: firstName,
                                  lastName: lastName,
                                  phoneNumber: widget.phone,
                                  password: password,
                                  posisjon: widget.posisjon,
                                );
                                if (response.statusCode == 200) {
                                  final token = await secureStorage
                                      .writeToken(response.body);
                                  if (token == null) {
                                    _isloading = false;
                                    throw (Exception());
                                  }
                                  FFAppState().brukernavn = username;
                                  FFAppState().firstname = firstName;
                                  FFAppState().lastname = lastName;
                                  FFAppState().email = email;
                                  FFAppState().brukerLat =
                                      widget.posisjon.latitude;
                                  FFAppState().brukerLng =
                                      widget.posisjon.longitude;
                                  FFAppState().login = true;
                                }

                                if (response.statusCode != 200) {
                                  _isloading = false;
                                  safeSetState(() {
                                    showCupertinoDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CupertinoAlertDialog(
                                          title: const Text('En feil oppstod'),
                                          content: const Text(
                                              'Prøv på nytt senere eller ta kontakt hvis problemet vedvarer'),
                                          actions: <Widget>[
                                            CupertinoDialogAction(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Ok',
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    return;
                                  });
                                  _isloading = false;
                                }

                                if (_model.formKey.currentState == null ||
                                    !_model.formKey.currentState!.validate()) {
                                  _isloading = false;
                                  return;
                                }
                                if (response.statusCode == 200) {
                                  _isloading = false;
                                  context.goNamed('AddProfilepic');
                                }
                              } catch (e) {
                                _isloading = false;
                                showCupertinoDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CupertinoAlertDialog(
                                      title: const Text('En feil oppstod'),
                                      content: const Text(
                                          'Prøv på nytt senere eller ta kontakt hvis problemet vedvarer'),
                                      actions: <Widget>[
                                        CupertinoDialogAction(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Ok',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            text: 'Neste',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 50.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).alternate,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: 'Nunito',
                                    color:
                                        FlutterFlowTheme.of(context).secondary,
                                    fontSize: 17.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                              elevation: 0.0,
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
