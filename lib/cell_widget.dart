import 'package:flutter/material.dart';
import 'piece.dart';
import 'position.dart';
import 'transitions.dart';

const CellWidth = 60.0;

class CellWidget extends StatefulWidget {
  final Piece piece;

  CellWidget(this.piece);

  @override
  CellWidgetState createState() => new CellWidgetState();
}


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
              color: Colors.white,
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
         return new SlidePositionedTransition(
             cellWidth: CellWidth,
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
