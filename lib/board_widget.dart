import 'package:flutter/material.dart';
import 'board.dart';
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
    debugPrint("building with [${offset.value.dx},${offset.value.dy}]");
    return new Positioned(
      width: size.width,
      height: size.height,
      top: offset.value.dy,
      left: offset.value.dx,
      child: child,
    );
  }
}

class SlideTransition extends StatefulWidget {
  final Widget child;
  final Position source;
  final Position target;

  SlideTransition({ @required this.child, @required this.source, @required this.target});

  @override
  SlideState createState() => new SlideState();
}

class SlideState extends State<SlideTransition> with SingleTickerProviderStateMixin {
  AnimationController controller;

  SlideState() {
    controller = new AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000)
    );
    controller.forward();
  }

  Widget build(BuildContext context) {

    var source = new Offset(widget.source.x * CellWidth, widget.source.y * CellWidth);
    var target = new Offset(widget.target.x * CellWidth, widget.target.y * CellWidth);

    debugPrint("sliding from $source to $target");

    Animation<Offset> offset = new Tween<Offset>(
      begin: source,
      end: target,
    ).animate(controller);

    return new AbsolutePositionedTransition(
      child: widget.child,
      size: new Size(CellWidth,CellWidth),
      offset: offset
    );
  }
}

class CellWidget extends StatefulWidget {
  final Piece piece;

  CellWidget(this.piece);

  @override
  CellWidgetState createState() => new CellWidgetState();
}

const CellWidth = 60.0;

class CellWidgetState extends State<CellWidget> {


  Widget createPositioned(Position pos, Widget child) {
    return new Positioned(
        top: pos.y * CellWidth,
        height: CellWidth,
        left: pos.x * CellWidth,
        width: CellWidth,
        child: child
    );
  }

  @override
  Widget build(BuildContext context) {

     var container = new Container(
            margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.all(8.0),
            width: 60.0,
            height: 60.0,
            alignment: Alignment.center,
            decoration: new BoxDecoration(
                border: new Border.all(width: 2.0, color: Colors.black),
                borderRadius:
                    const BorderRadius.all(const Radius.circular(10.0))),
            child: new Text(
                widget.piece.value == null ? " " : widget.piece.toString(),
                style: const TextStyle(
                    fontSize: 28.0, fontWeight: FontWeight.bold))
     );


     var position = widget.piece.position;
     if ( widget.piece.fromNothing() ) {
       return createPositioned(position, new EmptyAppearTransition(container));
     } else if ( widget.piece.newPiece() ) {
       return createPositioned(position, new NewPieceTransition(container));
     } else if ( widget.piece.maintained() || widget.piece.merged() ) {
       if ( ! widget.piece.position.equals(widget.piece.source[0].position) ) {
         return new SlideTransition(
             child: container,
             source: widget.piece.source[0].position,
             target: widget.piece.position
         );
       } else {
         return createPositioned(position, container);
       }
     } else {
       throw "unknown piece source";
     }
  }
}

class BoardWidget extends StatefulWidget {
  final Board board;

  BoardWidget(this.board);

  @override
  BoardWidgetState createState() => new BoardWidgetState();
}

class BoardWidgetState extends State<BoardWidget> {
  Widget build(BuildContext context) {

    var children = <Widget>[];
    for (int x = 0; x <= 3; x++) {
      for (int y = 0; y <= 3; y++) {
        var piece = widget.board.get(x, y);
        children.add(new CellWidget(piece));
      }
    }

    return new Container(
        width: CellWidth * 4,
        height: CellWidth * 4,
        child: new Stack(children: children));
  }
}
