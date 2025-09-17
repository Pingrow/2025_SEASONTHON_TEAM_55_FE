import 'package:http/http.dart' as http;
import 'package:icalendar_parser/icalendar_parser.dart';

Future<List<Map<String, dynamic>>> fetchAndSaveCalendar(
  String url, {
  String outputJson = "calendar_events.json",
}) async {
  // ICS 데이터 가져오기
  final response = await http.get(Uri.parse(url));

  if (response.statusCode != 200) {
    throw Exception('Failed to fetch calendar: ${response.statusCode}');
  }

  // 캘린더 파싱
  final calendar = ICalendar.fromString(response.body);

  List<Map<String, dynamic>> events = [];

  for (var component in calendar.data) {
    if (component['type'] == 'VEVENT') {
      events.add({
        "title": component['summary'],
        "start": DateTime.parse(component['dtstart'].dt),
        "end": DateTime.parse(component['dtend'].dt),
      });
    }
  }

  return events;
}

void main() async {
  // 사용 예시 (공개 구글 캘린더 ICS 주소 넣으세요)
  const url =
      "https://calendar.google.com/calendar/ical/gjbox0301%40gmail.com/public/basic.ics";
  await fetchAndSaveCalendar(url);
}
