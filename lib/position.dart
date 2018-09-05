import 'dart:ui';
import 'package:quiver/core.dart';

class Position {
  final int x, y;
  const Position(this.x, this.y);

  Offset toOffset() {
    return new Offset(x.toDouble(), y.toDouble());
  }

  bool operator ==(o) => o is Position && o.x == x && o.y == y;
  int get hashCode => hash2(x.hashCode, y.hashCode);


  String toString() {
    return "[$x,$y]";
  }
}
