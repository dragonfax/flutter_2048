import 'range.dart';
import 'piece.dart';
import 'position.dart';

// Direction of swiping.
// so a "left" swipe starts on the right side of the screen.
// could also be considered the arrow button used to elicit the response. (left arrow)
enum Direction { up, down, left, right }

class Board {

  List<Piece> _bag;

  add(Piece p) {
    assert(p != null);
    assert(p.value != null);
    _bag.add(p);
  }

  Piece get(int x, y) {
    return _bag.firstWhere((p){ return p.position.x == x && p.position.y == y; });
  }

  clear() {
    _bag.clear();
  }

  String toString() {
    return _bag.toString();
  }

  Position randomEmptyPosition() {
    Position p;
    range(0,3).forEach((x){
      range(0,3).forEach((y){
        if (get(x,y) == null ) {
          p = new Position(x,y);
        }
      });
    });

    return p;
  }


  static const rangeX = const[0,1,2,3];
  static const rangeXreverse = const[3,2,1,0];

  int getX(Piece p, bool up) {
    if ( !up ) {
      return p.position.x;
    } else {
      return p.position.y;
    }
  }

  setX(Piece p, bool up, int x) {
    if ( !up ) {
      p.position = new Position(x, p.position.y);
    } else {
      p.position = new Position(p.position.x, x);
    }
  }

  Piece getWithUp(int x, y, bool up) {
    if ( up ) {
      return get(y, x);
    } else {
      return get(x, y);
    }
  }

  Position newPositionWithUp(int x, y, bool up) {
    if ( up ) {
      return new Position(y, x);
    } else {
      return new Position(x, y);
    }
  }

  // swiping to the left.
  slidePieceLeft(Piece p, bool left, up) {

    List<int> directionReverse;
    if ( left ) {
      directionReverse = rangeXreverse;
    } else {
      directionReverse = rangeX;
    }

    if ( p.position.x == rangeX[0] ){
      return;
    }

    var started = false;
    rangeXreverse.firstWhere((ox){
      if ( ox == getX(p,up) ) {
        started = true;
        return false;
      }
      if ( ! started ) {
        return false;
      }

      var y = getX(p,!up);
      var op = getWithUp(ox,y, up);
      if ( op == null ) {
        p.position = newPositionWithUp(ox,y, up);
        return false;
      } else if ( op.value == p.value ) {
        // merge
        op.value *= 2;
        p.position = null;
        return true;
      }
      // hit another value piece
      return true;
    });
  }

  slideColumn(int y, bool left, up) {

    if ( p.position.x == rangeX[0] ){
      return;
    }

    rangeX.forEach((x){
      var p = get(x, y);
      if ( p != null ) {
        slidePieceLeft(p, left, up);
      }
    });
  }

  swipe(Direction direction) {
    // abstract the "direction" out of the sliding algorithm.

    bool columns;
    if ( direction == Direction.up || direction == Direction.down ) {
      columns = true;
    } else {
      columns = false;
    }

    bool left = false;
    if ( direction == Direction.up || direction == Direction.left ) {
      left = true;
    }

    range(0,3).forEach((y) {
      if ( left ) {
        slideColumn(y, left, columns);
      } else {
        // TODO
      }
    });
  }
}
