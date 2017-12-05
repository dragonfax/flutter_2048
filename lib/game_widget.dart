import 'package:flutter/material.dart';
import 'board.dart';
import 'board_widget.dart';
import 'swipe_gesture_widget.dart';
import 'piece.dart';
import 'position.dart';

class GameWidget extends StatefulWidget {
  GameWidget({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  GameState createState() => new GameState();
}

class GameState extends State<GameWidget> {
  final Board board = new Board();

  GameState() {
    addNewPeice();
  }

  newGame() {
    setState(() {
      board.reset();
      addNewPeice();
    });
  }

  addNewPeice() {
    var p = board.randomEmptyPosition();
    board.set(p.x, p.y, new Piece(1, null, position: new Position(p.x, p.y)));
  }

  @override
  Widget build(BuildContext context) {
    return new SwipeGestureWidget(
      onSwipeUp: () {
        setState((){
          board.swipe(Direction.up);
          addNewPeice();
        });
      },
      onSwipeDown: () {
        setState((){
          board.swipe(Direction.down);
          addNewPeice();
        });
      },
      onSwipeLeft: () {
        setState((){
          board.swipe(Direction.left);
          addNewPeice();
        });
      },
      onSwipeRight: () {
        setState((){
          board.swipe(Direction.right);
          addNewPeice();
        });
      },
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Center(
          child: new BoardWidget(board),
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: newGame,
          tooltip: 'New Game',
          child: new Icon(Icons.restore),
        ),
      ),
    );
  }
}