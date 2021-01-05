import 'package:flutter/material.dart';

import 'Event.dart';
import 'Feed.dart';
import 'FeedStyle.dart';

class FeedState extends State<Feed> {

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
        ),
        onPressed: () {
          setState((){});
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.info,
          ),
          onPressed: () {
            showInfoDialog();
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
          return Divider(
            height: 50,
            thickness: 1.5,
          );
        },
      )
    );
  }

  Future<void> showInfoDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Info'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(widget.controller.infoContent),
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
  final mediumSeparator = SizedBox(height: 15);
  final largeSeparator = SizedBox(height: 30);

  Container getEvent(event) {
    return Container(
        child: Column(
          children: <Widget>[
            smallSeparator,
            Align(
              alignment: Alignment.topCenter,
              child: Text(event.title, style: titleStyle, textAlign: TextAlign.center,),
            ),
            mediumSeparator,
            Align(
              alignment: Alignment.center,
              child: Text('📅 ${event.time}', style: dateStyle, textAlign: TextAlign.center),
            ),
            mediumSeparator,
            Align(
              alignment: Alignment.center,
              child: Text(event.location, style: dateStyle, textAlign: TextAlign.center),
            ),
            mediumSeparator,
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                ),
              ),
              child: Image.network(event.imgPath),
            ),
            largeSeparator,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(event.description, style: textStyle, textAlign: TextAlign.left),
            ),
          ],
        )
    );
  }

}
