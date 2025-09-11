import 'package:flutter/material.dart';

  
Route createRoute(Widget destination) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, animation, secondaryAnimation) => destination,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0); // bottom to top
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      final opacityTween = Tween<double>(begin: 0.0, end: 1.0);

      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(
          opacity: animation.drive(opacityTween),
          child: child,
        ),
      );
    },
  );
}