import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';


class SwipeGestureWidget extends StatelessWidget {

  final Widget child;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;
  final VoidCallback onSwipeUp;
  final VoidCallback onSwipeDown;

  SwipeGestureWidget({ @required this.child, this.onSwipeLeft, this.onSwipeRight, this.onSwipeUp, this.onSwipeDown });

  @override
  Widget build(BuildContext context) {

    return Focus(
      autofocus: true,
      onKey: (node, event) {
        if ( event is RawKeyDownEvent ) {
          if ( event.logicalKey == LogicalKeyboardKey.arrowLeft ) {
            onSwipeLeft();
            return true;
          }
          if ( event.logicalKey == LogicalKeyboardKey.arrowRight ) {
            onSwipeRight();
            return true;
          }
          if ( event.logicalKey == LogicalKeyboardKey.arrowDown ) {
            onSwipeDown();
            return true;
          }
          if ( event.logicalKey == LogicalKeyboardKey.arrowUp ) {
            onSwipeUp();
            return true;
          }
        }
        return false;
      },
      child: GestureDetector(
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
      )
    );
  }
}