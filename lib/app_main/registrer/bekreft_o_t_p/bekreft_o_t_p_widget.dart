import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';
import 'bekreft_o_t_p_model.dart';
export 'bekreft_o_t_p_model.dart';

class BekreftOTPWidget extends StatefulWidget {
  const BekreftOTPWidget({
    super.key,
    this.bonde,
    required this.email,
    required this.username,
    required this.password,
  });

  final bool? bonde;
  final String? email;
  final String? username;
  final String? password;

  @override
  State<BekreftOTPWidget> createState() => _BekreftOTPWidgetState();
}

class _BekreftOTPWidgetState extends State<BekreftOTPWidget> {
  late BekreftOTPModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BekreftOTPModel());
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
                size: 28.0,
              ),
            ),
            actions: const [],
            centerTitle: true,
            elevation: 0.0,
          ),
          body: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Align(
                    alignment: const AlignmentDirectional(0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            'assets/images/Mobile_login-bro.png',
                            width: 237.0,
                            height: 240.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 0.0),
                          child: Text(
                            'Skriv inn koden vi sendte',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Open Sans',
                                  fontSize: 26.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 10.0, 0.0, 30.0),
                          child: Text(
                            'Vi sendte deg en 4 sifferet kode',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Open Sans',
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                        Form(
                          key: _model.formKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: PinCodeTextField(
                            autoDisposeControllers: false,
                            appContext: context,
                            length: 4,
                            textStyle:
                                FlutterFlowTheme.of(context).bodyLarge.override(
                                      fontFamily: 'Open Sans',
                                      letterSpacing: 0.0,
                                    ),
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            enableActiveFill: false,
                            autoFocus: true,
                            enablePinAutofill: false,
                            errorTextSpace: 16.0,
                            showCursor: true,
                            cursorColor:
                                FlutterFlowTheme.of(context).primaryText,
                            obscureText: false,
                            keyboardType: TextInputType.number,
                            pinTheme: PinTheme(
                              fieldHeight: 60.0,
                              fieldWidth: 45.0,
                              borderWidth: 2.0,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                              shape: PinCodeFieldShape.box,
                              activeColor:
                                  FlutterFlowTheme.of(context).primaryText,
                              inactiveColor:
                                  FlutterFlowTheme.of(context).primaryText,
                              selectedColor:
                                  FlutterFlowTheme.of(context).alternate,
                            ),
                            controller: _model.pinCodeController,
                            onChanged: (_) {},
                            autovalidateMode: AutovalidateMode.disabled,
                            validator: _model.pinCodeControllerValidator
                                .asValidator(context),
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0.0, -1.0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 24.0, 0.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                if (_model.formKey.currentState == null ||
                                    !_model.formKey.currentState!.validate()) {
                                  return;
                                }
                                if (widget.bonde == true) {
                                  context.pushNamed(
                                    'VelgPosisjon',
                                    queryParameters: {
                                      'bonde': serializeParam(
                                        true,
                                        ParamType.bool,
                                      ),
                                      'endrepos': serializeParam(
                                        false,
                                        ParamType.bool,
                                      ),
                                      'email': serializeParam(
                                        widget.email,
                                        ParamType.String,
                                      ),
                                      'fullname': serializeParam(
                                        widget.username,
                                        ParamType.String,
                                      ),
                                      'password': serializeParam(
                                        widget.password,
                                        ParamType.String,
                                      ),
                                    }.withoutNulls,
                                  );
                                } else {
                                  context.pushNamed(
                                    'VelgPosisjon',
                                    queryParameters: {
                                      'bonde': serializeParam(
                                        false,
                                        ParamType.bool,
                                      ),
                                      'endrepos': serializeParam(
                                        false,
                                        ParamType.bool,
                                      ),
                                      'email': serializeParam(
                                        widget.email,
                                        ParamType.String,
                                      ),
                                      'fullname': serializeParam(
                                        widget.username,
                                        ParamType.String,
                                      ),
                                      'password': serializeParam(
                                        widget.password,
                                        ParamType.String,
                                      ),
                                    }.withoutNulls,
                                  );
                                }
                              },
                              text: 'Bekreft',
                              options: FFButtonOptions(
                                width: 230.0,
                                height: 50.0,
                                padding: const EdgeInsets.all(10.0),
                                iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).alternate,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Open Sans',
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      fontSize: 17.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                elevation: 3.0,
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
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
    );
  }
}
