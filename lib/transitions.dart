import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'position.dart';

/*
class CellKey extends ValueKey<Cell> {
  CellKey(Cell p): super(p);
}

class EmptyAppearTransition extends StatefulWidget {
  final Widget child;
  final Piece piece;

  EmptyAppearTransition(this.child, this.piece);

  @override
  EmptyAppearState createState() => new EmptyAppearState();
}

class EmptyAppearState extends State<EmptyAppearTransition> with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    debugPrint("starting empty animation");
    controller.forward();
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return new ScaleTransition(
        key: new PieceKey(widget.piece),
        scale: controller,
        child: widget.child
    );

  }
}

class NewPieceTransition extends StatefulWidget {
  final Widget child;
  final Piece piece;

  NewPieceTransition(this.child, this.piece);

  @override
  NewPieceState createState() => new NewPieceState();
}


class NewPieceState extends State<NewPieceTransition> with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  initState() {
    super.initState();
    controller = new AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000)
    );
    debugPrint("starting new piece animation");
    controller.forward();
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    var animation = new CurvedAnimation(parent: controller, curve: Curves.elasticOut);

    return new ScaleTransition(key: new PieceKey(widget.piece), scale: animation, child: widget.child);
  }
}
*/

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

class SlidePositionedTransition extends StatefulWidget {
  final Widget child;
  final Position source;
  final Position target;
  final double cellWidth;

  SlidePositionedTransition({ @required this.child, @required this.source, @required this.target, @required this.cellWidth});

  @override
  SlidePositionedState createState() => new SlidePositionedState();
}

class SlidePositionedState extends State<SlidePositionedTransition> with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  initState() {
    super.initState();
    controller = new AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000)
    );
    debugPrint("starting animation to ${widget.target}.");
    controller.forward();
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {

    var source = new Offset(widget.source.x * widget.cellWidth, widget.source.y * widget.cellWidth);
    var target = new Offset(widget.target.x * widget.cellWidth, widget.target.y * widget.cellWidth);

    // debugPrint("sliding from $source to $target");

    Animation<Offset> offset = new Tween<Offset>(
      begin: source,
      end: target,
    ).animate(controller);

    debugPrint("returning new absolute position transition to $target from $source.");
    return new AbsolutePositionedTransition(
        // key: new PieceKey(widget.piece),
      key: new UniqueKey(),
      child: widget.child,
      size: new Size(widget.cellWidth,widget.cellWidth),
      offset: offset
    );
  }
}
