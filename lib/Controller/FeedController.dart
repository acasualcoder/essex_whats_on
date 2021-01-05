import 'package:essexwhatson/Exceptions/EventException.dart';
import 'package:essexwhatson/Exceptions/NetworkException.dart';
import 'package:essexwhatson/Services/DataService.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'dart:io';

import '../Model/Event.dart';

class FeedController extends ControllerMVC {

  factory  FeedController() {
    return FeedController._();
  }
  FeedController._();


  final infoContent = 'This app uses information hosted on https://www.essexstudent.com/ '
      'to display current events at the University of Essex.\n\nCreated by Hamza Butt';

  Future<List<Event>> launchWebScraping() async {
    try {
      List<Event> events = [];
      try {
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          events = await DataService.pullData();
          if (events.length == 0) {
            throw EventException("No current events");
          }
        }
      } on SocketException catch (e) {
        throw NetworkException("No internet connection");
      }
      return events;
    } catch (e) {
      throw e;
    }
  }
}