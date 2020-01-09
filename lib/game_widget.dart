import 'package:flutter/material.dart';
import 'board_widget.dart';
import 'swipe_gesture_widget.dart';
import 'board.dart';

class GameWidget extends StatefulWidget {
  GameWidget({Key key, this.title}) : super(key: key);

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
          title: new Center(
            child: Text(
              widget.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ),
        ),
        body: new Center(
          // child: new Stack(
            // children: [
              // new BoardWidget(background, true),
              // new Positioned(left: 0.0, top: 0.0, child: new BoardWidget(board, false)),
              child: new BoardWidget(board),
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