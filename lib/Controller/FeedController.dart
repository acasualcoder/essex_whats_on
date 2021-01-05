import 'package:essexwhatson/Exceptions/EventException.dart';
import 'package:essexwhatson/Exceptions/NetworkException.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:web_scraper/web_scraper.dart';
import 'dart:io';

import '../Model/Event.dart';

class FeedController extends ControllerMVC {

  factory  FeedController() {
    return FeedController._();
  }
  FeedController._();

  final _url = 'https://www.essexstudent.com';
  final _page = '/whatson';

  final infoContent = 'This app uses information hosted on https://www.essexstudent.com/ '
      'to display current events at the University of Essex.\n\nCreated by Hamza Butt';

  Future<List<Event>> _pullData() async {
      List<Event> events = [];
        final webScraper = WebScraper(_url);
        try {
          if (await webScraper.loadWebPage(_page)) {
            List<Map<String, dynamic>> eventTimes = webScraper.getElement('div.event_item > dl > dd.msl_event_time', []);
            List<Map<String, dynamic>> eventLocations = webScraper.getElement('div.event_item > dl > dd.msl_event_location', []);
            List<Map<String, dynamic>> eventDescriptions = webScraper.getElement('div.event_item > dl > dd.msl_event_description', []);
            List<Map<String, dynamic>> eventTitles = webScraper.getElement('div.event_item > dl > dt > a.msl_event_name', []);
            List<Map<String, dynamic>> eventImagePaths = webScraper.getElement('div.event_item > dl > dt > a > span.msl_event_image > img', ['src']);

            for (var i = 0; i < eventTitles.length; i++) {
              Event event = new Event();
              event.title = eventTitles[i]['title'];
              event.description = eventDescriptions[i]['title'].replaceAll("\n", " ");
              event.location = eventLocations[i]['title'];
              event.time = eventTimes[i]['title'];
              event.setImgPath(eventImagePaths[i]['attributes']['src']);
              events.add(event);
            }
          }
        } catch (e) {
          throw EventException("Couldn't access events");
        }
      return events;
  }

  Future<List<Event>> launchWebScraping() async {
    try {
      List<Event> events = [];
      try {
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          events = await _pullData();
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