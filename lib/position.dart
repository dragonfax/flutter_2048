import 'dart:ui';

class Position {
  final int x, y;
  const Position(this.x, this.y);

  Offset toOffset() {
    return new Offset(x.toDouble(), y.toDouble());
  }

  bool equals(Position p) {
    return x == p.x && y == p.y;
  }

  String toString() {
    return "[$x,$y]";
  }
}
