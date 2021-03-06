import "position.dart";
import 'cell.dart';
import 'board.dart';


const rotatedPositions = const [
  [
    const Position(3, 0),
    const Position(3, 1),
    const Position(3, 2),
    const Position(3, 3),
  ],
  [
    const Position(2, 0),
    const Position(2, 1),
    const Position(2, 2),
    const Position(2, 3),
  ],
  [
    const Position(1, 0),
    const Position(1, 1),
    const Position(1, 2),
    const Position(1, 3),
  ],
  [
    const Position(0, 0),
    const Position(0, 1),
    const Position(0, 2),
    const Position(0, 3),
  ],
];

List<Cell> cellsInRow(Set<Cell> matrix, int y) {
  List<Cell> list = List();
  for ( var x = 0; x < Board.WIDTH; x++) {
    var p = Position(x, y);
    var c = findCell(matrix, p);
    if ( c != null ) {
      list.add(c);
    }
  }
  return list;
}

Cell findCell(Set<Cell> matrix, Position p) {
  for ( var c in matrix) {
    if ( c.current == p ) {
      return c;
    }
  }
  return null;
}


Set<Cell> moveLeft(Set<Cell> matrix) {

  var newMatrix = Set<Cell>();

  for ( var y = 0; y < Board.WIDTH; y++ ) {
    List<Cell> r = cellsInRow(matrix, y);

    // merge neighbors
    for ( var x = 0; x < r.length; x++ ) {
      if ( x + 1 < r.length && r[x].value == r[x+1].value ) {
        var c1 = r[x];
        var c2 = r[x+1];

        // merge them.
        r[x] = Cell(c1.value * 2, c1.current, Position(x,y), c2.current);

        // remove the second one from the list. and collapse.
        //r[x+1] = null;
        r.removeAt(x+1);

      } else {
        // just updates its position then.
        var c = r[x];
        r[x] = Cell(c.value, c.current, Position(x, y));
      }
    }

    newMatrix.addAll(r);
  } 
  return newMatrix;
}

Position rotatePosition(Position p) {
  if ( p == null ) {
    return null;
  }
  return rotatedPositions[p.y][p.x];
}

// rotates clockwise onces.
Set<Cell> rotate(Set<Cell> matrix) {
  Set<Cell> newMatrix = new Set();

  for ( var c in matrix ) {
    newMatrix.add(Cell(c.value, rotatePosition(c.source), rotatePosition(c.current), rotatePosition(c.source2)));
  }
  return newMatrix;
}

Set<Cell> swipeLeft(Set<Cell> matrix) {
  return moveLeft(matrix);
}

Set<Cell> rotateNum(int num, Set<Cell> matrix) {
  var m2 = matrix;
  for (var i = 0; i < num; i++) {
    m2 = rotate(m2);
  }
  return m2;
}

Set<Cell> swipeDown(Set<Cell> matrix) {
  return rotateNum(3, swipeLeft(rotate(matrix)));
}

Set<Cell> swipeRight(Set<Cell> matrix) {
  return rotateNum(2, swipeLeft(rotateNum(2, matrix)));
}

Set<Cell> swipeUp(Set<Cell> matrix) {
  return rotateNum(1, swipeLeft(rotateNum(3, matrix)));
}