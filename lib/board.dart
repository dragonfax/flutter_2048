import 'range.dart';
import 'piece.dart';
import 'position.dart';

// Direction of swiping.
// so a "left" swipe starts on the right side of the screen.
// could also be considered the arrow button used to elicit the response. (left arrow)
enum Direction { up, down, left, right }

class Board {

  // Visualized, x across, y down
  // rows-first,
  // so, first dimention is y, second is x
  List<List<Piece>> _grid;

  set(int x, y, Piece p) {
    if ( p == null ) {
      throw "cells are non-nullable";
    }
    _grid[y][x] = p;
    p.position = new Position(x,y);
  }

  Piece get(int x, y) {
    if ( x< 0 || x >= 4 ) {
      throw "x out of bounds [$x]";
    }
    if ( y < 0 || y >= 4 ) {
      throw "y out of bounds [$y]";
    }
    return _grid[y][x];
  }

  String toString() {
    return _grid.toString();
  }

  Position randomEmptyPosition() {
    Position p;
    range(0,3).forEach((x){
      range(0,3).forEach((y){
        if (_grid[y][x].value == null ) {
          p = new Position(x,y);
        }
      });
    });

    return p;
  }

  List<List<Piece>> getColumns() {
    return range(0,3).map((int x){
      return _grid.map((row) {
        return row[x];
      }).toList();
    }).toList();
  }

  List<List<Piece>> getRows() {
    return _grid;
  }

  setColumns(List<List<Piece>> columns) {
    int x = 0;
    columns.forEach((column){
      int y = 0;
      column.forEach((p){
        _grid[y][x] = p;
        y++;
      });
      x++;
    });

    _updatePositions();
  }

  _updatePositions() {
    int y = 0;
    _grid.forEach((row){
      int x = 0;
      row.forEach((p){
        p.oldPosition = p.position;
        p.position = new Position(x, y);
        x++;
      });
      y++;
    });
   }

  setRows(List<List<Piece>> rows) {
    _grid = rows;
    _updatePositions();
  }

  Board() {
    reset();
  }

  reset() {
    _grid = new List<List<Piece>>(4);
    for ( int y = 0; y < 4; y++) {
      _grid[y] = new List<Piece>(4);
      for ( int x = 0; x < 4; x++) {
        _grid[y][x] = new Piece(null, position: new Position(x, y));
      }
    }
  }

  swipe(Direction direction) {
    // abstract the "direction" out of the sliding algorithm.

    List<List<Piece>> columns; // columns or rows.

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

  List<Piece> removeEmpty(List<Piece> list) {
    return list.where((p) { return p.value != null; }).toList();
  }

  List<Piece> trailingBlanks(List<Piece> list) {
    var drop = false;
    return list.reversed.toList().where((item) {
      if ( item.value != null ) {
        drop = true;
      }
      return ! drop;
    }).toList().reversed.toList();
  }

  List<Piece> keepTrailingBlanks(List<Piece> list) {
    var l = removeEmpty(list);
    l.addAll(trailingBlanks(list));
    return l;
  }

  List<Piece> mergeNeighbors(List<Piece> list ) {
    var newList = <Piece>[];
    var skip = false;
    range(0, list.length - 1).forEach((x) {
      if ( skip ) {
        skip = false;
      } else if (x == list.length - 1 || list[x].value == null || list[x + 1].value == null) {
        // nothing special
        newList.add(list[x]);
      } else if (list[x].value == list[x + 1].value) {
        assert(list[x].value != null);
        // merge
        var p = list[x];
        p.value *= 2;
        newList.add(p);
        skip = true;
      } else {
        newList.add(list[x]);
      }
    });

    return newList;
  }

  List<Piece> expand(int length, List<Piece> list) {
    if ( list.length >= length ) {
      return list;
    }

    var needed = length - list.length;
    var l1 = <Piece>[];
    l1.addAll(list);
    l1.addAll(range(0,needed - 1).map((i){
      return new Piece(null);
    }));

    return l1;
  }

  List<Piece> swipeColumn(List<Piece> column) {

    var l1 = expand(4,keepTrailingBlanks(mergeNeighbors(keepTrailingBlanks(column))));
    return l1;
  }
}
