import '../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../helper_components/flutter_flow/flutter_flow_util.dart';
import '../../helper_components/widgets/maps/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'kart_pop_up_model.dart';
export 'kart_pop_up_model.dart';

class KartPopUpWidget extends StatefulWidget {
  const KartPopUpWidget({
    super.key,
    this.startLat,
    this.startLng,
    this.accuratePosition,
  });

  final double? startLat;
  final double? startLng;
  final bool? accuratePosition;

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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) {
            return;
          }
        },
        child: Scaffold(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            elevation: 0,
            scrolledUnderElevation: 0.0,
            leading: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 28.0,
                ),
                onPressed: () {
                  context.safePop();
                },
              ),
            ),
            centerTitle: true,
            title: Text(
              'Kart',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Nunito',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 18,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            actions: [],
          ),
          body: SafeArea(
            top: true,
            bottom: false,
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
                          center: LatLng(
                              widget.startLat ?? 0, widget.startLng ?? 0),
                          accuratePosition: widget.accuratePosition ?? false,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
