import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mat_salg/helper_components/functions/custom_pageview_scroll_physics.dart';
import 'package:mat_salg/my_ip.dart';
import 'package:zoom_widget/zoom_widget.dart';

class FullscreenImageGallery extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullscreenImageGallery({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  FullscreenImageGalleryState createState() => FullscreenImageGalleryState();
}

class FullscreenImageGalleryState extends State<FullscreenImageGallery> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _currentIndex = widget.initialIndex;
    _pageController.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    if (_pageController.page != null) {
      setState(() {
        _currentIndex = _pageController.page!.round();
      });
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.white.withOpacity(0.74),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              child: PageView.builder(
                physics: const PageScrollPhysics(),
                itemCount: widget.imageUrls.length,
                controller: _pageController,
                itemBuilder: (context, index) {
                  return Zoom(
                    maxScale: 3.0,
                    initScale: 1.0,
                    colorScrollBars: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    doubleTapZoom: false,
                    opacityScrollBars: 0,
                    child: Hero(
                      tag: widget.imageUrls[index],
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.59,
                        child: Image(
                          image: CachedNetworkImageProvider(
                            '${ApiConstants.baseUrl}${widget.imageUrls[index]}',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 70,
            right: 20,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Lukk',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "${_currentIndex + 1} av ${widget.imageUrls.length}",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
