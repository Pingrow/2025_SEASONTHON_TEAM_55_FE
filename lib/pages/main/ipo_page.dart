import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_grow/service/schedule_getter.dart';
import 'package:pin_grow/view_model/api_view_model.dart';
import 'package:pin_grow/view_model/auth_view_model.dart';
import 'package:table_calendar/table_calendar.dart';

// 이벤트와 '차선' 정보를 함께 담을 클래스
class PositionedEvent {
  final Event event;
  final int laneIndex; // 몇 번째 세로줄에 위치하는지

  PositionedEvent(this.event, this.laneIndex);
}

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

              // IPOPage.dart

              // ...
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: (MediaQuery.of(context).size.width - 328.w) / 2,
                  ),
                  child: FutureBuilder<List<Event>>(
                    future: _eventsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('에러 발생: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return TableCalendar(
                          // 데이터 없을 때 빈 캘린더 표시
                          firstDay: DateTime.utc(2020, 1, 1),
                          lastDay: DateTime.utc(2030, 12, 31),
                          focusedDay: _focusedDay,
                          locale: 'ko_KR',
                        );
                      }

                      final events = snapshot.data!;

                      // 1. 이벤트를 시작일, 기간 순으로 정렬
                      events.sort((a, b) {
                        final startDateComparison = a.start.compareTo(b.start);
                        if (startDateComparison != 0)
                          return startDateComparison;
                        return b.end.compareTo(a.end);
                      });

                      // 2. "차선 할당" 로직 (레이아웃 엔진)
                      final Map<DateTime, List<PositionedEvent?>>
                      positionedEventsMap = {};
                      final List<DateTime> laneEndDates = [];

                      for (final event in events) {
                        int targetLane = -1;

                        // 비어있는 가장 빠른 차선 찾기
                        for (int i = 0; i < laneEndDates.length; i++) {
                          if (event.start.isAfter(laneEndDates[i])) {
                            targetLane = i;
                            break;
                          }
                        }

                        // 비어있는 차선이 없으면 새 차선 만들기
                        if (targetLane == -1) {
                          targetLane = laneEndDates.length;
                          laneEndDates.add(event.end);
                        } else {
                          laneEndDates[targetLane] = event.end;
                        }

                        // 이벤트 기간의 모든 날짜에, 계산된 차선 정보와 함께 이벤트 추가
                        for (
                          var d = event.start;
                          d.isBefore(event.end.add(const Duration(days: 1)));
                          d = d.add(const Duration(days: 1))
                        ) {
                          final day = DateTime.utc(d.year, d.month, d.day);

                          if (positionedEventsMap[day] == null) {
                            positionedEventsMap[day] = [];
                          }

                          // 리스트 길이를 차선에 맞게 null로 채우기
                          while (positionedEventsMap[day]!.length <=
                              targetLane) {
                            positionedEventsMap[day]!.add(null);
                          }

                          // 해당 차선에 이벤트 배치
                          positionedEventsMap[day]![targetLane] =
                              PositionedEvent(event, targetLane);
                        }
                      }

                      // 3. UI에 전달할 함수 만들기
                      List<PositionedEvent?> getEventsForDay(DateTime day) {
                        return positionedEventsMap[day] ?? [];
                      }

                      // 4. TableCalendar 위젯 반환 (eventLoader 수정)
                      return Container(
                        //height: MediaQuery.of(context).size.height * 0.6,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xffD0D0D0),
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: TableCalendar<PositionedEvent?>(
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
                                  // ▼▼▼ 빌더 함수들의 타입과 로직을 수정해야 합니다.
                                  defaultBuilder: (context, day, focusedDay) {
                                    final eventsOnDay = getEventsForDay(day);
                                    return _buildDayWithEvents(
                                      day,
                                      eventsOnDay,
                                    );
                                  },
                                  selectedBuilder: (context, day, focusedDay) {
                                    final eventsOnDay = getEventsForDay(day);
                                    return _buildDayWithEvents(
                                      day,
                                      eventsOnDay,
                                      isSelected: true,
                                    );
                                  },
                                  todayBuilder: (context, day, focusedDay) {
                                    final eventsOnDay = getEventsForDay(day);
                                    return _buildDayWithEvents(
                                      day,
                                      eventsOnDay,
                                      isToday: true,
                                    );
                                  },
                                ),
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
                            ),

                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                itemCount: getEventsForDay(
                                  _selectedDay ?? DateTime.now(),
                                ).where((e) => e != null).length,
                                itemBuilder: (context, index) {
                                  final validEvents = getEventsForDay(
                                    _selectedDay ?? DateTime.now(),
                                  ).where((e) => e != null).toList();
                                  final positionedEvent = validEvents[index];
                                  final event = positionedEvent!.event;

                                  return Container(
                                    padding: EdgeInsets.fromLTRB(
                                      0,
                                      5.h,
                                      0,
                                      10.h,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Color(0xffD0D0D0),
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                    child: ListTile(
                                      title: Text(event.title),
                                      subtitle: Text(
                                        "기간: ${event.start.toLocal().toString().split(' ')[0]} ~ ${event.end.toLocal().toString().split(' ')[0]}",
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
    List<PositionedEvent?> events, {
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ...events
                    .take(2)
                    .map(
                      (event) => (event == null)
                          ? Container(
                              height: 21, // 이벤트 박스 높이 + 마진
                              margin: const EdgeInsets.only(bottom: 3.0),
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              margin: const EdgeInsets.only(bottom: 2.0),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.green[200],
                                borderRadius:
                                    (day.month == event.event.start.month &&
                                        day.day == event.event.start.day)
                                    ? BorderRadius.horizontal(
                                        left: Radius.circular(4.0),
                                      )
                                    : (day.month == event.event.end.month &&
                                          day.day == event.event.end.day)
                                    ? BorderRadius.horizontal(
                                        right: Radius.circular(4.0),
                                      )
                                    : BorderRadius.zero,
                              ),

                              child: Text(
                                event!.event.title,
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
