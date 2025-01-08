import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_widgets.dart';
import 'package:mat_salg/pages/app_pages/explore/category/category_model.dart';
import 'package:mat_salg/services/food_service.dart';
import '../../../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

import 'filter_model.dart';
export 'filter_model.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({super.key, required this.filterOptions});
  final FilterOptions filterOptions;

  @override
  State<FilterWidget> createState() => _SorterWidgetState();
}

class _SorterWidgetState extends State<FilterWidget> {
  Timer? _debounce;
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  late FilterOptions filterOptions;
  late FilterOptions localFilterOptions;
  late FilterModel _model;
  late RangeValues previousPriceRange;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    filterOptions = widget.filterOptions;
    super.initState();
    _model = createModel(context, () => FilterModel());
    localFilterOptions = FilterOptions.copy(widget.filterOptions);
    previousPriceRange = localFilterOptions.priceRange;
    resultCount();
  }

  bool _isEmpty() {
    if (localFilterOptions.distance == null &&
        (localFilterOptions.priceRange.start == 0 &&
            localFilterOptions.priceRange.end == 800) &&
        localFilterOptions.selectedCategories.isEmpty) {
      return true;
    }

    return false;
  }

  void toggleCategorySelection(String category, bool isSelected) {
    setState(() {
      if (isSelected) {
        HapticFeedback.selectionClick();
        localFilterOptions.selectedCategories.add(category);
      } else {
        localFilterOptions.selectedCategories.remove(category);
      }
    });
  }

  Future<void> resultCount() async {
    _model.isLoading = true;
    String? token = await firebaseAuthService.getToken(context);
    if (token == null) {
      return;
    } else {
      String? results = await ApiFoodService.getCategoryFoodCount(
          token,
          localFilterOptions.priceRange.start.toInt(),
          localFilterOptions.priceRange.end.toInt(),
          localFilterOptions.distance,
          localFilterOptions.selectedCategories);
      setState(() {
        _model.resultCount = results;
      });
      _model.isLoading = false;
      return;
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
      child: Container(
        height: 699,
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primary,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x25090F13),
              offset: Offset(
                0.0,
                2,
              ),
            )
          ],
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(17, 0, 0, 0),
          child: SizedBox.expand(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    if (!_model.category)
                      Column(
                        key: ValueKey('OtherWidget'),
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                            height: 22,
                            thickness: 4,
                            indent: MediaQuery.of(context).size.width * 0.42,
                            endIndent: MediaQuery.of(context).size.width * 0.42,
                            color: Colors.black12,
                          ),
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    12, 0, 12, 20),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Filter',
                                      textAlign: TextAlign.start,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Nunito',
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            fontSize: 18,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: const AlignmentDirectional(1, -1),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 6, 17, 15),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      safeSetState(() {
                                        resultCount();
                                        _isEmpty();
                                        localFilterOptions.selectedCategories =
                                            [];
                                        localFilterOptions.distance = null;
                                        localFilterOptions.priceRange =
                                            RangeValues(0, 800);
                                      });
                                    },
                                    child: Text(
                                      'Nullstill',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Nunito',
                                            fontSize: 16,
                                            color: _isEmpty()
                                                ? FlutterFlowTheme.of(context)
                                                    .secondaryText
                                                : FlutterFlowTheme.of(context)
                                                    .alternate,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Material(
                            color: Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primary,
                                borderRadius: BorderRadius.circular(14),
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                  color: Colors.transparent,
                                  width: 0,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      safeSetState(() {
                                        _model.category = true;
                                      });
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 20, 0, 8),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            CupertinoIcons.square_grid_2x2,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            size: 28,
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(12, 0, 0, 0),
                                                child: Text(
                                                  'Kategori',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .labelLarge
                                                      .override(
                                                        fontFamily: 'Nunito',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontSize: 16,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                if (localFilterOptions
                                                    .selectedCategories
                                                    .isNotEmpty)
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                16, 0, 0, 0),
                                                    child: Container(
                                                      width: 30,
                                                      height: 19,
                                                      decoration: BoxDecoration(
                                                        color: Colors.redAccent,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  24),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  24),
                                                          topLeft:
                                                              Radius.circular(
                                                                  24),
                                                          topRight:
                                                              Radius.circular(
                                                                  24),
                                                        ),
                                                      ),
                                                      child: Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0, 0),
                                                        child: Text(
                                                          '${localFilterOptions.selectedCategories.length}',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Nunito Sans',
                                                                fontSize: 13,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.9, 0),
                                                  child: Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: Color(0xA0262C2D),
                                                    size: 22,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 16,
                                                ),
                                              ],
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
                          const Divider(
                            thickness: 1.2,
                            indent: 15,
                            endIndent: 15,
                            color: Color(0xE5EAEAEA),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 20, 0, 8),
                            child: Material(
                              color: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primary,
                                  borderRadius: BorderRadius.circular(14),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: Colors.transparent,
                                    width: 0,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(
                                          CupertinoIcons.placemark,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          size: 30,
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(12, 0, 0, 0),
                                              child: Text(
                                                'Lokasjon',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .labelLarge
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 16,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        HapticFeedback.selectionClick();
                                        resultCount();
                                        safeSetState(() {
                                          localFilterOptions.distance = null;
                                        });
                                      },
                                      child: Container(
                                        width: 77,
                                        height: 34,
                                        decoration: BoxDecoration(
                                          color: localFilterOptions.distance ==
                                                  null
                                              ? FlutterFlowTheme.of(context)
                                                  .alternate
                                              : Color(0xFFF6F6F6),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(24),
                                            bottomRight: Radius.circular(24),
                                            topLeft: Radius.circular(24),
                                            topRight: Radius.circular(24),
                                          ),
                                        ),
                                        child: Align(
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Text(
                                            'Alle',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Nunito Sans',
                                                  fontSize: 15,
                                                  color: localFilterOptions
                                                              .distance ==
                                                          null
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .primary
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .primaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 0, 0, 0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        HapticFeedback.selectionClick();
                                        resultCount();
                                        safeSetState(() {
                                          localFilterOptions.distance = 50;
                                        });
                                      },
                                      child: Container(
                                        width: 77,
                                        height: 34,
                                        decoration: BoxDecoration(
                                          color:
                                              localFilterOptions.distance == 50
                                                  ? FlutterFlowTheme.of(context)
                                                      .alternate
                                                  : Color(0xFFF6F6F6),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(24),
                                            bottomRight: Radius.circular(24),
                                            topLeft: Radius.circular(24),
                                            topRight: Radius.circular(24),
                                          ),
                                        ),
                                        child: Align(
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Text(
                                            '50Km',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Nunito Sans',
                                                  fontSize: 15,
                                                  color: localFilterOptions
                                                              .distance ==
                                                          50
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .primary
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .primaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 0, 0, 0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        HapticFeedback.selectionClick();
                                        resultCount();
                                        safeSetState(() {
                                          localFilterOptions.distance = 30;
                                        });
                                      },
                                      child: Container(
                                        width: 77,
                                        height: 34,
                                        decoration: BoxDecoration(
                                          color:
                                              localFilterOptions.distance == 30
                                                  ? FlutterFlowTheme.of(context)
                                                      .alternate
                                                  : Color(0xFFF6F6F6),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(24),
                                            bottomRight: Radius.circular(24),
                                            topLeft: Radius.circular(24),
                                            topRight: Radius.circular(24),
                                          ),
                                        ),
                                        child: Align(
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Text(
                                            '30Km',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Nunito Sans',
                                                  fontSize: 15,
                                                  color: localFilterOptions
                                                              .distance ==
                                                          30
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .primary
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .primaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 0, 0, 0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        HapticFeedback.selectionClick();
                                        resultCount();
                                        safeSetState(() {
                                          localFilterOptions.distance = 10;
                                        });
                                      },
                                      child: Container(
                                        width: 77,
                                        height: 34,
                                        decoration: BoxDecoration(
                                          color:
                                              localFilterOptions.distance == 10
                                                  ? FlutterFlowTheme.of(context)
                                                      .alternate
                                                  : Color(0xFFF6F6F6),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(24),
                                            bottomRight: Radius.circular(24),
                                            topLeft: Radius.circular(24),
                                            topRight: Radius.circular(24),
                                          ),
                                        ),
                                        child: Align(
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Text(
                                            '10Km',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Nunito Sans',
                                                  fontSize: 15,
                                                  color: localFilterOptions
                                                              .distance ==
                                                          10
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .primary
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .primaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 0, 16, 0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        HapticFeedback.selectionClick();
                                        resultCount();
                                        safeSetState(() {
                                          localFilterOptions.distance = 5;
                                        });
                                      },
                                      child: Container(
                                        width: 77,
                                        height: 34,
                                        decoration: BoxDecoration(
                                          color:
                                              localFilterOptions.distance == 5
                                                  ? FlutterFlowTheme.of(context)
                                                      .alternate
                                                  : Color(0xFFF6F6F6),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(24),
                                            bottomRight: Radius.circular(24),
                                            topLeft: Radius.circular(24),
                                            topRight: Radius.circular(24),
                                          ),
                                        ),
                                        child: Align(
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Text(
                                            '5Km',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Nunito Sans',
                                                  color: localFilterOptions
                                                              .distance ==
                                                          5
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .primary
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .primaryText,
                                                  fontSize: 15,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(
                            thickness: 1.2,
                            indent: 15,
                            endIndent: 15,
                            color: Color(0xE5EAEAEA),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 20, 0, 0),
                            child: Material(
                              color: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primary,
                                  borderRadius: BorderRadius.circular(14),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: Colors.transparent,
                                    width: 0,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(
                                          CupertinoIcons.tag,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          size: 26,
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(12, 0, 0, 0),
                                              child: Text(
                                                'Pris',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .labelLarge
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 16,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              rangeThumbShape: RoundRangeSliderThumbShape(
                                enabledThumbRadius: 11.5,
                              ),
                              rangeTrackShape:
                                  RectangularRangeSliderTrackShape(),
                              overlayShape: RoundSliderOverlayShape(
                                overlayRadius: 38.0,
                              ),
                            ),
                            child: RangeSlider(
                              values: localFilterOptions.priceRange,
                              min: 0,
                              max: 800,
                              activeColor:
                                  FlutterFlowTheme.of(context).alternate,
                              inactiveColor: Colors.black12,
                              divisions: 100,
                              onChanged: (RangeValues values) {
                                double start = values.start;
                                double end = values.end;
                                if (start < 800) {
                                  start = (start / 10).roundToDouble() * 10;
                                }
                                if (end < 800) {
                                  end = (end / 10).roundToDouble() * 10;
                                }
                                if (end - start >= 10) {
                                  if (start !=
                                          localFilterOptions.priceRange.start ||
                                      end !=
                                          localFilterOptions.priceRange.end) {
                                    HapticFeedback.selectionClick();
                                  }
                                  safeSetState(() {
                                    localFilterOptions.priceRange =
                                        RangeValues(start, end);
                                  });
                                  if (_debounce?.isActive ?? false) {
                                    _debounce!.cancel();
                                  }
                                  _debounce = Timer(
                                      const Duration(milliseconds: 50), () {
                                    if (localFilterOptions.priceRange ==
                                        RangeValues(start, end)) {
                                      safeSetState(() {
                                        _model.isLoading = true;
                                      });
                                      resultCount();
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 17, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Min: ${_model.formatter.format(localFilterOptions.priceRange.start.toInt())} Kr",
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily: 'Nunito',
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          fontSize: 17.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: localFilterOptions
                                                      .priceRange.end ==
                                                  800
                                              ? 'Max: ' // Regular text for "Max:"
                                              : "Max: ${_model.formatter.format(localFilterOptions.priceRange.end.toInt())} Kr", // Regular formatted number
                                          style: FlutterFlowTheme.of(context)
                                              .titleMedium
                                              .override(
                                                fontFamily: 'Nunito',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 17.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        if (localFilterOptions.priceRange.end ==
                                            800) // Apply larger font only for infinity symbol
                                          TextSpan(
                                            text: '∞',
                                            style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  fontFamily: 'Nunito',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  fontSize: 25.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    AnimatedSwitcher(
                        duration: const Duration(milliseconds: 150),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          final offsetAnimation = Tween<Offset>(
                            begin: _model.previousCategoryState
                                ? const Offset(-1.0, 0.0)
                                : const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                        child: _model.category
                            ? Container(
                                width: double.infinity,
                                color: FlutterFlowTheme.of(context).primary,
                                key: ValueKey('CategoryWidget'),
                                child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Divider(
                                        height: 22,
                                        thickness: 4,
                                        indent:
                                            MediaQuery.of(context).size.width *
                                                0.42,
                                        endIndent:
                                            MediaQuery.of(context).size.width *
                                                0.42,
                                        color: Colors.black12,
                                      ),
                                      Stack(
                                        children: [
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              safeSetState(() {
                                                resultCount();
                                                _model.category = false;
                                              });
                                            },
                                            child: Icon(
                                              Icons.arrow_back_ios,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 26.0,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(12, 0, 12, 20),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Kategorier',
                                                  textAlign: TextAlign.start,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Nunito',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontSize: 18,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                    1, -1),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 6, 17, 15),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  safeSetState(() {
                                                    resultCount();
                                                    _isEmpty();
                                                    localFilterOptions
                                                        .selectedCategories = [];
                                                    localFilterOptions
                                                        .distance = null;
                                                    localFilterOptions
                                                            .priceRange =
                                                        RangeValues(0, 800);
                                                  });
                                                },
                                                child: Text(
                                                  'Nullstill',
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'Nunito',
                                                            fontSize: 16,
                                                            color: _isEmpty()
                                                                ? FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText
                                                                : FlutterFlowTheme.of(
                                                                        context)
                                                                    .alternate,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(17, 8, 17, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children:
                                              _model.categories.map((category) {
                                            bool isSelected = localFilterOptions
                                                .selectedCategories
                                                .any((selectedCategory) =>
                                                    selectedCategory
                                                        .toLowerCase() ==
                                                    category.toLowerCase());

                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5.5),
                                              child: InkWell(
                                                onTap: () {
                                                  toggleCategorySelection(
                                                      category.toLowerCase(),
                                                      !isSelected);
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      category,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .titleMedium
                                                          .override(
                                                            fontFamily:
                                                                'Nunito',
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                            fontSize: 17.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                    Checkbox(
                                                      value: isSelected,
                                                      activeColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                      onChanged: (bool? value) {
                                                        toggleCategorySelection(
                                                            category
                                                                .toLowerCase(),
                                                            value!);
                                                      },
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                      side: BorderSide(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryText
                                                            .withOpacity(0.6),
                                                        width: 2.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ]))
                            : Container()),
                  ],
                ),
                Align(
                  alignment: const AlignmentDirectional(0, -1),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 17.0, 35.0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        if (_model.category) {
                          safeSetState(() {
                            _model.isLoading = true;
                          });

                          // Trigger the result count function
                          await resultCount();

                          safeSetState(() {
                            _model.isLoading = false; //
                            _model.category = false;
                          });
                        } else {
                          Navigator.pop(context, localFilterOptions);
                        }
                      },
                      text: _model.isLoading
                          ? ''
                          : _model.category
                              ? 'Bruk'
                              : (_model.resultCount != null)
                                  ? _model.resultCount == '1'
                                      ? 'Vis 1 resultat'
                                      : 'Vis ${_model.resultCount} resultater'
                                  : 'Vis 0 resultater',
                      icon: _model.isLoading
                          ? CupertinoActivityIndicator(
                              radius: 10.5,
                              color: FlutterFlowTheme.of(context).primary,
                            )
                          : null,
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 50.0,
                        iconColor: FlutterFlowTheme.of(context).primary,
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 0.0, 0.0, 0.0),
                        iconPadding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).alternate,
                        textStyle:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: 'Nunito',
                                  color: FlutterFlowTheme.of(context).secondary,
                                  fontSize: 16.0,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
