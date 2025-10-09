import 'dart:async';
import 'package:flutter/material.dart';

class SlidingBackground extends StatefulWidget {
  final List<String> imagePaths;
  final int imageCount;
  final Duration slideDuration;

  const SlidingBackground({
    super.key,
    required this.imagePaths,
    required this.imageCount,
    required this.slideDuration,
  });

  @override
  State<SlidingBackground> createState() => _SlidingBackgroundState();
}

class _SlidingBackgroundState extends State<SlidingBackground> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.slideDuration, (Timer timer) {
      if (_currentPage < widget.imageCount - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.imageCount,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(widget.imagePaths[index]),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.5),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}