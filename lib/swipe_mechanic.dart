/*
given 
  a 2d matrix of cells
    not square but regular (all rows same length, all columns same length)
  a swipe direction
returns
  the new 2d matrix of cells
    not square or regular (different rows or columns could be different lengths)
  along with the origin of each cell (where it came from in the old matrix)

Notes:
  Assumes a fixed matrix of 4x4
*/



import "position.dart";
import "range.dart";

class Cell {
  final int value;
  final Position source;
  final Position current;

  Cell(this.value,[ this.source, this.current ]);

  @override
    String toString() {
      return this.value.toString();
    }
}

List<List<Cell>> padMatrix(List<List<Cell>> matrix ) {

  List<List<Cell>> m2 = new List();

  range(0,3).forEach((y) {
    m2.add([]);
    range(0,3).forEach((x){
      if ( matrix.length <= y || matrix[y].length <= x ) {
        m2[y].add(null);
      } else {
        m2[y].add(matrix[y][x]);
      }
    });
  });
  return m2;

  /*
  var m2 = range(0,3).map((y){
    var bump = 4 - matrix[y].length;
    if ( bump > 0 ) {
      return matrix[y] + range(0,bump - 1).map((i) { return null; }).toList();
    } else {
      return matrix[y];
    }
  }).toList();

  var bump = 4 - m2.length;
  if ( bump > 0 ) {
    return m2 + range(0,bump -1).map((i) { return new List(4); }).toList();
  } else {
    return m2;
  }
  */
}

List<List<Cell>> nestedUnmodifiableList(List<List<Cell>> matrix) {
    List<List<Cell>> l = new List();

    for ( List<Cell> lc in matrix ) {
      List<Cell> ly = List.unmodifiable(lc);
      l.add(ly);
    }
    return List.unmodifiable(padMatrix(l));
}

const rotatedPositions = const [
  [ 
    const Position(3,0),
    const Position(3,1) ,
    const Position(3,2) ,
    const Position(3,3) ,
  ],
  [ 
    const Position(2,0) ,
    const Position(2,1) ,
    const Position(2,2) ,
    const Position(2,3) ,
  ],
  [ 
    const Position(1,0) ,
    const Position(1,1) ,
    const Position(1,2) ,
    const Position(1,3) ,
  ],
  [ 
    const Position(0,0) ,
    const Position(0,1) ,
    const Position(0,2) ,
    const Position(0,3) ,
  ],
];

Position rotatePosition(Position p) {
  return rotatedPositions[p.y][p.x];
}

List<List<Cell>> stripNulls(List<List<Cell>> llc) {
  return llc.map((lc) {
    return lc.where((e) { return e != null; }).toList();
  }).where((lc) { return lc.length > 0; }).toList();
}

List<List<Cell>> mergeNeighbors(List<List<Cell>> matrix) {

  var llc0 = stripNulls(matrix);

  List<List<Cell>> llc = new List();

  for ( List<Cell> lc in llc0) {

    List<Cell> lc2 = new List();
    var skipNext = false;
    for ( var x = lc.length - 1; x >= 0; x-- ) {
      var cell = lc[x];

      if ( skipNext) { 
        skipNext = false;
      }
      else if ( x == 0 ) {
        lc2.insert(0,new Cell(cell.value, cell.current));
      } else {
        var nextCell = lc[x-1];
        if ( cell.value == nextCell.value ) {
          lc2.insert(0,new Cell(cell.value * 2, cell.current));
          skipNext = true;
        } else {
          lc2.insert(0,new Cell(cell.value, cell.current));
        }
      }
    }
    llc.add(lc2);
  }

  return llc;
}


List<List<Cell>> moveRight(List<List<Cell>> matrix) {
  /*
   * 1. foreach row
   * 2. filter out nulls
   * 3. pad the left side with null cells to pad the row length out to 4 items.
  */
  return range(0,matrix.length - 1).map((y) {
    var l = matrix[y].where((e){ return e != null; });
    var bump = 4 - l.length;
    if ( bump == 0 ) {
      return l;
    } else {
      return range(0, bump - 1).map((i) { return null; }).toList() + l;
    }
  });
}

List<List<Cell>> updateCurrentPositions(List<List<Cell>> llc) {
  var y = -1;
  return llc.map((lc) {
    y += 1;
    var x = -1;
    return lc.map((c) {
      x += 1;
      if ( c == null ) {
        return null;
      } else {
        return new Cell(c.value,c.source,new Position(x,y));
      }
    }).toList();
  }).toList();
}

class Matrix {
  final List<List<Cell>> matrix;

  Matrix(List<List<Cell>> oldMatrix) : matrix = nestedUnmodifiableList(updateCurrentPositions(oldMatrix));

  // rotates clockwise onces.
  // also updates the cell positions internally.
  Matrix rotate() {
    List<List<Cell>> newMatrix = new List(4);
    range(0, 3).forEach((y) {
      newMatrix.add(new List(4));
    });

    range(0,matrix.length - 1).forEach((y){
      range(0, matrix[y].length -1).forEach((x){
        var c = matrix[y][x];
        var source2 = rotatePosition(c.source);
        var c2 = new Cell(c.value,source2);
        var p2 = rotatePosition(new Position(x, y));
        newMatrix[p2.y][p2.x] = c2;
      });
    });
    return new Matrix(newMatrix);
  }

  // swipe right
  Matrix swipeRight() {
    /* 
     * 1. Merge neighbors right to left.
     *    Don't reuse a neighbor that was merged
     * 2. move all cells to the right.
    */
    var m1 = mergeNeighbors(this.matrix);
    var m2 = moveRight(m1);
    return new Matrix(m2);
  }

  @override
    String toString() {
      var s = "";
      for ( var lc in this.matrix ) {
        s += "[";
        for ( var c in lc ) {
          if ( c == null ) {
            s += "null, ";
          } else {
            s += "${c.value}, ";
          }
        }
        s += "],\n";
      }
      return s;
    }

}

