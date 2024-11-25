import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:ionicons/ionicons.dart';
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
import 'dart:math';
import 'bonde_gard_page_model.dart';
export 'bonde_gard_page_model.dart';

class BondeGardPageWidget extends StatefulWidget {
  const BondeGardPageWidget({
    super.key,
    required this.kategori,
    this.query,
  });

  final String? kategori;
  final dynamic query;

  @override
  State<BondeGardPageWidget> createState() => _BondeGardPageWidgetState();
}

class _BondeGardPageWidgetState extends State<BondeGardPageWidget> {
  late BondeGardPageModel _model;

  List<Matvarer>? _matvarer;
  List<Matvarer>? _allmatvarer;
  bool _isloading = true;
  bool _empty = false;
  int sorterVerdi = 1;
  final Securestorage securestorage = Securestorage();
  final ApiGetFilterFood apiGetFilterFood = ApiGetFilterFood();
  final ScrollController _scrollController = ScrollController();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BondeGardPageModel());
    getFilterFoods();
    _scrollController.addListener(_onScroll);

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    if (widget.query != null && widget.query.isNotEmpty) {
      _model.textController.text = widget.query;
    }
    _model.textFieldFocusNode!.addListener(() => safeSetState(() {}));
  }

  void _onScroll() {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {});
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

  void _runFilter(String enteredKeyword) {
    try {
      if (enteredKeyword.isEmpty) {
        _matvarer = List.from(_allmatvarer as Iterable);
      } else {
        // If a keyword is entered, filter the _allmatvarer list
        List<Matvarer> filteredResults = _allmatvarer!.where((matvare) {
          // Check if the name contains the entered keyword
          return matvare.name!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase());
        }).toList();

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
      setState(() {
        if (widget.kategori == 'Søk') {
          if (_matvarer != null && _matvarer!.isNotEmpty) {
            _isloading = false;
            _empty = false;
            return;
          } else {
            _empty = true;
            _isloading = false;
          }
        }
      });
    } on SocketException {
      showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      showErrorToast(context, 'En feil oppstod');
    }
  }

  Future<void> getFilterFoods() async {
    try {
      String? token = await Securestorage().readToken();
      if (token == null) {
        FFAppState().login = false;
        context.goNamed('registrer');
        return;
      } else {
        if (widget.kategori?.toLowerCase() == 'gårder') {
          _allmatvarer = await ApiGetFilterFood.getBondeFood(token);
          _matvarer = _allmatvarer;
          setState(() {
            if (_matvarer != null && _matvarer!.isNotEmpty) {
              _isloading = false;
              _empty = false;
              return;
            } else {
              _empty = true;
              _isloading = false;
            }
          });
          return;
        }
        if (widget.kategori?.toLowerCase() == 'følger') {
          _allmatvarer = await ApiGetFilterFood.getFolgerFood(token);
          _matvarer = _allmatvarer;
          setState(() {
            if (_matvarer != null && _matvarer!.isNotEmpty) {
              _isloading = false;
              _empty = false;
              return;
            } else {
              _empty = true;
              _isloading = false;
            }
          });
          return;
        } else {
          if (widget.kategori != 'Søk') {
            _allmatvarer =
                await ApiGetFilterFood.getFilterFood(token, widget.kategori);
            _matvarer = _allmatvarer;
            setState(() {
              if (_matvarer != null && _matvarer!.isNotEmpty) {
                _isloading = false;
                _empty = false;
                return;
              } else {
                _empty = true;
                _isloading = false;
              }
            });
            return;
          } else {
            _allmatvarer = await ApiGetAllFoods.getAllFoods(token);
            if (widget.query != null && widget.query.isNotEmpty) {
              _runFilter(widget.query);
            }
            setState(() {});
            return;
          }
        }
      }
    } on SocketException {
      showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      showErrorToast(context, 'En feil oppstod');
    }
  }

  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const earthRadius = 6371.0;
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLng = _degreesToRadians(lng2 - lng1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

// Helper method to build each profile outline with shimmer effect
  Widget buildProfileOutline(BuildContext context, int opacity, Color baseColor,
      Color highlightColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              width: 65.0,
              height: 65.0,
              decoration: BoxDecoration(
                color: Color.fromARGB(opacity, 255, 255, 255),
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  child: Container(
                    width: 75.0,
                    height: 13.0,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(opacity, 255, 255, 255),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  child: Container(
                    width: 200,
                    height: 13.0,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(opacity, 255, 255, 255),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
          floatingActionButtonLocation: FloatingActionButtonLocation
              .centerDocked, // Center the FAB at the bottom
          floatingActionButton: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
              child: GestureDetector(
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final selectedValue =
                      await showModalBottomSheet<List<String>>(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    useRootNavigator: true,
                    barrierColor: const Color.fromARGB(25, 0, 0, 0),
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
                      // Create a copy of the original list for sorting
                      List<Matvarer> sortedList = List.from(
                          _matvarer ?? []); // Use ?? [] to avoid null issues

                      if (selectedOption == 'Pris: lav til høy') {
                        sorterVerdi = 2; // Set the sorting to low to high
                        sortedList.sort((a, b) {
                          return (a.price ?? double.infinity)
                              .compareTo(b.price ?? double.infinity);
                        });
                      } else if (selectedOption == 'Pris: høy til lav') {
                        sorterVerdi = 3; // Set the sorting to high to low
                        sortedList.sort((a, b) {
                          return (b.price ?? double.negativeInfinity)
                              .compareTo(a.price ?? double.negativeInfinity);
                        });
                      } else if (selectedOption == 'Avstand: nærmest meg') {
                        sorterVerdi = 4; // Set the sorting to high to low
                        double brukerLat = FFAppState().brukerLat ?? 0.0;
                        double brukerLng = FFAppState().brukerLng ?? 0.0;

                        sortedList.sort((a, b) {
                          double distanceA = calculateDistance(
                              brukerLat, brukerLng, a.lat ?? 0.0, a.lng ?? 0.0);
                          double distanceB = calculateDistance(
                              brukerLat, brukerLng, b.lat ?? 0.0, b.lng ?? 0.0);

                          return distanceA.compareTo(distanceB);
                        });
                      } else {
                        // Assuming this is for "Best Match"
                        sorterVerdi = 1; // Reset to best match sorting
                        _runFilter(_model.textController
                            .text); // Run filter to get best matches
                        return; // Exit early to avoid setting _matvarer below
                      }

                      // Update _matvarer to the sorted list
                      _matvarer = sortedList;

                      // Refresh the UI
                      setState(() {});
                    });
                  }
                },
                child: Material(
                  color: Colors.transparent,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Container(
                      width: 125,
                      height: 52,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 3, 0),
                              child: Icon(
                                CupertinoIcons.arrow_up_arrow_down,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 22,
                              ),
                            ),
                            const VerticalDivider(
                              thickness: 1,
                              indent: 15,
                              endIndent: 15,
                              color: Color(0x2657636C),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  3, 0, 0, 0),
                              child: Icon(
                                Ionicons.options_outline,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ),
          ),
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            iconTheme: IconThemeData(
              color: FlutterFlowTheme.of(context).alternate,
            ),
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0.0,
            title: Row(
              mainAxisSize: MainAxisSize
                  .min, // Ensure Row does not try to fill unbounded width
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.safePop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Flexible(
                  fit: FlexFit
                      .loose, // FlexFit.loose to avoid taking infinite space
                  child: SizedBox(
                    height: 38.0,
                    child: CupertinoSearchTextField(
                      controller: _model.textController,
                      focusNode: _model.textFieldFocusNode,
                      autofocus: false,
                      onChanged: (value) => _runFilter(value),
                      placeholder: widget.kategori?.toLowerCase() != 'søk'
                          ? (widget.kategori == 'følger'
                              ? 'Søk innen brukere du følger'
                              : 'Søk innen ${widget.kategori}')
                          : 'Søk',
                      placeholderStyle:
                          FlutterFlowTheme.of(context).labelMedium.override(
                                fontFamily: 'Open Sans',
                                color: const Color(0x8F101213),
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                              ),
                      backgroundColor: const Color.fromARGB(255, 238, 238, 238),
                      prefixInsets:
                          const EdgeInsetsDirectional.fromSTEB(12, 6, 6, 6),
                      borderRadius: BorderRadius.circular(24.0),
                      prefixIcon: const Icon(
                        Icons.search_outlined,
                        size: 20,
                      ),
                      suffixIcon: Icon(
                        Icons.cancel,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                      onSuffixTap: () {
                        _model.textController!.clear();
                        setState(() {
                          _runFilter('');
                        });
                      },
                      padding: const EdgeInsets.symmetric(
                          vertical: 6.0, horizontal: 10.0),
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily: 'Open Sans',
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 15.0,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                ),
              ],
            ),
            actions: const [],
            centerTitle: true,
            elevation: 0.0,
          ),
          body: SafeArea(
            top: true,
            child: Stack(
              children: [
                NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification notification) {
                    if (notification is ScrollStartNotification) {
                      // Dismiss the keyboard when scrolling starts
                      FocusScope.of(context).unfocus();
                    }
                    return false; // Return false to continue processing the notification
                  },
                  child: SingleChildScrollView(
                    primary: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: const AlignmentDirectional(0, -1),
                          children: [
                            if ((_matvarer == null || _matvarer!.isEmpty) &&
                                (_isloading == false &&
                                    widget.kategori == 'følger'))
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                height: MediaQuery.sizeOf(context).height,
                                child: Align(
                                  alignment: const AlignmentDirectional(0, -1),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 20, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(0, 1),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              // First Profile Outline
                                              buildProfileOutline(
                                                context,
                                                100,
                                                Colors.grey[300]
                                                        ?.withOpacity(1) ??
                                                    Colors.grey.withOpacity(
                                                        0.3), // Reduce opacity
                                                Colors.grey[300]
                                                        ?.withOpacity(1) ??
                                                    Colors.grey.withOpacity(
                                                        0.3), // Reduce opacity
                                              ),

                                              // Second Profile Outline
                                              buildProfileOutline(
                                                context,
                                                80,
                                                Colors.grey[300]
                                                        ?.withOpacity(1) ??
                                                    Colors.grey.withOpacity(1),
                                                Colors.grey[300]
                                                        ?.withOpacity(1) ??
                                                    Colors.grey.withOpacity(1),
                                              ),

                                              // Third Profile Outline
                                              buildProfileOutline(
                                                context,
                                                50,
                                                Colors.grey[300]
                                                        ?.withOpacity(1) ??
                                                    Colors.grey.withOpacity(1),
                                                Colors.grey[300]
                                                        ?.withOpacity(1) ??
                                                    Colors.grey.withOpacity(1),
                                              ),

                                              // Fourth Profile Outline
                                              buildProfileOutline(
                                                context,
                                                38,
                                                Colors.grey[300]
                                                        ?.withOpacity(1) ??
                                                    Colors.grey.withOpacity(1),
                                                Colors.grey[300]
                                                        ?.withOpacity(1) ??
                                                    Colors.grey.withOpacity(1),
                                              ),

                                              const SizedBox(height: 8.0),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(25, 0, 25, 0),
                                                child: Text(
                                                  'Du kan se annonser fra folk du følger her',
                                                  textAlign: TextAlign.center,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .headlineSmall
                                                      .override(
                                                        fontFamily: 'Nunito',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontSize: 23,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            if ((_matvarer == null || _matvarer!.isEmpty) &&
                                (_isloading == false &&
                                    widget.kategori != 'følger'))
                              Container(
                                width: MediaQuery.sizeOf(context).width,
                                height: MediaQuery.sizeOf(context).height - 150,
                                child: Align(
                                  alignment: const AlignmentDirectional(0, -1),
                                  child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 0, 110),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.asset(
                                              'assets/images/Usability_testing-pana.png',
                                              width: 290,
                                              height: 250,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 20, 0, 0),
                                            child: Text(
                                              'Her var det tomt',
                                              textAlign: TextAlign.center,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .headlineSmall
                                                  .override(
                                                    fontFamily: 'Nunito',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    fontSize: 23,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                            if (_empty != true)
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 20, 0, 0),
                                child: SingleChildScrollView(
                                  primary: false,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Stack(
                                        alignment:
                                            const AlignmentDirectional(0, 0.9),
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(5, 0, 5, 0),
                                            child: RefreshIndicator(
                                              onRefresh: () async {
                                                await getFilterFoods();
                                              },
                                              child: GridView.builder(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                  0,
                                                  0,
                                                  0,
                                                  63.0,
                                                ),
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  childAspectRatio: 0.68,
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
                                                      baseColor:
                                                          Colors.grey[300]!,
                                                      highlightColor:
                                                          Colors.grey[100]!,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(5.0),
                                                            width: 200.0,
                                                            height: 230.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color
                                                                  .fromARGB(
                                                                  127,
                                                                  255,
                                                                  255,
                                                                  255),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16.0), // Rounded corners
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 8.0),
                                                          Container(
                                                            width: 200,
                                                            height: 15,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color
                                                                  .fromARGB(
                                                                  127,
                                                                  255,
                                                                  255,
                                                                  255),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                  final matvare =
                                                      _matvarer![index];
                                                  return Stack(children: [
                                                    Stack(
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  0, -1),
                                                          child: InkWell(
                                                            splashColor: Colors
                                                                .transparent,
                                                            focusColor: Colors
                                                                .transparent,
                                                            hoverColor: Colors
                                                                .transparent,
                                                            highlightColor:
                                                                Colors
                                                                    .transparent,
                                                            onTap: () async {
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      FocusNode());
                                                              context.pushNamed(
                                                                'MatDetaljBondegard',
                                                                queryParameters: {
                                                                  'matvare':
                                                                      serializeParam(
                                                                    matvare
                                                                        .toJson(), // Convert to JSON before passing
                                                                    ParamType
                                                                        .JSON,
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
                                                                  border: Border
                                                                      .all(
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
                                                                    Align(
                                                                      alignment:
                                                                          const AlignmentDirectional(
                                                                              0,
                                                                              0),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            3,
                                                                            0,
                                                                            3,
                                                                            0),
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(17),
                                                                          child:
                                                                              Image.network(
                                                                            '${ApiConstants.baseUrl}${matvare.imgUrls![0]}',
                                                                            width:
                                                                                200,
                                                                            height:
                                                                                229,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            errorBuilder: (BuildContext context,
                                                                                Object error,
                                                                                StackTrace? stackTrace) {
                                                                              return Image.asset(
                                                                                'assets/images/error_image.jpg',
                                                                                width: 200,
                                                                                height: 229,
                                                                                fit: BoxFit.cover,
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          5,
                                                                          0,
                                                                          5,
                                                                          0),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          Align(
                                                                            alignment:
                                                                                const AlignmentDirectional(-1, 0),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsetsDirectional.fromSTEB(7, 0, 0, 0),
                                                                              child: AutoSizeText(
                                                                                matvare.name ?? '',
                                                                                textAlign: TextAlign.start,
                                                                                minFontSize: 11,
                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                      fontFamily: 'Open Sans',
                                                                                      fontSize: 14,
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
                                                                      padding: const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          4),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          Flexible(
                                                                            child:
                                                                                Align(
                                                                              alignment: const AlignmentDirectional(0, 0),
                                                                              child: Padding(
                                                                                padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                                                                                child: Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        children: [
                                                                                          Padding(
                                                                                            padding: const EdgeInsetsDirectional.fromSTEB(7, 0, 0, 0),
                                                                                            child: Text(
                                                                                              '${matvare.price} Kr',
                                                                                              textAlign: TextAlign.end,
                                                                                              style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                                    fontFamily: 'Open Sans',
                                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                    fontSize: 14,
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
                                                                                                    fontSize: 14,
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                  ),
                                                                                            ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 7, 0),
                                                                                          child: Text(
                                                                                            // Directly calculate the distance using the provided latitude and longitude
                                                                                            (calculateDistance(FFAppState().brukerLat ?? 0.0, FFAppState().brukerLng ?? 0.0, matvare.lat ?? 0.0, matvare.lng ?? 0.0) < 1) ? '<1 Km' : '${calculateDistance(FFAppState().brukerLat ?? 0.0, FFAppState().brukerLng ?? 0.0, matvare.lat ?? 0.0, matvare.lng ?? 0.0).toStringAsFixed(0)} Km',
                                                                                            textAlign: TextAlign.start,
                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                  fontFamily: 'Open Sans',
                                                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                  fontSize: 14,
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
                      ].addToEnd(const SizedBox(height: 100)),
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0, 1),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 1, 0, 50),
                    child: Material(
                      color: Colors.transparent,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
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
