import '/flutter_flow/flutter_flow_checkbox_group.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';

import 'sorter_model.dart';
export 'sorter_model.dart';

class SorterWidget extends StatefulWidget {
  const SorterWidget({
    super.key,
    this.sorterVerdi,
  });
  final dynamic sorterVerdi;

  @override
  State<SorterWidget> createState() => _SorterWidgetState();
}

class _SorterWidgetState extends State<SorterWidget> {
  late SorterModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SorterModel());

    // Initialize the checkbox group values based on sorterVerdi
    if (widget.sorterVerdi == 1) {
      _model.checkboxGroupValueController =
          FormFieldController<List<String>>(['Mest relevant']);
    } else if (widget.sorterVerdi == 2) {
      _model.checkboxGroupValueController =
          FormFieldController<List<String>>(['Pris: lav til høy']);
    } else if (widget.sorterVerdi == 3) {
      _model.checkboxGroupValueController =
          FormFieldController<List<String>>(['Pris: høy til lav']);
    } else {
      _model.checkboxGroupValueController =
          FormFieldController<List<String>>([]); // Fallback if invalid
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 380,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primary,
        boxShadow: [
          const BoxShadow(
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
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            height: 22,
            thickness: 3,
            indent: 185,
            endIndent: 185,
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Sorter etter',
                      textAlign: TextAlign.start,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Nunito',
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 20,
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
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 6, 17, 15),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Lukk',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Nunito',
                            fontSize: 17,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(17, 27, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FlutterFlowCheckboxGroup(
                  options: const [
                    'Mest relevant',
                    'Pris: lav til høy',
                    'Pris: høy til lav',
                  ],
                  onChanged: (val) {
                    // Use post-frame callback to update state after the build is done
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        _model.checkboxGroupValues = val;
                      });
                    });
                  },
                  controller: _model.checkboxGroupValueController ??=
                      FormFieldController<List<String>>([]),
                  activeColor: FlutterFlowTheme.of(context).alternate,
                  checkColor: FlutterFlowTheme.of(context).primary,
                  checkboxBorderColor:
                      FlutterFlowTheme.of(context).secondaryText,
                  textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Nunito',
                        fontSize: 18,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                  unselectedTextStyle:
                      FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Nunito',
                            fontSize: 18,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                          ),
                  itemPadding:
                      const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 14),
                  checkboxBorderRadius: BorderRadius.circular(24),
                  initialized: _model.checkboxGroupValues != null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
