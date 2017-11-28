
import 'package:flutter/material.dart';
import 'board.dart';

class BoardWidget extends StatefulWidget {
  final Board board;

  BoardWidget(this.board);

  @override
  BoardWidgetState createState() => new BoardWidgetState();
}

class BoardWidgetState extends State<BoardWidget> {

  Widget build(BuildContext context) {
    return new Column(children: widget.board.getRows().map((row) {
      return new Row(children: row.map((peice){
        return new Container(
          width: 60.0,
          height: 60.0,
          decoration: new BoxDecoration(
            border: new Border.all(width: 2.0, color: Colors.black)
          ),
          child: new Text(peice == null ? " " : peice.value.toString())
        );
      }).toList());
    }).toList() );

  }

}