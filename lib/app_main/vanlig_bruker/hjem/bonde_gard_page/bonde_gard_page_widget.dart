import 'package:mat_salg/ApiCalls.dart';
import 'package:mat_salg/MyIP.dart';
import 'package:mat_salg/SecureStorage.dart';
import 'package:mat_salg/app_main/vanlig_bruker/hjem/sorter/sorter_widget.dart';
import 'package:mat_salg/matvarer.dart';
import 'package:shimmer/shimmer.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'bonde_gard_page_model.dart';
export 'bonde_gard_page_model.dart';

class BondeGardPageWidget extends StatefulWidget {
  const BondeGardPageWidget({
    super.key,
    required this.kategori,
  });

  final String? kategori;

  @override
  State<BondeGardPageWidget> createState() => _BondeGardPageWidgetState();
}

class _BondeGardPageWidgetState extends State<BondeGardPageWidget> {
  late BondeGardPageModel _model;

  List<Matvarer>? _matvarer;
  List<Matvarer>? _allmatvarer;
  List<Matvarer>? _allSokmatvarer;
  bool _isloading = true;
  int sorterVerdi = 1;
  final Securestorage securestorage = Securestorage();
  final ApiGetFilterFood apiGetFilterFood = ApiGetFilterFood();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BondeGardPageModel());
    getFilterFoods();

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _model.textFieldFocusNode!.addListener(() => safeSetState(() {}));
  }

  void _runFilter(String enteredKeyword) {
    // If no keyword is entered, reset _matvarer to the full list
    if (enteredKeyword.isEmpty) {
      _matvarer = List.from(_allmatvarer as Iterable);
      _allSokmatvarer =
          List.from(_allmatvarer as Iterable); // Keep original unsorted list
    } else {
      // If a keyword is entered, filter the _allmatvarer list
      List<Matvarer> filteredResults = _allmatvarer!.where((matvare) {
        // Check if the name contains the entered keyword
        return matvare.name!
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase());
      }).toList();

      // Store the unsorted search results in _allSokmatvarer
      _allSokmatvarer =
          List.from(filteredResults); // Keep the filtered results unsorted

      // Now sort the filtered results based on match quality
      filteredResults.sort((a, b) {
        String keyword = enteredKeyword.toLowerCase();

        // Check for exact matches (case-insensitive)
        bool aExactMatch = a.name!.toLowerCase() == keyword;
        bool bExactMatch = b.name!.toLowerCase() == keyword;

        if (aExactMatch && !bExactMatch) return -1;
        if (bExactMatch && !aExactMatch) return 1;

        // Check if the keyword is at the start of the name
        bool aStartsWith = a.name!.toLowerCase().startsWith(keyword);
        bool bStartsWith = b.name!.toLowerCase().startsWith(keyword);

        if (aStartsWith && !bStartsWith) return -1;
        if (bStartsWith && !aStartsWith) return 1;

        // Otherwise, fall back to regular string comparison for alphabetical order
        return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
      });

      // Assign the sorted results to _matvarer
      _matvarer = filteredResults;
    }

    // Apply sorting based on the selected sorterVerdi
    if (sorterVerdi == 2) {
      // Sort low to high
      _matvarer!.sort((a, b) {
        return (a.price ?? double.infinity)
            .compareTo(b.price ?? double.infinity);
      });
    } else if (sorterVerdi == 3) {
      // Sort high to low
      _matvarer!.sort((a, b) {
        return (b.price ?? double.negativeInfinity)
            .compareTo(a.price ?? double.negativeInfinity);
      });
    }

    // Update the UI
    setState(() {});
  }

  Future<void> getFilterFoods() async {
    String? token = await Securestorage().readToken();
    if (token == null) {
      FFAppState().login = false;
      context.pushNamed('registrer');
      return;
    } else {
      if (widget.kategori?.toLowerCase() == 'gårder') {
        _allmatvarer = await ApiGetFilterFood.getBondeFood(token);
        _matvarer = _allmatvarer;
        _allSokmatvarer = _allmatvarer;
        setState(() {
          if (_matvarer != null && _matvarer!.isEmpty) {
            return;
          } else {
            _isloading = false;
          }
        });
        return;
      }
      if (widget.kategori?.toLowerCase() == 'følger') {
        _allmatvarer = await ApiGetFilterFood.getFolgerFood(token);
        _matvarer = _allmatvarer;
        _allSokmatvarer = _allmatvarer;
        setState(() {
          if (_matvarer != null && _matvarer!.isEmpty) {
            return;
          } else {
            _isloading = false;
          }
        });
        return;
      } else {
        _allmatvarer =
            await ApiGetFilterFood.getFilterFood(token, widget.kategori);
        _matvarer = _allmatvarer;
        _allSokmatvarer = _allmatvarer;
        setState(() {
          if (_matvarer != null && _matvarer!.isEmpty) {
            return;
          } else {
            _isloading = false;
          }
        });
        return;
      }
    }
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
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              final selectedValue = await showModalBottomSheet<List<String>>(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) {
                  return GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Padding(
                      padding: MediaQuery.viewInsetsOf(context),
                      child: SorterWidget(
                        sorterVerdi: sorterVerdi,
                      ),
                    ),
                  );
                },
              );

              if (selectedValue != null && selectedValue.isNotEmpty) {
                final String selectedOption = selectedValue.first;

                safeSetState(() {
                  if (selectedOption == 'Pris: lav til høy') {
                    sorterVerdi = 2;
                    _matvarer!.sort((a, b) {
                      return (a.price ?? double.infinity)
                          .compareTo(b.price ?? double.infinity);
                    });
                  } else if (selectedOption == 'Pris: høy til lav') {
                    sorterVerdi = 3;
                    _matvarer!.sort((a, b) {
                      return (b.price ?? double.negativeInfinity)
                          .compareTo(a.price ?? double.negativeInfinity);
                    });
                  } else {
                    sorterVerdi = 1; // Reset to original
                    _runFilter(_model.textController.text);
                    _matvarer = List.from(_allSokmatvarer as Iterable);
                  }
                });
              }
            },
            backgroundColor: FlutterFlowTheme.of(context).primary,
            elevation: 8,
            child: FaIcon(
              FontAwesomeIcons.sortAmountDown,
              color: FlutterFlowTheme.of(context).alternate,
              size: 25,
            ),
          ),
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).alternate),
            automaticallyImplyLeading: false,
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
            title: Text(
              widget.kategori ?? '',
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
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: AlignmentDirectional(0, -1),
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 10, 0, 17),
                              child: SafeArea(
                                child: Container(
                                  width: valueOrDefault<double>(
                                    MediaQuery.sizeOf(context).width,
                                    500.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10, 0, 10, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                controller:
                                                    _model.textController,
                                                focusNode:
                                                    _model.textFieldFocusNode,
                                                autofocus: false,
                                                obscureText: false,
                                                onChanged: (value) =>
                                                    _runFilter(value),
                                                textInputAction: TextInputAction
                                                    .search, // Add this line to
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  alignLabelWithHint: false,
                                                  hintText: 'Søk',
                                                  hintStyle: FlutterFlowTheme
                                                          .of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily: 'Open Sans',
                                                        color: const Color(
                                                            0x8F101213),
                                                        fontSize: 15.0,
                                                        letterSpacing: 0.0,
                                                      ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Color.fromARGB(
                                                          0, 85, 85, 85),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13.0),
                                                  ),
                                                  filled: true,
                                                  fillColor: Color.fromARGB(
                                                      246, 243, 243, 243),
                                                  prefixIcon: const Icon(
                                                    Icons.search_outlined,
                                                  ),
                                                ),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyLarge
                                                    .override(
                                                      fontFamily: 'Open Sans',
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      fontSize: 15.0,
                                                      letterSpacing: 0.0,
                                                    ),
                                                textAlign: TextAlign.start,
                                                cursorColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                validator: _model
                                                    .textControllerValidator
                                                    .asValidator(context),
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
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 60, 0, 0),
                            child: SingleChildScrollView(
                              primary: false,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Stack(
                                    alignment: AlignmentDirectional(0, 0.9),
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            5, 22, 5, 0),
                                        child: RefreshIndicator(
                                          onRefresh: () async {
                                            await getFilterFoods();
                                          },
                                          child: GridView.builder(
                                            padding: const EdgeInsets.fromLTRB(
                                              0,
                                              0,
                                              0,
                                              63.0,
                                            ),
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 0.64,
                                            ),
                                            primary: false,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount: _isloading
                                                ? 1
                                                : _matvarer?.length ?? 0,
                                            itemBuilder: (context, index) {
                                              if (_isloading) {
                                                return Shimmer.fromColors(
                                                  baseColor: Colors.grey[
                                                      300]!, // Base color for the shimmer
                                                  highlightColor: Colors.grey[
                                                      100]!, // Highlight color for the shimmer
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    width: 225.0,
                                                    height: 235.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              127,
                                                              255,
                                                              255,
                                                              255),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0), // Rounded corners
                                                    ),
                                                  ),
                                                );
                                              }
                                              final matvare = _matvarer![index];
                                              return Stack(children: [
                                                Stack(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0, -1),
                                                      child: InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                                  FocusNode());
                                                          context.pushNamed(
                                                            'MatDetaljBondegard',
                                                            queryParameters: {
                                                              'matvare':
                                                                  serializeParam(
                                                                matvare
                                                                    .toJson(), // Convert to JSON before passing
                                                                ParamType.JSON,
                                                              ),
                                                            },
                                                          );
                                                        },
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          elevation: 0,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16),
                                                          ),
                                                          child: Container(
                                                            width: 235,
                                                            height: 290,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16),
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .transparent,
                                                              ),
                                                            ),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
// Generated code for this Image Widget...
                                                                Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0, 0),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            3,
                                                                            0,
                                                                            3,
                                                                            0),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              17),
                                                                      child: Image
                                                                          .network(
                                                                        '${ApiConstants.baseUrl}${matvare.imgUrls![0]}',
                                                                        width:
                                                                            200,
                                                                        height:
                                                                            229,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        errorBuilder: (BuildContext context,
                                                                            Object
                                                                                error,
                                                                            StackTrace?
                                                                                stackTrace) {
                                                                          return Image
                                                                              .asset(
                                                                            'assets/images/error_image.jpg', // Path to your local error image
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          5,
                                                                          0,
                                                                          5,
                                                                          0),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Align(
                                                                        alignment: AlignmentDirectional(
                                                                            -1,
                                                                            0),
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              7,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              AutoSizeText(
                                                                            matvare.name ??
                                                                                '',
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            minFontSize:
                                                                                11,
                                                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                  fontFamily: 'Open Sans',
                                                                                  fontSize: 15,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          4),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Flexible(
                                                                        child:
                                                                            Align(
                                                                          alignment: AlignmentDirectional(
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                5,
                                                                                0,
                                                                                5,
                                                                                0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(7, 0, 0, 0),
                                                                                        child: Text(
                                                                                          '${matvare.price} Kr',
                                                                                          textAlign: TextAlign.end,
                                                                                          style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                                fontFamily: 'Open Sans',
                                                                                                color: FlutterFlowTheme.of(context).alternate,
                                                                                                fontSize: 15,
                                                                                                letterSpacing: 0.0,
                                                                                                fontWeight: FontWeight.bold,
                                                                                              ),
                                                                                        ),
                                                                                      ),
                                                                                      if (matvare.kg == true)
                                                                                        Text(
                                                                                          '/kg',
                                                                                          textAlign: TextAlign.end,
                                                                                          style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                                fontFamily: 'Open Sans',
                                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                fontSize: 15,
                                                                                                letterSpacing: 0.0,
                                                                                                fontWeight: FontWeight.w600,
                                                                                              ),
                                                                                        ),
                                                                                      if (matvare.kg != true)
                                                                                        Text(
                                                                                          '/stk',
                                                                                          textAlign: TextAlign.end,
                                                                                          style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                                fontFamily: 'Open Sans',
                                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                fontSize: 15,
                                                                                                letterSpacing: 0.0,
                                                                                                fontWeight: FontWeight.w600,
                                                                                              ),
                                                                                        ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 7, 0),
                                                                                      child: Text(
                                                                                        '(3Km)',
                                                                                        textAlign: TextAlign.start,
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: 'Open Sans',
                                                                                              color: FlutterFlowTheme.of(context).primaryText,
                                                                                              fontSize: 14,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.w600,
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
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ]);
                                            },
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
                    ].addToEnd(SizedBox(height: 100)),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0, 1),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 1, 0, 50),
                    child: Material(
                      color: Colors.transparent,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                      // child: Container(
                      //   width: 125,
                      //   height: 52,
                      //   decoration: BoxDecoration(
                      //     color: FlutterFlowTheme.of(context).primary,
                      //     borderRadius: BorderRadius.circular(13),
                      //   ),
                      //   child: Row(
                      //     mainAxisSize: MainAxisSize.max,
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Padding(
                      //         padding:
                      //             EdgeInsetsDirectional.fromSTEB(0, 0, 3, 0),
                      //         child: FaIcon(
                      //           FontAwesomeIcons.sortAmountDownAlt,
                      //           color: FlutterFlowTheme.of(context).primaryText,
                      //           size: 25,
                      //         ),
                      //       ),
                      //       VerticalDivider(
                      //         thickness: 1.5,
                      //         indent: 15,
                      //         endIndent: 15,
                      //         color: Color(0x8557636C),
                      //       ),
                      //       Padding(
                      //         padding:
                      //             EdgeInsetsDirectional.fromSTEB(3, 0, 0, 0),
                      //         child: FaIcon(
                      //           FontAwesomeIcons.slidersH,
                      //           color: FlutterFlowTheme.of(context).primaryText,
                      //           size: 25,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
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
