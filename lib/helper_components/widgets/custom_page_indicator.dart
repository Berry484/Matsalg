import 'package:flutter/cupertino.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_theme.dart';

class CustomPageIndicator extends StatefulWidget {
  const CustomPageIndicator(
      {super.key, required this.itemCount, required this.currentIndex});

  final int itemCount;
  final int currentIndex;

  @override
  CustomPageIndicatorState createState() => CustomPageIndicatorState();
}

class CustomPageIndicatorState extends State<CustomPageIndicator> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.itemCount, (index) {
        if (index == 0) {
          return Icon(
            CupertinoIcons.location_fill,
            size: 13.5,
            color: widget.currentIndex == 0
                ? FlutterFlowTheme.of(context).alternate
                : const Color(0xFFE6E6E6),
          );
        } else {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: widget.currentIndex == index
                  ? FlutterFlowTheme.of(context).alternate
                  : const Color(0xFFE6E6E6),
              shape: BoxShape.circle,
            ),
          );
        }
      }),
    );
  }
}
