import 'dart:io';
import 'package:decimal/decimal.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mat_salg/ApiCalls.dart';
import 'package:mat_salg/MyIP.dart';
import 'package:mat_salg/SecureStorage.dart';
import 'package:mat_salg/app_main/vanlig_bruker/hjem/betaling/velgBetalingsmetode/velg_betaling_widget.dart';
import 'package:mat_salg/flutter_flow/flutter_flow_widgets.dart';
import 'package:mat_salg/matvarer.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'betaling_model.dart';
export 'betaling_model.dart';

class BetalingWidget extends StatefulWidget {
  const BetalingWidget({
    super.key,
    this.matinfo,
  });

  final dynamic matinfo;

  @override
  State<BetalingWidget> createState() => _BetalingWidgetState();
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

class _BetalingWidgetState extends State<BetalingWidget> {
  late BetalingModel _model;
  bool _isLoading = false;
  int matpris = 1;
  bool isFocused = false;
  double _selectedValue = 0.0;
  int kjopsBeskyttelse = 2;
  bool applePay = true;

  late Matvarer matvare;
  final Securestorage securestorage = Securestorage();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BetalingModel());
    _model.antallStkTextController ??= TextEditingController();
    _model.antallStkFocusNode ??= FocusNode();
    matvare = Matvarer.fromJson1(widget.matinfo);
    matpris = matvare.price ?? 1;

    kjopsBeskyttelse = ((_selectedValue * matpris * 0.05 + 2).round());
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
                      fontWeight: FontWeight.bold,
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
          backgroundColor: FlutterFlowTheme.of(context).primary,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).alternate),
            automaticallyImplyLeading: true,
            scrolledUnderElevation: 0.0,
            leading: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                context.pop();
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 28,
              ),
            ),
            title: Text(
              'Kjøp',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Nunito',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 17,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            actions: [],
            centerTitle: true,
            elevation: 0,
          ),
          body: SafeArea(
            top: true,
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                18, 10, 12, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 10, 16),
                                  child: Material(
                                    color: Colors.transparent,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Container(
                                      height: 107,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        borderRadius: BorderRadius.circular(24),
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 1, 1, 1),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: Image.network(
                                                  '${ApiConstants.baseUrl}${matvare.imgUrls![0].toString()}',
                                                  width: 64,
                                                  height: 64,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (BuildContext
                                                          context,
                                                      Object error,
                                                      StackTrace? stackTrace) {
                                                    return Image.asset(
                                                      'assets/images/error_image.jpg', // Path to your local error image
                                                      height: 64,
                                                      width: 64,
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(12, 0, 4, 0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0, 0, 0, 0),
                                                          child: Text(
                                                            matvare.name ?? '',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .headlineSmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  fontSize: 16,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0, 3, 0, 0),
                                                          child: Text(
                                                            'Tilgjengelig: ${matvare.antall!.toStringAsFixed(0)} Stk',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .headlineSmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  fontSize: 14,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
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
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              0, 0, 0, 0),
                                                      child: Text(
                                                        '${matvare.price} Kr',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineSmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  fontSize: 15,
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
                                  ),
                                ),
                                const Divider(
                                  thickness: 1.2,
                                  indent: 15,
                                  endIndent: 15,
                                  color: Color.fromRGBO(234, 234, 234, 1.0),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 12, 0, 0),
                                  child: Text(
                                    'Antall',
                                    textAlign: TextAlign.start,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Nunito',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 19.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 10, 0, 0),
                                  child: Text(
                                    'Skriv inn antallet du ønsker å kjøpe',
                                    textAlign: TextAlign.start,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Nunito',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 14,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                                Form(
                                  key: _model.formKey,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  child: Align(
                                    alignment:
                                        const AlignmentDirectional(0.0, 0.0),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 12.0, 16.0, 16.0),
                                      child: TextFormField(
                                        controller:
                                            _model.antallStkTextController,
                                        focusNode: _model.antallStkFocusNode,
                                        onChanged: (_) => EasyDebounce.debounce(
                                          '_model.antallStkTextController',
                                          const Duration(milliseconds: 300),
                                          () => safeSetState(() {}),
                                        ),
                                        textCapitalization:
                                            TextCapitalization.none,
                                        obscureText: false,
                                        readOnly: true, // Disable the keyboard
                                        decoration: InputDecoration(
                                          labelText: 'Antall',
                                          labelStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily: 'Nunito',
                                                    color: const Color.fromRGBO(
                                                        113, 113, 113, 1.0),
                                                    fontSize: 17.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                          alignLabelWithHint: false,
                                          hintText: 'Skriv inn antall',
                                          hintStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .override(
                                                    fontFamily: 'Nunito',
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0x00000000),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          filled: true,
                                          fillColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondary,
                                          contentPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                  20.0, 30.0, 0.0, 0.0),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Nunito',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 17.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                        maxLength: 5,
                                        maxLengthEnforcement:
                                            MaxLengthEnforcement.enforced,
                                        buildCounter: (context,
                                                {required currentLength,
                                                required isFocused,
                                                maxLength}) =>
                                            null,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        validator: _model
                                            .antallStkTextControllerValidator
                                            .asValidator(context),
                                        onTap: () {
                                          List<double> getPickerValues() {
                                            List<double> values = [];
                                            double step;

                                            step = 1.0;
                                            double antall =
                                                matvare.antall as double;
                                            for (double i = 1.0;
                                                i <= antall;
                                                i += step) {
                                              values.add(i);
                                            }

                                            return values;
                                          }

                                          showCupertinoModalPopup(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CupertinoActionSheet(
                                                title:
                                                    const Text('Velg antall'),
                                                message: Column(
                                                  children: [
                                                    Container(
                                                      height:
                                                          200, // Set a fixed height for the picker
                                                      child: CupertinoPicker(
                                                        itemExtent:
                                                            32.0, // Height of each item
                                                        scrollController:
                                                            FixedExtentScrollController(
                                                          initialItem:
                                                              getPickerValues()
                                                                  .indexOf(
                                                                      _selectedValue), // Set initial value
                                                        ),
                                                        onSelectedItemChanged:
                                                            (index) {
                                                          setState(() {
                                                            _selectedValue =
                                                                getPickerValues()[
                                                                    index];
                                                            // Update the TextFormField value with the selected value
                                                            _model.antallStkTextController
                                                                    .text =
                                                                _selectedValue
                                                                    .toStringAsFixed(
                                                                        0);

                                                            kjopsBeskyttelse =
                                                                (_selectedValue *
                                                                            matpris *
                                                                            0.05 +
                                                                        2)
                                                                    .round();
                                                            // Trigger light haptic feedback on each tick/value change
                                                            HapticFeedback
                                                                .lightImpact();
                                                          });
                                                        },
                                                        children:
                                                            getPickerValues()
                                                                .map(
                                                                    (value) =>
                                                                        Center(
                                                                          child:
                                                                              Text(value.toStringAsFixed(0)),
                                                                        ))
                                                                .toList(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                cancelButton:
                                                    CupertinoActionSheetAction(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Velg',
                                                      style: TextStyle(
                                                        fontSize: 19,
                                                        color: CupertinoColors
                                                            .systemBlue,
                                                      )),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const Divider(
                                  thickness: 1.2,
                                  indent: 15,
                                  endIndent: 15,
                                  color: Color.fromRGBO(234, 234, 234, 1.0),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 30, 0, 0),
                                  child: Text(
                                    'Betaling',
                                    textAlign: TextAlign.start,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Nunito',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 19.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 10, 0, 0),
                                      child: Text(
                                        matvare.name ?? '',
                                        textAlign: TextAlign.start,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Nunito',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 15,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 10, 20, 0),
                                      child: Text(
                                        '${((_selectedValue * matpris).toStringAsFixed(
                                          ((_selectedValue * matpris) % 1 == 0)
                                              ? 0
                                              : 2,
                                        ))} Kr',
                                        textAlign: TextAlign.start,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Nunito',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 15,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 30),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 10, 0, 0),
                                        child: Text(
                                          'Kjøpsbeskyttelse',
                                          textAlign: TextAlign.start,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Nunito',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 15,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 10, 20, 0),
                                        child: Text(
                                          '${kjopsBeskyttelse.toString()} Kr',
                                          textAlign: TextAlign.start,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Nunito',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 15,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  thickness: 1.2,
                                  indent: 15,
                                  endIndent: 15,
                                  color: Color.fromRGBO(234, 234, 234, 1.0),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                18, 30, 12, 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          'Totalt å betale',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Nunito',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontSize: 20.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          ((_selectedValue * matpris +
                                                  kjopsBeskyttelse)
                                              .toStringAsFixed(
                                            ((_selectedValue * matpris +
                                                            kjopsBeskyttelse) %
                                                        1 ==
                                                    0)
                                                ? 0
                                                : 2,
                                          )),
                                          style: FlutterFlowTheme.of(context)
                                              .displaySmall
                                              .override(
                                                fontFamily: 'Nunito',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontSize: 20,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(5, 0, 0, 0),
                                          child: Text(
                                            'Kr',
                                            style: FlutterFlowTheme.of(context)
                                                .displaySmall
                                                .override(
                                                  fontFamily: 'Nunito',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  fontSize: 20,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment:
                                      const AlignmentDirectional(-1.0, 0.0),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 12.0, 0.0, 16.0),
                                    child: Text.rich(
                                      TextSpan(
                                        text: 'Vi gjør dine kjøp tryggere med ',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Nunito',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                        children: [
                                          TextSpan(
                                            text: 'matsalg.no kjøpsbeskyttelse',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Nunito',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.normal,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              try {
                                FocusScope.of(context).unfocus();
                                bool? velgBetal =
                                    await showModalBottomSheet<bool?>(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  barrierColor:
                                      const Color.fromARGB(60, 17, 0, 0),
                                  context: context,
                                  builder: (context) {
                                    return GestureDetector(
                                      onTap: () =>
                                          FocusScope.of(context).unfocus(),
                                      child: Padding(
                                        padding:
                                            MediaQuery.viewInsetsOf(context),
                                        child: const VelgBetalingWidget(),
                                      ),
                                    );
                                  },
                                );

                                setState(() {
                                  if (velgBetal != null) {
                                    applePay = true;
                                    isFocused = true;
                                  }
                                });
                              } catch (e) {
                                HapticFeedback.lightImpact();
                                showErrorToast(context, 'En feil oppstod');
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    width: MediaQuery.sizeOf(context).width,
                                    height: 57,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            applePay == true
                                                ? FaIcon(
                                                    FontAwesomeIcons.ccApplePay,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    size: 24,
                                                  )
                                                : Icon(
                                                    CupertinoIcons.creditcard,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    size: 25,
                                                  ),
                                            const SizedBox(width: 15),
                                            Text(
                                              applePay == true
                                                  ? 'Apple Pay'
                                                  : 'Velg betalingsmetode ...',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily: 'Nunito',
                                                    color: applePay == true
                                                        ? Colors.black
                                                        : const Color.fromRGBO(
                                                            113, 113, 113, 1.0),
                                                    fontSize: 17.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          CupertinoIcons.chevron_forward,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          size: 22,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isFocused || applePay == true)
                                    Positioned(
                                      top: -10,
                                      left: 18,
                                      child: Container(
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: Text(
                                          'Betalingsmetode',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                fontFamily: 'Nunito',
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.bold,
                                                color: const Color.fromRGBO(
                                                    113, 113, 113, 1.0),
                                              ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                15, 43, 15, 0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                if (_isLoading == true) {
                                  return;
                                }
                                if (_model.formKey.currentState == null ||
                                    !_model.formKey.currentState!.validate()) {
                                  print(_model.antallStkTextController.text);
                                  return;
                                }
                                if (_selectedValue * matpris +
                                        kjopsBeskyttelse <=
                                    30) {
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CupertinoAlertDialog(
                                        title: const Text(
                                            'Du må handle for minst 30 kr'),
                                        actions: <Widget>[
                                          CupertinoDialogAction(
                                            onPressed: () {
                                              _isLoading = false;
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Okei',
                                              style: TextStyle(
                                                  color: Colors
                                                      .blue), // Blue for 'Nei'
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  _isLoading = false;
                                  return;
                                }
                                try {
                                  _isLoading = true;
                                  if (matvare.matId != null &&
                                      _model.antallStkTextController.text
                                          .isNotEmpty) {
                                    Decimal antall = Decimal.parse(
                                        _selectedValue.toString());
                                    Decimal pris = Decimal.parse(
                                        (_selectedValue * matpris +
                                                kjopsBeskyttelse)
                                            .toString());
                                    int matId = matvare.matId ?? 0;
                                    if (matvare.matId != null) {
                                      String? token =
                                          await Securestorage().readToken();
                                      if (token == null) {
                                        FFAppState().login = false;
                                        context.goNamed('registrer');
                                        return;
                                      } else {
                                        if (matId != 0) {
                                          final response = await ApiKjop()
                                              .kjopMat(
                                                  matId: matId,
                                                  price: pris,
                                                  antall: antall,
                                                  token: token);
                                          if (response.statusCode == 200) {
                                            context.goNamed('Godkjentbetaling');
                                          }
                                        } else {
                                          _isLoading = false;
                                          throw (Exception);
                                        }
                                      }
                                    } else {
                                      _isLoading = false;
                                      throw (Exception);
                                    }
                                  }
                                } on SocketException {
                                  HapticFeedback.lightImpact();
                                  showErrorToast(
                                      context, 'Ingen internettforbindelse');
                                } catch (e) {
                                  HapticFeedback.lightImpact();
                                  showErrorToast(context, 'En feil oppstod');
                                }
                              },
                              text: 'Gi bud',
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 50,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 0, 16, 0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                color: FlutterFlowTheme.of(context).alternate,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Nunito',
                                      color: Colors.white,
                                      fontSize: 17,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                elevation: 0,
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 5, 0, 0),
                            child: Text(
                              'Ved å fullføre handelen godtar du våre vilkår',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Nunito',
                                    fontSize: 13,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
