import 'package:flutter/material.dart';

import 'FeedController.dart';
import 'FeedState.dart';

class Feed extends StatefulWidget {
  Feed({Key key}) : super(key: key);

  final FeedController controller = FeedController();

  @override
  FeedState createState() => new FeedState();
}

