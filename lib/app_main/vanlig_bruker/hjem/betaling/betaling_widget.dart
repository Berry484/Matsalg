import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mat_salg/ApiCalls.dart';
import 'package:mat_salg/MyIP.dart';
import 'package:mat_salg/SecureStorage.dart';
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
  double _selectedValue = 0.0;

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
                color: FlutterFlowTheme.of(context).primaryText,
                size: 28,
              ),
            ),
            title: Text(
              'Kjøp',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Montserrat',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 20,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              12, 20, 12, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 30, 10, 20),
                                child: Material(
                                  color: Colors.transparent,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Container(
                                    height: 107,
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      borderRadius: BorderRadius.circular(24),
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 1, 1, 1),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: Image.network(
                                                '${ApiConstants.baseUrl}${matvare.imgUrls![0].toString()}',
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                                errorBuilder: (BuildContext
                                                        context,
                                                    Object error,
                                                    StackTrace? stackTrace) {
                                                  return Image.asset(
                                                    'assets/images/error_image.jpg', // Path to your local error image
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
                                                      .fromSTEB(8, 0, 4, 0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0, 10, 0, 0),
                                                    child: Text(
                                                      matvare.name ?? '',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .headlineSmall
                                                          .override(
                                                            fontFamily:
                                                                'Open Sans',
                                                            fontSize: 22,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        1, 1),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0, 0, 0, 10),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                0, 12, 0, 0),
                                                        child: Text(
                                                          '${matvare.price} Kr',
                                                          textAlign:
                                                              TextAlign.end,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Open Sans',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontSize: 18,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                      ),
                                                      if (matvare.kg == true)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0, 12, 4, 0),
                                                          child: Text(
                                                            '/kg',
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Open Sans',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  fontSize: 18,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                          ),
                                                        ),
                                                      if (matvare.kg != true)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0, 12, 4, 0),
                                                          child: Text(
                                                            '/stk',
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Open Sans',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  fontSize: 18,
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
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Divider(
                                thickness: 1,
                                indent: 30,
                                endIndent: 30,
                                color: Color(0x62757575),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 30, 0, 0),
                                child: Text(
                                  'Antall',
                                  textAlign: TextAlign.start,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Open Sans',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: 22,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
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
                                        fontFamily: 'Open Sans',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: 13,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, 30),
                                child: Form(
                                  key: _model.formKey,
                                  autovalidateMode: AutovalidateMode.disabled,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 20, 0, 20),
                                        child: Stack(
                                          alignment: const AlignmentDirectional(
                                              1, -0.3),
                                          children: [
                                            TextFormField(
                                              controller: _model
                                                  .antallStkTextController,
                                              focusNode:
                                                  _model.antallStkFocusNode,
                                              obscureText: false,
                                              readOnly:
                                                  true, // Disable the keyboard
                                              decoration: InputDecoration(
                                                labelText: 'Antall',
                                                labelStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              'Open Sans',
                                                          fontSize: 16,
                                                          letterSpacing: 0.0,
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
                                                    color: Colors.transparent,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
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
                                                      BorderRadius.circular(20),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
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
                                                      BorderRadius.circular(20),
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
                                                        fontFamily: 'Open Sans',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontSize: 16,
                                                        letterSpacing: 0.0,
                                                      ),
                                              maxLength: 5,
                                              maxLengthEnforcement:
                                                  MaxLengthEnforcement.enforced,
                                              buildCounter: (context,
                                                      {required currentLength,
                                                      required isFocused,
                                                      maxLength}) =>
                                                  null,
                                              validator: _model
                                                  .antallStkTextControllerValidator
                                                  .asValidator(context),
                                              onTap: () {
                                                List<double> getPickerValues() {
                                                  List<double> values = [];
                                                  double step = matvare.kg ==
                                                          true
                                                      ? 0.1
                                                      : 1.0; // Choose step size based on matvare.kg

                                                  double antall =
                                                      matvare.antall ?? 0.0;

                                                  // Add values from 0.0 up to and including antall
                                                  for (double i = 0.0;
                                                      i <= antall + step / 2;
                                                      i += step) {
                                                    if ((i - antall).abs() <
                                                        0.0000001) {
                                                      values.add(
                                                          antall); // Add antall exactly if i is very close to antall
                                                      break; // Break out of the loop to avoid adding further values
                                                    }
                                                    values.add(i);
                                                  }
                                                  return values;
                                                }

                                                showCupertinoModalPopup(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return CupertinoActionSheet(
                                                      title:
                                                          Text('Velg antall'),
                                                      message: Column(
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
                                                                              1);

                                                                  // Trigger light haptic feedback on each tick/value change
                                                                  HapticFeedback
                                                                      .lightImpact();
                                                                });
                                                              },
                                                              children:
                                                                  getPickerValues()
                                                                      .map((value) =>
                                                                          Center(
                                                                            child:
                                                                                Text(value.toStringAsFixed(1)),
                                                                          ))
                                                                      .toList(),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      cancelButton:
                                                          CupertinoActionSheetAction(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('Velg'),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                            if (matvare.kg != true)
                                              Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        0.8, 0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(0, 7, 0, 0),
                                                  child: Text(
                                                    'Stk',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Open Sans',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 17,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            if (matvare.kg == true)
                                              Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        0.8, -0.19),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(0, 7, 0, 0),
                                                  child: Text(
                                                    'Kg',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Open Sans',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 17,
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
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                thickness: 1,
                                indent: 30,
                                endIndent: 30,
                                color: Color(0x62757575),
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
                                        fontFamily: 'Open Sans',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: 22,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
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
                                            fontFamily: 'Open Sans',
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            fontSize: 14,
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
                                      '${(_selectedValue * matpris).toStringAsFixed(
                                        ((_selectedValue * matpris) % 1 == 0)
                                            ? 0
                                            : 0,
                                      )} Kr',
                                      textAlign: TextAlign.start,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Open Sans',
                                            color: FlutterFlowTheme.of(context)
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
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 10, 0, 0),
                                      child: Text(
                                        'Kjøpsbeskyttelse',
                                        textAlign: TextAlign.start,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Open Sans',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 14,
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
                                        '${(_selectedValue * matpris * 0.05 + 2).toStringAsFixed(
                                          ((_selectedValue * matpris * 0.05 +
                                                          2) %
                                                      1 ==
                                                  0)
                                              ? 0
                                              : 2,
                                        )} Kr',
                                        textAlign: TextAlign.start,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Open Sans',
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
                                thickness: 1,
                                indent: 30,
                                endIndent: 30,
                                color: Color(0x62757575),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              12, 30, 12, 16),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Totalt å betale',
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily: 'Open Sans',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 20,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    ((_selectedValue * matpris * 1.05 + 2)
                                        .toStringAsFixed(
                                      ((_selectedValue * matpris * 1.05 + 2) %
                                                  1 ==
                                              0)
                                          ? 0
                                          : 2,
                                    )),
                                    style: FlutterFlowTheme.of(context)
                                        .displaySmall
                                        .override(
                                          fontFamily: 'Open Sans',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 23,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            5, 0, 0, 0),
                                    child: Text(
                                      'Kr',
                                      style: FlutterFlowTheme.of(context)
                                          .displaySmall
                                          .override(
                                            fontFamily: 'Open Sans',
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            fontSize: 23,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
                                return;
                              }
                              try {
                                _isLoading = true;
                                if (matvare.matId != null &&
                                    _model.antallStkTextController.text
                                        .isNotEmpty) {
                                  Decimal antall =
                                      Decimal.parse(_selectedValue.toString());
                                  Decimal pris = Decimal.parse(
                                      (_selectedValue * matpris * 1.05 + 2)
                                          .toString());
                                  int matId = matvare.matId ?? 0;
                                  if (matvare.matId != null) {
                                    String? token =
                                        await Securestorage().readToken();
                                    if (token == null) {
                                      FFAppState().login = false;
                                      context.pushNamed('registrer');
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
                                          context.pushNamed('Godkjentbetaling');
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
                                showErrorToast(
                                    context, 'Ingen internettforbindelse');
                              } catch (e) {
                                showErrorToast(context, 'En feil oppstod');
                              }
                            },
                            text: 'Gi bud',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 45,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 0, 16, 0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 0),
                              color: FlutterFlowTheme.of(context).alternate,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Open Sans',
                                    color: Colors.white,
                                    fontSize: 17,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                              elevation: 0,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                          child: Text(
                            'Ved å fullføre handelen godtar du våre vilkår',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Open Sans',
                                  fontSize: 13,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ].addToEnd(const SizedBox(height: 100)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// class BetalingWidget extends StatefulWidget {
//   const BetalingWidget({
//     super.key,
//     this.matinfo,
//   });

//   final dynamic matinfo;

//   @override
//   State<BetalingWidget> createState() => _BetalingWidgetState();
// }

// class _BetalingWidgetState extends State<BetalingWidget> {
//   late BetalingModel _model;
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//   int matpris = 1;
//   late Matvarer matvare;
//   bool _isLoading = false;
//   final Securestorage securestorage = Securestorage();

//   @override
//   void initState() {
//     super.initState();
//     _model = createModel(context, () => BetalingModel());

//     _model.antallStkTextController ??= TextEditingController();
//     _model.antallStkFocusNode ??= FocusNode();

//     matvare = Matvarer.fromJson1(widget.matinfo);
//     matpris = matvare.price ?? 1;
//   }

//   void showErrorToast(BuildContext context, String message) {
//     final overlay = Overlay.of(context);
//     final overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         top: 50.0,
//         left: 16.0,
//         right: 16.0,
//         child: Material(
//           color: Colors.transparent,
//           child: Container(
//             padding:
//                 const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10.0),
//               boxShadow: [
//                 BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8)
//               ],
//             ),
//             child: Row(
//               children: [
//                 const Icon(
//                   FontAwesomeIcons.solidTimesCircle,
//                   color: Colors.black,
//                   size: 30.0,
//                 ),
//                 const SizedBox(width: 15),
//                 Expanded(
//                   child: Text(
//                     message,
//                     style: const TextStyle(
//                       color: Colors.black,
//                       fontSize: 16.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );

//     overlay.insert(overlayEntry);

//     Future.delayed(const Duration(seconds: 3), () {
//       overlayEntry.remove();
//     });
//   }

//   @override
//   void dispose() {
//     _model.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: WillPopScope(
//         onWillPop: () async => false,
//         child: Scaffold(
//           key: scaffoldKey,
//           backgroundColor: FlutterFlowTheme.of(context).primary,
//           appBar: AppBar(
//             backgroundColor: FlutterFlowTheme.of(context).primary,
//             iconTheme:
//                 IconThemeData(color: FlutterFlowTheme.of(context).alternate),
//             automaticallyImplyLeading: true,
//             leading: InkWell(
//               splashColor: Colors.transparent,
//               focusColor: Colors.transparent,
//               hoverColor: Colors.transparent,
//               highlightColor: Colors.transparent,
//               onTap: () async {
//                 context.safePop();
//               },
//               child: Icon(
//                 Icons.arrow_back_ios,
//                 color: FlutterFlowTheme.of(context).alternate,
//                 size: 28,
//               ),
//             ),
//             title: Text(
//               'Kjøpsforespørsel',
//               textAlign: TextAlign.center,
//               style: FlutterFlowTheme.of(context).bodyMedium.override(
//                     fontFamily: 'Montserrat',
//                     color: FlutterFlowTheme.of(context).primaryText,
//                     fontSize: 20,
//                     letterSpacing: 0.0,
//                     fontWeight: FontWeight.w600,
//                   ),
//             ),
//             actions: [],
//             centerTitle: true,
//             elevation: 0,
//           ),
//           body: SafeArea(
//             top: true,
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsetsDirectional.fromSTEB(12, 40, 0, 0),
//                     child: Text(
//                       'Fint å vite',
//                       textAlign: TextAlign.start,
//                       style: FlutterFlowTheme.of(context).bodyMedium.override(
//                             fontFamily: 'Open Sans',
//                             color: FlutterFlowTheme.of(context).primaryText,
//                             fontSize: 20,
//                             letterSpacing: 0.0,
//                             fontWeight: FontWeight.w600,
//                           ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 40),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.max,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding:
//                               const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.max,
//                             children: [
//                               Text(
//                                 '1.',
//                                 textAlign: TextAlign.start,
//                                 style: FlutterFlowTheme.of(context)
//                                     .bodyMedium
//                                     .override(
//                                       fontFamily: 'Open Sans',
//                                       color: FlutterFlowTheme.of(context)
//                                           .primaryText,
//                                       fontSize: 14,
//                                       letterSpacing: 0.0,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsetsDirectional.fromSTEB(
//                                     12, 0, 0, 0),
//                                 child: Text(
//                                   'Når du sender en kjøpsforespørsel, \nmå du fullføre kjøpet hvis selgeren godtar.',
//                                   textAlign: TextAlign.start,
//                                   style: FlutterFlowTheme.of(context)
//                                       .bodyMedium
//                                       .override(
//                                         fontFamily: 'Open Sans',
//                                         color: FlutterFlowTheme.of(context)
//                                             .primaryText,
//                                         fontSize: 12,
//                                         letterSpacing: 0.0,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding:
//                               const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.max,
//                             children: [
//                               Text(
//                                 '2.',
//                                 textAlign: TextAlign.start,
//                                 style: FlutterFlowTheme.of(context)
//                                     .bodyMedium
//                                     .override(
//                                       fontFamily: 'Open Sans',
//                                       color: FlutterFlowTheme.of(context)
//                                           .primaryText,
//                                       fontSize: 14,
//                                       letterSpacing: 0.0,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsetsDirectional.fromSTEB(
//                                     12, 0, 0, 0),
//                                 child: Text(
//                                   ' Selgeren har 3 dager til å godta, \nellers får du pengene tilbake.',
//                                   textAlign: TextAlign.start,
//                                   style: FlutterFlowTheme.of(context)
//                                       .bodyMedium
//                                       .override(
//                                         fontFamily: 'Open Sans',
//                                         color: FlutterFlowTheme.of(context)
//                                             .primaryText,
//                                         fontSize: 12,
//                                         letterSpacing: 0.0,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding:
//                               const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.max,
//                             children: [
//                               Text(
//                                 '3.',
//                                 textAlign: TextAlign.start,
//                                 style: FlutterFlowTheme.of(context)
//                                     .bodyMedium
//                                     .override(
//                                       fontFamily: 'Open Sans',
//                                       color: FlutterFlowTheme.of(context)
//                                           .primaryText,
//                                       fontSize: 14,
//                                       letterSpacing: 0.0,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsetsDirectional.fromSTEB(
//                                     12, 0, 0, 0),
//                                 child: Text(
//                                   'Ta gjerne kontakt med selgeren i appen',
//                                   textAlign: TextAlign.start,
//                                   style: FlutterFlowTheme.of(context)
//                                       .bodyMedium
//                                       .override(
//                                         fontFamily: 'Open Sans',
//                                         color: FlutterFlowTheme.of(context)
//                                             .primaryText,
//                                         fontSize: 12,
//                                         letterSpacing: 0.0,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 32),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsetsDirectional.fromSTEB(
//                               12, 0, 0, 30),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.max,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsetsDirectional.fromSTEB(
//                                     0, 30, 10, 20),
//                                 child: Material(
//                                   color: Colors.transparent,
//                                   elevation: 0,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(24),
//                                   ),
//                                   child: Container(
//                                     height: 107,
//                                     decoration: BoxDecoration(
//                                       color:
//                                           FlutterFlowTheme.of(context).primary,
//                                       borderRadius: BorderRadius.circular(24),
//                                       shape: BoxShape.rectangle,
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8),
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.max,
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsetsDirectional
//                                                 .fromSTEB(0, 1, 1, 1),
//                                             child: ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(6),
//                                               child: Image.network(
//                                                 '${ApiConstants.baseUrl}${matvare.imgUrls![0].toString()}',
//                                                 width: 80,
//                                                 height: 80,
//                                                 fit: BoxFit.cover,
//                                                 errorBuilder: (BuildContext
//                                                         context,
//                                                     Object error,
//                                                     StackTrace? stackTrace) {
//                                                   return Image.asset(
//                                                     'assets/images/error_image.jpg', // Path to your local error image
//                                                     fit: BoxFit.cover,
//                                                   );
//                                                 },
//                                               ),
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsetsDirectional
//                                                       .fromSTEB(8, 0, 4, 0),
//                                               child: Column(
//                                                 mainAxisSize: MainAxisSize.max,
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Padding(
//                                                     padding:
//                                                         const EdgeInsetsDirectional
//                                                             .fromSTEB(
//                                                             0, 10, 0, 0),
//                                                     child: Text(
//                                                       matvare.name ?? '',
//                                                       style: FlutterFlowTheme
//                                                               .of(context)
//                                                           .headlineSmall
//                                                           .override(
//                                                             fontFamily:
//                                                                 'Open Sans',
//                                                             fontSize: 22,
//                                                             letterSpacing: 0.0,
//                                                             fontWeight:
//                                                                 FontWeight.w500,
//                                                           ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                           Column(
//                                             mainAxisSize: MainAxisSize.max,
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.end,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.end,
//                                             children: [
//                                               Align(
//                                                 alignment:
//                                                     const AlignmentDirectional(
//                                                         1, 1),
//                                                 child: Padding(
//                                                   padding:
//                                                       const EdgeInsetsDirectional
//                                                           .fromSTEB(
//                                                           0, 0, 0, 10),
//                                                   child: Row(
//                                                     mainAxisSize:
//                                                         MainAxisSize.max,
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment.end,
//                                                     children: [
//                                                       Padding(
//                                                         padding:
//                                                             const EdgeInsetsDirectional
//                                                                 .fromSTEB(
//                                                                 0, 12, 0, 0),
//                                                         child: Text(
//                                                           '${matvare.price ?? 0} Kr',
//                                                           textAlign:
//                                                               TextAlign.end,
//                                                           style: FlutterFlowTheme
//                                                                   .of(context)
//                                                               .bodyMedium
//                                                               .override(
//                                                                 fontFamily:
//                                                                     'Open Sans',
//                                                                 color: FlutterFlowTheme.of(
//                                                                         context)
//                                                                     .alternate,
//                                                                 fontSize: 18,
//                                                                 letterSpacing:
//                                                                     0.0,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold,
//                                                               ),
//                                                         ),
//                                                       ),
//                                                       if (matvare.kg == true)
//                                                         Padding(
//                                                           padding:
//                                                               const EdgeInsetsDirectional
//                                                                   .fromSTEB(
//                                                                   0, 12, 4, 0),
//                                                           child: Text(
//                                                             '/kg',
//                                                             textAlign:
//                                                                 TextAlign.end,
//                                                             style: FlutterFlowTheme
//                                                                     .of(context)
//                                                                 .bodyMedium
//                                                                 .override(
//                                                                   fontFamily:
//                                                                       'Open Sans',
//                                                                   color: FlutterFlowTheme.of(
//                                                                           context)
//                                                                       .secondaryText,
//                                                                   fontSize: 18,
//                                                                   letterSpacing:
//                                                                       0.0,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w600,
//                                                                 ),
//                                                           ),
//                                                         ),
//                                                       if (matvare.kg != true)
//                                                         Padding(
//                                                           padding:
//                                                               const EdgeInsetsDirectional
//                                                                   .fromSTEB(
//                                                                   0, 12, 4, 0),
//                                                           child: Text(
//                                                             '/stk',
//                                                             textAlign:
//                                                                 TextAlign.end,
//                                                             style: FlutterFlowTheme
//                                                                     .of(context)
//                                                                 .bodyMedium
//                                                                 .override(
//                                                                   fontFamily:
//                                                                       'Open Sans',
//                                                                   color: FlutterFlowTheme.of(
//                                                                           context)
//                                                                       .secondaryText,
//                                                                   fontSize: 18,
//                                                                   letterSpacing:
//                                                                       0.0,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w600,
//                                                                 ),
//                                                           ),
//                                                         ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsetsDirectional.fromSTEB(
//                                     0, 30, 0, 0),
//                                 child: Text(
//                                   'Antall',
//                                   textAlign: TextAlign.start,
//                                   style: FlutterFlowTheme.of(context)
//                                       .bodyMedium
//                                       .override(
//                                         fontFamily: 'Open Sans',
//                                         color: FlutterFlowTheme.of(context)
//                                             .primaryText,
//                                         fontSize: 22,
//                                         letterSpacing: 0.0,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsetsDirectional.fromSTEB(
//                                     0, 10, 0, 0),
//                                 child: Text(
//                                   'Skriv inn antallet du ønsker å kjøpe',
//                                   textAlign: TextAlign.start,
//                                   style: FlutterFlowTheme.of(context)
//                                       .bodyMedium
//                                       .override(
//                                         fontFamily: 'Open Sans',
//                                         color: FlutterFlowTheme.of(context)
//                                             .primaryText,
//                                         fontSize: 13,
//                                         letterSpacing: 0.0,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                 ),
//                               ),
//                               Form(
//                                 key: _model.formKey,
//                                 autovalidateMode: AutovalidateMode.disabled,
//                                 child: Padding(
//                                   padding: const EdgeInsetsDirectional.fromSTEB(
//                                       15, 20, 15, 20),
//                                   child: Stack(
//                                     alignment:
//                                         const AlignmentDirectional(1, -0.3),
//                                     children: [
//                                       Align(
//                                         alignment:
//                                             const AlignmentDirectional(0, 0),
//                                         child: Padding(
//                                           padding: const EdgeInsetsDirectional
//                                               .fromSTEB(0, 0, 20, 0),
//                                           child: TextFormField(
//                                             controller:
//                                                 _model.antallStkTextController,
//                                             focusNode:
//                                                 _model.antallStkFocusNode,
//                                             onChanged: (_) =>
//                                                 EasyDebounce.debounce(
//                                               '_model.antallStkTextController',
//                                               const Duration(milliseconds: 300),
//                                               () => safeSetState(() {}),
//                                             ),
//                                             textCapitalization:
//                                                 TextCapitalization.none,
//                                             obscureText: false,
//                                             decoration: InputDecoration(
//                                               labelText: 'Antall',
//                                               labelStyle:
//                                                   FlutterFlowTheme.of(context)
//                                                       .bodyMedium
//                                                       .override(
//                                                         fontFamily: 'Open Sans',
//                                                         fontSize: 14,
//                                                         letterSpacing: 0.0,
//                                                         fontWeight:
//                                                             FontWeight.w600,
//                                                       ),
//                                               alignLabelWithHint: false,
//                                               hintText: 'Skriv inn antall',
//                                               hintStyle:
//                                                   FlutterFlowTheme.of(context)
//                                                       .labelMedium
//                                                       .override(
//                                                         fontFamily: 'Open Sans',
//                                                         letterSpacing: 0.0,
//                                                         fontWeight:
//                                                             FontWeight.w600,
//                                                       ),
//                                               enabledBorder: OutlineInputBorder(
//                                                 borderSide: const BorderSide(
//                                                   color: Color(0x4757636C),
//                                                   width: 1,
//                                                 ),
//                                                 borderRadius:
//                                                     BorderRadius.circular(8),
//                                               ),
//                                               focusedBorder: OutlineInputBorder(
//                                                 borderSide: BorderSide(
//                                                   color: FlutterFlowTheme.of(
//                                                           context)
//                                                       .primary,
//                                                   width: 1,
//                                                 ),
//                                                 borderRadius:
//                                                     BorderRadius.circular(8),
//                                               ),
//                                               errorBorder: OutlineInputBorder(
//                                                 borderSide: BorderSide(
//                                                   color: FlutterFlowTheme.of(
//                                                           context)
//                                                       .error,
//                                                   width: 1,
//                                                 ),
//                                                 borderRadius:
//                                                     BorderRadius.circular(8),
//                                               ),
//                                               focusedErrorBorder:
//                                                   OutlineInputBorder(
//                                                 borderSide: BorderSide(
//                                                   color: FlutterFlowTheme.of(
//                                                           context)
//                                                       .error,
//                                                   width: 1,
//                                                 ),
//                                                 borderRadius:
//                                                     BorderRadius.circular(8),
//                                               ),
//                                               filled: true,
//                                               fillColor:
//                                                   FlutterFlowTheme.of(context)
//                                                       .primary,
//                                               contentPadding:
//                                                   const EdgeInsetsDirectional
//                                                       .fromSTEB(20, 24, 0, 24),
//                                             ),
//                                             style: FlutterFlowTheme.of(context)
//                                                 .bodyMedium
//                                                 .override(
//                                                   fontFamily: 'Open Sans',
//                                                   color: FlutterFlowTheme.of(
//                                                           context)
//                                                       .primaryText,
//                                                   fontSize: 17,
//                                                   letterSpacing: 0.0,
//                                                   fontWeight: FontWeight.w600,
//                                                 ),
//                                             maxLength: 5,
//                                             maxLengthEnforcement:
//                                                 MaxLengthEnforcement.enforced,
//                                             buildCounter: (context,
//                                                     {required currentLength,
//                                                     required isFocused,
//                                                     maxLength}) =>
//                                                 null,
//                                             keyboardType: TextInputType.number,
//                                             validator: _model
//                                                 .antallStkTextControllerValidator
//                                                 .asValidator(context),
//                                             inputFormatters: [
//                                               FilteringTextInputFormatter.allow(
//                                                   RegExp('[0-9]'))
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       if (matvare.kg != true)
//                                         Align(
//                                           alignment: const AlignmentDirectional(
//                                               0.8, 0),
//                                           child: Padding(
//                                             padding: const EdgeInsetsDirectional
//                                                 .fromSTEB(0, 7, 0, 0),
//                                             child: Text(
//                                               'Stk',
//                                               style: FlutterFlowTheme.of(
//                                                       context)
//                                                   .bodyMedium
//                                                   .override(
//                                                     fontFamily: 'Open Sans',
//                                                     color: FlutterFlowTheme.of(
//                                                             context)
//                                                         .alternate,
//                                                     fontSize: 17,
//                                                     letterSpacing: 0.0,
//                                                     fontWeight: FontWeight.w600,
//                                                   ),
//                                             ),
//                                           ),
//                                         ),
//                                       if (matvare.kg == true)
//                                         Align(
//                                           alignment: const AlignmentDirectional(
//                                               0.8, -0.19),
//                                           child: Padding(
//                                             padding: const EdgeInsetsDirectional
//                                                 .fromSTEB(0, 7, 0, 0),
//                                             child: Text(
//                                               'Kg',
//                                               style: FlutterFlowTheme.of(
//                                                       context)
//                                                   .bodyMedium
//                                                   .override(
//                                                     fontFamily: 'Open Sans',
//                                                     color: FlutterFlowTheme.of(
//                                                             context)
//                                                         .alternate,
//                                                     fontSize: 17,
//                                                     letterSpacing: 0.0,
//                                                     fontWeight: FontWeight.w600,
//                                                   ),
//                                             ),
//                                           ),
//                                         ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsetsDirectional.fromSTEB(
//                               12, 30, 12, 16),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.max,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 children: [
//                                   Text(
//                                     'Pris',
//                                     style: FlutterFlowTheme.of(context)
//                                         .titleMedium
//                                         .override(
//                                           fontFamily: 'Open Sans',
//                                           color: FlutterFlowTheme.of(context)
//                                               .secondaryText,
//                                           fontSize: 20,
//                                           letterSpacing: 0.0,
//                                         ),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Text(
//                                     (_model.antallStkTextController.text
//                                                 .isNotEmpty
//                                             ? (int.tryParse(_model
//                                                         .antallStkTextController
//                                                         .text) ??
//                                                     0) *
//                                                 matpris
//                                             : 0)
//                                         .toString(),
//                                     style: FlutterFlowTheme.of(context)
//                                         .displaySmall
//                                         .override(
//                                           fontFamily: 'Open Sans',
//                                           color: FlutterFlowTheme.of(context)
//                                               .alternate,
//                                           fontSize: 23,
//                                           letterSpacing: 0.0,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                   ),
//                                   Padding(
//                                     padding:
//                                         const EdgeInsetsDirectional.fromSTEB(
//                                             5, 0, 0, 0),
//                                     child: Text(
//                                       'Kr',
//                                       style: FlutterFlowTheme.of(context)
//                                           .displaySmall
//                                           .override(
//                                             fontFamily: 'Open Sans',
//                                             color: FlutterFlowTheme.of(context)
//                                                 .alternate,
//                                             fontSize: 23,
//                                             letterSpacing: 0.0,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding:
//                               const EdgeInsetsDirectional.fromSTEB(0, 45, 0, 0),
//                           child: InkWell(
//                             splashColor: Colors.transparent,
//                             focusColor: Colors.transparent,
//                             hoverColor: Colors.transparent,
//                             highlightColor: Colors.transparent,
//                             onTap: () async {
//                               if (_isLoading == true) {
//                                 return;
//                               }
//                               if (_model.formKey.currentState == null ||
//                                   !_model.formKey.currentState!.validate()) {
//                                 return;
//                               }
//                               try {
//                                 _isLoading = true;
//                                 if (matvare.matId != null &&
//                                     _model.antallStkTextController.text
//                                         .isNotEmpty) {
//                                   int? antall = int.tryParse(
//                                       _model.antallStkTextController.text);
//                                   int pris = antall! * matpris;
//                                   int matId = matvare.matId ?? 0;
//                                   if (matvare.matId != null) {
//                                     String? token =
//                                         await Securestorage().readToken();
//                                     if (token == null) {
//                                       FFAppState().login = false;
//                                       context.pushNamed('registrer');
//                                       return;
//                                     } else {
//                                       if (matId != 0) {
//                                         final response = await ApiKjop()
//                                             .kjopMat(
//                                                 matId: matId,
//                                                 price: pris,
//                                                 antall: antall,
//                                                 token: token);
//                                         if (response.statusCode == 200) {
//                                           context.pushNamed('Godkjentbetaling');
//                                         }
//                                       } else {
//                                         _isLoading = false;
//                                         throw (Exception);
//                                       }
//                                     }
//                                   } else {
//                                     _isLoading = false;
//                                     throw (Exception);
//                                   }
//                                 }
//                               } on SocketException {
//                                 showErrorToast(
//                                     context, 'Ingen internettforbindelse');
//                               } catch (e) {
//                                 showErrorToast(context, 'En feil oppstod');
//                               }
//                             },
//                             child: Material(
//                               color: Colors.transparent,
//                               elevation: 1,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(13),
//                               ),
//                               child: Container(
//                                 width: 250,
//                                 height: 45,
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFFFF5B24),
//                                   borderRadius: BorderRadius.circular(13),
//                                 ),
//                                 child: Align(
//                                   alignment: const AlignmentDirectional(0, 0),
//                                   child: Image.asset(
//                                     'assets/images/vipps-rgb-orange-neg.png',
//                                     width: 170,
//                                     height: 40,
//                                     fit: BoxFit.contain,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ].addToEnd(const SizedBox(height: 100)),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
