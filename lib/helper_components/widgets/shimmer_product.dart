import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingWidget extends StatelessWidget {
  const ShimmerLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(5.0),
            width: 190.0,
            height: 230.0,
            decoration: BoxDecoration(
              color: const Color.fromARGB(115, 255, 255, 255),
              borderRadius: BorderRadius.circular(16.0), // Rounded corners
            ),
          ),
          const SizedBox(height: 8.0),
          Container(
            width: 190,
            height: 15,
            decoration: BoxDecoration(
              color: const Color.fromARGB(115, 255, 255, 255),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ],
      ),
    );
  }
}
