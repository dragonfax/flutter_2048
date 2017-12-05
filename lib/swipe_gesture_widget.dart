import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class SwipeGestureWidget extends StatelessWidget {

  final Widget child;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;
  final VoidCallback onSwipeUp;
  final VoidCallback onSwipeDown;

  SwipeGestureWidget({ @required this.child, this.onSwipeLeft, this.onSwipeRight, this.onSwipeUp, this.onSwipeDown });

  @override
  Widget build(BuildContext context) {

    return new GestureDetector(
      onHorizontalDragEnd: (deets) {
          if (deets.primaryVelocity < 0.0) {
            if ( onSwipeLeft != null ) {
              onSwipeLeft();
            }
          } else {
            if ( onSwipeRight != null ) {
              onSwipeRight();
            }
          }
      },
      onVerticalDragEnd: (deets) {
          if (deets.primaryVelocity < 0.0) {
            if ( onSwipeUp != null ) {
              onSwipeUp();
            }
          } else {
            if ( onSwipeDown != null ) {
              onSwipeDown();
            }
          }
      },
      child: child
    );
  }
}