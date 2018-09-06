import 'swipe_mechanic.dart' as swipe;

List<List<swipe.Cell>> fixMatrix(List<List<swipe.Cell>> matrix) {
  return swipe.updateCurrentPositions(swipe.padMatrix(matrix));
}

class Board {

  List<List<swipe.Cell>> matrix = fixMatrix([]);

  addNewPiece() {
    var p = swipe.randomEmptyPosition(matrix);
    matrix[p.y][p.x] = new swipe.Cell(1, null, p);
  }

  reset() {
    matrix = fixMatrix([]);
    matrix[0][0] = new swipe.Cell(2048);
    matrix[0][1] = new swipe.Cell(1024);
    matrix[0][3] = new swipe.Cell(512);
    matrix[1][0] = new swipe.Cell(256);
    matrix[1][1] = new swipe.Cell(128);
    matrix[1][2] = new swipe.Cell(64);
    matrix[1][3] = new swipe.Cell(32);
    matrix[2][0] = new swipe.Cell(16);
    matrix[2][1] = new swipe.Cell(8);
    matrix[2][2] = new swipe.Cell(4);
    matrix = fixMatrix(matrix);
  }

  bool swipeUp() {
    var om = matrix;
    matrix = fixMatrix(swipe.swipeUp(matrix));
    return swipe.compareMatrix(om, matrix);
  }

  bool swipeDown() {
    var om = matrix;
    matrix = fixMatrix(swipe.swipeDown(matrix));
    return swipe.compareMatrix(om, matrix);
  }

  bool swipeLeft() {
    var om = matrix;
    matrix = fixMatrix(swipe.swipeLeft(matrix));
    return swipe.compareMatrix(om, matrix);
  }

  bool swipeRight() {
    var om = matrix;
    matrix = fixMatrix(swipe.swipeRight(matrix));
    return swipe.compareMatrix(om, matrix);
  }

}