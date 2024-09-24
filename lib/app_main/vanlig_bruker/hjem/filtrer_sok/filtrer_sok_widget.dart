import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'filtrer_sok_model.dart';
export 'filtrer_sok_model.dart';

class FiltrerSokWidget extends StatefulWidget {
  const FiltrerSokWidget({super.key});

  @override
  State<FiltrerSokWidget> createState() => _FiltrerSokWidgetState();
}

class _FiltrerSokWidgetState extends State<FiltrerSokWidget> {
  late FiltrerSokModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FiltrerSokModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: 260.0,
        height: 330.0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4.0,
              color: Color(0x33000000),
              offset: Offset(
                0.0,
                2.0,
              ),
            )
          ],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: const AlignmentDirectional(-1.0, -1.0),
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 0.0, 0.0),
                child: Text(
                  'Filtrer',
                  textAlign: TextAlign.start,
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Plus Jakarta Sans',
                        color: const Color(0xFF57636C),
                        fontSize: 14.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
              child: Theme(
                data: ThemeData(
                  checkboxTheme: const CheckboxThemeData(
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  unselectedWidgetColor: FlutterFlowTheme.of(context).alternate,
                ),
                child: CheckboxListTile(
                  value: _model.checkboxListTileValue1 ??= false,
                  onChanged: (newValue) async {
                    safeSetState(
                        () => _model.checkboxListTileValue1 = newValue!);
                  },
                  title: Text(
                    'Kjøtt',
                    style: FlutterFlowTheme.of(context).titleLarge.override(
                          fontFamily: 'Open Sans',
                          fontSize: 18.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  tileColor: FlutterFlowTheme.of(context).primaryBackground,
                  activeColor: FlutterFlowTheme.of(context).primary,
                  checkColor: FlutterFlowTheme.of(context).alternate,
                  dense: false,
                  controlAffinity: ListTileControlAffinity.trailing,
                  contentPadding: const EdgeInsetsDirectional.fromSTEB(
                      12.0, 0.0, 12.0, 0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
              child: Theme(
                data: ThemeData(
                  checkboxTheme: const CheckboxThemeData(
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  unselectedWidgetColor: FlutterFlowTheme.of(context).alternate,
                ),
                child: CheckboxListTile(
                  value: _model.checkboxListTileValue2 ??= false,
                  onChanged: (newValue) async {
                    safeSetState(
                        () => _model.checkboxListTileValue2 = newValue!);
                  },
                  title: Text(
                    'Grønnt',
                    style: FlutterFlowTheme.of(context).titleLarge.override(
                          fontFamily: 'Open Sans',
                          fontSize: 18.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  tileColor: FlutterFlowTheme.of(context).primaryBackground,
                  activeColor: FlutterFlowTheme.of(context).primary,
                  checkColor: FlutterFlowTheme.of(context).alternate,
                  dense: false,
                  controlAffinity: ListTileControlAffinity.trailing,
                  contentPadding: const EdgeInsetsDirectional.fromSTEB(
                      12.0, 0.0, 12.0, 0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
              child: Theme(
                data: ThemeData(
                  checkboxTheme: const CheckboxThemeData(
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  unselectedWidgetColor: FlutterFlowTheme.of(context).alternate,
                ),
                child: CheckboxListTile(
                  value: _model.checkboxListTileValue3 ??= false,
                  onChanged: (newValue) async {
                    safeSetState(
                        () => _model.checkboxListTileValue3 = newValue!);
                  },
                  title: Text(
                    'Meieri',
                    style: FlutterFlowTheme.of(context).titleLarge.override(
                          fontFamily: 'Open Sans',
                          fontSize: 18.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  tileColor: FlutterFlowTheme.of(context).primaryBackground,
                  activeColor: FlutterFlowTheme.of(context).primary,
                  checkColor: FlutterFlowTheme.of(context).alternate,
                  dense: false,
                  controlAffinity: ListTileControlAffinity.trailing,
                  contentPadding: const EdgeInsetsDirectional.fromSTEB(
                      12.0, 0.0, 12.0, 0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
              child: Theme(
                data: ThemeData(
                  checkboxTheme: const CheckboxThemeData(
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  unselectedWidgetColor: FlutterFlowTheme.of(context).alternate,
                ),
                child: CheckboxListTile(
                  value: _model.checkboxListTileValue4 ??= false,
                  onChanged: (newValue) async {
                    safeSetState(
                        () => _model.checkboxListTileValue4 = newValue!);
                  },
                  title: Text(
                    'Bakverk',
                    style: FlutterFlowTheme.of(context).titleLarge.override(
                          fontFamily: 'Open Sans',
                          fontSize: 18.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  tileColor: FlutterFlowTheme.of(context).primaryBackground,
                  activeColor: FlutterFlowTheme.of(context).primary,
                  checkColor: FlutterFlowTheme.of(context).alternate,
                  dense: false,
                  controlAffinity: ListTileControlAffinity.trailing,
                  contentPadding: const EdgeInsetsDirectional.fromSTEB(
                      12.0, 0.0, 12.0, 0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 25.0, 0.0, 0.0),
              child: FFButtonWidget(
                onPressed: () async {
                  Navigator.pop(context);
                },
                text: 'Filtrer',
                options: FFButtonOptions(
                  width: 170.0,
                  height: 32.0,
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  iconPadding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).alternate,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Lexend Deca',
                        color: FlutterFlowTheme.of(context).primary,
                        fontSize: 17.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                  elevation: 3.0,
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
