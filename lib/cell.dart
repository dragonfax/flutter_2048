import 'position.dart';
import 'package:quiver/core.dart';

class Cell {
  final int value;
  final Position source;
  final Position current;

  Cell(this.value, [this.source, this.current]);

  bool operator ==(o) => o is Cell && current == o.current && value == o.value;
  int get hashCode => hash2(value.hashCode,current.hashCode);

  @override
  String toString() {
    return this.value.toString();
  }
}