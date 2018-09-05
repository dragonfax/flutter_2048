import 'package:flutter/material.dart';
import 'cell_widget.dart';
import 'board.dart';
import 'position.dart';


class BoardWidget extends StatelessWidget {
  final Board board;
  final bool background;

  BoardWidget(this.board, this.background);

  Widget build(BuildContext context) {

    var children = <Widget>[];
    for (int x = 0; x <= 3; x++) {
      for (int y = 0; y <= 3; y++) {
        var piece = board.matrix[y][x];
        children.add(new CellWidget(new Position(x, y), piece));
      }
    }

    return new Container(
        width: CellWidth * 4,
        height: CellWidth * 4,
        child: new Stack(children: children));
  }
}
