import '../../../../../helper_components/flutter_flow/form_field_controller.dart';
import '../../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import 'filter_widget.dart' show FilterWidget;
import 'package:flutter/material.dart';

class FilterModel extends FlutterFlowModel<FilterWidget> {
  final NumberFormat formatter = NumberFormat('#,###', 'fr_FR');
//---------------------------------------------------------------------------------------------------------------
//--------------------Variables used througout-------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  String? resultCount;
  bool previousCategoryState = false;
  bool isLoading = false;
  bool category = false;
  List<String> categories = [
    'Kjøtt',
    'Grønt',
    'Meieri',
    'Sjømat',
    'Produkter',
  ];

//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes, Controllers and validators for the text fields---------------------------------
//---------------------------------------------------------------------------------------------------------------
  FormFieldController<List<String>>? checkboxGroupValueController;

  List<String>? get checkboxGroupValues => checkboxGroupValueController?.value;

//---------------------------------------------------------------------------------------------------------------
//--------------------FocusNodes and controller for the text fields----------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  set checkboxGroupValues(List<String>? v) =>
      checkboxGroupValueController?.value = v;

//---------------------------------------------------------------------------------------------------------------
//--------------------Initstate and dispose----------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
