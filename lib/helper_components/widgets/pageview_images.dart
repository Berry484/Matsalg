import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final String imageUrl;
  final bool isSoldOut;

  const ImageCard({
    super.key,
    required this.imageUrl,
    required this.isSoldOut,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 485,
          child: CachedNetworkImage(
            fadeInDuration: Duration.zero,
            imageUrl: imageUrl,
            width: double.infinity,
            height: 485,
            fit: BoxFit.cover,
            alignment: const Alignment(0.0, 0.0),
            imageBuilder: (context, imageProvider) {
              return Container(
                width: double.infinity,
                height: 485,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
            errorWidget: (context, url, error) => Container(
              width: double.infinity,
              height: 485,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                image: const DecorationImage(
                  image: AssetImage('assets/images/error_image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        if (isSoldOut)
          Positioned(
            top: 18,
            right: -25,
            child: Transform.rotate(
              angle: 0.600,
              child: Container(
                width: 140,
                height: 25,
                color: Colors.redAccent,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(right: 2),
                child: const Text(
                  'Utsolgt',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
