import 'position.dart';

class Piece {
  final int value;
  final List<Piece> source;
  Position position;

  Piece(this.value, this.source, {this.position});

  @override
  String toString() {
    return value.toString();
  }

  bool fromNothing() {
    return value == null && source == null;
  }

  bool newPiece() {
    return value != null && source == null;
  }

  bool merged() {
    return value != null && source != null && source.length == 2;
  }

  bool mergeRemoved() {
    return value == null && source != null && source.length == 2;
  }

  bool maintained() {
    return source != null && source.length == 1;
  }
}
