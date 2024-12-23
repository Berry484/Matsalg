import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mat_salg/helper_components/functions/calculate_distance.dart';
import 'package:mat_salg/helper_components/widgets/product_list.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/pages/app_pages/hjem/category/sort/sort_widget.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_icon_button.dart';
import 'package:mat_salg/services/food_service.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'category_model.dart';
export 'category_model.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({
    super.key,
    required this.kategori,
    this.query,
  });

  final String? kategori;
  final dynamic query;

  @override
  State<CategoryWidget> createState() => _BondeGardPageWidgetState();
}

class _BondeGardPageWidgetState extends State<CategoryWidget> {
  late CategoryModel _model;
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final ApiFoodService apiFoodService = ApiFoodService();
  final ScrollController _scrollController = ScrollController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CategoryModel());
    getCategoryFood();
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

  void _runFilter(String enteredKeyword) {
    try {
      if (enteredKeyword.isEmpty) {
        _model.matvarer = List.from(_model.allmatvarer as Iterable);
      } else {
        // If a keyword is entered, filter the _allmatvarer list
        List<Matvarer> filteredResults = _model.allmatvarer!.where((matvare) {
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

        _model.matvarer = filteredResults;
      }

      // Apply sorting based on the selected sorterVerdi
      if (_model.sorterVerdi == 2) {
        // Sort low to high
        _model.matvarer!.sort((a, b) {
          return (a.price ?? double.infinity)
              .compareTo(b.price ?? double.infinity);
        });
      } else if (_model.sorterVerdi == 3) {
        // Sort high to low
        _model.matvarer!.sort((a, b) {
          return (b.price ?? double.negativeInfinity)
              .compareTo(a.price ?? double.negativeInfinity);
        });
      }
      setState(() {
        if (widget.kategori == 'Søk') {
          if (_model.matvarer != null && _model.matvarer!.isNotEmpty) {
            _model.isloading = false;
            _model.empty = false;
            return;
          } else {
            _model.empty = true;
            _model.isloading = false;
          }
        }
      });
    } on SocketException {
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

  Future<void> getCategoryFood() async {
    try {
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        return;
      } else {
        if (widget.kategori != 'Søk') {
          _model.allmatvarer =
              await ApiFoodService.getCategoryFood(token, widget.kategori);
          _model.matvarer = _model.allmatvarer;
          setState(() {
            if (_model.matvarer != null && _model.matvarer!.isNotEmpty) {
              _model.isloading = false;
              _model.empty = false;
              return;
            } else {
              _model.empty = true;
              _model.isloading = false;
            }
          });
          return;
        } else {
          _model.allmatvarer = await ApiFoodService.getAllFoods(token);

          _runFilter(widget.query);

          setState(() {});
          return;
        }
      }
    } on SocketException {
      if (!mounted) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      if (!mounted) return;
      Toasts.showErrorToast(context, 'En feil oppstod');
    }
  }

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
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) {
            return;
          }
        },
        child: Scaffold(
          key: scaffoldKey,
          resizeToAvoidBottomInset: false,
          backgroundColor: FlutterFlowTheme.of(context).primary,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
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
                          child: SortWidget(
                            sorterVerdi: _model.sorterVerdi,
                          ),
                        ),
                      );
                    },
                  );
                  if (selectedValue != null && selectedValue.isNotEmpty) {
                    final String selectedOption = selectedValue.first;

                    safeSetState(() {
                      List<Matvarer> sortedList =
                          List.from(_model.matvarer ?? []);

                      if (selectedOption == 'Pris: lav til høy') {
                        _model.sorterVerdi = 2;
                        sortedList.sort((a, b) {
                          return (a.price ?? double.infinity)
                              .compareTo(b.price ?? double.infinity);
                        });
                      } else if (selectedOption == 'Pris: høy til lav') {
                        _model.sorterVerdi = 3;
                        sortedList.sort((a, b) {
                          return (b.price ?? double.negativeInfinity)
                              .compareTo(a.price ?? double.negativeInfinity);
                        });
                      } else if (selectedOption == 'Avstand: nærmest meg') {
                        _model.sorterVerdi = 4;
                        double brukerLat = FFAppState().brukerLat;
                        double brukerLng = FFAppState().brukerLng;

                        sortedList.sort((a, b) {
                          double distanceA =
                              CalculateDistance.calculateDistance(brukerLat,
                                  brukerLng, a.lat ?? 0.0, a.lng ?? 0.0);
                          double distanceB =
                              CalculateDistance.calculateDistance(brukerLat,
                                  brukerLng, b.lat ?? 0.0, b.lng ?? 0.0);

                          return distanceA.compareTo(distanceB);
                        });
                      } else {
                        _model.sorterVerdi = 1;
                        _runFilter(_model.textController.text);
                        return;
                      }
                      _model.matvarer = sortedList;
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
              mainAxisSize: MainAxisSize.min,
              children: [
                FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 50.0,
                  borderWidth: 1.0,
                  buttonSize: 40.0,
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24,
                  ),
                  onPressed: () => context.safePop(),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: SizedBox(
                    height: 38.0,
                    child: CupertinoSearchTextField(
                      controller: _model.textController,
                      focusNode: _model.textFieldFocusNode,
                      autofocus: false,
                      onChanged: (value) => _runFilter(value),
                      placeholder: widget.kategori?.toLowerCase() != 'søk'
                          ? 'Søk innen ${widget.kategori}'
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
                      FocusScope.of(context).unfocus();
                    }
                    return false;
                  },
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    primary: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: const AlignmentDirectional(0, -1),
                          children: [
                            if ((_model.matvarer == null ||
                                    _model.matvarer!.isEmpty) &&
                                _model.isloading == false)
                              SizedBox(
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
                            if (_model.empty != true)
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
                                                await getCategoryFood();
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
                                                itemCount: _model.isloading
                                                    ? 1
                                                    : _model.matvarer?.length ??
                                                        0,
                                                itemBuilder: (context, index) {
                                                  if (_model.isloading) {
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
                                                                          16.0),
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
                                                      _model.matvarer![index];
                                                  return ProductList(
                                                    matvare: matvare,
                                                    onTap: () async {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              FocusNode());
                                                      context.pushNamed(
                                                        'MatDetaljBondegard',
                                                        queryParameters: {
                                                          'matvare':
                                                              serializeParam(
                                                            matvare.toJson(),
                                                            ParamType.JSON,
                                                          ),
                                                        },
                                                      );
                                                    },
                                                  );
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
