
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
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: widget.board.getRows().map((row) {
      return new Row(
        mainAxisSize: MainAxisSize.min,
        children: row.map((peice){
        return new Container(
          margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.all(8.0),

            width: 60.0,
          height: 60.0,
          alignment: Alignment.center,
          decoration: new BoxDecoration(
            border: new Border.all(width: 2.0, color: Colors.black),
            borderRadius: const BorderRadius.all(const Radius.circular(10.0))
          ),
          child: new Text(
            peice == null ? " " : peice.value.toString(),
            style: const TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold)
          )
        );
      }).toList());
    }).toList() );

  }

}