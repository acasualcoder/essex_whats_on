import 'package:flutter/material.dart';

import 'Event.dart';
import 'HomePage.dart';
import 'HomePageStyle.dart';

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
            showMyDialog();
          },
        )
      ],
    );
  }

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

  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Info'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This app uses information hosted on https://www.essexstudent.com/ '
                    'to display current events at the University of Essex.\n'),
                Text('Created by Hamza Butt'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final smallSeparator = SizedBox(height: 5);
  final largeSeparator = SizedBox(height: 30);

  Column getEvent(event) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Text(event.title, style: titleStyle, textAlign: TextAlign.center,),
        ),
        smallSeparator,
        Align(
          alignment: Alignment.center,
          child: Text('📅 ${event.time}', style: dateStyle, textAlign: TextAlign.center),
        ),
        smallSeparator,
        Align(
          alignment: Alignment.center,
          child: Text(event.location, style: dateStyle, textAlign: TextAlign.center),
        ),
        largeSeparator,
        Image.network(event.imgPath),
        largeSeparator,
        Align(
          alignment: Alignment.centerLeft,
          child: Text(event.description, style: textStyle, textAlign: TextAlign.left),
        ),
      ],
    );
  }

}
