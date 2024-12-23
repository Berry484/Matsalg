import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'form_field_controller.dart'; // Import your FormFieldController

class FlutterFlowCheckboxGroup extends StatefulWidget {
  const FlutterFlowCheckboxGroup({
    super.key,
    required this.options,
    required this.onChanged,
    required this.controller, // Add controller from your imported file
    this.activeColor,
    this.checkColor,
    this.checkboxBorderColor,
    this.checkboxBorderRadius,
    this.textStyle,
    this.unselectedTextStyle,
    this.itemPadding,
    this.initialized = false,
  });

  final List<String> options;
  final void Function(List<String>) onChanged; // Keep it as a List<String>
  final FormFieldController<List<String>>
      controller; // Use the controller from imported file
  final Color? activeColor;
  final Color? checkColor;
  final Color? checkboxBorderColor;
  final BorderRadius? checkboxBorderRadius;
  final TextStyle? textStyle;
  final TextStyle? unselectedTextStyle;
  final EdgeInsetsGeometry? itemPadding;
  final bool initialized;

  @override
  FlutterFlowCheckboxGroupState createState() =>
      FlutterFlowCheckboxGroupState();
}

class FlutterFlowCheckboxGroupState extends State<FlutterFlowCheckboxGroup> {
  late List<String> selectedValues; // Keep this as List<String>

  @override
  void initState() {
    super.initState();
    // Initialize the selected values using the controller's initial value
    selectedValues = widget.controller.initialValue ?? [];
    if (widget.initialized) {
      widget.onChanged(selectedValues);
    }
  }

  void _onCheckboxChanged(bool? checked, String option) {
    setState(() {
      if (checked == true) {
        selectedValues = [option]; // Only select the current option
      } else {
        selectedValues = []; // Unselect if unchecked (optional)
      }
    });
    widget.controller.value = selectedValues; // Update the controller value
    widget
        .onChanged(selectedValues); // Call the onChanged callback with the list

    HapticFeedback.mediumImpact();
    Navigator.pop(context, selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.options.map((option) {
        final isSelected =
            selectedValues.contains(option); // Check if the option is selected
        return Padding(
          padding: widget.itemPadding ?? EdgeInsets.zero,
          child: Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: (checked) => _onCheckboxChanged(checked, option),
                activeColor: widget.activeColor,
                checkColor: widget.checkColor,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      widget.checkboxBorderRadius ?? BorderRadius.circular(4),
                ),
                side: WidgetStateBorderSide.resolveWith(
                  (states) => BorderSide(
                    color: widget.checkboxBorderColor ?? Colors.grey,
                    width: 1.5,
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    final newValue =
                        !isSelected; // Toggle the current selection
                    _onCheckboxChanged(newValue, option);
                  },
                  child: Text(
                    option,
                    style: isSelected
                        ? widget.textStyle
                        : widget.unselectedTextStyle,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
