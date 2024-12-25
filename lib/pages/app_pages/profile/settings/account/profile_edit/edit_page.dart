import 'dart:io';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_widgets.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/helper_components/widgets/dialog_utils.dart';
import 'package:mat_salg/logging.dart';
import 'package:mat_salg/my_ip.dart';
import 'package:mat_salg/pages/app_pages/profile/settings/account/profile_edit/edit_services.dart';
import 'package:mat_salg/pages/app_pages/profile/settings/account/re_authenticate/re_authenticate_widget.dart';
import 'package:mat_salg/services/image_service.dart';
import 'package:mat_salg/services/user_service.dart';
import '../../../../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import '../../../../../../helper_components/flutter_flow/upload_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
export 'edit_model.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key, this.konto});

  final dynamic konto;

  @override
  State<EditPage> createState() => _ProfilRedigerWidgetState();
}

class _ProfilRedigerWidgetState extends State<EditPage> {
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final ApiMultiplePics apiMultiplePics = ApiMultiplePics();
  final UserInfoService userInfoService = UserInfoService();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late EditModel _model;
  late EditServices editServices;
  bool hasPressed = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditModel());
    editServices = EditServices(model: _model, konto: widget.konto);

    _model.brukernavnTextController ??= TextEditingController();
    _model.brukernavnFocusNode ??= FocusNode();

    _model.fornavnTextController ??= TextEditingController();
    _model.fornavnFocusNode ??= FocusNode();

    _model.etternavnTextController ??= TextEditingController();
    _model.etternavnFocusNode ??= FocusNode();

    _model.emailTextController ??= TextEditingController();
    _model.emailFocusNode ??= FocusNode();

    _model.bioTextController ??= TextEditingController();
    _model.bioFocusNode ??= FocusNode();

    _model.passwordChangeController ??= TextEditingController();
    _model.passwordChangeNode ??= FocusNode();

    _model.passwordChangeConfirmController ??= TextEditingController();
    _model.passwordChangeConfirmNode ??= FocusNode();

    _model.brukernavnTextController.text = FFAppState().brukernavn;
    _model.emailTextController.text = FFAppState().email;
    _model.fornavnTextController.text = FFAppState().firstname;
    _model.etternavnTextController.text = FFAppState().lastname;
    _model.bioTextController.text = FFAppState().bio;
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
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0.0,
            title: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              child: Align(
                alignment: const AlignmentDirectional(0, 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: SafeArea(
                    child: Container(
                      width: valueOrDefault<double>(
                        MediaQuery.sizeOf(context).width,
                        500.0,
                      ),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.safePop();
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 28,
                            ),
                          ),
                          Text(
                            widget.konto ?? 'Rediger',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Nunito',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 19,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, 0),
                                child: GestureDetector(
                                  onTap: () async {
                                    if (widget.konto != 'Endre passord') {
                                      await editServices.saveAccountUpdates(
                                          context,
                                          (title, content) =>
                                              DialogUtils.showSimpleDialog(
                                                  context: context,
                                                  title: title,
                                                  content: content,
                                                  buttonText: 'Ok'),
                                          (message, error) => error
                                              ? Toasts.showErrorToast(
                                                  context, message)
                                              : Toasts.showAccepted(
                                                  context, message),
                                          (path, pop) => pop
                                              ? Navigator.of(context).pop()
                                              : context.pushNamed(path));
                                      safeSetState(() {});
                                    }
                                  },
                                  child: Text(
                                    'Lagre',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Nunito',
                                          color: widget.konto == 'Endre passord'
                                              ? Colors.transparent
                                              : (editServices.isTextFieldEmpty()
                                                  ? FlutterFlowTheme.of(context)
                                                      .secondaryText
                                                  : FlutterFlowTheme.of(context)
                                                      .alternate),
                                          fontSize: 17,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                        ),
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
              ),
            ),
            actions: [],
            centerTitle: true,
            elevation: 0.0,
          ),
          body: SafeArea(
            top: true,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (widget.konto == 'Profilbilde')
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 50, 16, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Align(
                                alignment: const AlignmentDirectional(1, -1),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    try {
                                      final selectedMedia =
                                          await selectMediaWithSourceBottomSheet(
                                        context: context,
                                        maxWidth: 500.00,
                                        maxHeight: 500.00,
                                        allowPhoto: true,
                                      );
                                      if (selectedMedia != null &&
                                          selectedMedia.every((m) =>
                                              validateFileFormat(
                                                  m.storagePath, context))) {
                                        safeSetState(() =>
                                            _model.isDataUploading = true);
                                        var selectedUploadedFiles =
                                            <FFUploadedFile>[];

                                        try {
                                          selectedUploadedFiles = selectedMedia
                                              .map((m) => FFUploadedFile(
                                                    name: m.storagePath
                                                        .split('/')
                                                        .last,
                                                    bytes: m.bytes,
                                                    height:
                                                        m.dimensions?.height,
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
                                    } on SocketException {
                                      if (!context.mounted) return;
                                      Toasts.showErrorToast(context,
                                          'Ingen internettforbindelse');
                                    } catch (e) {
                                      if (!context.mounted) return;
                                      Toasts.showErrorToast(
                                          context, 'En feil oppstod');
                                    }
                                  },
                                  child: Stack(
                                    alignment:
                                        const AlignmentDirectional(1, -1),
                                    children: [
                                      if (_model
                                          .uploadedLocalFile.bytes!.isEmpty)
                                        Column(
                                          children: [
                                            Align(
                                              alignment:
                                                  const AlignmentDirectional(
                                                      0, -0.5),
                                              child: Container(
                                                width: 135,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Image.network(
                                                  '${ApiConstants.baseUrl}${FFAppState().profilepic}',
                                                  fit: BoxFit.cover,
                                                  width: 135,
                                                  height: 135,
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      Image.asset(
                                                    'assets/images/profile_pic.png',
                                                    width: 135,
                                                    height: 135,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 8, 0, 0),
                                              child: Text(
                                                'Last opp bilde',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .labelLarge
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                          fontSize: 17,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (_model
                                          .uploadedLocalFile.bytes!.isNotEmpty)
                                        Column(
                                          children: [
                                            Align(
                                              alignment:
                                                  const AlignmentDirectional(
                                                      0, -0.5),
                                              child: Container(
                                                width: 135,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Image.memory(
                                                  _model.uploadedLocalFile
                                                          .bytes ??
                                                      Uint8List.fromList([]),
                                                  width: 135,
                                                  height: 135,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      Image.asset(
                                                    'assets/images/profile_pic.png',
                                                    width: 135,
                                                    height: 135,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 8, 0, 0),
                                              child: Text(
                                                'Last opp bilde',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .labelLarge
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                          fontSize: 17,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      if ((_model.uploadedLocalFile.bytes
                                              ?.isNotEmpty ??
                                          false))
                                        GestureDetector(
                                          onTap: () async {
                                            safeSetState(() {
                                              _model.isDataUploading = false;
                                              _model.uploadedLocalFile =
                                                  FFUploadedFile(
                                                      bytes: Uint8List.fromList(
                                                          []));
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 5, 0, 0),
                                            child: Container(
                                              width: 29, // Matches buttonSize
                                              height: 29,
                                              decoration: BoxDecoration(
                                                color:
                                                    Colors.black, // Black fill
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors
                                                      .white, // White outline
                                                  width:
                                                      0.8, // Thickness of the outline
                                                ),
                                              ),
                                              child: Center(
                                                child: FaIcon(
                                                  FontAwesomeIcons.xmark,
                                                  color: Colors
                                                      .white, // Icon color to stand out on black
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ]
                                .addToStart(const SizedBox(width: 15))
                                .addToEnd(const SizedBox(width: 15)),
                          ),
                        ],
                      ),
                    ),
                  if (widget.konto == 'For- og etternavn')
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 16, 0, 0),
                                child: TextFormField(
                                  controller: _model.fornavnTextController,
                                  focusNode: _model.fornavnFocusNode,
                                  obscureText: false,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    '_model.textController',
                                    const Duration(milliseconds: 0),
                                    () => safeSetState(() {}),
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Fornavn',
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Nunito',
                                          color: const Color.fromRGBO(
                                              113, 113, 113, 1.0),
                                          fontSize: 17.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                    hintStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          fontFamily: 'Open Sans',
                                          letterSpacing: 0.0,
                                        ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    filled: true,
                                    fillColor:
                                        FlutterFlowTheme.of(context).secondary,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Nunito',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: 16,
                                        letterSpacing: 0.0,
                                      ),
                                  validator: _model
                                      .fornavnTextControllerValidator
                                      .asValidator(context),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(17),
                                    TextInputFormatter.withFunction(
                                        (oldValue, newValue) {
                                      final lineCount = '\n'
                                              .allMatches(newValue.text)
                                              .length +
                                          1;
                                      if (lineCount > 1) {
                                        return oldValue;
                                      }
                                      return newValue;
                                    }),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 16, 0, 0),
                                child: TextFormField(
                                  controller: _model.etternavnTextController,
                                  focusNode: _model.etternavnFocusNode,
                                  obscureText: false,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    '_model.textController',
                                    const Duration(milliseconds: 0),
                                    () => safeSetState(() {}),
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Etternavn',
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Nunito',
                                          color: const Color.fromRGBO(
                                              113, 113, 113, 1.0),
                                          fontSize: 17.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                    hintStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          fontFamily: 'Open Sans',
                                          letterSpacing: 0.0,
                                        ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    filled: true,
                                    fillColor:
                                        FlutterFlowTheme.of(context).secondary,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Nunito',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: 16,
                                        letterSpacing: 0.0,
                                      ),
                                  validator: _model
                                      .etternavnTextControllerValidator
                                      .asValidator(context),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(17),
                                    TextInputFormatter.withFunction(
                                        (oldValue, newValue) {
                                      final lineCount = '\n'
                                              .allMatches(newValue.text)
                                              .length +
                                          1;
                                      if (lineCount > 1) {
                                        return oldValue;
                                      }
                                      return newValue;
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  if (widget.konto == 'Brukernavn')
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 16, 0, 0),
                                  child: TextFormField(
                                    controller: _model.brukernavnTextController,
                                    focusNode: _model.brukernavnFocusNode,
                                    obscureText: false,
                                    onChanged: (_) => EasyDebounce.debounce(
                                      '_model.textController',
                                      const Duration(milliseconds: 0),
                                      () => safeSetState(() {}),
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Brukernavn',
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Nunito',
                                            color: const Color.fromRGBO(
                                                113, 113, 113, 1.0),
                                            fontSize: 17.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w700,
                                          ),
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            fontFamily: 'Open Sans',
                                            letterSpacing: 0.0,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      filled: true,
                                      fillColor: FlutterFlowTheme.of(context)
                                          .secondary,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Nunito',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 16,
                                          letterSpacing: 0.0,
                                        ),
                                    validator: _model
                                        .brukernavnTextControllerValidator
                                        .asValidator(context),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(50),
                                      TextInputFormatter.withFunction(
                                          (oldValue, newValue) {
                                        final lineCount = '\n'
                                                .allMatches(newValue.text)
                                                .length +
                                            1;
                                        if (lineCount > 1) {
                                          return oldValue;
                                        }
                                        return newValue;
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                12, 8, 12, 0),
                            child: Text(
                              'Du kan kun endre brukernavnet ditt en gang hver 30. dag',
                              style: FlutterFlowTheme.of(context)
                                  .labelLarge
                                  .override(
                                    fontFamily: 'Nunito',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontSize: 14,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (widget.konto == 'E-post')
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 16, 0, 0),
                                  child: TextFormField(
                                    controller: _model.emailTextController,
                                    focusNode: _model.emailFocusNode,
                                    obscureText: false,
                                    onChanged: (_) => EasyDebounce.debounce(
                                      '_model.textController',
                                      const Duration(milliseconds: 0),
                                      () => safeSetState(() {}),
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'E-post',
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Nunito',
                                            color: const Color.fromRGBO(
                                                113, 113, 113, 1.0),
                                            fontSize: 17.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w700,
                                          ),
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            fontFamily: 'Open Sans',
                                            letterSpacing: 0.0,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      filled: true,
                                      fillColor: FlutterFlowTheme.of(context)
                                          .secondary,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Nunito',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 16,
                                          letterSpacing: 0.0,
                                        ),
                                    validator: _model
                                        .emailTextControllerValidator
                                        .asValidator(context),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(50),
                                      TextInputFormatter.withFunction(
                                          (oldValue, newValue) {
                                        final lineCount = '\n'
                                                .allMatches(newValue.text)
                                                .length +
                                            1;
                                        if (lineCount > 1) {
                                          return oldValue;
                                        }
                                        return newValue;
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  if (widget.konto == 'Bio')
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 40),
                      child: TextFormField(
                        controller: _model.bioTextController,
                        focusNode: _model.bioFocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          '_model.textController',
                          const Duration(milliseconds: 0),
                          () => safeSetState(() {}),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelStyle:
                              FlutterFlowTheme.of(context).labelMedium.override(
                                    fontFamily: 'Open Sans',
                                    fontSize: 13,
                                    letterSpacing: 0.0,
                                  ),
                          hintText: 'Bio',
                          hintStyle: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Nunito',
                                color: const Color.fromRGBO(113, 113, 113, 1.0),
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w700,
                              ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: FlutterFlowTheme.of(context).secondary,
                          contentPadding: const EdgeInsetsDirectional.fromSTEB(
                              20, 24, 0, 24),
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Nunito',
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 16,
                              letterSpacing: 0.0,
                            ),
                        textAlign: TextAlign.start,
                        maxLength: 200,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        minLines: 3,
                        maxLines: 7,
                        validator: _model.bioTextControllerValidator
                            .asValidator(context),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(200),
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            final lineCount =
                                '\n'.allMatches(newValue.text).length + 1;
                            if (lineCount > 7) {
                              return oldValue;
                            }
                            return newValue;
                          }),
                        ],
                      ),
                    ),
                  if (widget.konto == 'Endre passord')
                    Form(
                      key: _model.formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            16, 20, 16, 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 16, 0, 0),
                                    child: TextFormField(
                                      controller:
                                          _model.passwordChangeController,
                                      focusNode: _model.passwordChangeNode,
                                      textInputAction: TextInputAction.done,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      autovalidateMode: hasPressed
                                          ? AutovalidateMode.onUserInteraction
                                          : AutovalidateMode.disabled,
                                      autofillHints: null,
                                      keyboardType: TextInputType.text,
                                      obscureText: !_model.passordVisibility,
                                      onChanged: (_) => EasyDebounce.debounce(
                                        '_model.textController',
                                        const Duration(milliseconds: 0),
                                        () => safeSetState(() {}),
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Nytt passord',
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Nunito',
                                              color: const Color.fromRGBO(
                                                  113, 113, 113, 1.0),
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w700,
                                            ),
                                        hintStyle: FlutterFlowTheme.of(context)
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
                                            color: FlutterFlowTheme.of(context)
                                                .secondary,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        filled: true,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .secondary,
                                        suffixIcon: InkWell(
                                          onTap: () => safeSetState(
                                            () => _model.passordVisibility =
                                                !_model.passordVisibility,
                                          ),
                                          focusNode:
                                              FocusNode(skipTraversal: true),
                                          child: Icon(
                                            _model.passordVisibility
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: const Color(0xFF757575),
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Nunito',
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            fontSize: 15,
                                            letterSpacing: 0.0,
                                          ),
                                      textAlign: TextAlign.start,
                                      validator: _model
                                          .passwordChangeControllerValidator
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
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 16, 0, 0),
                                    child: TextFormField(
                                      controller: _model
                                          .passwordChangeConfirmController,
                                      focusNode:
                                          _model.passwordChangeConfirmNode,
                                      textInputAction: TextInputAction.done,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      autofillHints: null,
                                      autovalidateMode: hasPressed
                                          ? AutovalidateMode.onUserInteraction
                                          : AutovalidateMode.disabled,
                                      keyboardType: TextInputType.text,
                                      obscureText:
                                          !_model.passordConfirmVisibility,
                                      onChanged: (_) => EasyDebounce.debounce(
                                        '_model.textController',
                                        const Duration(milliseconds: 0),
                                        () => safeSetState(() {}),
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Bekreft passord',
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Nunito',
                                              color: const Color.fromRGBO(
                                                  113, 113, 113, 1.0),
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w700,
                                            ),
                                        hintStyle: FlutterFlowTheme.of(context)
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
                                            color: FlutterFlowTheme.of(context)
                                                .secondary,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        filled: true,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .secondary,
                                        suffixIcon: InkWell(
                                          onTap: () => safeSetState(
                                            () => _model
                                                    .passordConfirmVisibility =
                                                !_model
                                                    .passordConfirmVisibility,
                                          ),
                                          focusNode:
                                              FocusNode(skipTraversal: true),
                                          child: Icon(
                                            _model.passordConfirmVisibility
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: const Color(0xFF757575),
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Nunito',
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            fontSize: 15,
                                            letterSpacing: 0.0,
                                          ),
                                      textAlign: TextAlign.start,
                                      validator: _model
                                          .passwordChangeControllerConfirmValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: const AlignmentDirectional(0, 0),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 20, 0, 0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    if (!editServices.isPasswordGood()) return;
                                    hasPressed = true;
                                    if (_model.formKey.currentState == null ||
                                        !_model.formKey.currentState!
                                            .validate()) {
                                      return;
                                    }
                                    _model.newPassword =
                                        _model.passwordChangeController.text;
                                    if (_model.newPassword != null) {
                                      bool success = await firebaseAuthService
                                          .updatePassword(
                                              _model.newPassword ?? '');
                                      if (success) {
                                        if (!context.mounted) return;
                                        Toasts.showAccepted(
                                            context, 'Passord endret');
                                        Navigator.of(context).pop();
                                      } else {
                                        logger.d(
                                            "Did not work to change password");
                                        if (!context.mounted) return;
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        await showModalBottomSheet(
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
                                                child: ReAuthenticateWidget(
                                                  newPassword:
                                                      _model.newPassword,
                                                ),
                                              ),
                                            );
                                          },
                                        ).then((value) => setState(() {}));
                                        return;
                                      }
                                    }
                                  },
                                  text: 'Oppdater',
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 50.0,
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                    iconPadding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                    color: editServices.isPasswordGood()
                                        ? FlutterFlowTheme.of(context).alternate
                                        : FlutterFlowTheme.of(context)
                                            .unSelected,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily: 'Nunito',
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          fontSize: 15.0,
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
                      ),
                    ),
                ]),
          ),
        ),
      ),
    );
  }
}
