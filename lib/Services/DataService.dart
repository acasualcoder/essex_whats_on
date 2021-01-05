import 'package:essexwhatson/Exceptions/EventException.dart';
import 'package:essexwhatson/Model/Event.dart';
import 'package:web_scraper/web_scraper.dart';

class DataService {

  static final _url = 'https://www.essexstudent.com';
  static final _page = '/whatson';

  static Future<List<Event>> pullData() async {
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

}