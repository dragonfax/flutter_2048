

enum Direction { up, down, left, right }

class Peice {
  int value;
}

List<int> range(int start, end) {
  var l = end  + 1 - start;
  return new List<int>.generate(l, (i) => start + i);
}

class Board {
  List<List<Peice>> grid;

  List<List<Peice>> getColumns() {
    return range(0,3).map((int x){
      return grid.map((row) {
        return row[x];
      }).toList();
    }).toList();
  }

  List<List<Peice>> getRows() {
    return grid;
  }

  setColumns(List<List<Peice>> columns) {
    int x = 0;
    columns.forEach((column){
      int y = 0;
      column.forEach((p){
        grid[x][y] = p;
      });
    });
  }

  setRows(List<List<Peice>> rows) {
    grid = rows;
  }

  Board() {
    grid = new List<List<Peice>>();
    for ( int x = 0; x < 4; x++) {
      grid.add(new List<Peice>());
      for ( int y = 0; y < 4; y++) {
        grid[x].add(null);
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
      cellSequence = <int>[0, 1, 2, 3];
    } else {
      cellSequence = <int>[3, 2, 1, 0];
    }

    var newColumns = columns.map((column) {
      return swipeColumn(column, cellSequence);
    }).toList();

    if ( direction == Direction.up || direction == Direction.down ) {
      setColumns(newColumns);
    }
    else {
      setRows(newColumns);
    }
  }

  List<Peice> swipeColumn(List<Peice> column, List<int> cellSequence) {
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

          int rightMostNewI;
          Peice rightMostPeice;
          for ( int rI = i; i <= 3; i++ ) {
            var rX = cellSequence[rI];
            if ( newColumn[rX] != null ) {
              rightMostNewI = rI;
              rightMostPeice = newColumn[rX];
            }
          }

          if ( peice.value == rightMostPeice.value && lastIMerged != rightMostNewI  ) {
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
