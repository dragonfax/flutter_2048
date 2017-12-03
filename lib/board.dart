
// Direction of swiping.
// so a "left" swipe starts on the right side of the screen.
// could also be considered the arrow button used to elicit the response. (left arrow)
enum Direction { up, down, left, right }

// how this peice was created.
// from 2 peices merging. its the random new peice, or it was an empty cell.
enum Source { merged, newPeice, empty, maintained }

class Position {
  int x, y;
  Position(this.x, this.y);
}

List<int> range(int start, end) {
  var l = end  + 1 - start;
  return new List<int>.generate(l, (i) => start + i);
}

class Piece {
  final int value;
  final Source source;

  Piece(this.value, this.source);

  @override
  String toString() {
    return value.toString();
  }
}

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
  }

  setRows(List<List<Piece>> rows) {
    _grid = rows;
  }

  Board() {
    reset();
  }

  reset() {
    _grid = new List<List<Piece>>(4);
    for ( int x = 0; x < 4; x++) {
      _grid[x] = new List<Piece>(4);
      for ( int y = 0; y < 4; y++) {
        _grid[x][y] = new Piece(null, Source.empty);
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

  List<Piece> mergeNeighbor(List<Piece> list ) {
    // find one neighbor next to its twin, merge them, return the new list.
    bool merged = false;
    bool mergePartnerRemoved = true;
    var l1 = range(0,list.length - 1).map((x) {
      if ( ! mergePartnerRemoved ) {
        mergePartnerRemoved = true;
        return new Piece(null, Source.empty);
      }

      if ( !merged && list.length > x + 1 && list[x].value != null && list[x].value == list[x + 1].value ) {
        // merge them.
        merged = true;
        mergePartnerRemoved = false;
        return new Piece(list[x].value * 2, Source.merged);
      }

      return list[x];
    }).toList();

    if ( merged ) {
      return l1;
    } else {
      return list;
    }
  }

  List<Piece> mergeNeighbors(List<Piece> list) {
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

  List<Piece> modifySource(Source source, List<Piece> list) {
    return list.map((p1){ return new Piece(p1.value, source); }).toList();
  }

  List<Piece> expand(int length, List<Piece> list) {
    if ( list.length >= length ) {
      return list;
    }

    var needed = length - list.length;
    var l1 = <Piece>[];
    l1.addAll(list);
    l1.addAll(range(0,needed - 1).map((i){
      return new Piece(null, Source.empty);
    }));

    return l1;
  }

  List<Piece> swipeColumn(List<Piece> column) {

    var l1 = expand(4,removeEmpty(mergeNeighbors(removeEmpty(modifySource(Source.maintained,column)))));
    return l1;
  }
}
