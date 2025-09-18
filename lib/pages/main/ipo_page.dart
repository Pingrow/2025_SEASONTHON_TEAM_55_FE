import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_grow/service/schedule_getter.dart';
import 'package:pin_grow/view_model/api_view_model.dart';
import 'package:pin_grow/view_model/auth_view_model.dart';
import 'package:table_calendar/table_calendar.dart';

class IPOPage extends StatefulHookConsumerWidget {
  const IPOPage({super.key});

  @override
  ConsumerState<IPOPage> createState() => _IPOPageState();
}

class _IPOPageState extends ConsumerState<IPOPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  late final Future<List<Event>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;

    _eventsFuture = fetchIPOList();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final apiRepo = ref.read(productViewModelProvider.notifier);

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(
        0,
        MediaQuery.of(context).padding.top,
        0,
        MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(color: Color(0xffffffff)),
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      //width: 338.w,
                      //height: 39.h,
                      margin: EdgeInsets.fromLTRB(
                        (MediaQuery.of(context).size.width - 338.w) / 2 - 10.w,
                        20.h,
                        (MediaQuery.of(context).size.width - 338.w) / 2 - 10.w,
                        10.h,
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              GoRouter.of(context).pop();
                            },
                            child: Padding(
                              padding: EdgeInsetsGeometry.fromLTRB(
                                10.w,
                                10.h,
                                10.w,
                                10.h,
                              ),
                              child: Image.asset(
                                'assets/icons/back.png',
                                width: 10.w,
                                height: 16.h,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: 338.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff374151),
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      authState.user?.nickname ??
                                      '???', //'핀그로우',
                                  style: TextStyle(color: Color(0xff0CA361)),
                                ),

                                TextSpan(text: ' 님을 위한 공모주 일정'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: (MediaQuery.of(context).size.width - 328.w) / 2,
                  ),
                  child: FutureBuilder<List<Event>>(
                    future: _eventsFuture, // 추적할 Future를 지정
                    builder: (context, snapshot) {
                      // 로딩 중일 때 로딩 인디케이터 표시
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // 에러가 발생했을 때 에러 메시지 표시
                      if (snapshot.hasError) {
                        return Center(child: Text('에러 발생: ${snapshot.error}'));
                      }

                      // 데이터 로딩이 성공적으로 완료되었을 때
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      final events = snapshot.data!;

                      events.sort((a, b) {
                        // 1. 시작일 기준으로 오름차순 정렬
                        final startDateComparison = a.start.compareTo(b.start);
                        if (startDateComparison != 0) {
                          return startDateComparison;
                        }
                        // 2. 시작일이 같다면, 종료일 기준으로 내림차순 정렬 (긴 일정이 위로)
                        return b.end.compareTo(a.end);
                      });

                      // 데이터를 table_calendar 형식으로 변환
                      final eventsMap = LinkedHashMap<DateTime, List<Event>>(
                        equals: isSameDay,
                        hashCode: (key) =>
                            key.day * 1000000 + key.month * 10000 + key.year,
                      );

                      for (var event in events) {
                        for (
                          var d = event.start;
                          d.isBefore(event.end.add(const Duration(days: 1)));
                          d = d.add(const Duration(days: 1))
                        ) {
                          final day = DateTime.utc(d.year, d.month, d.day);
                          if (eventsMap[day] == null) {
                            eventsMap[day] = [];
                          }
                          eventsMap[day]!.add(event);
                        }
                      }

                      List<Event> getEventsForDay(DateTime day) {
                        return eventsMap[day] ?? [];
                      }

                      // 캘린더와 리스트뷰를 포함한 UI 반환
                      return Container(
                        //height: MediaQuery.of(context).size.height * 0.6,
                        child: Column(
                          children: [
                            TableCalendar<Event>(
                              locale: 'ko_KR',

                              headerStyle: HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true,
                                titleTextStyle: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              firstDay: DateTime.utc(2020, 1, 1),
                              lastDay: DateTime.utc(2030, 12, 31),
                              focusedDay: _focusedDay,
                              selectedDayPredicate: (day) =>
                                  isSameDay(_selectedDay, day),
                              eventLoader: getEventsForDay,

                              rangeStartDay: _rangeStart,
                              rangeEndDay: _rangeEnd,
                              rangeSelectionMode: RangeSelectionMode
                                  .toggledOff, // 사용자가 직접 범위 선택하는 기능은 끔
                              rowHeight: 70,
                              onDaySelected: (selectedDay, focusedDay) {
                                setState(() {
                                  _selectedDay = selectedDay;
                                  _focusedDay = focusedDay;
                                });
                              },
                              calendarBuilders: CalendarBuilders(
                                // 각 날짜 셀에 이벤트 위젯을 빌드
                                defaultBuilder: (context, day, focusedDay) {
                                  final eventsOnDay = getEventsForDay(day);
                                  if (eventsOnDay.isNotEmpty) {
                                    return _buildDayWithEvents(
                                      day,
                                      eventsOnDay,
                                    );
                                  }
                                  return null; // 이벤트 없으면 기본 빌더 사용
                                },
                                // 선택된 날짜도 동일하게 이벤트 표시
                                selectedBuilder: (context, day, focusedDay) {
                                  final eventsOnDay = getEventsForDay(day);
                                  return _buildDayWithEvents(
                                    day,
                                    eventsOnDay,
                                    isSelected: true,
                                  );
                                },
                                // 오늘 날짜도 동일하게 이벤트 표시
                                todayBuilder: (context, day, focusedDay) {
                                  final eventsOnDay = getEventsForDay(day);
                                  return _buildDayWithEvents(
                                    day,
                                    eventsOnDay,
                                    isToday: true,
                                  );
                                },
                              ),

                              // 5. 스타일링: 범위 선택 UI를 보기 좋게 만듦
                              calendarStyle: CalendarStyle(
                                cellAlignment: Alignment.topCenter,

                                rangeStartDecoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(8.0),
                                  ),
                                ),
                                rangeEndDecoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.horizontal(
                                    right: Radius.circular(8.0),
                                  ),
                                ),
                                withinRangeDecoration: const BoxDecoration(
                                  color: Colors.lightBlue,
                                  shape: BoxShape.rectangle,
                                ),

                                markerSize: 0,
                              ),
                            ),

                            const SizedBox(height: 8.0),
                            Expanded(
                              child: ListView.builder(
                                itemCount: getEventsForDay(
                                  _selectedDay ?? DateTime.now(),
                                ).length,
                                itemBuilder: (context, index) {
                                  final event = getEventsForDay(
                                    _selectedDay ?? DateTime.now(),
                                  )[index];
                                  return GestureDetector(
                                    onTap: () {
                                      // 6. 하단 리스트의 일정을 탭하면 캘린더에 해당 범위가 하이라이트됨
                                      setState(() {
                                        _rangeStart = event.start;
                                        _rangeEnd = event.end;
                                        _selectedDay = event.start;
                                        _focusedDay = event.start;
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                        vertical: 4.0,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius: BorderRadius.circular(
                                          12.0,
                                        ),
                                      ),
                                      child: ListTile(
                                        title: Text(event.title),
                                        subtitle: Text(
                                          "기간: ${event.start.toLocal().toString().split(' ')[0]} ~ ${event.end.toLocal().toString().split(' ')[0]}",
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 15.w,
            bottom: 15.h,
            child: GestureDetector(
              onTap: () {
                GoRouter.of(context).push('/chat_bot');
              },
              child: Image.asset(
                'assets/icons/chat_bot_icon.png',
                width: 60.r,
                height: 60.r,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 날짜 셀 안에 이벤트 내용을 표시하는 위젯을 생성하는 헬퍼 함수
  Widget _buildDayWithEvents(
    DateTime day,
    List<Event> events, {
    bool isSelected = false,
    bool isToday = false,
  }) {
    return Column(
      children: [
        // 날짜 숫자 표시 (선택/오늘 여부에 따라 스타일 변경)
        Container(
          width: 30.r,
          height: 30.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? Colors.blue[300]
                : (isToday ? Colors.black45 : null),
          ),
          child: Center(
            child: Text(
              '${day.day}',
              style: TextStyle(
                color: isToday || isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4.0),
        // 이벤트 이름 표시
        Expanded(
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                ...events
                    .map(
                      (event) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        margin: const EdgeInsets.only(bottom: 2.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.green[200],
                          borderRadius:
                              (day.month == event.start.month &&
                                  day.day == event.start.day)
                              ? BorderRadius.horizontal(
                                  left: Radius.circular(4.0),
                                )
                              : (day.month == event.end.month &&
                                    day.day == event.end.day)
                              ? BorderRadius.horizontal(
                                  right: Radius.circular(4.0),
                                )
                              : BorderRadius.zero,
                        ),

                        child: Text(
                          event.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
