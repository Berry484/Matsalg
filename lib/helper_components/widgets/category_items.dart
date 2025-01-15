import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_theme.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_util.dart';
//-----------------------------------------------------------------------------------------------------------------------
//--------------------Displays a category that is used on the home page--------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------

class CategoryItem extends StatelessWidget {
  final int index;

  const CategoryItem({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final List<IconData> icons = [
      Ionicons.restaurant_outline,
      Ionicons.leaf_outline,
      Ionicons.egg_outline,
      Ionicons.basket_outline,
      Ionicons.fish_outline,
    ];

    final List<String> texts = [
      'Kjøtt',
      'Grønt',
      'Meieri',
      'Bakverk',
      'Sjømat',
    ];

    final List<String> kategorier = [
      'kjøtt',
      'grønt',
      'meieri',
      'bakverk',
      'sjømat',
    ];

    final icon = icons[index];
    final text = texts[index];
    final kategori = kategorier[index];

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0, 0, 0),
      child: GestureDetector(
        onTap: () async {
          context.pushNamed(
            'BondeGardPage',
            queryParameters: {
              'kategori': serializeParam(kategori, ParamType.String),
            }.withoutNulls,
          );
        },
        child: Container(
          width: 90,
          height: 103.14,
          decoration: BoxDecoration(
            color: const Color(0xFFF6F6F6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 29,
              ),
              const SizedBox(height: 2),
              Text(
                text,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Nunito',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
