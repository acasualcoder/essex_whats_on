import 'dart:developer';

import 'package:essexwhatson/Exceptions/EventException.dart';
import 'package:essexwhatson/Model/Event.dart';
import 'package:web_scraper/web_scraper.dart';

class DataService {

  static final _url = 'https://www.essexstudent.com';
  static final _page = '/whatson';

  static Future<List<Event>> pullData() async {
    final webScraper = WebScraper(_url);
    try {
      if (await webScraper.loadWebPage(_page)) {
        List<Map<String, dynamic>> eventTimes = webScraper.getElement('div.event_item > dl > dd.msl_event_time', []);
        List<Map<String, dynamic>> eventLocations = webScraper.getElement('div.event_item > dl > dd.msl_event_location', []);
        List<Map<String, dynamic>> eventDescriptions = webScraper.getElement('div.event_item > dl > dd.msl_event_description', []);
        List<Map<String, dynamic>> eventTitles = webScraper.getElement('div.event_item > dl > dt > a.msl_event_name', []);
        List<Map<String, dynamic>> eventImagePaths = webScraper.getElement('div.event_item > dl > dt > a > span.msl_event_image > img', ['src']);
        List<Event> events = List<Event>(eventTitles.length);

        if (!(eventTimes.length == eventLocations.length
            && eventLocations.length == eventDescriptions.length
            && eventDescriptions.length == eventTitles.length
            && eventTitles.length == eventImagePaths.length)) {

          List<String> incompleteTitles = await incompleteEventsByTitle();
          for(var i = 0; i < incompleteTitles.length; i++){
            for(var j = 0; j < eventTitles.length; j++){
                if (eventTitles[j]['title'] == incompleteTitles[i]) {
                  var replacement = eventImagePaths[j];
                  replacement['attributes']['src'] = "NULL_IMAGE_SUBSTITUTE";
                  eventImagePaths.insert(j, replacement);
                  log("A MATCH!");
                }
              }
          }
        }

        for (var i = 0; i < eventTitles.length; i++) {
          Event event = new Event();
          event.title = eventTitles[i]['title'];
          event.description = eventDescriptions[i]['title'].replaceAll("\n", " ");
          event.location = eventLocations[i]['title'];
          event.time = eventTimes[i]['title'];
          if (eventImagePaths[i]['attributes']['src'] == "NULL_IMAGE_SUBSTITUTE") {
            event.imgPath = "https://www.essexstudent.com/pageassets/whatson/image00034.jpg";
          } else {
            event.setImgPath(eventImagePaths[i]['attributes']['src']);
          }
          events[i] = event;
        }
        return events;
      }
    } catch (e) {
      log(e.toString());
      throw EventException("Couldn't access events");
    }
  }

  static Future<List<String>> incompleteEventsByTitle() async {
    final webScraper = WebScraper(_url);
    try {
      if (await webScraper.loadWebPage(_page)) {
        List<Map<String, dynamic>> incompleteEventTitles = webScraper.getElement('div.event_item > dl > dt > a.msl_event_name:only-child', []);
        List<String> events = List<String>(incompleteEventTitles.length);
        for (var i = 0; i < incompleteEventTitles.length; i++) {
          events[i] = incompleteEventTitles[i]['title'];
        }
        return events;
      }
    } catch (e) {
      log(e.toString());
      throw EventException("Couldn't access events");
    }
  }


}