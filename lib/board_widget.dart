import 'package:flutter/material.dart';
import 'cell_widget.dart';
import 'board.dart';


class BoardWidget extends StatelessWidget {
  final Board board;

  BoardWidget(this.board);

  Widget build(BuildContext context) {

    var children = <Widget>[];
    for (int x = 0; x < Board.WIDTH; x++) {
      for (int y = 0; y < Board.WIDTH; y++) {
        var cell = board.findCell(x, y);
        if ( cell != null ) {
          children.add(new CellWidget(cell));
        }
      }
    }

    return new Container(
        width: CellWidth * 4,
        height: CellWidth * 4,
        child: new Stack(children: children));
  }
}
