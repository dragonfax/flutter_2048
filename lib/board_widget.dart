import 'package:flutter/material.dart';
import 'board.dart';



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

class CellWidget extends StatefulWidget {
  final Piece piece;

  CellWidget(this.piece);

  @override
  CellWidgetState createState() => new CellWidgetState();
}

class CellWidgetState extends State<CellWidget> {

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


     if ( widget.piece.source == Source.empty ) {
       return new EmptyAppearTransition(container);
     } else if ( widget.piece.source == Source.newPeice ) {
       return new NewPieceTransition(container);
     } else if ( widget.piece.source == Source.maintained ) {
       return container;
     } else {
       return container;
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
    var cellWidth = 80.0;

    var children = <Widget>[];
    for (int x = 0; x <= 3; x++) {
      for (int y = 0; y <= 3; y++) {
        var piece = widget.board.get(x, y);
        children.add(new Positioned(
            top: y * cellWidth,
            height: cellWidth,
            left: x * cellWidth,
            width: cellWidth,
            child: new CellWidget(piece)));
      }
    }

    return new Container(
        width: 80.0 * 4,
        height: 80.0 * 4,
        child: new Stack(children: children));
  }
}
