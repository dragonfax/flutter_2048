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

class CellWidgetState extends State<CellWidget>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  CellWidgetState() {
    controller = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
  }

  Widget createPositioned(Position pos, Widget child) {
    return new Positioned(
        top: pos.y * CellWidth,
        height: CellWidth,
        left: pos.x * CellWidth,
        width: CellWidth,
        child: child);
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
            borderRadius: const BorderRadius.all(const Radius.circular(10.0))),
        child: new Text(
            widget.piece.value == null ? " " : widget.piece.value.toString(),
            style:
                const TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold)));

    var position = widget.piece.position;

    switch (widget.piece.getState()) {
      case PieceState.dropped:
        // nothing
        throw "unexpected 'dropped' state for peice";
      case PieceState.addedEmpty:
        return createPositioned(position, new EmptyAppearTransition(container));
      case PieceState.newPiece:
        return createPositioned(position, new NewPieceTransition(container));
      case PieceState.moved:
        return slideTransition(container);
      default:
        throw "unknown piece state in widget ${widget.piece}";
    }
  }

  Widget slideTransition(Widget child) {

    return new SlidePositionedTransition(
        cellWidth: CellWidth,
        child: child,
        source: widget.piece.oldPosition,
        target: widget.piece.position
    );

    /*
    var dOffset = widget.piece.source[0].position.toOffset() -
        widget.piece.position.toOffset();

    Animation<Offset> offset = new Tween<Offset>(
      begin: dOffset,
      end: new Offset(0.0, 0.0),
    ).animate(controller);

    controller.forward();

    return new SlideTransition(position: offset, child: child);
    // return child;
    */
  }
}
