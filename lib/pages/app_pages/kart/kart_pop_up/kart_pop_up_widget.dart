import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:mat_salg/helper_components/Toasts.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import '../../../../helper_components/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'kart_pop_up_model.dart';
export 'kart_pop_up_model.dart';

class KartPopUpWidget extends StatefulWidget {
  const KartPopUpWidget({
    super.key,
    this.startLat,
    this.startLng,
  });

  final dynamic startLat;
  final dynamic startLng;

  @override
  State<KartPopUpWidget> createState() => _KartPopUpWidgetState();
}

class _KartPopUpWidgetState extends State<KartPopUpWidget> {
  late KartPopUpModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => KartPopUpModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 60.0, 0.0, 0.0),
      child: Container(
        width: 500,
        height: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primary,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      height: 22,
                      thickness: 4,
                      indent: MediaQuery.of(context).size.width * 0.4,
                      endIndent: MediaQuery.of(context).size.width * 0.4,
                      color: Colors.black12,
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  7, 0, 0, 0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  try {
                                    Navigator.pop(context);
                                  } on SocketException {
                                    Toasts.showErrorToast(
                                        context, 'Ingen internettforbindelse');
                                  } catch (e) {
                                    Toasts.showErrorToast(
                                        context, 'En feil oppstod');
                                  }
                                },
                                child: Icon(
                                  CupertinoIcons.xmark,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 25,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 0),
                            child: Text(
                              'Kart',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Nunito',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize: 18,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 7, 0),
                            child: Icon(
                              CupertinoIcons.xmark,
                              color: Colors.transparent,
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  width: 500.0,
                  height: MediaQuery.sizeOf(context).height,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: SizedBox(
                    width: 500.0,
                    height: 450.0,
                    child: custom_widgets.MyOsmKart(
                      width: 500.0,
                      height: 450.0,
                      center: LatLng(widget.startLat, widget.startLng),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
