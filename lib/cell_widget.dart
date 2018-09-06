import 'package:flutter/material.dart';
import 'position.dart';
import 'swipe_mechanic.dart';
import 'transitions.dart';

const CellWidth = 60.0;

Widget createPositioned(Position pos, Widget child) {
  return new Positioned(
      top: pos.y * CellWidth,
      height: CellWidth,
      left: pos.x * CellWidth,
      width: CellWidth,
      child: child);
}

class CellWidget extends StatelessWidget {
  final Cell piece;
  final Position position;

  CellWidget(this.position, this.piece); // : super(key: new PieceKey(piece));

  @override
  Widget build(BuildContext context) {
    var fontSize = 28.0;
    if (piece != null) {
      if (piece.value > 999) {
        fontSize = 14.0;
      } else if (piece.value > 99) {
        fontSize = 17.0;
      } else if (piece.value > 9) {
        fontSize = 23.0;
      }
    }

    var container = new Container(
        margin: const EdgeInsets.all(3.0),
        padding: const EdgeInsets.all(8.0),
        width: 60.0,
        height: 60.0,
        alignment: Alignment.center,
        decoration: new BoxDecoration(
            color: Colors.white,
            border: new Border.all(width: 2.0, color: Colors.black),
            borderRadius: const BorderRadius.all(const Radius.circular(10.0))),
        // child: new FittedBox(
        // fit: BoxFit.scaleDown,
        child: new Text(
            (piece == null || piece.value == null) ? " " : piece.toString(),
            style:
                new TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold))
        // )
        );

    // var position = piece.current;
    // if ( piece.fromNothing() ) {
    // return createPositioned(position, container);
    // } else if ( piece.maintained() || piece.merged() ) {
    if (piece == null) {
      return createPositioned(position, new EmptyAppearTransition(container));
    } else if (piece.source == null) {
      return createPositioned(position, new PopInTransition(container));
    } else {
      return new SlidePositionedTransition(
        cellWidth: CellWidth,
        child: container,
        source: piece.source,
        target: piece.current,
      );
    }
    /*
     } else {
       throw "unknown piece source";
     } */
  }
}
