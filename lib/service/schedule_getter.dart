import 'package:http/http.dart' as http;
import 'package:icalendar_parser/icalendar_parser.dart';

class Event {
  final String title;
  final DateTime start;
  final DateTime end;

  Event({required this.title, required this.start, required this.end});
}

Future<List<Event>> fetchIPOList() async {
  const url =
      "https://calendar.google.com/calendar/ical/gjbox0301%40gmail.com/public/basic.ics";

  // ICS 데이터 가져오기
  final response = await http.get(Uri.parse(url));

  if (response.statusCode != 200) {
    throw Exception('Failed to fetch calendar: ${response.statusCode}');
  }

  // 캘린더 파싱
  final calendar = ICalendar.fromString(response.body);

  List<Event> events = [];

  for (var component in calendar.data) {
    if (component['type'] == 'VEVENT') {
      events.add(
        Event(
          title: component['summary'],
          start: DateTime.parse(component['dtstart'].dt),
          end: DateTime.parse(component['dtend'].dt),
        ),
      );
    }
  }

  return events;
}
