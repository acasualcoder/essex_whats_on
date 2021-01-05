import 'package:flutter/material.dart';
import 'View/Feed/Feed.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Feed(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}