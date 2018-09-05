import 'package:flutter/material.dart';
import 'position.dart';
import 'swipe_mechanic.dart';
// import 'transitions.dart';

const CellWidth = 60.0;

Widget createPositioned(Position pos, Widget child) {
  return new Positioned(
      top: pos.y * CellWidth,
      height: CellWidth,
      left: pos.x * CellWidth,
      width: CellWidth,
      child: child
  );
}

class CellWidget extends StatelessWidget {
  final Cell piece;
  final Position position;

  CellWidget(this.position, this.piece); // : super(key: new PieceKey(piece));

  @override
  Widget build(BuildContext context) {

     var container = new Container(
            margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.all(8.0),
            width: 60.0,
            height: 60.0,
            alignment: Alignment.center,
            decoration: new BoxDecoration(
              color: Colors.white,
                border: new Border.all(width: 2.0, color: Colors.black),
                borderRadius:
                    const BorderRadius.all(const Radius.circular(10.0))),
            child: new Text(
                ( piece == null || piece.value == null ) ? " " : piece.toString(),
                style: const TextStyle(
                    fontSize: 28.0, fontWeight: FontWeight.bold))
     );


     // var position = piece.current;
     // if ( piece.fromNothing() ) {
       return createPositioned(position, container);
     /*} else if ( piece.newPiece() ) {
       return createPositioned(position, new NewPieceTransition(container, piece));
     } else if ( piece.maintained() || piece.merged() ) {
       return new SlidePositionedTransition(
           cellWidth: CellWidth,
           child: container,
           source: piece.source[0].position,
           target: piece.position,
           piece: piece
       );
     } else {
       throw "unknown piece source";
     } */
  }
}
