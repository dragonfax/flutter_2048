

// Direction of swiping.
// so a "left" swipe starts on the right side of the screen.
// could also be considered the arrow button used to elicit the response. (left arrow)
enum Direction { up, down, left, right }

class Peice {
  int value;

  Peice([this.value]);
}

List<int> range(int start, end) {
  var l = end  + 1 - start;
  return new List<int>.generate(l, (i) => start + i);
}

class Board {

  // Visualized, x across, y down
  // rows-first,
  // so, first dimention is y, second is x
  List<List<Peice>> _grid;

  Set(int x, y, Peice p) {
    _grid[y][x] = p;
  }

  Peice Get(int x, y) {
    return _grid[y][x];
  }

  String toString() {
    return _grid.toString();
  }

  List<List<Peice>> getColumns() {
    return range(0,3).map((int x){
      return _grid.map((row) {
        return row[x];
      }).toList();
    }).toList();
  }

  List<List<Peice>> getRows() {
    return _grid;
  }

  setColumns(List<List<Peice>> columns) {
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

  setRows(List<List<Peice>> rows) {
    _grid = rows;
  }

  Board() {
    _grid = new List<List<Peice>>();
    for ( int x = 0; x < 4; x++) {
      _grid.add(new List<Peice>());
      for ( int y = 0; y < 4; y++) {
        _grid[x].add(null);
      }
    }
  }

  swipe(Direction direction) {
    // abstract the "direction" out of the sliding algorithm.

    List<List<Peice>> columns; // columns or rows.

    if ( direction == Direction.up || direction == Direction.down ) {
      columns = getColumns();
    } else {
      columns = getRows();
    }

    List<int> cellSequence; // abstracts which order to look at the column/row (asc or desc)

    if ( direction == Direction.up || direction == Direction.left ) {
      cellSequence = <int>[3, 2, 1, 0];
    } else {
      cellSequence = <int>[0, 1, 2, 3];
    }

    var newColumns = columns.map((column) {
      return _swipeColumn(column, cellSequence);
    }).toList();

    if ( direction == Direction.up || direction == Direction.down ) {
      setColumns(newColumns);
    }
    else {
      setRows(newColumns);
    }
  }

  List<Peice> _swipeColumn(List<Peice> column, List<int> cellSequence) {
    var newColumn = <Peice>[ null, null, null, null ];

    int lastIMerged = 4; // out of bounds

    for ( int i = 3; i >=0; i--) {
      var x = cellSequence[i];
      if ( column[x] != null ) {
        var peice = column[x];
        if (i == 3) {
          // no previous piece.
          newColumn[x] = peice;
        } else {

          int rightMostNewI = 4;
          Peice rightMostPeice;
          for ( int rI = i; rI <= 3; rI++ ) {
            var rX = cellSequence[rI];
            if ( newColumn[rX] != null ) {
              rightMostNewI = rI;
              rightMostPeice = newColumn[rX];
            }
          }

          if ( peice.value == rightMostPeice?.value && lastIMerged != rightMostNewI  ) {
            // can merge peices.
            rightMostPeice.value = rightMostPeice.value * 2;
            lastIMerged = rightMostNewI; // only merge each target cell once
          } else {
            // just slide this one over, then
            newColumn[cellSequence[rightMostNewI - 1]] = peice;
          }
        }
      }
    }
    return newColumn;
  }
}
