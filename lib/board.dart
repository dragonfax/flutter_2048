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
    if ( get(p.position.x, p.position.y) != null ) {
      throw "colliding pieces";
    }
    _bag.add(p);
  }

  Piece get(int x, y) {
    var p = _bag.firstWhere((p){ return p.position.x == x && p.position.y == y; });
    if ( p == null ) {
      p = new Piece(null, position: new Position(x, y));
      add(p);
    }
    return p
  }

  clear() {
    _bag.clear();
  }

  removeUnsued() {
    _bag = _bag.where((p) { return p.position != null; }).toList();
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

  List<Piece> getColumn(int x) {
    return range(0,3).map((int y){
      return get(x,y);
    }).toList();
  }

  List<Piece>> getRow(int y) {
    return range(0,3).map((int x){
      return get(x,y);
    }).toList();
  }

  // works for a column or a row. but assumes same direction (to the left).
  swipeColumn(List<Piece> column) {

    while ( true ) {
      slideLeft(column) // including buried nulls
      var merged = mergeNeighbors(column);
      // until no neighbors can merge
      if ( ! merged ) {
        break;
      }
      // always keep far right nulls
    }

    // bump back up to 4 pieces
    fill(column);
  }

  slideLeft(List<Piece> column) {
    while ( slideOneLeft(column) ) {
    }
  }

  bool slideOneLeft(List<Piece> column) {
    var y = column[0].position.y;

    var done = false;
    range(1,3).firstWhere((x){
      var p = get(x, y);

      // ignore nulls and blanks
      if ( p != null || p.value != null ) {
        var pp = get(x - 1, y);

        // if previous peice is null or blank.
        if ( pp == null ) {
          p.position = new Position(x-1, y);

          return true;

        } else if ( pp.value == null ) {
          pp.position = null;
          p.position = new Position(x-1, y);

          return true;
        }
      }

      return false;
    });
  }

  fill(List<Piece> column) {
    var y = column[0].position.y;

    // find the last item, and add any needed
    range(0,3).forEach((x) {
      if ( get(x,y) != null ) {
        add(new Piece(null, position: new Position(x,y)));
      }
    });
  }


  List<Piece> removeEmpty(List<Piece> list) {
    return list.where((p) {
      if ( p.value == null ) {
        _removed.add(p);
        return false;
      }
      return true;
    }).toList();
  }

  List<Piece> trailingBlanks(List<Piece> list) {
    var drop = false;
    return list.reversed.toList().where((item) {
      if ( item.value != null ) {
        drop = true;
      }
      if ( drop ) {
        _removed.add(item);
        return false;
      }
      return true;
    }).toList().reversed.toList();
  }

  List<Piece> keepTrailingBlanks(List<Piece> list) {
    var l = removeEmpty(list);
    l.addAll(trailingBlanks(list));
    return l;
  }

  List<Piece> mergeNeighbors(List<Piece> list ) {
    var newList = <Piece>[];
    var skip = false;
    range(0, list.length - 1).forEach((x) {
      if ( skip ) {
        skip = false;
        _removed.add(list[x]);
      } else if (x == list.length - 1 || list[x].value == null || list[x + 1].value == null) {
        // nothing special
        newList.add(list[x]);
      } else if (list[x].value == list[x + 1].value) {
        assert(list[x].value != null);
        // merge
        var p = list[x];
        p.value *= 2;
        newList.add(p);
        skip = true;
      } else {
        newList.add(list[x]);
      }
    });

    return newList;
  }

  List<Piece> expand(int length, List<Piece> list) {
    if ( list.length >= length ) {
      return list;
    }

    var needed = length - list.length;
    var l1 = <Piece>[];
    l1.addAll(list);
    l1.addAll(range(0,needed - 1).map((i){
      return new Piece(null);
    }).toList());

    return l1;
  }


  swipe(Direction direction) {
    // abstract the "direction" out of the sliding algorithm.

    List<List<Piece>> columns; // columns or rows.

    if ( direction == Direction.up || direction == Direction.down ) {
      columns = getColumns();
    } else {
      columns = getRows();
    }

    bool left = false;
    if ( direction == Direction.up || direction == Direction.left ) {
      left = true;
    }

    var newColumns = columns.map((column) {
      if ( ! left ) {
        column = column.reversed.toList();
      }
      var swapped = swipeColumn(column);

      if ( ! left ) {
        swapped = swapped.reversed.toList();
      }

      return swapped;
    }).toList();

    if ( direction == Direction.up || direction == Direction.down ) {
      setColumns(newColumns);
    }
    else {
      setRows(newColumns);
    }
  }
}
