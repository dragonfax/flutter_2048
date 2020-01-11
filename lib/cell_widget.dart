import 'package:flutter/material.dart';
import 'position.dart';
import 'transitions.dart';
import 'cell.dart';

const CellWidth = 60.0;

Widget createPositioned(Key key, Position pos, Widget child) {
  return new Positioned(
    key: key,
      top: pos.y * CellWidth,
      height: CellWidth,
      left: pos.x * CellWidth,
      width: CellWidth,
      child: child);
}

Widget _container(Cell cell) {
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

    return container;
  }

  List<Widget> createCellWidgets(Cell cell) {

    if (cell == null) {
      return [createPositioned(null, cell.current, new EmptyAppearTransition(_container(cell)))];
    } else if (cell.source == null) {
      return [createPositioned(ObjectKey(cell), cell.current, new PopInTransition(_container(cell)))];
    } else {
      print("adding cell");
      List<Widget> widgets = List();
      widgets.add(
        new SlidePositionedTransition(
          key: cell.source1Key,
          cellWidth: CellWidth,
          child: _container(cell),
          source: cell.source,
          target: cell.current,
        )
      );
      if ( cell.source2 != null ) {
        print("adding second merged cell for ${cell.value}");
        widgets.add(
          new SlidePositionedTransition(
            key: cell.source2Key,
            cellWidth: CellWidth,
            child: _container(cell),
            source: cell.source2,
            target: cell.current,
          )
        );
      }
      return widgets;
    }
}
