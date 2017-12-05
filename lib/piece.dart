import 'position.dart';

enum PieceState {
  /* created to fill empty space.
     they didn't exist before. and came from nowhere.

     will animate appearing from nothing after other animations are done.
   */
  nothing,

  /* newly added piece with a number.
     came from nowhere.

     will do a bump animation to make it stand out.
     but only after the moving animations are done.
     until then its hidden.
   */
  newPiece,

  /* came form 2 peices merging together.
    may also have moved.

    will animate with a slide from one of its old positions.
    later can do more complicated animations.
   */
  merged,

  /* this is the item that was removed during a merge
      should not show up at all, visually.
   */
  mergeRemoved,

  /* unchanged, but possibliy moved.
    could be blank, could have a number.

    we will animate it moving from old location to new location.
   */
  maintained
}

class Piece {
  final int value;
  final List<Piece> source;
  Position position;

  Piece(this.value, this.source, {this.position});

  @override
  String toString() {
    return "[value:$value position:$position sources:${source?.length}]";
  }


  PieceState getState() {
    if ( source == null && value == null ) {
      return PieceState.nothing;
    } else if ( source == null && value != null ) {
      return PieceState.newPiece;
    } else if ( value != null && source != null && source.length == 2 ) {
      return PieceState.merged;
      /*} else if ( value == null & source != null && source.length == 2 ) {
      return PieceState.mergeRemoved; */
    } else if ( source != null && source.length == 1 ) {
      // could be null or a number.
      return PieceState.maintained;
    } else {
      throw "unknown piece state ${this}";
    }
  }

}
