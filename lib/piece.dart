import 'position.dart';

enum PieceState {

  /* removed from the board for various reasons */
  dropped,

  /* created to fill empty space.
     they didn't exist before. and came from nowhere.

     will animate appearing from nothing after other animations are done.
   */
  addedEmpty,


  newPiece,

  /* moved.
    could be blank, could have a number.

    we will animate it moving from old location to new location.
   */
  moved
}

class Piece {
  int value;
  Position position;
  Position oldPosition;

  Piece(this.value, {this.position, this.oldPosition});

  @override
  String toString() {
    return "[value:$value position:$position oldposition:$oldPosition]";
  }


  PieceState getState() {
    if ( oldPosition == null && value == null ) {
      return PieceState.addedEmpty;
    } else if ( oldPosition == null && value != null ) {
      return PieceState.newPiece;
    } else if ( position == null ) {
      return PieceState.dropped;
    } else if ( position != null && oldPosition != null ) {
      return PieceState.moved;
    } else {
      throw "unknown piece state ${this}";
    }
  }

}
