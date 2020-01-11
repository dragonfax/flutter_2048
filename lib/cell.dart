import 'position.dart';
import 'package:quiver/core.dart';
import 'package:flutter/widgets.dart';

class Cell {
  final int value;
  final Position source;
  final Position source2;
  final Position current;

  final UniqueKey source1Key = UniqueKey();
  final UniqueKey source2Key = UniqueKey();

  Cell(this.value, [this.source, this.current, this.source2]);

  bool operator ==(o) => o is Cell && current == o.current && value == o.value && source == o.source && source2 == o.source2;
  int get hashCode => hash2(value.hashCode,hash2(current.hashCode,hash2(source.hashCode, source2.hashCode)));

  @override
  String toString() {
    return this.value.toString();
  }
}