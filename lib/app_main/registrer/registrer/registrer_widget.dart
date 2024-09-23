import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'registrer_model.dart';
export 'registrer_model.dart';

class RegistrerWidget extends StatefulWidget {
  const RegistrerWidget({super.key});

  @override
  State<RegistrerWidget> createState() => _RegistrerWidgetState();
}

class _RegistrerWidgetState extends State<RegistrerWidget>
    with TickerProviderStateMixin {
  late RegistrerModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RegistrerModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
    _model.emailLoginTextController ??= TextEditingController();
    _model.emailLoginFocusNode ??= FocusNode();

    _model.passordLoginTextController ??= TextEditingController();
    _model.passordLoginFocusNode ??= FocusNode();

    _model.epostLagTextController ??= TextEditingController();
    _model.epostLagFocusNode ??= FocusNode();

    _model.navnLagTextController ??= TextEditingController();
    _model.navnLagFocusNode ??= FocusNode();

    _model.passordLagTextController ??= TextEditingController();
    _model.passordLagFocusNode ??= FocusNode();
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
          body: SafeArea(
            top: true,
            child: Padding(
<<<<<<< HEAD
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 200.0, 0.0, 0.0),
=======
              padding: EdgeInsetsDirectional.fromSTEB(0, 200, 0, 0),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Align(
<<<<<<< HEAD
                          alignment: const Alignment(0.0, 0),
                          child: TabBar(
                            isScrollable: true,
                            labelColor: FlutterFlowTheme.of(context).black600,
                            labelPadding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
=======
                          alignment: Alignment(0, 0),
                          child: TabBar(
                            isScrollable: true,
                            labelColor: FlutterFlowTheme.of(context).black600,
                            labelPadding:
                                EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                            labelStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: 'Open Sans',
                                  letterSpacing: 0.0,
                                ),
<<<<<<< HEAD
                            unselectedLabelStyle: const TextStyle(),
                            indicatorColor:
                                FlutterFlowTheme.of(context).alternate,
                            tabs: const [
=======
                            unselectedLabelStyle: TextStyle(),
                            indicatorColor:
                                FlutterFlowTheme.of(context).alternate,
                            tabs: [
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                              Tab(
                                text: 'Logg Inn',
                              ),
                              Tab(
                                text: 'Registrer Deg',
                              ),
                            ],
                            controller: _model.tabBarController,
                            onTap: (i) async {
                              [() async {}, () async {}][i]();
                            },
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _model.tabBarController,
                            children: [
                              Padding(
<<<<<<< HEAD
                                padding: const EdgeInsets.all(24.0),
=======
                                padding: EdgeInsets.all(24),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Form(
                                      key: _model.formKey1,
                                      autovalidateMode:
                                          AutovalidateMode.disabled,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
<<<<<<< HEAD
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 20.0, 20.0, 0.0),
=======
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20, 20, 20, 0),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                            child: TextFormField(
                                              controller: _model
                                                  .emailLoginTextController,
                                              focusNode:
                                                  _model.emailLoginFocusNode,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                labelText: 'E-post',
                                                labelStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily:
                                                              'Open Sans',
<<<<<<< HEAD
                                                          fontSize: 14.0,
=======
                                                          fontSize: 14,
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                          letterSpacing: 0.0,
                                                        ),
                                                alignLabelWithHint: false,
                                                hintText: 'Skriv inn e-post...',
                                                hintStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily:
                                                              'Open Sans',
<<<<<<< HEAD
                                                          fontSize: 14.0,
=======
                                                          fontSize: 14,
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                          letterSpacing: 0.0,
                                                        ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
<<<<<<< HEAD
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
=======
                                                      BorderRadius.circular(10),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                    color: Color(0x00000000),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
<<<<<<< HEAD
                                                      BorderRadius.circular(
                                                          10.0),
=======
                                                      BorderRadius.circular(10),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
<<<<<<< HEAD
                                                      BorderRadius.circular(
                                                          10.0),
=======
                                                      BorderRadius.circular(10),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
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
<<<<<<< HEAD
                                                      BorderRadius.circular(
                                                          10.0),
=======
                                                      BorderRadius.circular(10),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                ),
                                                filled: true,
                                                fillColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                contentPadding:
<<<<<<< HEAD
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(20.0, 24.0,
                                                            20.0, 24.0),
=======
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            20, 24, 20, 24),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Open Sans',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
<<<<<<< HEAD
                                                        fontSize: 14.0,
=======
                                                        fontSize: 14,
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                        letterSpacing: 0.0,
                                                      ),
                                              maxLines: null,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              validator: _model
                                                  .emailLoginTextControllerValidator
                                                  .asValidator(context),
                                            ),
                                          ),
                                          Padding(
                                            padding:
<<<<<<< HEAD
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 12.0, 20.0, 0.0),
=======
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20, 12, 20, 0),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                            child: TextFormField(
                                              controller: _model
                                                  .passordLoginTextController,
                                              focusNode:
                                                  _model.passordLoginFocusNode,
                                              obscureText: !_model
                                                  .passordLoginVisibility,
                                              decoration: InputDecoration(
                                                labelText: 'Passord',
                                                labelStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily:
                                                              'Open Sans',
<<<<<<< HEAD
                                                          fontSize: 14.0,
=======
                                                          fontSize: 14,
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                          letterSpacing: 0.0,
                                                        ),
                                                hintText:
                                                    'Skriv inn  passord...',
                                                hintStyle: FlutterFlowTheme.of(
                                                        context)
                                                    .bodySmall
                                                    .override(
                                                      fontFamily: 'Open Sans',
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
<<<<<<< HEAD
                                                      fontSize: 14.0,
=======
                                                      fontSize: 14,
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                      letterSpacing: 0.0,
                                                    ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
<<<<<<< HEAD
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
=======
                                                      BorderRadius.circular(10),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                    color: Color(0x00000000),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
<<<<<<< HEAD
                                                      BorderRadius.circular(
                                                          10.0),
=======
                                                      BorderRadius.circular(10),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
<<<<<<< HEAD
                                                      BorderRadius.circular(
                                                          10.0),
=======
                                                      BorderRadius.circular(10),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
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
<<<<<<< HEAD
                                                      BorderRadius.circular(
                                                          10.0),
=======
                                                      BorderRadius.circular(10),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                ),
                                                filled: true,
                                                fillColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                contentPadding:
<<<<<<< HEAD
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(20.0, 24.0,
                                                            20.0, 24.0),
=======
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            20, 24, 20, 24),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                suffixIcon: InkWell(
                                                  onTap: () => safeSetState(
                                                    () => _model
                                                            .passordLoginVisibility =
                                                        !_model
                                                            .passordLoginVisibility,
                                                  ),
                                                  focusNode: FocusNode(
                                                      skipTraversal: true),
                                                  child: Icon(
                                                    _model.passordLoginVisibility
                                                        ? Icons
                                                            .visibility_outlined
                                                        : Icons
                                                            .visibility_off_outlined,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
<<<<<<< HEAD
                                                    size: 20.0,
=======
                                                    size: 20,
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                  ),
                                                ),
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Open Sans',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        letterSpacing: 0.0,
                                                      ),
                                              validator: _model
                                                  .passordLoginTextControllerValidator
                                                  .asValidator(context),
                                            ),
                                          ),
                                          Padding(
                                            padding:
<<<<<<< HEAD
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 24.0, 0.0, 0.0),
=======
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 24, 0, 0),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                            child: FFButtonWidget(
                                              onPressed: () async {
                                                if (_model.formKey1
                                                            .currentState ==
                                                        null ||
                                                    !_model
                                                        .formKey1.currentState!
                                                        .validate()) {
                                                  return;
                                                }

                                                context.goNamed('Hjem');
                                              },
                                              text: 'Logg inn',
<<<<<<< HEAD
                                              icon: const Icon(
                                                Icons.login,
                                                size: 20.0,
                                              ),
                                              options: FFButtonOptions(
                                                width: 230.0,
                                                height: 50.0,
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 0.0),
                                                iconPadding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
=======
                                              icon: Icon(
                                                Icons.login,
                                                size: 20,
                                              ),
                                              options: FFButtonOptions(
                                                width: 230,
                                                height: 50,
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 0, 0),
                                                iconPadding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(0, 0, 0, 0),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                textStyle: FlutterFlowTheme.of(
                                                        context)
                                                    .titleSmall
                                                    .override(
                                                      fontFamily: 'Open Sans',
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
<<<<<<< HEAD
                                                      fontSize: 16.0,
=======
                                                      fontSize: 16,
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
<<<<<<< HEAD
                                                elevation: 3.0,
                                                borderSide: const BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(24.0),
=======
                                                elevation: 3,
                                                borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(24),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
<<<<<<< HEAD
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24.0, 24.0, 24.0, 24.0),
=======
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24, 24, 24, 24),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Form(
                                        key: _model.formKey2,
                                        autovalidateMode:
                                            AutovalidateMode.disabled,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
<<<<<<< HEAD
                                                  padding: const EdgeInsetsDirectional
                                                      .fromSTEB(20.0, 20.0,
                                                          20.0, 0.0),
=======
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(20, 20, 20, 0),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                  child: TextFormField(
                                                    controller: _model
                                                        .epostLagTextController,
                                                    focusNode: _model
                                                        .epostLagFocusNode,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      labelText: 'E-post',
                                                      labelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .override(
                                                                fontFamily:
                                                                    'Open Sans',
<<<<<<< HEAD
                                                                fontSize: 14.0,
=======
                                                                fontSize: 14,
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                      hintText:
                                                          'Skriv inn e-post...',
                                                      hintStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .override(
                                                                fontFamily:
                                                                    'Open Sans',
<<<<<<< HEAD
                                                                fontSize: 14.0,
=======
                                                                fontSize: 14,
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
<<<<<<< HEAD
                                                                .circular(10.0),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: const BorderSide(
=======
                                                                .circular(10),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                          color:
                                                              Color(0x00000000),
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
<<<<<<< HEAD
                                                                .circular(10.0),
=======
                                                                .circular(10),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
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
<<<<<<< HEAD
                                                                .circular(10.0),
=======
                                                                .circular(10),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
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
<<<<<<< HEAD
                                                                .circular(10.0),
=======
                                                                .circular(10),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                      ),
                                                      filled: true,
                                                      fillColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      contentPadding:
<<<<<<< HEAD
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  20.0,
                                                                  24.0,
                                                                  20.0,
                                                                  24.0),
=======
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(20, 24,
                                                                  20, 24),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Open Sans',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
<<<<<<< HEAD
                                                          fontSize: 15.0,
=======
                                                          fontSize: 15,
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                          letterSpacing: 0.0,
                                                        ),
                                                    maxLines: null,
                                                    validator: _model
                                                        .epostLagTextControllerValidator
                                                        .asValidator(context),
                                                  ),
                                                ),
                                                Padding(
<<<<<<< HEAD
                                                  padding: const EdgeInsetsDirectional
                                                      .fromSTEB(20.0, 20.0,
                                                          20.0, 0.0),
=======
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(20, 20, 20, 0),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                  child: TextFormField(
                                                    controller: _model
                                                        .navnLagTextController,
                                                    focusNode:
                                                        _model.navnLagFocusNode,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      labelText: 'Fullt navn',
                                                      labelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .override(
                                                                fontFamily:
                                                                    'Open Sans',
<<<<<<< HEAD
                                                                fontSize: 14.0,
=======
                                                                fontSize: 14,
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                      hintText:
                                                          'Skriv inn fullt navn...',
                                                      hintStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .override(
                                                                fontFamily:
                                                                    'Open Sans',
<<<<<<< HEAD
                                                                fontSize: 14.0,
=======
                                                                fontSize: 14,
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
<<<<<<< HEAD
                                                                .circular(10.0),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: const BorderSide(
=======
                                                                .circular(10),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                          color:
                                                              Color(0x00000000),
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
<<<<<<< HEAD
                                                                .circular(10.0),
=======
                                                                .circular(10),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
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
<<<<<<< HEAD
                                                                .circular(10.0),
=======
                                                                .circular(10),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
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
<<<<<<< HEAD
                                                                .circular(10.0),
=======
                                                                .circular(10),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                      ),
                                                      filled: true,
                                                      fillColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      contentPadding:
<<<<<<< HEAD
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  20.0,
                                                                  24.0,
                                                                  20.0,
                                                                  24.0),
=======
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(20, 24,
                                                                  20, 24),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Open Sans',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
<<<<<<< HEAD
                                                          fontSize: 15.0,
=======
                                                          fontSize: 15,
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                          letterSpacing: 0.0,
                                                        ),
                                                    maxLines: null,
                                                    validator: _model
                                                        .navnLagTextControllerValidator
                                                        .asValidator(context),
                                                  ),
                                                ),
                                                Padding(
<<<<<<< HEAD
                                                  padding: const EdgeInsetsDirectional
                                                      .fromSTEB(20.0, 12.0,
                                                          20.0, 0.0),
=======
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(20, 12, 20, 0),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                  child: TextFormField(
                                                    controller: _model
                                                        .passordLagTextController,
                                                    focusNode: _model
                                                        .passordLagFocusNode,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    obscureText: !_model
                                                        .passordLagVisibility,
                                                    decoration: InputDecoration(
                                                      labelText: 'Passord',
                                                      labelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .override(
                                                                fontFamily:
                                                                    'Open Sans',
<<<<<<< HEAD
                                                                fontSize: 14.0,
=======
                                                                fontSize: 14,
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                      hintText:
                                                          'Skriv inn passord...',
                                                      hintStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .override(
                                                                fontFamily:
                                                                    'Open Sans',
<<<<<<< HEAD
                                                                fontSize: 14.0,
=======
                                                                fontSize: 14,
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
<<<<<<< HEAD
                                                                .circular(10.0),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: const BorderSide(
=======
                                                                .circular(10),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                          color:
                                                              Color(0x00000000),
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
<<<<<<< HEAD
                                                                .circular(10.0),
=======
                                                                .circular(10),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
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
<<<<<<< HEAD
                                                                .circular(10.0),
=======
                                                                .circular(10),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
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
<<<<<<< HEAD
                                                                .circular(10.0),
=======
                                                                .circular(10),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                      ),
                                                      filled: true,
                                                      fillColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      contentPadding:
<<<<<<< HEAD
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  20.0,
                                                                  24.0,
                                                                  20.0,
                                                                  24.0),
=======
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(20, 24,
                                                                  20, 24),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                      suffixIcon: InkWell(
                                                        onTap: () =>
                                                            safeSetState(
                                                          () => _model
                                                                  .passordLagVisibility =
                                                              !_model
                                                                  .passordLagVisibility,
                                                        ),
                                                        focusNode: FocusNode(
                                                            skipTraversal:
                                                                true),
                                                        child: Icon(
                                                          _model.passordLagVisibility
                                                              ? Icons
                                                                  .visibility_outlined
                                                              : Icons
                                                                  .visibility_off_outlined,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
<<<<<<< HEAD
                                                          size: 20.0,
=======
                                                          size: 20,
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                        ),
                                                      ),
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Open Sans',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
<<<<<<< HEAD
                                                          fontSize: 15.0,
=======
                                                          fontSize: 15,
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                          letterSpacing: 0.0,
                                                        ),
                                                    validator: _model
                                                        .passordLagTextControllerValidator
                                                        .asValidator(context),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
<<<<<<< HEAD
                                                      const AlignmentDirectional(
                                                          0.0, -1.0),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 24.0,
                                                                0.0, 0.0),
=======
                                                      AlignmentDirectional(
                                                          0, -1),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 24, 0, 0),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                    child: FFButtonWidget(
                                                      onPressed: () async {
                                                        if (_model.formKey2
                                                                    .currentState ==
                                                                null ||
                                                            !_model.formKey2
                                                                .currentState!
                                                                .validate()) {
                                                          return;
                                                        }

                                                        context.pushNamed(
                                                          'BekreftTLF',
                                                          queryParameters: {
                                                            'bonde':
                                                                serializeParam(
                                                              false,
                                                              ParamType.bool,
                                                            ),
                                                          }.withoutNulls,
                                                        );
                                                      },
                                                      text: 'Fortsett',
<<<<<<< HEAD
                                                      icon: const FaIcon(
                                                        FontAwesomeIcons.check,
                                                        size: 15.0,
                                                      ),
                                                      options: FFButtonOptions(
                                                        width: 230.0,
                                                        height: 50.0,
                                                        padding: const EdgeInsets.all(
                                                            10.0),
                                                        iconPadding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
=======
                                                      icon: FaIcon(
                                                        FontAwesomeIcons.check,
                                                        size: 15,
                                                      ),
                                                      options: FFButtonOptions(
                                                        width: 230,
                                                        height: 50,
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        iconPadding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0, 0, 0, 0),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Open Sans',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
<<<<<<< HEAD
                                                                  fontSize:
                                                                      16.0,
=======
                                                                  fontSize: 16,
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
<<<<<<< HEAD
                                                        elevation: 3.0,
                                                        borderSide: const BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
=======
                                                        elevation: 3,
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
<<<<<<< HEAD
                                                      const AlignmentDirectional(
                                                          0.0, -1.0),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                20.0,
                                                                24.0,
                                                                20.0,
                                                                0.0),
=======
                                                      AlignmentDirectional(
                                                          0, -1),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                20, 24, 20, 0),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                    child: FFButtonWidget(
                                                      onPressed: () async {
                                                        if (_model.formKey2
                                                                    .currentState ==
                                                                null ||
                                                            !_model.formKey2
                                                                .currentState!
                                                                .validate()) {
                                                          return;
                                                        }

                                                        context.pushNamed(
                                                            'RegistrerBonde');
                                                      },
                                                      text:
                                                          'Registrer din bondegård',
<<<<<<< HEAD
                                                      options: FFButtonOptions(
                                                        width: double.infinity,
                                                        height: 50.0,
                                                        padding: const EdgeInsets.all(
                                                            10.0),
                                                        iconPadding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
=======
                                                      icon: Icon(
                                                        Icons
                                                            .agriculture_outlined,
                                                        size: 24,
                                                      ),
                                                      options: FFButtonOptions(
                                                        width: double.infinity,
                                                        height: 50,
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        iconPadding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0, 0, 0, 0),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Open Sans',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .alternate,
<<<<<<< HEAD
                                                                  fontSize:
                                                                      18.0,
=======
                                                                  fontSize: 17,
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
<<<<<<< HEAD
                                                        elevation: 3.0,
                                                        borderSide: const BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
=======
                                                        elevation: 3,
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
<<<<<<< HEAD
                                    ].addToEnd(const SizedBox(height: 150.0)),
=======
                                    ].addToEnd(SizedBox(height: 150)),
>>>>>>> 021215c13c82bcb1e16545d0790d9cd06127f431
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
        ),
      ),
    );
  }
}
