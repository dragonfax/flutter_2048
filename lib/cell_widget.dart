import 'package:flutter/material.dart';
import 'position.dart';
import 'transitions.dart';
import 'cell.dart';

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
  final Cell cell;

  CellWidget(this.cell)
      : super(key: cell == null ? null : new ObjectKey(cell));

  @override
  Widget build(BuildContext context) {
    var fontSize = 28.0;
    if (cell != null) {
      if (cell.value > 999) {
        fontSize = 14.0;
      } else if (cell.value > 99) {
        fontSize = 17.0;
      } else if (cell.value > 9) {
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
            (cell == null || cell.value == null) ? " " : cell.toString(),
            style:
                new TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold))
        // )
        );

    var position = cell.current;
    if (cell == null) {
      return createPositioned(position, new EmptyAppearTransition(container));
    } else if (cell.source == null) {
      return createPositioned(position, new PopInTransition(container));
    } else {
      return new SlidePositionedTransition(
        cellWidth: CellWidth,
        child: container,
        source: cell.source,
        target: cell.current,
      );
    }
    /*
     } else {
       throw "unknown cell source";
     } */
  }
}
