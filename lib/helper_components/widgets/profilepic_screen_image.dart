import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class ProfilepicScreenImage extends StatefulWidget {
  final String imageUrl;

  const ProfilepicScreenImage({super.key, required this.imageUrl});

  @override
  ProfilepicScreenImageState createState() => ProfilepicScreenImageState();
}

class ProfilepicScreenImageState extends State<ProfilepicScreenImage>
    with SingleTickerProviderStateMixin {
  Offset _offset = Offset.zero;
  double _scale = 1.0;
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _controller.addListener(() {
      setState(() {
        _offset = _animation.value;
        _scale = _scaleAnimation.value;
      });
    });
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      final newScale = _scale * details.scale;
      _scale = newScale.clamp(0.95, 1.69);
      _offset += details.focalPointDelta;
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      _offset = Offset(
        _offset.dx.clamp(-screenWidth * 0.5, screenWidth * 0.5),
        _offset.dy.clamp(-screenHeight * 0.5, screenHeight * 0.5),
      );
    });
  }

  void _onScaleEnd(ScaleEndDetails details) {
    if (_offset.distance > 100) {
      Navigator.pop(context);
    } else {
      _animateBack();
    }
  }

  void _animateBack() {
    _animation = Tween<Offset>(begin: _offset, end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _scaleAnimation = Tween<double>(begin: _scale, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
            Positioned.fill(
              child: GestureDetector(
                onTap: () {},
                onScaleUpdate: _onScaleUpdate,
                onScaleEnd: _onScaleEnd,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (_, __) {
                    return Transform.translate(
                      offset: _offset,
                      child: Transform.scale(
                        scale: _scale,
                        child: Center(
                          child: Hero(
                            tag: widget.imageUrl,
                            child: ClipOval(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                height: MediaQuery.of(context).size.width * 0.7,
                                child: Image(
                                  image: CachedNetworkImageProvider(
                                    widget.imageUrl,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
