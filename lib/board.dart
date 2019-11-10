import 'swipe_mechanic.dart' as swipe;
import 'position.dart';
import 'cell.dart';

class Board {
  Set<Cell> matrix = Set();

  static const WIDTH = 4;

  static const elements = [0, 1, 2, 3];

  static final allPositions = {
    for ( var x in elements ) 
      for ( var y in elements )
        Position(x, y)
  };

  Set<Position> filledPositions() {
    var set = Set<Position>();
    matrix.forEach((i) => set.add(i.current));
    return set;
  }

  Set<Position> emptyPositions() {
    return allPositions.difference(filledPositions());
  }

  addNewPiece() {

    var empties = emptyPositions();
    
    if ( empties.length == 0 ) {
      throw "game over, no empty spots";
    }

    var emptyPos = emptyPositions().first;

    matrix.add(new Cell(1, null, emptyPos));
  }

  Cell findCell(int x, y) {
    var p = Position(x, y);
    for ( var c in matrix) {
      if ( c.current == p ) {
        return c;
      }
    }
    return null;
  }

  reset() {
    matrix = Set();
    matrix.add(new Cell(256));
    matrix.add(new Cell(32));
    matrix.add(new Cell(8));
  }

  bool swipeUp() {
    var om = matrix;
    matrix = swipe.swipeUp(matrix);
    return om == matrix;
  }

  bool swipeDown() {
    var om = matrix;
    matrix = swipe.swipeDown(matrix);
    return om == matrix;
  }

  bool swipeLeft() {
    var om = matrix;
    matrix = swipe.swipeLeft(matrix);
    return om == matrix;
  }

  bool swipeRight() {
    var om = matrix;
    matrix = swipe.swipeRight(matrix);
    return om == matrix;
  }
}
