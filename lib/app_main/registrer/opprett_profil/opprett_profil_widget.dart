import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mat_salg/api/web_socket.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';

import 'package:mat_salg/apiCalls.dart';

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
  late WebSocketService _webSocketService;
  final ApiGetToken apiGetToken = ApiGetToken();
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
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

    _webSocketService = WebSocketService();
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
          // resizeToAvoidBottomInset: false,
          backgroundColor: FlutterFlowTheme.of(context).primary,
          body: SafeArea(
              top: true,
              // bottom: false,
              child: Stack(children: [
                Align(
                  alignment: AlignmentDirectional(0, -1),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
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
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily: 'Nunito',
                                                    color: FlutterFlowTheme.of(
                                                            context)
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
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily: 'Nunito',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 15, 0, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 16, 0, 0),
                                              child: TextFormField(
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                controller: _model
                                                    .brukernavnTextController,
                                                focusNode:
                                                    _model.brukernavnFocusNode,
                                                textInputAction:
                                                    TextInputAction.next,
                                                enableSuggestions:
                                                    false, // Disable suggestions
                                                autocorrect:
                                                    false, // Turn off autocorrect
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  labelText: 'Brukernavn',
                                                  labelStyle: FlutterFlowTheme
                                                          .of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Nunito',
                                                        color: const Color
                                                            .fromRGBO(
                                                            113, 113, 113, 1.0),
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                  hintStyle: FlutterFlowTheme
                                                          .of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily: 'Nunito',
                                                        letterSpacing: 0.0,
                                                      ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
                                                  ),
                                                  filled: true,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondary,
                                                  errorText: _errorMessage,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                                                      .checkUsernameTaken(
                                                          username)
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
                                                onFieldSubmitted: (_) {
                                                  FocusScope.of(context)
                                                      .requestFocus(_model
                                                          .fornavnFocusNode);
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
                                              focusNode:
                                                  _model.fornavnFocusNode,
                                              textInputAction:
                                                  TextInputAction.next,
                                              enableSuggestions:
                                                  false, // Disable suggestions
                                              autocorrect:
                                                  false, // Turn off autocorrect
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                labelText: 'Fornavn',
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
                                                      fontSize: 16.0,
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
                                                    color: Colors.transparent,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
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
                                                        fontSize: 15,
                                                        letterSpacing: 0.0,
                                                      ),
                                              textAlign: TextAlign.start,
                                              validator: _model
                                                  .fornavnTextControllerValidator
                                                  .asValidator(context),
                                              onFieldSubmitted: (_) {
                                                FocusScope.of(context)
                                                    .requestFocus(_model
                                                        .etternavnFocusNode);
                                              },
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
                                              controller: _model
                                                  .etternavnTextController,
                                              focusNode:
                                                  _model.etternavnFocusNode,
                                              textInputAction:
                                                  TextInputAction.next,
                                              enableSuggestions:
                                                  false, // Disable suggestions
                                              autocorrect:
                                                  false, // Turn off autocorrect
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                labelText: 'Etternavn',
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
                                                      fontSize: 16.0,
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
                                                    color: Colors.transparent,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
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
                                                        fontSize: 15,
                                                        letterSpacing: 0.0,
                                                      ),
                                              textAlign: TextAlign.start,
                                              validator: _model
                                                  .etternavnTextControllerValidator
                                                  .asValidator(context),
                                              onFieldSubmitted: (_) {
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        _model.emailFocusNode);
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
                                                  _model.emailTextController,
                                              focusNode: _model.emailFocusNode,
                                              textInputAction:
                                                  TextInputAction.next,
                                              enableSuggestions: false,
                                              autocorrect: false,
                                              obscureText: false,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              decoration: InputDecoration(
                                                labelText: 'E-post',
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
                                                      fontSize: 16.0,
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
                                                    color: Colors.transparent,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
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
                                                errorText: _emailTatt,
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
                                              focusNode:
                                                  _model.passordFocusNode,
                                              textInputAction:
                                                  TextInputAction.done,
                                              enableSuggestions: false,
                                              autocorrect: false,
                                              autofillHints:
                                                  null, // Disable autofill for this field
                                              keyboardType: TextInputType.text,
                                              obscureText:
                                                  !_model.passordVisibility,
                                              decoration: InputDecoration(
                                                labelText: 'Passord',
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
                                                      fontSize: 16.0,
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
                                                    color: Colors.transparent,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
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
                                                suffixIcon: InkWell(
                                                  onTap: () => safeSetState(
                                                    () => _model
                                                            .passordVisibility =
                                                        !_model
                                                            .passordVisibility,
                                                  ),
                                                  focusNode: FocusNode(
                                                      skipTraversal: true),
                                                  child: Icon(
                                                    _model.passordVisibility
                                                        ? Icons
                                                            .visibility_outlined
                                                        : Icons
                                                            .visibility_off_outlined,
                                                    color:
                                                        const Color(0xFF757575),
                                                    size: 22,
                                                  ),
                                                ),
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
                          ].addToEnd(const SizedBox(height: 350)),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0, 1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
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
                              color: const Color.fromARGB(173, 212, 212, 212),
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 5),
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
                                    _emailTatt = "E-posten er allerede i bruk";
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
                                final token =
                                    await firebaseAuthService.getToken(context);
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
                                              style:
                                                  TextStyle(color: Colors.blue),
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
                                _webSocketService = WebSocketService();
                                _webSocketService.connect(retrying: true);
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
                                          style: TextStyle(color: Colors.blue),
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
                                  color: FlutterFlowTheme.of(context).secondary,
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
                    ],
                  ),
                ),
              ])),
        ),
      ),
    );
  }
}
