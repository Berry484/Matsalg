import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'category_widget.dart' show CategoryWidget;
import 'package:flutter/material.dart';

class FilterOptions {
  int? distance;
  RangeValues priceRange;
  List<String> selectedCategories;

  FilterOptions({
    this.distance,
    required this.priceRange,
    required this.selectedCategories,
  });

  FilterOptions.copy(FilterOptions original)
      : distance = original.distance,
        priceRange = original.priceRange,
        selectedCategories = List.from(original.selectedCategories);
}

class CategoryModel extends FlutterFlowModel<CategoryWidget> {
//---------------------------------------------------------------------------------------------------------------
//--------------------Variables used througout-------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  List<Matvarer>? matvarer;
  List<Matvarer>? allmatvarer;
  bool isloading = true;
  bool empty = false;
  bool sortByPriceAsc = false;
  bool sortByPriceDesc = false;
  bool sortByDistance = false;
  bool end = false;
  int sorterVerdi = 1;
  int page = 0;

//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes, Controllers and validators-----------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  FocusNode? textFieldFocusNode;

  TextEditingController? textController;

//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes and controller for the text fields----------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  String? Function(BuildContext, String?)? textControllerValidator;

//---------------------------------------------------------------------------------------------------------------
//--------------------Initstate and dispose----------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
