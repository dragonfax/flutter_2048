import 'package:flutter/material.dart';
import 'game_widget.dart';


void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '2048',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new GameWidget(title: '2048'),
    );
  }
}


