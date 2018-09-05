import 'swipe_mechanic.dart' as swipe;

List<List<swipe.Cell>> fixMatrix(List<List<swipe.Cell>> matrix) {
  return swipe.updateCurrentPositions(swipe.padMatrix(matrix));
}

class Board {

  List<List<swipe.Cell>> matrix = fixMatrix([]);

  addNewPiece() {
    var p = swipe.randomEmptyPosition(matrix);
    matrix[p.y][p.x] = new swipe.Cell(1, p, p);
  }

  reset() {
    matrix = fixMatrix([]);
  }

  swipeUp() {
    matrix = fixMatrix(swipe.swipeUp(matrix));
  }

  swipeDown() {
    matrix = fixMatrix(swipe.swipeDown(matrix));
  }

  swipeLeft() {
    matrix = fixMatrix(swipe.swipeLeft(matrix));
  }

  swipeRight() {
    matrix = fixMatrix(swipe.swipeRight(matrix));
  }

}