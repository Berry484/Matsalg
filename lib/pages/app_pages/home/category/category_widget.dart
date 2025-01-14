import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:mat_salg/models/matvarer.dart';
import 'package:mat_salg/helper_components/widgets/product_list.dart';
import 'package:mat_salg/helper_components/widgets/shimmer_widgets/shimmer_product.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/pages/app_pages/home/category/filter/filter_widget.dart';
import 'package:mat_salg/pages/app_pages/home/category/sort/sort_widget.dart';
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
  final ScrollController _scrollController1 = ScrollController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late FilterOptions filterOptions;
  late FilterOptions localFilterOptions;
  bool _moreIsLoading = false;
  String? searchBy;

  @override
  void initState() {
    super.initState();
    filterOptions = FilterOptions(
        distance: null,
        priceRange: RangeValues(0, 800),
        selectedCategories: [widget.kategori ?? '']);
    _model = createModel(context, () => CategoryModel());
    getCategoryFood(true, false);
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    if (widget.query != null && widget.query.isNotEmpty) {
      _model.textController.text = widget.query;
    }
    _model.textFieldFocusNode!.addListener(() => safeSetState(() {}));

    _scrollController1.addListener(_scrollListener);
    searchBy = widget.kategori;
  }

  Future<void> getCategoryFood(bool refresh, bool nextPage) async {
    try {
      if (nextPage == false) {
        _model.isloading = true;
      }
      String? token = await firebaseAuthService.getToken(context);
      if (token == null) {
        _model.isloading = false;
        return;
      } else {
        if (widget.kategori != 'Søk') {
          if (refresh == true) {
            _model.end = false;
            _model.page = 0;
            _model.matvarer = await ApiFoodService.getCategoryFood(
                token,
                0,
                _model.sortByPriceAsc,
                _model.sortByPriceDesc,
                _model.sortByDistance,
                filterOptions.priceRange.start.toInt(),
                filterOptions.priceRange.end.toInt(),
                filterOptions.distance,
                filterOptions.selectedCategories,
                _model.textController.text);
          } else {
            List<Matvarer>? nyeMatvarer = await ApiFoodService.getCategoryFood(
                token,
                _model.page,
                _model.sortByPriceAsc,
                _model.sortByPriceDesc,
                _model.sortByDistance,
                filterOptions.priceRange.start.toInt(),
                filterOptions.priceRange.end.toInt(),
                filterOptions.distance,
                filterOptions.selectedCategories,
                _model.textController.text);

            _model.matvarer ??= [];

            if (nyeMatvarer != null && nyeMatvarer.isNotEmpty) {
              _model.matvarer?.addAll(nyeMatvarer);
            } else {
              _model.end = true;
            }
          }
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
          if (ListEquality()
              .equals(filterOptions.selectedCategories, ['Søk'])) {
            filterOptions.selectedCategories = [];
          }
          if (refresh == true) {
            _model.end = false;
            _model.page = 0;
            _model.matvarer = await ApiFoodService.getCategoryFood(
                token,
                0,
                _model.sortByPriceAsc,
                _model.sortByPriceDesc,
                _model.sortByDistance,
                filterOptions.priceRange.start.toInt(),
                filterOptions.priceRange.end.toInt(),
                filterOptions.distance,
                filterOptions.selectedCategories,
                _model.textController.text);
          } else {
            List<Matvarer>? nyeMatvarer = await ApiFoodService.getCategoryFood(
                token,
                _model.page,
                _model.sortByPriceAsc,
                _model.sortByPriceDesc,
                _model.sortByDistance,
                filterOptions.priceRange.start.toInt(),
                filterOptions.priceRange.end.toInt(),
                filterOptions.distance,
                filterOptions.selectedCategories,
                _model.textController.text);

            _model.matvarer ??= [];

            if (nyeMatvarer != null && nyeMatvarer.isNotEmpty) {
              _model.matvarer?.addAll(nyeMatvarer);
            } else {
              _model.end = true;
            }
          }
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
        }
      }
    } on SocketException {
      _model.isloading = false;
      if (!mounted) return;
      Toasts.showErrorToast(context, 'Ingen internettforbindelse');
    } catch (e) {
      _model.isloading = false;
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

  int checkFilter() {
    int filterCount = 0;

    if (filterOptions.distance != null) {
      filterCount += 1;
    }
    if (filterOptions.priceRange.start != 0 ||
        filterOptions.priceRange.end != 800) {
      filterCount += 1;
    }
    if (filterOptions.selectedCategories.isNotEmpty) {
      filterCount += filterOptions.selectedCategories.length;
    }

    return filterCount;
  }

  void _scrollListener() async {
    if (_scrollController1.position.pixels >=
        _scrollController1.position.maxScrollExtent) {
      if (_moreIsLoading || _model.end || _model.matvarer!.length < 44) return;
      _moreIsLoading = true;
      _model.page += 1;
      await getCategoryFood(false, true);
      _moreIsLoading = false;
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
              child: Material(
                color: Colors.transparent,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 130,
                      height: 52,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                final selectedValue =
                                    await showModalBottomSheet<List<String>>(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  useRootNavigator: true,
                                  barrierColor:
                                      const Color.fromARGB(25, 0, 0, 0),
                                  context: context,
                                  builder: (context) {
                                    return GestureDetector(
                                      onTap: () =>
                                          FocusScope.of(context).unfocus(),
                                      child: Padding(
                                        padding:
                                            MediaQuery.viewInsetsOf(context),
                                        child: SortWidget(
                                          sorterVerdi: _model.sorterVerdi,
                                        ),
                                      ),
                                    );
                                  },
                                );
                                if (selectedValue != null &&
                                    selectedValue.isNotEmpty) {
                                  final String selectedOption =
                                      selectedValue.first;

                                  safeSetState(() {
                                    if (selectedOption == 'Pris: lav til høy') {
                                      _model.sorterVerdi = 2;
                                      _model.sortByPriceAsc = true;
                                      _model.sortByPriceDesc = false;
                                      _model.sortByDistance = false;
                                      getCategoryFood(true, false);
                                    } else if (selectedOption ==
                                        'Pris: høy til lav') {
                                      _model.sorterVerdi = 3;
                                      _model.sortByPriceAsc = false;
                                      _model.sortByPriceDesc = true;
                                      _model.sortByDistance = false;
                                      getCategoryFood(true, false);
                                    } else if (selectedOption ==
                                        'Avstand: nærmest meg') {
                                      _model.sorterVerdi = 4;
                                      _model.sortByPriceAsc = false;
                                      _model.sortByPriceDesc = false;
                                      _model.sortByDistance = true;
                                      getCategoryFood(true, false);
                                    } else {
                                      _model.sorterVerdi = 1;
                                      _model.sortByPriceAsc = false;
                                      _model.sortByPriceDesc = false;
                                      _model.sortByDistance = false;
                                      getCategoryFood(true, false);
                                      return;
                                    }
                                    setState(() {});
                                  });
                                }
                              },
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(24),
                                bottomLeft: Radius.circular(24),
                              ),
                              child: Center(
                                child: Icon(
                                  CupertinoIcons.arrow_up_arrow_down,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                          const VerticalDivider(
                            thickness: 1,
                            indent: 15,
                            endIndent: 15,
                            color: Color(0x2657636C),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());

                                final localFilterOptions =
                                    await showModalBottomSheet<FilterOptions>(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  useRootNavigator: true,
                                  barrierColor:
                                      const Color.fromARGB(25, 0, 0, 0),
                                  context: context,
                                  builder: (context) {
                                    return GestureDetector(
                                      onTap: () =>
                                          FocusScope.of(context).unfocus(),
                                      child: Padding(
                                        padding:
                                            MediaQuery.viewInsetsOf(context),
                                        child: FilterWidget(
                                          filterOptions: filterOptions,
                                        ),
                                      ),
                                    );
                                  },
                                );
                                if (localFilterOptions != null) {
                                  filterOptions = localFilterOptions;
                                  getCategoryFood(true, false);
                                  if (localFilterOptions
                                          .selectedCategories.isEmpty ||
                                      localFilterOptions
                                              .selectedCategories.length !=
                                          1) {
                                    safeSetState(() {
                                      searchBy = 'Søk';
                                    });
                                  } else {
                                    safeSetState(() {
                                      searchBy = localFilterOptions
                                          .selectedCategories.first;
                                    });
                                  }
                                }
                              },
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(24),
                                bottomRight: Radius.circular(24),
                              ),
                              child: Center(
                                child: Icon(
                                  Ionicons.options_outline,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (checkFilter() != 0)
                      Positioned(
                        top: -5,
                        right: -5,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${checkFilter()}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
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
                      onChanged: (value) => getCategoryFood(true, false),
                      placeholder: widget.kategori?.toLowerCase() == 'søk' ||
                              searchBy?.toLowerCase() == 'søk'
                          ? 'Søk'
                          : 'Søk innen $searchBy',
                      placeholderStyle:
                          FlutterFlowTheme.of(context).labelMedium.override(
                                fontFamily: 'Open Sans',
                                color: const Color(0x8F101213),
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
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
                          getCategoryFood(true, false);
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
                  child: RefreshIndicator.adaptive(
                    color: FlutterFlowTheme.of(context).alternate,
                    onRefresh: () async {
                      HapticFeedback.selectionClick();
                      getCategoryFood(true, false);
                    },
                    child: SingleChildScrollView(
                      controller: _scrollController1,
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
                                  height:
                                      MediaQuery.sizeOf(context).height - 150,
                                  child: Align(
                                    alignment:
                                        const AlignmentDirectional(0, -1),
                                    child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 110),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.asset(
                                                'assets/images/no-results.png',
                                                width: 180,
                                                height: 180,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 20, 0, 0),
                                              child: Text(
                                                'Ingen treff',
                                                textAlign: TextAlign.center,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineSmall
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 22,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                              if (_model.isloading)
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width,
                                  height:
                                      MediaQuery.sizeOf(context).height - 150,
                                  child: Align(
                                    alignment:
                                        const AlignmentDirectional(0, -1),
                                    child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 110),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Align(
                                              alignment:
                                                  const AlignmentDirectional(
                                                      0.0, 0.0),
                                              child: Lottie.asset(
                                                'assets/lottie_animations/loading.json',
                                                width: 200.0,
                                                height: 180.0,
                                                fit: BoxFit.cover,
                                                repeat: true,
                                                animate: true,
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                              if (_model.empty != true &&
                                  _model.isloading == false)
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 20, 0, 0),
                                  child: Stack(
                                    alignment:
                                        const AlignmentDirectional(0, 0.9),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(5, 0, 5, 0),
                                        child: RefreshIndicator(
                                          onRefresh: () async {
                                            await getCategoryFood(true, false);
                                          },
                                          child: GridView.builder(
                                            padding: const EdgeInsets.fromLTRB(
                                              0,
                                              0,
                                              0,
                                              0,
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
                                                : _model.end
                                                    ? _model.matvarer?.length ??
                                                        0
                                                    : (_model.matvarer
                                                                ?.length ??
                                                            0) +
                                                        1,
                                            itemBuilder: (context, index) {
                                              if (_model.isloading) {
                                                return const ShimmerLoadingWidget();
                                              }

                                              if (index <
                                                  (_model.matvarer?.length ??
                                                      0)) {
                                                final matvare =
                                                    _model.matvarer![index];
                                                return ProductList(
                                                  matvare: matvare,
                                                  onTap: () async {
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            FocusNode());
                                                    context.pushNamed(
                                                      'ProductDetail',
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
                                              } else {
                                                if (_model.matvarer == null ||
                                                    _model.matvarer!.length <
                                                        44) {
                                                  return Container();
                                                } else {
                                                  return const ShimmerLoadingWidget();
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
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
