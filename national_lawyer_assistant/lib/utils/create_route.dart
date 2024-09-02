import 'package:flutter/material.dart';

enum TransitionType { slide, fade, scale, rotation }

Route createPopupRoute({
  required Widget redirectedPage,
  TransitionType transitionType = TransitionType.slide,
  int duration = 2000,
}) {
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: duration),
    pageBuilder: (context, animation, secondaryAnimation) => redirectedPage,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (transitionType) {
        case TransitionType.slide:
          const begin = Offset(1.0, 0.0); // Slide from right to left
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );

        case TransitionType.fade:
          return FadeTransition(
            opacity: animation,
            child: child,
          );

        case TransitionType.scale:
          return ScaleTransition(
            scale: animation,
            child: child,
          );

        case TransitionType.rotation:
          return RotationTransition(
            turns: animation,
            child: child,
          );

        default:
          return child;
      }
    },
  );
}
