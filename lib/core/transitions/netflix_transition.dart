import 'package:flutter/material.dart';
//import 'dart:ui';

class NetflixTransition extends PageRouteBuilder {
  final Widget page;
  
  NetflixTransition({required this.page, super.settings})
    : super(
        transitionDuration: const Duration(milliseconds: 600),
        reverseTransitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Netflix-style curve
          final curve = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutQuart,
          );

          // Slide from right
          final slide = Tween<Offset>(
            begin: const Offset(0.25, 0),
            end: Offset.zero,
          ).animate(curve);

          // Fade slightly
          final fade = Tween<double>(begin: 0.0, end: 1.0).animate(curve);

          // Netflix subtle zoom-out on entry
          final scale = Tween<double>(begin: 1.12, end: 1.0).animate(curve);

          return Stack(
            children: [
              FadeTransition(
                opacity: fade,
                child: SlideTransition(
                  position: slide,
                  child: ScaleTransition(scale: scale, child: child),
                ),
              ),
            ],
          );
        },
      );
}
