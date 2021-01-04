import 'package:flutter/material.dart';

import 'HomeController.dart';
import 'HomePageState.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  final String title = 'Flutter Demo Home Page';

  final HomeController controller = HomeController();

  @override
  HomePageState createState() => new HomePageState();

}
