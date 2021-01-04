import 'package:flutter/material.dart';

import 'Event.dart';
import 'HomePage.dart';

class HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: widget.controller.launchWebScraping(),
      builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
        if( snapshot.connectionState == ConnectionState.waiting){
          return loadingUI;
        } else{
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            return mainUI(snapshot.data);
        }
      },
    );
  }

  final loadingUI = Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 30),
                Text("Please wait, loading...")
            ],
          )
      )
  );

  final errorUI = Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("There was an error pulling your data"),
            ],
          )
      )
  );

  Scaffold mainUI(dataSnapshot) {
    return Scaffold(
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              Text('${dataSnapshot}'),
          ],
        )
    )
    );
  }

}
