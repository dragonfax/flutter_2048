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

double fontSizeFor(int value) {
  var fontSize = 28.0;
  if (value != null ) {
    if (value > 999) {
      fontSize = 14.0;
    } else if (value > 99) {
      fontSize = 17.0;
    } else if (value > 9) {
      fontSize = 23.0;
    }
  }
  return fontSize;
}

Widget _container(Cell cell, int value, [int finalValue]) {
  if (finalValue == null ) {
    finalValue = value;
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
    child: SwitchTransition(
      child1: new Text(
        value == null ? " " : value.toString(),
        style:
            new TextStyle(fontSize: fontSizeFor(value), fontWeight: FontWeight.bold)
      ),
      child2: new Text(
        finalValue == null ? " " : finalValue.toString(),
        style:
            new TextStyle(fontSize: fontSizeFor(finalValue), fontWeight: FontWeight.bold)
      ),
    )
  );

  return container;
}

List<Widget> createCellWidgets(Cell cell) {

  if (cell == null) {
    return [createPositioned(null, cell.current, new EmptyAppearTransition(_container(cell, cell.value)))];
  } else if (cell.source == null) {
    return [createPositioned(ObjectKey(cell), cell.current, new PopInTransition(_container(cell, cell.value)))];
  } else if ( cell.source2 != null ) {
    /* 2 cells merging together */
    var value = cell.value;
    return [
      new SlidePositionedTransition(
        key: cell.source1Key,
        cellWidth: CellWidth,
        child: _container(cell, (value/2).floor(), value),
        source: cell.source,
        target: cell.current,
      ),
      new SlidePositionedTransition(
        key: cell.source2Key,
        cellWidth: CellWidth,
        child: _container(cell, (value/2).floor(), value),
        source: cell.source2,
        target: cell.current,
      )
    ];
  } else {
    // a single cell moving
    return [
      new SlidePositionedTransition(
        key: cell.source1Key,
        cellWidth: CellWidth,
        child: _container(cell, cell.value),
        source: cell.source,
        target: cell.current,
      )
    ];
  }
}
