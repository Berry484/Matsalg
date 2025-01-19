import 'dart:async';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/services/check_taken_service.dart';
import 'package:mat_salg/services/user_service.dart';
import 'package:mat_salg/services/web_socket.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/logging.dart';
import '../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../helper_components/flutter_flow/flutter_flow_util.dart';
import '../../../helper_components/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'create_profile_model.dart';
export 'create_profile_model.dart';

class OpprettProfilWidget extends StatefulWidget {
  const OpprettProfilWidget({
    super.key,
    required this.phone,
  });

  final String? phone;

  @override
  State<OpprettProfilWidget> createState() => _OpprettProfilWidgetState();
}

class _OpprettProfilWidgetState extends State<OpprettProfilWidget> {
  late OpprettProfilModel _model;
  late WebSocketService _webSocketService;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final UserInfoService userInfoService = UserInfoService();
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
    if (_auth.currentUser!.providerData[0].providerId == 'google.com') {
      _model.emailTextController.text = _auth.currentUser?.email ?? '';
    }

    if (_auth.currentUser!.providerData[0].providerId == 'apple.com') {
      String displayName = _auth.currentUser?.displayName ?? '';
      List<String> nameParts = displayName.split(',');
      _model.firstName = nameParts[0].replaceAll('firstname:', '').trim();
      _model.lastName = nameParts[1].replaceAll('lastname:', '').trim();
      if (_model.firstName != 'null' && _model.lastName != 'null') {
        _model.fornavnTextController.text = _model.firstName ?? '';
        _model.etternavnTextController.text = _model.lastName ?? '';
      }
      _model.emailTextController.text = _auth.currentUser?.email ?? '';
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  bool buttonClickable() {
    if (_errorMessage != null || _emailTatt != null) {
      return false;
    }

    if (_model.brukernavnTextController.text.trim().isEmpty ||
        _model.brukernavnTextController.text.length < 4 ||
        !RegExp(kTextValidatorUsernameRegex)
            .hasMatch(_model.brukernavnTextController.text)) {
      return false;
    }
    if (_auth.currentUser!.providerData[0].providerId != 'apple.com' ||
        (_model.firstName == 'null' && _model.lastName == 'null')) {
      if (_model.fornavnTextController.text.trim().isEmpty ||
          !RegExp(kTextValidatorNormalnameRegex)
              .hasMatch(_model.fornavnTextController.text)) {
        return false;
      }
      if (_model.etternavnTextController.text.trim().isEmpty ||
          !RegExp(kTextValidatorNormalnameRegex)
              .hasMatch(_model.etternavnTextController.text)) {
        return false;
      }
      if (_model.emailTextController.text.trim().isEmpty ||
          !RegExp(kTextValidatorEmailRegex)
              .hasMatch(_model.emailTextController.text)) {
        return false;
      }
      if (widget.phone != '0') {
        if (_model.passordTextController.text.isEmpty ||
            _model.passordTextController.text.length < 7) {
          return false;
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
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
                                                  buttonClickable();

                                                  if (username.length < 4) {
                                                    setState(() {
                                                      _errorMessage = null;
                                                    });
                                                    _activeRequest?.ignore();
                                                    return;
                                                  }

                                                  _activeRequest?.ignore();

                                                  _activeRequest =
                                                      CheckTakenService
                                                              .checkUsernameTaken(
                                                                  username)
                                                          .then((response) {
                                                    setState(() {
                                                      if (response.statusCode !=
                                                          200) {
                                                        _errorMessage =
                                                            "Brukernavnet er allerede i bruk";
                                                      } else {
                                                        _errorMessage = null;
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
                                    if (_auth.currentUser!.providerData[0]
                                                .providerId !=
                                            'apple.com' ||
                                        (_model.firstName == 'null' &&
                                            _model.lastName == 'null'))
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 16, 10, 0),
                                              child: TextFormField(
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                controller: _model
                                                    .fornavnTextController,
                                                focusNode:
                                                    _model.fornavnFocusNode,
                                                textCapitalization:
                                                    TextCapitalization
                                                        .sentences,
                                                textInputAction:
                                                    TextInputAction.next,
                                                onChanged: (_) =>
                                                    EasyDebounce.debounce(
                                                  '_model.textController',
                                                  const Duration(
                                                      milliseconds: 0),
                                                  () => safeSetState(() {}),
                                                ),
                                                enableSuggestions:
                                                    false, // Disable suggestions
                                                autocorrect:
                                                    false, // Turn off autocorrect
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  labelText: 'Fornavn',
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
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(10, 16, 0, 0),
                                              child: TextFormField(
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                controller: _model
                                                    .etternavnTextController,
                                                focusNode:
                                                    _model.etternavnFocusNode,
                                                textCapitalization:
                                                    TextCapitalization
                                                        .sentences,
                                                onChanged: (_) =>
                                                    EasyDebounce.debounce(
                                                  '_model.textController',
                                                  const Duration(
                                                      milliseconds: 0),
                                                  () => safeSetState(() {}),
                                                ),
                                                textInputAction:
                                                    TextInputAction.next,
                                                enableSuggestions: false,
                                                autocorrect: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  labelText: 'Etternavn',
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
                                                    .etternavnTextControllerValidator
                                                    .asValidator(context),
                                                onFieldSubmitted: (_) {
                                                  FocusScope.of(context)
                                                      .requestFocus(_model
                                                          .emailFocusNode);
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (_auth.currentUser!.providerData[0]
                                                .providerId !=
                                            'apple.com' &&
                                        _auth.currentUser!.providerData[0]
                                                .providerId !=
                                            'google.com')
                                      Row(
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
                                                controller:
                                                    _model.emailTextController,
                                                focusNode:
                                                    _model.emailFocusNode,
                                                textInputAction:
                                                    TextInputAction.next,
                                                enableSuggestions: false,
                                                autocorrect: false,
                                                obscureText: false,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration: InputDecoration(
                                                  labelText: 'E-post',
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
                                                  errorText: _emailTatt,
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
                                                    .emailTextControllerValidator
                                                    .asValidator(context),
                                                onChanged: (email) {
                                                  if (email.length < 4) {
                                                    setState(() {
                                                      _emailTatt = null;
                                                    });
                                                    _activeEmailRequest
                                                        ?.ignore();
                                                    return;
                                                  }
                                                  _activeEmailRequest?.ignore();
                                                  _activeEmailRequest =
                                                      CheckTakenService
                                                              .checkEmailTaken(
                                                                  email)
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
                                    if (widget.phone != '0')
                                      Row(
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
                                                    .passordTextController,
                                                focusNode:
                                                    _model.passordFocusNode,
                                                textInputAction:
                                                    TextInputAction.done,
                                                enableSuggestions: false,
                                                autocorrect: false,
                                                onChanged: (_) =>
                                                    EasyDebounce.debounce(
                                                  '_model.textController',
                                                  const Duration(
                                                      milliseconds: 0),
                                                  () => safeSetState(() {}),
                                                ),
                                                autofillHints: null,
                                                keyboardType:
                                                    TextInputType.text,
                                                obscureText:
                                                    !_model.passordVisibility,
                                                decoration: InputDecoration(
                                                  labelText: 'Passord',
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
                                                      color: const Color(
                                                          0xFF757575),
                                                      size: 22,
                                                    ),
                                                  ),
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
                          Container(
                            width: 30,
                            height: 5.5,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).alternate,
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          const SizedBox(width: 10), // Space between rectangles
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
                            if (_isloading) return;
                            _isloading = true;
                            if (widget.phone == '0') {
                              try {
                                if (_model.formKey.currentState == null ||
                                    !_model.formKey.currentState!.validate()) {
                                  _isloading = false;
                                  return;
                                }
                                if (_errorMessage != null ||
                                    _emailTatt != null) {
                                  _isloading = false;
                                  return;
                                }
                                String? token =
                                    await firebaseAuthService.getToken(context);
                                logger.d(token);
                                _isloading = false;

                                await CheckTakenService.checkEmailTaken(
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
                                  _isloading = false;
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

                                if (token == null) {
                                  _isloading = false;
                                  if (!context.mounted) return;
                                  Toasts.showErrorToast(context,
                                      'Noe gikk galt, vennligst prøv på nytt.\nHvis problemet vedvarer ta kontakt');
                                }
                                logger.d(token);

                                if (token != null) {
                                  final response = await userInfoService
                                      .createUserInPostgres(
                                    token: token,
                                    username: username,
                                    email: email,
                                    firstName: firstName,
                                    lastName: lastName,
                                    phoneNumber: '0',
                                  );
                                  logger.d(
                                      '${response.body} + ${response.statusCode}');

                                  if (response.statusCode == 200 ||
                                      response.statusCode == 201) {
                                    FFAppState().brukernavn = username;
                                    FFAppState().firstname = firstName;
                                    FFAppState().lastname = lastName;
                                    FFAppState().email = email;
                                    FFAppState().login = true;
                                    FFAppState().lagtUt = false;
                                    FFAppState().liked = false;
                                    _webSocketService = WebSocketService();
                                    _webSocketService.connect(retrying: true);
                                    if (!context.mounted) return;
                                    _isloading = false;
                                    context.goNamed('AddProfilepic');
                                  }

                                  if (response.statusCode != 200 &&
                                      response.statusCode != 201) {
                                    _isloading = false;
                                    if (!context.mounted) return;
                                    Toasts.showErrorToast(context,
                                        'Noe gikk galt, vennligst prøv på nytt.\nHvis problemet vedvarer ta kontakt');
                                    return;
                                  }
                                }
                                _isloading = false;
                              } catch (e) {
                                _isloading = false;
                                if (!context.mounted) return;
                                Toasts.showErrorToast(context,
                                    'Noe gikk galt, vennligst prøv på nytt.\nHvis problemet vedvarer ta kontakt');
                              }
                              return;
                            }
                            /*





                            */
                            //Vanlig lag bruker
                            if (widget.phone != null) {
                              if (_model.formKey.currentState == null ||
                                  !_model.formKey.currentState!.validate()) {
                                _isloading = false;
                                return;
                              }

                              if (_errorMessage != null || _emailTatt != null) {
                                _isloading = false;
                                return;
                              }

                              try {
                                _isloading = true;
                                await CheckTakenService.checkEmailTaken(
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
                                  _isloading = false;
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

                                //Make user in firebase
                                try {
                                  final response = await firebaseAuthService
                                      .linkEmailAndPasswordToPhoneUser(
                                          '${widget.phone}@gmail.com',
                                          password);
                                  if (response == null) {
                                    _isloading = false;
                                    safeSetState(() {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog.adaptive(
                                            title:
                                                const Text('En feil oppstod'),
                                            content: const Text(
                                              'Prøv på nytt senere eller ta kontakt hvis problemet vedvarer',
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(
                                                      context); // Close the dialog
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
                                  }
                                } catch (e) {
                                  if (e == 'email-taken') {
                                    setState(() {
                                      _isloading = false;
                                      _emailTatt =
                                          "E-posten er allerede i bruk";
                                    });
                                  }
                                }
                                if (!context.mounted) return;
                                String? token =
                                    await firebaseAuthService.getToken(context);
                                if (token == null) {
                                  _isloading = false;
                                  if (!context.mounted) return;
                                  Toasts.showErrorToast(context,
                                      'Noe gikk galt, vennligst prøv på nytt.\nHvis problemet vedvarer ta kontakt');
                                }

                                if (token != null) {
                                  final response = await userInfoService
                                      .createUserInPostgres(
                                    token: token,
                                    username: username,
                                    email: email,
                                    firstName: firstName,
                                    lastName: lastName,
                                    phoneNumber: widget.phone,
                                  );
                                  logger.d(
                                      '${response.body} + ${response.statusCode}');

                                  if (response.statusCode == 200 ||
                                      response.statusCode == 201) {
                                    FFAppState().brukernavn = username;
                                    FFAppState().firstname = firstName;
                                    FFAppState().lastname = lastName;
                                    FFAppState().email = email;
                                    FFAppState().login = true;
                                    FFAppState().lagtUt = false;
                                    FFAppState().liked = false;
                                    _webSocketService = WebSocketService();
                                    _webSocketService.connect(retrying: true);
                                    if (!context.mounted) return;
                                    _isloading = false;
                                    context.goNamed('AddProfilepic');
                                  }

                                  if (response.statusCode != 200 &&
                                      response.statusCode != 201) {
                                    _isloading = false;
                                    if (!context.mounted) return;
                                    Toasts.showErrorToast(context,
                                        'Noe gikk galt, vennligst prøv på nytt.\nHvis problemet vedvarer ta kontakt');
                                    return;
                                  }
                                }
                                _isloading = false;
                              } catch (e) {
                                logger.e("Error $e");
                                _isloading = false;
                                if (!context.mounted) return;
                                Toasts.showErrorToast(context,
                                    'Noe gikk galt, vennligst prøv på nytt.\nHvis problemet vedvarer ta kontakt');
                              }
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
                            color: buttonClickable()
                                ? FlutterFlowTheme.of(context).alternate
                                : FlutterFlowTheme.of(context).unSelected,
                            textStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Nunito',
                                  color: Colors.white,
                                  fontSize: 16,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w700,
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
