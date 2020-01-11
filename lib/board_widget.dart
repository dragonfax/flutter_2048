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
        if (cell != null) {
          children.addAll(createCellWidgets(cell));
        }
      }
    }

    return new Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(width: 2.0, color: Colors.grey),
            left: BorderSide(width: 2.0, color: Colors.grey),
            right: BorderSide(width: 2.0, color: Colors.grey),
            bottom: BorderSide(width: 2.0, color: Colors.grey),
          ),
        ),
        width: CellWidth * 4 + 4,
        height: CellWidth * 4 + 4,
        child: new Stack(children: children));
  }
}
