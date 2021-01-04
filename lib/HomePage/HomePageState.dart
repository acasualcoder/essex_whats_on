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
          return loadingUI();
        } else {
          if (snapshot.hasError)
            return errorUI();
          else
            return mainUI(snapshot.data);
        }
      },
    );
  }

  Scaffold loadingUI() {
    return Scaffold(
        appBar: appBar(),
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
  }


  Scaffold errorUI() {
    return Scaffold(
        appBar: appBar(),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("There was an error pulling your data"),
              ],
            )
        )
    );
  }

  Scaffold mainUI(dataSnapshot) {
    return Scaffold(
        appBar: appBar(),
        body: Container(
          color: Colors.white,
          child: Padding (
              padding: const EdgeInsets.all(36.0),
              child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      feedView(dataSnapshot),
                    ],
                  )
              )
          )
    ));
  }

  AppBar appBar() {
    return AppBar(
      title: Text("Essex - What's on"),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.refresh,
          color: Colors.white,
        ),
        onPressed: () {
          setState(() { });
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.info,
            color: Colors.white,
          ),
          onPressed: () {
            // MARK - Add dialog for info here
          },
        )
      ],
    );
  }

//  Expanded feedView(dateSnapshot) {
//    return Expanded(
//        child: ListView.builder
//          (
//            itemCount: dateSnapshot.length,
//            itemBuilder: (BuildContext ctxt, int index) {
//              return getEvent(dateSnapshot[index]);
//            }
//        )
//    );
//  }

  Expanded feedView(dateSnapshot) {
    return Expanded(
      child: ListView.separated(
        itemCount: dateSnapshot.length,
        itemBuilder: (context, index) {
          return getEvent(dateSnapshot[index]);
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      )
    );
  }

  final titleStyle = TextStyle(
    fontSize: 18,
    fontFamily: 'Montserrat',
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  final dateStyle = TextStyle(
    fontSize: 15,
    fontFamily: 'Montserrat',
    color: Colors.black,
  );

  final descriptionStyle = TextStyle(
    fontSize: 12,
    fontFamily: 'Montserrat',
    color: Colors.black,
  );

  Column getEvent(event) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Text(event.title, style: titleStyle),
        ),
        Align(
          alignment: Alignment.center,
          child: Text('📅 ${event.time}', style: dateStyle),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(event.location, style: dateStyle),
        ),
        SizedBox(height: 30),
        Image.network(event.imgPath),
        SizedBox(height: 30),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(event.description, style: descriptionStyle),
        ),
      ],
    );
  }

}
