import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'position.dart';

class EmptyAppearTransition extends StatefulWidget {
  final Widget child;

  EmptyAppearTransition(this.child);

  @override
  EmptyAppearState createState() => new EmptyAppearState();
}

class EmptyAppearState extends State<EmptyAppearTransition>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    controller.forward();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Animation<double> animation = new TweenSequence(
      <TweenSequenceItem<double>>[
        new TweenSequenceItem<double>(
          tween: new ConstantTween<double>(0.0),
          weight: 85.0,
        ),
        new TweenSequenceItem<double>(
          tween: new CurveTween(curve: new Threshold(0.50)),
          weight: 15.0,
        ),
      ],
    ).animate(controller);

    // return new ScaleTransition(scale: animation, child: widget.child);
    /*
    return new AnimatedOpacity(
      child: widget.child,
      opacity: 1.0,
      duration: new Duration(milliseconds: 700),
      curve: new Threshold(0.85),
    );
    */

    return new FadeTransition(
      child: widget.child,
      opacity: animation,
    );
  }
}

class PopInTransition extends StatefulWidget {
  final Widget child;

  PopInTransition(this.child);

  @override
  PopInState createState() => new PopInState();
}

class PopInState extends State<PopInTransition>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  initState() {
    super.initState();

    controller = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    controller.forward();
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var animation = new CurvedAnimation(parent: controller, curve: Curves.elasticOut);

    Animation<double> animation = new TweenSequence(
      <TweenSequenceItem<double>>[
        new TweenSequenceItem<double>(
          tween: new ConstantTween<double>(0.0),
          weight: 75.0,
        ),
        new TweenSequenceItem<double>(
          tween: new CurveTween(curve: Curves.elasticOut),
          weight: 25.0,
        ),
      ],
    ).animate(controller);

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

class SlidePositionedTransition extends StatefulWidget {
  final Widget child;
  final Position source;
  final Position target;
  final double cellWidth;

  SlidePositionedTransition({
      @required Key key,
      @required this.child,
      @required this.source,
      @required this.target,
      @required this.cellWidth
    }) : super(key: key);

  @override
  SlidePositionedState createState() => new SlidePositionedState();
}

class SlidePositionedState extends State<SlidePositionedTransition>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  initState() {
    super.initState();
    controller = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    // debugPrint("starting animation to ${widget.target}.");
    controller.forward();
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    var source = widget.source;
    var target = widget.target;
    if (source == null) {
      source = target;
    }
    var sourceO =
        new Offset(source.x * widget.cellWidth, source.y * widget.cellWidth);
    var targetO =
        new Offset(target.x * widget.cellWidth, target.y * widget.cellWidth);

    Animation<Offset> offset = new TweenSequence(<TweenSequenceItem<Offset>>[
      new TweenSequenceItem<Offset>(
        tween: new Tween<Offset>(
          begin: sourceO,
          end: sourceO,
        ),
        weight: 33.0,
      ),
      new TweenSequenceItem<Offset>(
        tween: new Tween<Offset>(
          begin: sourceO,
          end: targetO,
        ),
        weight: 66.0,
      ),
    ]).animate(controller);

    // debugPrint("returning new absolute position transition to $target from $source.");
    return new AbsolutePositionedTransition(
        child: widget.child,
        size: new Size(widget.cellWidth, widget.cellWidth),
        offset: offset
      );
  }
}
