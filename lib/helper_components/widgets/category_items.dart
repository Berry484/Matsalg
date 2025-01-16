import 'package:flutter/material.dart';
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
    final List<String> texts = [
      'Kjøtt',
      'Grønt',
      'Meieri',
      'Sjømat',
      'Produkter',
    ];

    final List<String> kategorier = [
      'kjøtt',
      'grønt',
      'meieri',
      'sjømat',
      'produkter',
    ];

    final List<String> images = [
      'meat',
      'green',
      'dairy',
      'seafood',
      'selfmade',
    ];

    final text = texts[index];
    final kategori = kategorier[index];

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
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
              Image.asset(
                'assets/images/${images[index]}.png',
                height: 33,
                width: 37,
              ),
              const SizedBox(height: 2),
              Text(
                text,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Nunito',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
