import 'package:flutter/material.dart';

// Direction of swiping.
// so a "left" swipe starts on the right side of the screen.
// could also be considered the arrow button used to elicit the response. (left arrow)
enum Direction { up, down, left, right }

class Position {
  int x, y;
  Position(this.x, this.y);
}

List<int> range(int start, end) {
  var l = end  + 1 - start;
  return new List<int>.generate(l, (i) => start + i);
}

class Board {

  // Visualized, x across, y down
  // rows-first,
  // so, first dimention is y, second is x
  List<List<int>> _grid;

  set(int x, y, int p) {
    _grid[y][x] = p;
  }

  int get(int x, y) {
    return _grid[y][x];
  }

  String toString() {
    return _grid.toString();
  }

  Position randomEmptyPosition() {
    Position p;
    range(0,3).forEach((x){
      range(0,3).forEach((y){
        if (_grid[y][x] == null ) {
          p = new Position(x,y);
        }
      });
    });

    return p;
  }

  List<List<int>> getColumns() {
    return range(0,3).map((int x){
      return _grid.map((row) {
        return row[x];
      }).toList();
    }).toList();
  }

  List<List<int>> getRows() {
    return _grid;
  }

  setColumns(List<List<int>> columns) {
    int x = 0;
    columns.forEach((column){
      int y = 0;
      column.forEach((p){
        _grid[y][x] = p;
        y++;
      });
      x++;
    });
  }

  setRows(List<List<int>> rows) {
    _grid = rows;
  }

  Board() {
    reset();
  }

  reset() {
    _grid = new List<List<int>>();
    for ( int x = 0; x < 4; x++) {
      _grid.add(new List<int>());
      for ( int y = 0; y < 4; y++) {
        _grid[x].add(null);
      }
    }
  }

  swipe(Direction direction) {
    // abstract the "direction" out of the sliding algorithm.

    debugPrint("swipe " + direction.toString());

    List<List<int>> columns; // columns or rows.

    if ( direction == Direction.up || direction == Direction.down ) {
      columns = getColumns();
    } else {
      columns = getRows();
    }

    bool left = false;
    if ( direction == Direction.up || direction == Direction.left ) {
      left = true;
    }

    var newColumns = columns.map((column) {
      if ( ! left ) {
        column = column.reversed.toList();
      }
      var swapped = swipeColumn(column);

      if ( ! left ) {
        swapped = swapped.reversed.toList();
      }

      return swapped;
    }).toList();

    if ( direction == Direction.up || direction == Direction.down ) {
      setColumns(newColumns);
    }
    else {
      setRows(newColumns);
    }
  }

  List<int> removeEmpty(List<int> list) {
    return list.where((p) { return p != null; }).toList();
  }

  List<int> mergeNeighbor(List<int> list ) {
    // find one neighbor next to its twin, merge them, return the new list.
    bool merged = false;
    bool mergePartnerRemoved = true;
    var l1 = range(0,list.length - 1).map((x) {
      if ( ! mergePartnerRemoved ) {
        mergePartnerRemoved = true;
        return null;
      }

      if ( !merged && list.length > x + 1 && list[x] != null && list[x] == list[x + 1] ) {
        // merge them.
        merged = true;
        mergePartnerRemoved = false;
        return list[x] * 2;
      }

      return list[x];
    }).toList();

    if ( merged ) {
      return l1;
    } else {
      return list;
    }
  }

  List<int> mergeNeighbors(List<int> list) {
    var l1 = list;
    var l2 = mergeNeighbor(l1);
    while ( true ) {
      l2 = mergeNeighbor(l1);
      if ( l1 == l2 ) {
        break;
      }
      l1 = l2;
    }

    return l2;
  }

  List<int> swipeColumn(List<int> column) {

    var l1 = removeEmpty(mergeNeighbors(removeEmpty(column)));
    l1.length = 4;
    return l1;
  }
}
