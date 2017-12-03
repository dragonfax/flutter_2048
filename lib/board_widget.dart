
import 'package:flutter/material.dart';
import 'board.dart';

class BoardWidget extends StatefulWidget {
  final Board board;

  BoardWidget(this.board);

  @override
  BoardWidgetState createState() => new BoardWidgetState();
}

class CellWidget extends StatefulWidget {

  final Piece piece;

  CellWidget(this.piece);

  @override
  CellWidgetState createState() => new CellWidgetState();
}

class CellWidgetState extends State<CellWidget> with SingleTickerProviderStateMixin {

  AnimationController controller;

  CellWidgetState() {
    controller = new AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this
    );
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {

    return
      new ScaleTransition(
        scale: controller,
      child: new Container(
      margin: const EdgeInsets.all(3.0),
        padding: const EdgeInsets.all(8.0),

        width: 60.0,
      height: 60.0,
      alignment: Alignment.center,
      decoration: new BoxDecoration(
        border: new Border.all(width: 2.0, color: Colors.black),
        borderRadius: const BorderRadius.all(const Radius.circular(10.0))
      ),
      child: new Text(
        widget.piece.value == null ? " " : widget.piece.toString(),
        style: const TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold)
      )
    ));
  }
}

class BoardWidgetState extends State<BoardWidget> with SingleTickerProviderStateMixin {

  Widget build(BuildContext context) {

    var cellWidth = 80.0;

    var children = <Widget>[];
    for ( int x = 0; x <= 3; x++ ) {
      for ( int y = 0; y <= 3; y++ ) {
        var piece = widget.board.get(x,y);
        children.add(
          new Positioned(
            top: y * cellWidth,
            height: cellWidth,
            left: x * cellWidth,
            width: cellWidth,
            child: new CellWidget(piece)
          )
        );
      }
    }

    return new Container(width: 80.0 * 4, height: 80.0 * 4, child: new Stack( children: children ));

  }
}