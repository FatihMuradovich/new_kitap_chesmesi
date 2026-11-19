import 'package:flutter/material.dart';

class SlideRoute extends PageRouteBuilder {
  final Widget page;
  final SlideDirection direction;

  SlideRoute({
    required this.page,
    this.direction = SlideDirection.fromTop,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            Offset begin;
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            switch (direction) {
              case SlideDirection.fromTop:
                begin = const Offset(0.0, -1.0);
                break;
              case SlideDirection.fromBottom:
                begin = const Offset(0.0, 1.0);
                break;
              case SlideDirection.fromLeft:
                begin = const Offset(-1.0, 0.0);
                break;
              case SlideDirection.fromRight:
                begin = const Offset(1.0, 0.0);
                break;
            }

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}

enum SlideDirection {
  fromTop,
  fromBottom,
  fromLeft,
  fromRight,
}
