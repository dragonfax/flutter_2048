import 'package:flutter/material.dart';
import 'board_widget.dart';
import 'swipe_gesture_widget.dart';
import 'board.dart';

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
    board.addNewPiece();
  }

  newGame() {
    setState(() {
      board.reset();
      board.addNewPiece();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new SwipeGestureWidget(
      onSwipeUp: () {
        setState((){
          if ( ! board.swipeUp() ) {
            board.addNewPiece();
          }
        });
      },
      onSwipeDown: () {
        setState((){
          if ( ! board.swipeDown() ) {
            board.addNewPiece();
          }
        });
      },
      onSwipeLeft: () {
        setState((){
          if ( ! board.swipeLeft() ) {
            board.addNewPiece();
          }
        });
      },
      onSwipeRight: () {
        setState((){
          if ( ! board.swipeRight() ) {
            board.addNewPiece();
          }
        });
      },
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Center(
          // child: new Stack(
            // children: [
              // new BoardWidget(background, true),
              // new Positioned(left: 0.0, top: 0.0, child: new BoardWidget(board, false)),
              child: new BoardWidget(board, false),
            //]
          //)
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