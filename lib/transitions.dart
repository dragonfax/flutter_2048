import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class EmptyAppearTransition extends StatefulWidget {
  final Widget child;

  EmptyAppearTransition(this.child);

  @override
  EmptyAppearState createState() => new EmptyAppearState();
}

class EmptyAppearState extends State<EmptyAppearTransition> with SingleTickerProviderStateMixin {
  AnimationController controller;

  EmptyAppearState() {
    controller = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new ScaleTransition(
        scale: controller,
        child: widget.child
    );

  }
}

class NewPieceTransition extends StatefulWidget {
  final Widget child;

  NewPieceTransition(this.child);

  @override
  NewPieceState createState() => new NewPieceState();
}

class NewPieceState extends State<NewPieceTransition> with SingleTickerProviderStateMixin {
  AnimationController controller;

  NewPieceState() {
    controller = new AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000)
    );
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {

    var animation = new CurvedAnimation(parent: controller, curve: Curves.elasticOut);

    return new ScaleTransition(scale: animation, child: widget.child);
  }
}

class AbsolutePositionedTransition extends AnimatedWidget {
  /// Uses static size for the Positioned, (not the container, like RelativePositionedTransition does)
  const AbsolutePositionedTransition({
    Key key,
    @required Animation<Offset> offset,
    @required this.size,
    @required this.child,
  }) : super(key: key, listenable: offset);

  Animation<Offset> get offset => listenable;

  /// The widget below this widget in the tree.
  final Widget child;
  final Size size;

  @override
  Widget build(BuildContext context) {
    // debugPrint("building with [${offset.value.dx},${offset.value.dy}]");
    return new Positioned(
      width: size.width,
      height: size.height,
      top: offset.value.dy,
      left: offset.value.dx,
      child: child,
    );
  }
}
