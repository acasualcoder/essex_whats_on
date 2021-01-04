import 'package:flutter/material.dart';

import 'HomePage/HomePage.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Essex - What's on",
      home: new HomePage(),
    );
  }
}