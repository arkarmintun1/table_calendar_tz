// Copyright 2026 Arkar Min Tun
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import 'package:table_calendar_tz/table_calendar_tz.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'common.dart';

Widget setupTestWidget(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: child,
  );
}

void main() {
  setUpAll(() {
    tzdata.initializeTimeZones();
  });

  group('Correct days are displayed for given focusedDay when:', () {
    testWidgets(
      'in month format, starting day is Sunday',
      (tester) async {
        final focusedDay = DateTime.utc(2021, 7, 15);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendarBase(
              firstDay: DateTime.utc(2021, 5, 15),
              lastDay: DateTime.utc(2021, 8, 18),
              focusedDay: focusedDay,
              dayBuilder: (context, day, focusedDay) {
                return Text(
                  '${day.day}',
                  key: dateToKey(day),
                );
              },
              rowHeight: 52,
              dowVisible: false,
            ),
          ),
        );

        final firstVisibleDay = DateTime.utc(2021, 6, 27);
        final lastVisibleDay = DateTime.utc(2021, 7, 31);

        final focusedDayKey = dateToKey(focusedDay);
        final firstVisibleDayKey = dateToKey(firstVisibleDay);
        final lastVisibleDayKey = dateToKey(lastVisibleDay);

        final startOOBKey =
            dateToKey(firstVisibleDay.subtract(const Duration(days: 1)));
        final endOOBKey =
            dateToKey(lastVisibleDay.add(const Duration(days: 1)));

        expect(find.byKey(focusedDayKey), findsOneWidget);
        expect(find.byKey(firstVisibleDayKey), findsOneWidget);
        expect(find.byKey(lastVisibleDayKey), findsOneWidget);

        expect(find.byKey(startOOBKey), findsNothing);
        expect(find.byKey(endOOBKey), findsNothing);
      },
    );

    testWidgets(
      'in two weeks format, starting day is Sunday',
      (tester) async {
        final focusedDay = DateTime.utc(2021, 7, 15);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendarBase(
              firstDay: DateTime.utc(2021, 5, 15),
              lastDay: DateTime.utc(2021, 8, 18),
              focusedDay: focusedDay,
              dayBuilder: (context, day, focusedDay) {
                return Text(
                  '${day.day}',
                  key: dateToKey(day),
                );
              },
              rowHeight: 52,
              dowVisible: false,
              calendarFormat: CalendarFormat.twoWeeks,
            ),
          ),
        );

        final firstVisibleDay = DateTime.utc(2021, 7, 4);
        final lastVisibleDay = DateTime.utc(2021, 7, 17);

        final focusedDayKey = dateToKey(focusedDay);
        final firstVisibleDayKey = dateToKey(firstVisibleDay);
        final lastVisibleDayKey = dateToKey(lastVisibleDay);

        final startOOBKey =
            dateToKey(firstVisibleDay.subtract(const Duration(days: 1)));
        final endOOBKey =
            dateToKey(lastVisibleDay.add(const Duration(days: 1)));

        expect(find.byKey(focusedDayKey), findsOneWidget);
        expect(find.byKey(firstVisibleDayKey), findsOneWidget);
        expect(find.byKey(lastVisibleDayKey), findsOneWidget);

        expect(find.byKey(startOOBKey), findsNothing);
        expect(find.byKey(endOOBKey), findsNothing);
      },
    );

    testWidgets(
      'in week format, starting day is Sunday',
      (tester) async {
        final focusedDay = DateTime.utc(2021, 7, 15);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendarBase(
              firstDay: DateTime.utc(2021, 5, 15),
              lastDay: DateTime.utc(2021, 8, 18),
              focusedDay: focusedDay,
              dayBuilder: (context, day, focusedDay) {
                return Text(
                  '${day.day}',
                  key: dateToKey(day),
                );
              },
              rowHeight: 52,
              dowVisible: false,
              calendarFormat: CalendarFormat.week,
            ),
          ),
        );

        final firstVisibleDay = DateTime.utc(2021, 7, 11);
        final lastVisibleDay = DateTime.utc(2021, 7, 17);

        final focusedDayKey = dateToKey(focusedDay);
        final firstVisibleDayKey = dateToKey(firstVisibleDay);
        final lastVisibleDayKey = dateToKey(lastVisibleDay);

        final startOOBKey =
            dateToKey(firstVisibleDay.subtract(const Duration(days: 1)));
        final endOOBKey =
            dateToKey(lastVisibleDay.add(const Duration(days: 1)));

        expect(find.byKey(focusedDayKey), findsOneWidget);
        expect(find.byKey(firstVisibleDayKey), findsOneWidget);
        expect(find.byKey(lastVisibleDayKey), findsOneWidget);

        expect(find.byKey(startOOBKey), findsNothing);
        expect(find.byKey(endOOBKey), findsNothing);
      },
    );

    testWidgets(
      'in month format, starting day is Monday',
      (tester) async {
        final focusedDay = DateTime.utc(2021, 7, 15);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendarBase(
              firstDay: DateTime.utc(2021, 5, 15),
              lastDay: DateTime.utc(2021, 8, 18),
              focusedDay: focusedDay,
              dayBuilder: (context, day, focusedDay) {
                return Text(
                  '${day.day}',
                  key: dateToKey(day),
                );
              },
              rowHeight: 52,
              dowVisible: false,
              startingDayOfWeek: StartingDayOfWeek.monday,
            ),
          ),
        );

        final firstVisibleDay = DateTime.utc(2021, 6, 28);
        final lastVisibleDay = DateTime.utc(2021, 8);

        final focusedDayKey = dateToKey(focusedDay);
        final firstVisibleDayKey = dateToKey(firstVisibleDay);
        final lastVisibleDayKey = dateToKey(lastVisibleDay);

        final startOOBKey =
            dateToKey(firstVisibleDay.subtract(const Duration(days: 1)));
        final endOOBKey =
            dateToKey(lastVisibleDay.add(const Duration(days: 1)));

        expect(find.byKey(focusedDayKey), findsOneWidget);
        expect(find.byKey(firstVisibleDayKey), findsOneWidget);
        expect(find.byKey(lastVisibleDayKey), findsOneWidget);

        expect(find.byKey(startOOBKey), findsNothing);
        expect(find.byKey(endOOBKey), findsNothing);
      },
    );

    testWidgets(
      'in two weeks format, starting day is Monday',
      (tester) async {
        final focusedDay = DateTime.utc(2021, 7, 15);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendarBase(
              firstDay: DateTime.utc(2021, 5, 15),
              lastDay: DateTime.utc(2021, 8, 18),
              focusedDay: focusedDay,
              dayBuilder: (context, day, focusedDay) {
                return Text(
                  '${day.day}',
                  key: dateToKey(day),
                );
              },
              rowHeight: 52,
              dowVisible: false,
              calendarFormat: CalendarFormat.twoWeeks,
              startingDayOfWeek: StartingDayOfWeek.monday,
            ),
          ),
        );

        final firstVisibleDay = DateTime.utc(2021, 7, 5);
        final lastVisibleDay = DateTime.utc(2021, 7, 18);

        final focusedDayKey = dateToKey(focusedDay);
        final firstVisibleDayKey = dateToKey(firstVisibleDay);
        final lastVisibleDayKey = dateToKey(lastVisibleDay);

        final startOOBKey =
            dateToKey(firstVisibleDay.subtract(const Duration(days: 1)));
        final endOOBKey =
            dateToKey(lastVisibleDay.add(const Duration(days: 1)));

        expect(find.byKey(focusedDayKey), findsOneWidget);
        expect(find.byKey(firstVisibleDayKey), findsOneWidget);
        expect(find.byKey(lastVisibleDayKey), findsOneWidget);

        expect(find.byKey(startOOBKey), findsNothing);
        expect(find.byKey(endOOBKey), findsNothing);
      },
    );

    testWidgets(
      'in week format, starting day is Monday',
      (tester) async {
        final focusedDay = DateTime.utc(2021, 7, 15);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendarBase(
              firstDay: DateTime.utc(2021, 5, 15),
              lastDay: DateTime.utc(2021, 8, 18),
              focusedDay: focusedDay,
              dayBuilder: (context, day, focusedDay) {
                return Text(
                  '${day.day}',
                  key: dateToKey(day),
                );
              },
              rowHeight: 52,
              dowVisible: false,
              calendarFormat: CalendarFormat.week,
              startingDayOfWeek: StartingDayOfWeek.monday,
            ),
          ),
        );

        final firstVisibleDay = DateTime.utc(2021, 7, 12);
        final lastVisibleDay = DateTime.utc(2021, 7, 18);

        final focusedDayKey = dateToKey(focusedDay);
        final firstVisibleDayKey = dateToKey(firstVisibleDay);
        final lastVisibleDayKey = dateToKey(lastVisibleDay);

        final startOOBKey =
            dateToKey(firstVisibleDay.subtract(const Duration(days: 1)));
        final endOOBKey =
            dateToKey(lastVisibleDay.add(const Duration(days: 1)));

        expect(find.byKey(focusedDayKey), findsOneWidget);
        expect(find.byKey(firstVisibleDayKey), findsOneWidget);
        expect(find.byKey(lastVisibleDayKey), findsOneWidget);

        expect(find.byKey(startOOBKey), findsNothing);
        expect(find.byKey(endOOBKey), findsNothing);
      },
    );
  });

  group('time zone support', () {
    testWidgets(
      'dayBuilder receives TZDateTime instances for provided location',
      (tester) async {
        final location = tz.getLocation('America/Los_Angeles');
        final capturedDays = <DateTime>[];

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendarBase(
              firstDay: tz.TZDateTime(location, 2021, 5),
              lastDay: tz.TZDateTime(location, 2021, 7, 31),
              focusedDay: tz.TZDateTime(location, 2021, 6, 15),
              timeZone: location,
              dowVisible: false,
              rowHeight: 52,
              dayBuilder: (context, day, focusedDay) {
                capturedDays.add(day);
                return const SizedBox();
              },
            ),
          ),
        );

        expect(capturedDays, isNotEmpty);
        expect(
          capturedDays.whereType<tz.TZDateTime>(),
          hasLength(capturedDays.length),
        );
        expect(
          capturedDays
              .whereType<tz.TZDateTime>()
              .every((day) => day.location == location),
          isTrue,
        );
      },
    );

    testWidgets(
      'month grid is correct when leading days cross DST spring-forward (Sunday start)',
      (tester) async {
        // Europe/Berlin DST spring-forward: March 29, 2026.
        // April 1, 2026 is Wednesday — subtracting 3 days to reach Sunday
        // crosses the DST boundary. Without calendar-aware arithmetic the grid
        // would start on Saturday March 28 instead of Sunday March 29.
        final location = tz.getLocation('Europe/Berlin');
        final focusedDay = tz.TZDateTime(location, 2026, 4, 15);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendarBase(
              firstDay: tz.TZDateTime(location, 2026),
              lastDay: tz.TZDateTime(location, 2026, 12, 31),
              focusedDay: focusedDay,
              timeZone: location,
              dowVisible: false,
              rowHeight: 52,
              dayBuilder: (context, day, focusedDay) {
                return Text('${day.day}', key: dateToKey(day));
              },
            ),
          ),
        );

        final firstVisibleDay = tz.TZDateTime(location, 2026, 3, 29);
        final lastVisibleDay = tz.TZDateTime(location, 2026, 5, 2);

        expect(find.byKey(dateToKey(firstVisibleDay)), findsOneWidget);
        expect(find.byKey(dateToKey(lastVisibleDay)), findsOneWidget);

        // March 28 must NOT appear — that's the DST bug symptom
        final marchTwentyEighth = tz.TZDateTime(location, 2026, 3, 28);
        expect(find.byKey(dateToKey(marchTwentyEighth)), findsNothing);

        // May 3 must NOT appear
        final mayThird = tz.TZDateTime(location, 2026, 5, 3);
        expect(find.byKey(dateToKey(mayThird)), findsNothing);
      },
    );

    testWidgets(
      'month grid is correct when leading days cross DST spring-forward (Monday start)',
      (tester) async {
        final location = tz.getLocation('Europe/Berlin');
        final focusedDay = tz.TZDateTime(location, 2026, 4, 15);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendarBase(
              firstDay: tz.TZDateTime(location, 2026),
              lastDay: tz.TZDateTime(location, 2026, 12, 31),
              focusedDay: focusedDay,
              timeZone: location,
              startingDayOfWeek: StartingDayOfWeek.monday,
              dowVisible: false,
              rowHeight: 52,
              dayBuilder: (context, day, focusedDay) {
                return Text('${day.day}', key: dateToKey(day));
              },
            ),
          ),
        );

        final firstVisibleDay = tz.TZDateTime(location, 2026, 3, 30);
        final lastVisibleDay = tz.TZDateTime(location, 2026, 5, 3);

        expect(find.byKey(dateToKey(firstVisibleDay)), findsOneWidget);
        expect(find.byKey(dateToKey(lastVisibleDay)), findsOneWidget);

        final beforeFirst = tz.TZDateTime(location, 2026, 3, 29);
        expect(find.byKey(dateToKey(beforeFirst)), findsNothing);

        final afterLast = tz.TZDateTime(location, 2026, 5, 4);
        expect(find.byKey(dateToKey(afterLast)), findsNothing);
      },
    );

    testWidgets(
      'week grid is correct when it spans a DST spring-forward boundary',
      (tester) async {
        final location = tz.getLocation('Europe/Berlin');
        // Focused on March 30 (Monday), week with Sunday start includes
        // March 29 (the DST transition day) through April 4.
        final focusedDay = tz.TZDateTime(location, 2026, 3, 30);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendarBase(
              firstDay: tz.TZDateTime(location, 2026),
              lastDay: tz.TZDateTime(location, 2026, 12, 31),
              focusedDay: focusedDay,
              timeZone: location,
              calendarFormat: CalendarFormat.week,
              dowVisible: false,
              rowHeight: 52,
              dayBuilder: (context, day, focusedDay) {
                return Text('${day.day}', key: dateToKey(day));
              },
            ),
          ),
        );

        final firstVisibleDay = tz.TZDateTime(location, 2026, 3, 29);
        final lastVisibleDay = tz.TZDateTime(location, 2026, 4, 4);

        expect(find.byKey(dateToKey(firstVisibleDay)), findsOneWidget);
        expect(find.byKey(dateToKey(lastVisibleDay)), findsOneWidget);

        final beforeFirst = tz.TZDateTime(location, 2026, 3, 28);
        expect(find.byKey(dateToKey(beforeFirst)), findsNothing);

        final afterLast = tz.TZDateTime(location, 2026, 4, 5);
        expect(find.byKey(dateToKey(afterLast)), findsNothing);
      },
    );

    testWidgets(
      'two-week grid is correct when it spans a DST spring-forward boundary',
      (tester) async {
        final location = tz.getLocation('Europe/Berlin');
        // The two-week page grid is anchored to firstDay (Jan 1, 2026).
        // Page containing March 30 has baseDay = Jan 1 + 6*14 = Mar 26 (Thu).
        // Sunday start → 4 leading days → first visible: Mar 22 (Sun).
        // 14 rendered days: Mar 22 → Apr 4.
        // The DST spring-forward (Mar 29) falls within this range.
        final focusedDay = tz.TZDateTime(location, 2026, 3, 30);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendarBase(
              firstDay: tz.TZDateTime(location, 2026),
              lastDay: tz.TZDateTime(location, 2026, 12, 31),
              focusedDay: focusedDay,
              timeZone: location,
              calendarFormat: CalendarFormat.twoWeeks,
              dowVisible: false,
              rowHeight: 52,
              dayBuilder: (context, day, focusedDay) {
                return Text('${day.day}', key: dateToKey(day));
              },
            ),
          ),
        );

        final firstVisibleDay = tz.TZDateTime(location, 2026, 3, 22);
        final lastVisibleDay = tz.TZDateTime(location, 2026, 4, 4);

        expect(find.byKey(dateToKey(firstVisibleDay)), findsOneWidget);
        expect(find.byKey(dateToKey(lastVisibleDay)), findsOneWidget);

        // DST spring-forward day (Mar 29) must be present in the grid
        final dstDay = tz.TZDateTime(location, 2026, 3, 29);
        expect(find.byKey(dateToKey(dstDay)), findsOneWidget);

        final beforeFirst = tz.TZDateTime(location, 2026, 3, 21);
        expect(find.byKey(dateToKey(beforeFirst)), findsNothing);

        final afterLast = tz.TZDateTime(location, 2026, 4, 5);
        expect(find.byKey(dateToKey(afterLast)), findsNothing);
      },
    );

    testWidgets(
      'month grid is correct during DST fall-back (Europe/Berlin, Monday start)',
      (tester) async {
        final location = tz.getLocation('Europe/Berlin');
        // Europe/Berlin fall-back: October 25, 2026 at 3:00 → 2:00 AM.
        // October 1 is Thursday, Monday start → 3 leading days (Sep 28-30).
        // October 31 is Saturday → 1 trailing day (Nov 1).
        // Grid: Sep 28 → Nov 1 (35 days, 5 rows).
        // The fall-back on Oct 25 is within this grid.
        final focusedDay = tz.TZDateTime(location, 2026, 10, 15);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendarBase(
              firstDay: tz.TZDateTime(location, 2026),
              lastDay: tz.TZDateTime(location, 2026, 12, 31),
              focusedDay: focusedDay,
              timeZone: location,
              startingDayOfWeek: StartingDayOfWeek.monday,
              dowVisible: false,
              rowHeight: 52,
              dayBuilder: (context, day, focusedDay) {
                return Text('${day.day}', key: dateToKey(day));
              },
            ),
          ),
        );

        final firstVisibleDay = tz.TZDateTime(location, 2026, 9, 28);
        final lastVisibleDay = tz.TZDateTime(location, 2026, 11);

        expect(find.byKey(dateToKey(firstVisibleDay)), findsOneWidget);
        expect(find.byKey(dateToKey(lastVisibleDay)), findsOneWidget);

        // Verify the DST fall-back day itself is present
        final fallBackDay = tz.TZDateTime(location, 2026, 10, 25);
        expect(find.byKey(dateToKey(fallBackDay)), findsOneWidget);

        final beforeFirst = tz.TZDateTime(location, 2026, 9, 27);
        expect(find.byKey(dateToKey(beforeFirst)), findsNothing);

        final afterLast = tz.TZDateTime(location, 2026, 11, 2);
        expect(find.byKey(dateToKey(afterLast)), findsNothing);
      },
    );

    testWidgets(
      'month grid is correct for US spring-forward (America/New_York, Sunday start)',
      (tester) async {
        final location = tz.getLocation('America/New_York');
        // US spring-forward: March 8, 2026 at 2:00 AM.
        // March 1 is Sunday, Sunday start → 0 leading days.
        // March 31 is Tuesday → 4 trailing days (Apr 1-4).
        // Grid: Mar 1 → Apr 4 (35 days, 5 rows).
        final focusedDay = tz.TZDateTime(location, 2026, 3, 15);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendarBase(
              firstDay: tz.TZDateTime(location, 2026),
              lastDay: tz.TZDateTime(location, 2026, 12, 31),
              focusedDay: focusedDay,
              timeZone: location,
              dowVisible: false,
              rowHeight: 52,
              dayBuilder: (context, day, focusedDay) {
                return Text('${day.day}', key: dateToKey(day));
              },
            ),
          ),
        );

        final firstVisibleDay = tz.TZDateTime(location, 2026, 3);
        final lastVisibleDay = tz.TZDateTime(location, 2026, 4, 4);

        expect(find.byKey(dateToKey(firstVisibleDay)), findsOneWidget);
        expect(find.byKey(dateToKey(lastVisibleDay)), findsOneWidget);

        // Verify the DST spring-forward day itself is present
        final springForwardDay = tz.TZDateTime(location, 2026, 3, 8);
        expect(find.byKey(dateToKey(springForwardDay)), findsOneWidget);

        final beforeFirst = tz.TZDateTime(location, 2026, 2, 28);
        expect(find.byKey(dateToKey(beforeFirst)), findsNothing);

        final afterLast = tz.TZDateTime(location, 2026, 4, 5);
        expect(find.byKey(dateToKey(afterLast)), findsNothing);
      },
    );

    testWidgets(
      'month grid is correct for US fall-back (America/New_York, Sunday start)',
      (tester) async {
        final location = tz.getLocation('America/New_York');
        // US fall-back: November 1, 2026 at 2:00 AM.
        // November 1 is Sunday, Sunday start → 0 leading days.
        // November 30 is Monday → 5 trailing days (Dec 1-5).
        // Grid: Nov 1 → Dec 5 (35 days, 5 rows).
        final focusedDay = tz.TZDateTime(location, 2026, 11, 15);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendarBase(
              firstDay: tz.TZDateTime(location, 2026),
              lastDay: tz.TZDateTime(location, 2026, 12, 31),
              focusedDay: focusedDay,
              timeZone: location,
              dowVisible: false,
              rowHeight: 52,
              dayBuilder: (context, day, focusedDay) {
                return Text('${day.day}', key: dateToKey(day));
              },
            ),
          ),
        );

        final firstVisibleDay = tz.TZDateTime(location, 2026, 11);
        final lastVisibleDay = tz.TZDateTime(location, 2026, 12, 5);

        expect(find.byKey(dateToKey(firstVisibleDay)), findsOneWidget);
        expect(find.byKey(dateToKey(lastVisibleDay)), findsOneWidget);

        final beforeFirst = tz.TZDateTime(location, 2026, 10, 31);
        expect(find.byKey(dateToKey(beforeFirst)), findsNothing);

        final afterLast = tz.TZDateTime(location, 2026, 12, 6);
        expect(find.byKey(dateToKey(afterLast)), findsNothing);
      },
    );

    testWidgets(
      'month grid is correct with sixWeekMonthsEnforced and DST spring-forward',
      (tester) async {
        final location = tz.getLocation('Europe/Berlin');
        // April 2026 Berlin with sixWeekMonthsEnforced.
        // Apr 1 = Wednesday, Sunday start → 3 leading days → first visible: Mar 29.
        // 6 rows × 7 = 42 cells → last visible: May 9.
        final focusedDay = tz.TZDateTime(location, 2026, 4, 15);
        final capturedDays = <DateTime>[];

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendarBase(
              firstDay: tz.TZDateTime(location, 2026),
              lastDay: tz.TZDateTime(location, 2026, 12, 31),
              focusedDay: focusedDay,
              timeZone: location,
              sixWeekMonthsEnforced: true,
              dowVisible: false,
              rowHeight: 52,
              dayBuilder: (context, day, focusedDay) {
                capturedDays.add(day);
                return Text('${day.day}', key: dateToKey(day));
              },
            ),
          ),
        );

        expect(capturedDays.length, 42);

        final firstVisibleDay = tz.TZDateTime(location, 2026, 3, 29);
        final lastVisibleDay = tz.TZDateTime(location, 2026, 5, 9);

        expect(find.byKey(dateToKey(firstVisibleDay)), findsOneWidget);
        expect(find.byKey(dateToKey(lastVisibleDay)), findsOneWidget);

        final beforeFirst = tz.TZDateTime(location, 2026, 3, 28);
        expect(find.byKey(dateToKey(beforeFirst)), findsNothing);

        final afterLast = tz.TZDateTime(location, 2026, 5, 10);
        expect(find.byKey(dateToKey(afterLast)), findsNothing);
      },
    );

    testWidgets(
      'February (28 days) with timezone renders correct grid',
      (tester) async {
        final location = tz.getLocation('Asia/Tokyo');
        // February 2026: Feb 1 is Sunday, Feb 28 is Saturday.
        // Sunday start → 0 leading, 0 trailing → exactly 28 days, 4 rows.
        final focusedDay = tz.TZDateTime(location, 2026, 2, 15);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendarBase(
              firstDay: tz.TZDateTime(location, 2026),
              lastDay: tz.TZDateTime(location, 2026, 12, 31),
              focusedDay: focusedDay,
              timeZone: location,
              dowVisible: false,
              rowHeight: 52,
              dayBuilder: (context, day, focusedDay) {
                return Text('${day.day}', key: dateToKey(day));
              },
            ),
          ),
        );

        final firstVisibleDay = tz.TZDateTime(location, 2026, 2);
        final lastVisibleDay = tz.TZDateTime(location, 2026, 2, 28);

        expect(find.byKey(dateToKey(firstVisibleDay)), findsOneWidget);
        expect(find.byKey(dateToKey(lastVisibleDay)), findsOneWidget);

        final beforeFirst = tz.TZDateTime(location, 2026, 1, 31);
        expect(find.byKey(dateToKey(beforeFirst)), findsNothing);

        final afterLast = tz.TZDateTime(location, 2026, 3);
        expect(find.byKey(dateToKey(afterLast)), findsNothing);
      },
    );

    testWidgets(
      'year boundary: December grid shows January trailing days with timezone',
      (tester) async {
        final location = tz.getLocation('Asia/Tokyo');
        // December 2025: Dec 1 is Monday, Dec 31 is Wednesday.
        // Monday start → 0 leading days.
        // Trailing: need Thu, Fri, Sat, Sun → 4 days (Jan 1-4, 2026).
        // Grid: Dec 1 → Jan 4 (35 days, 5 rows).
        final focusedDay = tz.TZDateTime(location, 2025, 12, 15);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendarBase(
              firstDay: tz.TZDateTime(location, 2025),
              lastDay: tz.TZDateTime(location, 2026, 12, 31),
              focusedDay: focusedDay,
              timeZone: location,
              startingDayOfWeek: StartingDayOfWeek.monday,
              dowVisible: false,
              rowHeight: 52,
              dayBuilder: (context, day, focusedDay) {
                return Text('${day.day}', key: dateToKey(day));
              },
            ),
          ),
        );

        final firstVisibleDay = tz.TZDateTime(location, 2025, 12);
        final lastVisibleDay = tz.TZDateTime(location, 2026, 1, 4);

        expect(find.byKey(dateToKey(firstVisibleDay)), findsOneWidget);
        expect(find.byKey(dateToKey(lastVisibleDay)), findsOneWidget);

        final beforeFirst = tz.TZDateTime(location, 2025, 11, 30);
        expect(find.byKey(dateToKey(beforeFirst)), findsNothing);

        final afterLast = tz.TZDateTime(location, 2026, 1, 5);
        expect(find.byKey(dateToKey(afterLast)), findsNothing);
      },
    );

    testWidgets(
      'all days in timezone grid are TZDateTime with correct location',
      (tester) async {
        final location = tz.getLocation('America/Chicago');
        final capturedDays = <DateTime>[];

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendarBase(
              firstDay: tz.TZDateTime(location, 2026),
              lastDay: tz.TZDateTime(location, 2026, 12, 31),
              focusedDay: tz.TZDateTime(location, 2026, 4, 15),
              timeZone: location,
              dowVisible: false,
              rowHeight: 52,
              dayBuilder: (context, day, focusedDay) {
                capturedDays.add(day);
                return Text('${day.day}', key: dateToKey(day));
              },
            ),
          ),
        );

        expect(capturedDays, isNotEmpty);
        for (final day in capturedDays) {
          expect(day, isA<tz.TZDateTime>());
          expect((day as tz.TZDateTime).location, location);
          expect(day.hour, 0);
          expect(day.minute, 0);
          expect(day.second, 0);
        }
      },
    );

    testWidgets(
      'consecutive days in grid have exactly 1 day between them',
      (tester) async {
        final location = tz.getLocation('Europe/Berlin');
        final capturedDays = <DateTime>[];

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendarBase(
              firstDay: tz.TZDateTime(location, 2026),
              lastDay: tz.TZDateTime(location, 2026, 12, 31),
              focusedDay: tz.TZDateTime(location, 2026, 4, 15),
              timeZone: location,
              dowVisible: false,
              rowHeight: 52,
              dayBuilder: (context, day, focusedDay) {
                capturedDays.add(day);
                return Text('${day.day}', key: dateToKey(day));
              },
            ),
          ),
        );

        for (int i = 1; i < capturedDays.length; i++) {
          final prev = capturedDays[i - 1];
          final curr = capturedDays[i];
          final diffDays = DateTime.utc(curr.year, curr.month, curr.day)
              .difference(DateTime.utc(prev.year, prev.month, prev.day))
              .inDays;
          expect(
            diffDays,
            1,
            reason: 'Day $i (${curr.year}-${curr.month}-${curr.day}) should '
                'be 1 day after day ${i - 1} '
                '(${prev.year}-${prev.month}-${prev.day})',
          );
        }
      },
    );

    testWidgets(
      'cross-timezone: focusedDay from ahead-TZ preserves month in behind-TZ grid',
      (tester) async {
        // focusedDay created in Singapore (UTC+8), but calendar uses Berlin (UTC+1).
        // March 1 00:00 SGT = Feb 28 16:00 UTC. Old code would compute
        // _firstDayOfMonth as February's first day instead of March's.
        final singapore = tz.getLocation('Asia/Singapore');
        final berlin = tz.getLocation('Europe/Berlin');

        final focusedDay = tz.TZDateTime(singapore, 2027, 3, 15);
        final capturedDays = <DateTime>[];

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendarBase(
              firstDay: tz.TZDateTime(berlin, 2027),
              lastDay: tz.TZDateTime(berlin, 2027, 12, 31),
              focusedDay: focusedDay,
              timeZone: berlin,
              dowVisible: false,
              rowHeight: 52,
              dayBuilder: (context, day, focusedDay) {
                capturedDays.add(day);
                return Text('${day.day}', key: dateToKey(day));
              },
            ),
          ),
        );

        // March 1 2027 is Monday. Sunday start → 1 leading day (Feb 28).
        // March 31 is Wednesday → 3 trailing days (Apr 1-3).
        // Grid: Feb 28 → Apr 3 (35 days, 5 rows).
        expect(capturedDays, isNotEmpty);

        final march1 = tz.TZDateTime(berlin, 2027, 3);
        final march31 = tz.TZDateTime(berlin, 2027, 3, 31);
        expect(find.byKey(dateToKey(march1)), findsOneWidget);
        expect(find.byKey(dateToKey(march31)), findsOneWidget);

        // Verify all captured days are consecutive
        for (int i = 1; i < capturedDays.length; i++) {
          final prev = capturedDays[i - 1];
          final curr = capturedDays[i];
          final diffDays = DateTime.utc(curr.year, curr.month, curr.day)
              .difference(DateTime.utc(prev.year, prev.month, prev.day))
              .inDays;
          expect(diffDays, 1);
        }
      },
    );

    testWidgets(
      'cross-timezone: Jan 1 from Tokyo targeted to New York shows January grid',
      (tester) async {
        // Jan 1 00:00 JST = Dec 31 10:00 EST via epoch.
        // Old code: _firstDayOfMonth would compute December boundaries.
        final tokyo = tz.getLocation('Asia/Tokyo');
        final newYork = tz.getLocation('America/New_York');

        final focusedDay = tz.TZDateTime(tokyo, 2027, 1, 15);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendarBase(
              firstDay: tz.TZDateTime(newYork, 2026, 10),
              lastDay: tz.TZDateTime(newYork, 2027, 6, 30),
              focusedDay: focusedDay,
              timeZone: newYork,
              dowVisible: false,
              rowHeight: 52,
              dayBuilder: (context, day, focusedDay) {
                return Text('${day.day}', key: dateToKey(day));
              },
            ),
          ),
        );

        final jan1 = tz.TZDateTime(newYork, 2027);
        final jan31 = tz.TZDateTime(newYork, 2027, 1, 31);
        expect(find.byKey(dateToKey(jan1)), findsOneWidget);
        expect(find.byKey(dateToKey(jan31)), findsOneWidget);
      },
    );

    testWidgets(
      'cross-timezone: month boundary dates are correct when source TZ is far behind target',
      (tester) async {
        // Device in Honolulu (UTC-10), app in Tokyo (UTC+9). 19-hour difference.
        // March 31 midnight HST = April 1 05:00 UTC = April 1 14:00 JST via epoch.
        // Old _lastDayOfMonth would compute April's last day instead of March's.
        final honolulu = tz.getLocation('Pacific/Honolulu');
        final tokyo = tz.getLocation('Asia/Tokyo');

        final focusedDay = tz.TZDateTime(honolulu, 2027, 3, 15);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendarBase(
              firstDay: tz.TZDateTime(tokyo, 2027),
              lastDay: tz.TZDateTime(tokyo, 2027, 12, 31),
              focusedDay: focusedDay,
              timeZone: tokyo,
              dowVisible: false,
              rowHeight: 52,
              dayBuilder: (context, day, focusedDay) {
                return Text('${day.day}', key: dateToKey(day));
              },
            ),
          ),
        );

        final march1 = tz.TZDateTime(tokyo, 2027, 3);
        final march31 = tz.TZDateTime(tokyo, 2027, 3, 31);
        expect(find.byKey(dateToKey(march1)), findsOneWidget);
        expect(find.byKey(dateToKey(march31)), findsOneWidget);
      },
    );
  });

  testWidgets(
    'Callbacks return expected values',
    (tester) async {
      DateTime focusedDay = DateTime.utc(2021, 7, 15);
      final nextMonth = focusedDay.add(const Duration(days: 31)).month;

      bool calendarCreatedFlag = false;
      SwipeDirection? verticalSwipeDirection;

      await tester.pumpWidget(
        setupTestWidget(
          TableCalendarBase(
            firstDay: DateTime.utc(2021, 5, 15),
            lastDay: DateTime.utc(2021, 8, 18),
            focusedDay: focusedDay,
            dayBuilder: (context, day, focusedDay) {
              return Text(
                '${day.day}',
                key: dateToKey(day),
              );
            },
            onCalendarCreated: (pageController) {
              calendarCreatedFlag = true;
            },
            onPageChanged: (focusedDay2) {
              focusedDay = focusedDay2;
            },
            onVerticalSwipe: (direction) {
              verticalSwipeDirection = direction;
            },
            rowHeight: 52,
            dowVisible: false,
          ),
        ),
      );

      expect(calendarCreatedFlag, true);

      // Swipe left
      await tester.drag(
        find.byKey(dateToKey(focusedDay)),
        const Offset(-500, 0),
      );
      await tester.pumpAndSettle();
      expect(focusedDay.month, nextMonth);

      // Swipe up
      await tester.drag(
        find.byKey(dateToKey(focusedDay)),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();
      expect(verticalSwipeDirection, SwipeDirection.up);
    },
  );

  testWidgets(
    'Throw AssertionError when TableCalendarBase is built with dowVisible and dowBuilder, but dowHeight is absent',
    (tester) async {
      expect(
        () async {
          await tester.pumpWidget(
            setupTestWidget(
              TableCalendarBase(
                firstDay: DateTime.utc(2021, 5, 15),
                lastDay: DateTime.utc(2021, 8, 18),
                focusedDay: DateTime.utc(2021, 7, 15),
                dayBuilder: (context, day, focusedDay) {
                  return Text(
                    '${day.day}',
                    key: dateToKey(day),
                  );
                },
                rowHeight: 52,
                dowBuilder: (context, day) {
                  return Text('${day.weekday}');
                },
              ),
            ),
          );
        },
        throwsAssertionError,
      );
    },
  );
}
