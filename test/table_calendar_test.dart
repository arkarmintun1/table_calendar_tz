// Copyright 2026 Arkar Min Tun
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart' as intl;
import 'package:table_calendar_tz/src/widgets/calendar_header.dart';
import 'package:table_calendar_tz/src/widgets/cell_content.dart';
import 'package:table_calendar_tz/src/widgets/custom_icon_button.dart';
import 'package:table_calendar_tz/table_calendar_tz.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'common.dart';

final initialFocusedDay = DateTime.utc(2021, 7, 15);
final today = initialFocusedDay;
final firstDay = DateTime.utc(2021, 5, 15);
final lastDay = DateTime.utc(2021, 9, 18);

Widget setupTestWidget(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: Material(child: child),
  );
}

Widget createTableCalendar({
  DateTime? focusedDay,
  CalendarFormat calendarFormat = CalendarFormat.month,
  Function(DateTime)? onPageChanged,
  bool sixWeekMonthsEnforced = false,
}) {
  return setupTestWidget(
    TableCalendar(
      focusedDay: focusedDay ?? initialFocusedDay,
      firstDay: firstDay,
      lastDay: lastDay,
      currentDay: today,
      calendarFormat: calendarFormat,
      onPageChanged: onPageChanged,
      sixWeekMonthsEnforced: sixWeekMonthsEnforced,
    ),
  );
}

ValueKey<String> cellContentKey(DateTime date) {
  return dateToKey(date, prefix: 'CellContent-');
}

void main() {
  group('TableCalendar correctly displays:', () {
    testWidgets(
      'visible day cells for given focusedDay',
      (tester) async {
        await tester.pumpWidget(createTableCalendar());

        final firstVisibleDay = DateTime.utc(2021, 6, 27);
        final lastVisibleDay = DateTime.utc(2021, 7, 31);

        final focusedDayKey = cellContentKey(initialFocusedDay);
        final firstVisibleDayKey = cellContentKey(firstVisibleDay);
        final lastVisibleDayKey = cellContentKey(lastVisibleDay);

        final startOOBKey =
            cellContentKey(firstVisibleDay.subtract(const Duration(days: 1)));
        final endOOBKey =
            cellContentKey(lastVisibleDay.add(const Duration(days: 1)));

        expect(find.byKey(focusedDayKey), findsOneWidget);
        expect(find.byKey(firstVisibleDayKey), findsOneWidget);
        expect(find.byKey(lastVisibleDayKey), findsOneWidget);

        expect(find.byKey(startOOBKey), findsNothing);
        expect(find.byKey(endOOBKey), findsNothing);
      },
    );

    testWidgets(
      'visible day cells after swipe right when in week format',
      (tester) async {
        DateTime? updatedFocusedDay;

        await tester.pumpWidget(
          createTableCalendar(
            calendarFormat: CalendarFormat.week,
            onPageChanged: (focusedDay) {
              updatedFocusedDay = focusedDay;
            },
          ),
        );

        await tester.drag(
          find.byType(CellContent).first,
          const Offset(500, 0),
        );
        await tester.pumpAndSettle();

        expect(updatedFocusedDay, isNotNull);

        final firstVisibleDay = DateTime.utc(2021, 7, 4);
        final lastVisibleDay = DateTime.utc(2021, 7, 10);

        final focusedDayKey = cellContentKey(updatedFocusedDay!);
        final firstVisibleDayKey = cellContentKey(firstVisibleDay);
        final lastVisibleDayKey = cellContentKey(lastVisibleDay);

        final startOOBKey =
            cellContentKey(firstVisibleDay.subtract(const Duration(days: 1)));
        final endOOBKey =
            cellContentKey(lastVisibleDay.add(const Duration(days: 1)));

        expect(find.byKey(focusedDayKey), findsOneWidget);
        expect(find.byKey(firstVisibleDayKey), findsOneWidget);
        expect(find.byKey(lastVisibleDayKey), findsOneWidget);

        expect(find.byKey(startOOBKey), findsNothing);
        expect(find.byKey(endOOBKey), findsNothing);
      },
    );

    testWidgets(
      'visible day cells after swipe left when in week format',
      (tester) async {
        DateTime? updatedFocusedDay;

        await tester.pumpWidget(
          createTableCalendar(
            calendarFormat: CalendarFormat.week,
            onPageChanged: (focusedDay) {
              updatedFocusedDay = focusedDay;
            },
          ),
        );

        await tester.drag(
          find.byType(CellContent).first,
          const Offset(-500, 0),
        );
        await tester.pumpAndSettle();

        expect(updatedFocusedDay, isNotNull);

        final firstVisibleDay = DateTime.utc(2021, 7, 18);
        final lastVisibleDay = DateTime.utc(2021, 7, 24);

        final focusedDayKey = cellContentKey(updatedFocusedDay!);
        final firstVisibleDayKey = cellContentKey(firstVisibleDay);
        final lastVisibleDayKey = cellContentKey(lastVisibleDay);

        final startOOBKey =
            cellContentKey(firstVisibleDay.subtract(const Duration(days: 1)));
        final endOOBKey =
            cellContentKey(lastVisibleDay.add(const Duration(days: 1)));

        expect(find.byKey(focusedDayKey), findsOneWidget);
        expect(find.byKey(firstVisibleDayKey), findsOneWidget);
        expect(find.byKey(lastVisibleDayKey), findsOneWidget);

        expect(find.byKey(startOOBKey), findsNothing);
        expect(find.byKey(endOOBKey), findsNothing);
      },
    );

    testWidgets(
      'visible day cells after swipe right when in two weeks format',
      (tester) async {
        DateTime? updatedFocusedDay;

        await tester.pumpWidget(
          createTableCalendar(
            calendarFormat: CalendarFormat.twoWeeks,
            onPageChanged: (focusedDay) {
              updatedFocusedDay = focusedDay;
            },
          ),
        );

        await tester.drag(
          find.byType(CellContent).first,
          const Offset(500, 0),
        );
        await tester.pumpAndSettle();

        expect(updatedFocusedDay, isNotNull);

        final firstVisibleDay = DateTime.utc(2021, 6, 20);
        final lastVisibleDay = DateTime.utc(2021, 7, 3);

        final focusedDayKey = cellContentKey(updatedFocusedDay!);
        final firstVisibleDayKey = cellContentKey(firstVisibleDay);
        final lastVisibleDayKey = cellContentKey(lastVisibleDay);

        final startOOBKey =
            cellContentKey(firstVisibleDay.subtract(const Duration(days: 1)));
        final endOOBKey =
            cellContentKey(lastVisibleDay.add(const Duration(days: 1)));

        expect(find.byKey(focusedDayKey), findsOneWidget);
        expect(find.byKey(firstVisibleDayKey), findsOneWidget);
        expect(find.byKey(lastVisibleDayKey), findsOneWidget);

        expect(find.byKey(startOOBKey), findsNothing);
        expect(find.byKey(endOOBKey), findsNothing);
      },
    );

    testWidgets(
      'visible day cells after swipe left when in two weeks format',
      (tester) async {
        DateTime? updatedFocusedDay;

        await tester.pumpWidget(
          createTableCalendar(
            calendarFormat: CalendarFormat.twoWeeks,
            onPageChanged: (focusedDay) {
              updatedFocusedDay = focusedDay;
            },
          ),
        );

        await tester.drag(
          find.byType(CellContent).first,
          const Offset(-500, 0),
        );
        await tester.pumpAndSettle();

        expect(updatedFocusedDay, isNotNull);

        final firstVisibleDay = DateTime.utc(2021, 7, 18);
        final lastVisibleDay = DateTime.utc(2021, 7, 31);

        final focusedDayKey = cellContentKey(updatedFocusedDay!);
        final firstVisibleDayKey = cellContentKey(firstVisibleDay);
        final lastVisibleDayKey = cellContentKey(lastVisibleDay);

        final startOOBKey =
            cellContentKey(firstVisibleDay.subtract(const Duration(days: 1)));
        final endOOBKey =
            cellContentKey(lastVisibleDay.add(const Duration(days: 1)));

        expect(find.byKey(focusedDayKey), findsOneWidget);
        expect(find.byKey(firstVisibleDayKey), findsOneWidget);
        expect(find.byKey(lastVisibleDayKey), findsOneWidget);

        expect(find.byKey(startOOBKey), findsNothing);
        expect(find.byKey(endOOBKey), findsNothing);
      },
    );

    testWidgets(
      '7 day cells in week format',
      (tester) async {
        await tester.pumpWidget(
          createTableCalendar(
            calendarFormat: CalendarFormat.week,
          ),
        );

        final dayCells = tester.widgetList(find.byType(CellContent));
        expect(dayCells.length, 7);
      },
    );

    testWidgets(
      '14 day cells in two weeks format',
      (tester) async {
        await tester.pumpWidget(
          createTableCalendar(
            calendarFormat: CalendarFormat.twoWeeks,
          ),
        );

        final dayCells = tester.widgetList(find.byType(CellContent));
        expect(dayCells.length, 14);
      },
    );

    testWidgets(
      '35 day cells in month format for July 2021',
      (tester) async {
        await tester.pumpWidget(
          createTableCalendar(),
        );

        final dayCells = tester.widgetList(find.byType(CellContent));
        expect(dayCells.length, 35);
      },
    );

    testWidgets(
      '42 day cells in month format for July 2021, when sixWeekMonthsEnforced is set to true',
      (tester) async {
        await tester.pumpWidget(
          createTableCalendar(
            sixWeekMonthsEnforced: true,
          ),
        );

        final dayCells = tester.widgetList(find.byType(CellContent));
        expect(dayCells.length, 42);
      },
    );

    testWidgets(
      'CalendarHeader with updated month and year when focusedDay is changed',
      (tester) async {
        await tester.pumpWidget(createTableCalendar());

        String headerText = intl.DateFormat.yMMMM().format(initialFocusedDay);
        expect(find.byType(CalendarHeader), findsOneWidget);
        expect(find.text(headerText), findsOneWidget);

        final updatedFocusedDay = DateTime.utc(2021, 8, 4);

        await tester.pumpWidget(
          createTableCalendar(focusedDay: updatedFocusedDay),
        );

        headerText = intl.DateFormat.yMMMM().format(updatedFocusedDay);
        expect(find.byType(CalendarHeader), findsOneWidget);
        expect(find.text(headerText), findsOneWidget);
      },
    );

    testWidgets(
      'CalendarHeader with updated month and year when TableCalendar is swiped left',
      (tester) async {
        DateTime? updatedFocusedDay;

        await tester.pumpWidget(
          createTableCalendar(
            onPageChanged: (focusedDay) {
              updatedFocusedDay = focusedDay;
            },
          ),
        );

        String headerText = intl.DateFormat.yMMMM().format(initialFocusedDay);
        expect(find.byType(CalendarHeader), findsOneWidget);
        expect(find.text(headerText), findsOneWidget);

        await tester.drag(
          find.byType(CellContent).first,
          const Offset(-500, 0),
        );
        await tester.pumpAndSettle();

        expect(updatedFocusedDay, isNotNull);
        expect(updatedFocusedDay!.month, initialFocusedDay.month + 1);

        headerText = intl.DateFormat.yMMMM().format(updatedFocusedDay!);
        expect(find.byType(CalendarHeader), findsOneWidget);
        expect(find.text(headerText), findsOneWidget);

        updatedFocusedDay = null;

        await tester.drag(
          find.byType(CellContent).first,
          const Offset(-500, 0),
        );
        await tester.pumpAndSettle();

        expect(updatedFocusedDay, isNotNull);
        expect(updatedFocusedDay!.month, initialFocusedDay.month + 2);

        headerText = intl.DateFormat.yMMMM().format(updatedFocusedDay!);
        expect(find.byType(CalendarHeader), findsOneWidget);
        expect(find.text(headerText), findsOneWidget);
      },
    );

    testWidgets(
      'CalendarHeader with updated month and year when TableCalendar is swiped right',
      (tester) async {
        DateTime? updatedFocusedDay;

        await tester.pumpWidget(
          createTableCalendar(
            onPageChanged: (focusedDay) {
              updatedFocusedDay = focusedDay;
            },
          ),
        );

        String headerText = intl.DateFormat.yMMMM().format(initialFocusedDay);
        expect(find.byType(CalendarHeader), findsOneWidget);
        expect(find.text(headerText), findsOneWidget);

        await tester.drag(
          find.byType(CellContent).first,
          const Offset(500, 0),
        );
        await tester.pumpAndSettle();

        expect(updatedFocusedDay, isNotNull);
        expect(updatedFocusedDay!.month, initialFocusedDay.month - 1);

        headerText = intl.DateFormat.yMMMM().format(updatedFocusedDay!);
        expect(find.byType(CalendarHeader), findsOneWidget);
        expect(find.text(headerText), findsOneWidget);

        updatedFocusedDay = null;

        await tester.drag(
          find.byType(CellContent).first,
          const Offset(500, 0),
        );
        await tester.pumpAndSettle();

        expect(updatedFocusedDay, isNotNull);
        expect(updatedFocusedDay!.month, initialFocusedDay.month - 2);

        headerText = intl.DateFormat.yMMMM().format(updatedFocusedDay!);
        expect(find.byType(CalendarHeader), findsOneWidget);
        expect(find.text(headerText), findsOneWidget);
      },
    );

    testWidgets(
      '3 event markers are visible when 3 events are assigned to a given day',
      (tester) async {
        final eventDay = DateTime.utc(2021, 7, 20);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              eventLoader: (day) {
                if (day.day == eventDay.day && day.month == eventDay.month) {
                  return ['Event 1', 'Event 2', 'Event 3'];
                }

                return [];
              },
            ),
          ),
        );

        final eventDayKey = cellContentKey(eventDay);
        final eventDayCellContent = find.byKey(eventDayKey);

        final eventDayStack = find.ancestor(
          of: eventDayCellContent,
          matching: find.byType(Stack),
        );

        final eventMarkers = tester.widgetList(
          find.descendant(
            of: eventDayStack,
            matching: find.byWidgetPredicate(
              (Widget marker) => marker is Container && marker.child == null,
            ),
          ),
        );

        expect(eventMarkers.length, 3);
      },
    );

    testWidgets(
      'Event loader is called for disabled days when loadEventForDisabledDays is set to true',
      (tester) async {
        final eventDay = DateTime.utc(2021, 7, 20);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: initialFocusedDay,
              loadEventsForDisabledDays: true,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              eventLoader: (day) {
                if (day.day == eventDay.day && day.month == eventDay.month) {
                  return ['Event 1', 'Event 2', 'Event 3'];
                }

                return [];
              },
              enabledDayPredicate: (day) => false,
            ),
          ),
        );

        final eventDayKey = cellContentKey(eventDay);
        final eventDayCellContent = find.byKey(eventDayKey);

        final eventDayStack = find.ancestor(
          of: eventDayCellContent,
          matching: find.byType(Stack),
        );

        final eventMarkers = tester.widgetList(
          find.descendant(
            of: eventDayStack,
            matching: find.byWidgetPredicate(
              (Widget marker) => marker is Container && marker.child == null,
            ),
          ),
        );

        expect(eventMarkers.length, 3);
      },
    );

    testWidgets(
      'currentDay correctly marks given day as today',
      (tester) async {
        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
            ),
          ),
        );

        final currentDayKey = cellContentKey(today);
        final currentDayCellContent =
            tester.widget(find.byKey(currentDayKey)) as CellContent;

        expect(currentDayCellContent.isToday, true);
      },
    );

    testWidgets(
      'if currentDay is absent, DateTime.now() is marked as today',
      (tester) async {
        final now = DateTime.now();
        final firstDay = DateTime.utc(now.year, now.month - 3, now.day);
        final lastDay = DateTime.utc(now.year, now.month + 3, now.day);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: now,
              firstDay: firstDay,
              lastDay: lastDay,
            ),
          ),
        );

        final currentDayKey = cellContentKey(now);
        final currentDayCellContent =
            tester.widget(find.byKey(currentDayKey)) as CellContent;

        expect(currentDayCellContent.isToday, true);
      },
    );

    testWidgets(
      'selectedDayPredicate correctly marks given day as selected',
      (tester) async {
        final selectedDay = DateTime.utc(2021, 7, 20);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              selectedDayPredicate: (day) {
                return isSameDay(day, selectedDay);
              },
            ),
          ),
        );

        final selectedDayKey = cellContentKey(selectedDay);
        final selectedDayCellContent =
            tester.widget(find.byKey(selectedDayKey)) as CellContent;

        expect(selectedDayCellContent.isSelected, true);
      },
    );

    testWidgets(
      'holidayPredicate correctly marks given day as holiday',
      (tester) async {
        final holiday = DateTime.utc(2021, 7, 20);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              holidayPredicate: (day) {
                return isSameDay(day, holiday);
              },
            ),
          ),
        );

        final holidayKey = cellContentKey(holiday);
        final holidayCellContent =
            tester.widget(find.byKey(holidayKey)) as CellContent;

        expect(holidayCellContent.isHoliday, true);
      },
    );
  });

  group('CalendarHeader chevrons test:', () {
    testWidgets(
      'tapping on a left chevron navigates to previous calendar page',
      (tester) async {
        await tester.pumpWidget(createTableCalendar());

        expect(find.text('July 2021'), findsOneWidget);

        final leftChevron = find.widgetWithIcon(
          CustomIconButton,
          Icons.chevron_left,
        );

        await tester.tap(leftChevron);
        await tester.pumpAndSettle();

        expect(find.text('June 2021'), findsOneWidget);
      },
    );

    testWidgets(
      'tapping on a right chevron navigates to next calendar page',
      (tester) async {
        await tester.pumpWidget(createTableCalendar());

        expect(find.text('July 2021'), findsOneWidget);

        final rightChevron = find.widgetWithIcon(
          CustomIconButton,
          Icons.chevron_right,
        );

        await tester.tap(rightChevron);
        await tester.pumpAndSettle();

        expect(find.text('August 2021'), findsOneWidget);
      },
    );
  });

  group('Scrolling boundaries are set up properly:', () {
    testWidgets('starting scroll boundary works correctly', (tester) async {
      final focusedDay = DateTime.utc(2021, 6, 15);

      await tester.pumpWidget(createTableCalendar(focusedDay: focusedDay));

      expect(find.byType(TableCalendar), findsOneWidget);
      expect(find.text('June 2021'), findsOneWidget);

      await tester.drag(find.byType(CellContent).first, const Offset(500, 0));
      await tester.pumpAndSettle();
      expect(find.text('May 2021'), findsOneWidget);

      await tester.drag(find.byType(CellContent).first, const Offset(500, 0));
      await tester.pumpAndSettle();
      expect(find.text('May 2021'), findsOneWidget);
    });

    testWidgets('ending scroll boundary works correctly', (tester) async {
      final focusedDay = DateTime.utc(2021, 8, 15);

      await tester.pumpWidget(createTableCalendar(focusedDay: focusedDay));

      expect(find.byType(TableCalendar), findsOneWidget);
      expect(find.text('August 2021'), findsOneWidget);

      await tester.drag(find.byType(CellContent).first, const Offset(-500, 0));
      await tester.pumpAndSettle();
      expect(find.text('September 2021'), findsOneWidget);

      await tester.drag(find.byType(CellContent).first, const Offset(-500, 0));
      await tester.pumpAndSettle();
      expect(find.text('September 2021'), findsOneWidget);
    });
  });

  group('onFormatChanged callback returns correct values:', () {
    testWidgets('when initial format is month', (tester) async {
      CalendarFormat calendarFormat = CalendarFormat.month;

      await tester.pumpWidget(
        setupTestWidget(
          TableCalendar(
            focusedDay: today,
            firstDay: firstDay,
            lastDay: lastDay,
            currentDay: today,
            calendarFormat: calendarFormat,
            onFormatChanged: (format) {
              calendarFormat = format;
            },
          ),
        ),
      );

      await tester.drag(find.byType(CellContent).first, const Offset(0, -500));
      await tester.pumpAndSettle();
      expect(calendarFormat, CalendarFormat.twoWeeks);

      await tester.drag(find.byType(CellContent).first, const Offset(0, 500));
      await tester.pumpAndSettle();
      expect(calendarFormat, CalendarFormat.month);
    });

    testWidgets('when initial format is two weeks', (tester) async {
      CalendarFormat calendarFormat = CalendarFormat.twoWeeks;

      await tester.pumpWidget(
        setupTestWidget(
          TableCalendar(
            focusedDay: today,
            firstDay: firstDay,
            lastDay: lastDay,
            currentDay: today,
            calendarFormat: calendarFormat,
            onFormatChanged: (format) {
              calendarFormat = format;
            },
          ),
        ),
      );

      await tester.drag(find.byType(CellContent).first, const Offset(0, -500));
      await tester.pumpAndSettle();
      expect(calendarFormat, CalendarFormat.week);

      await tester.drag(find.byType(CellContent).first, const Offset(0, 500));
      await tester.pumpAndSettle();
      expect(calendarFormat, CalendarFormat.month);
    });

    testWidgets('when initial format is week', (tester) async {
      CalendarFormat calendarFormat = CalendarFormat.week;

      await tester.pumpWidget(
        setupTestWidget(
          TableCalendar(
            focusedDay: today,
            firstDay: firstDay,
            lastDay: lastDay,
            currentDay: today,
            calendarFormat: calendarFormat,
            onFormatChanged: (format) {
              calendarFormat = format;
            },
          ),
        ),
      );

      await tester.drag(find.byType(CellContent).first, const Offset(0, -500));
      await tester.pumpAndSettle();
      expect(calendarFormat, CalendarFormat.week);

      await tester.drag(find.byType(CellContent).first, const Offset(0, 500));
      await tester.pumpAndSettle();
      expect(calendarFormat, CalendarFormat.twoWeeks);
    });
  });

  group('onDaySelected callback test:', () {
    testWidgets(
      'selects correct day when tapped',
      (tester) async {
        DateTime? selectedDay;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              onDaySelected: (selected, focused) {
                selectedDay = selected;
              },
            ),
          ),
        );

        expect(selectedDay, isNull);

        final tappedDay = DateTime.utc(2021, 7, 18);
        final tappedDayKey = cellContentKey(tappedDay);

        await tester.tap(find.byKey(tappedDayKey));
        await tester.pumpAndSettle();
        expect(selectedDay, tappedDay);
      },
    );

    testWidgets(
      'focuses correct day when tapped',
      (tester) async {
        DateTime? focusedDay;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              onDaySelected: (selected, focused) {
                focusedDay = focused;
              },
            ),
          ),
        );

        expect(focusedDay, isNull);

        final tappedDay = DateTime.utc(2021, 7, 18);
        final tappedDayKey = cellContentKey(tappedDay);

        await tester.tap(find.byKey(tappedDayKey));
        await tester.pumpAndSettle();
        expect(focusedDay, tappedDay);
      },
    );

    testWidgets(
      'properly selects and focuses on outside cell tap - previous month (when in month format)',
      (tester) async {
        DateTime? selectedDay;
        DateTime? focusedDay;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              onDaySelected: (selected, focused) {
                selectedDay = selected;
                focusedDay = focused;
              },
            ),
          ),
        );

        expect(selectedDay, isNull);
        expect(focusedDay, isNull);

        final tappedDay = DateTime.utc(2021, 6, 30);
        final tappedDayKey = cellContentKey(tappedDay);

        final expectedFocusedDay = DateTime.utc(2021, 7);

        await tester.tap(find.byKey(tappedDayKey));
        await tester.pumpAndSettle();
        expect(selectedDay, tappedDay);
        expect(focusedDay, expectedFocusedDay);
      },
    );

    testWidgets(
      'properly selects and focuses on outside cell tap - next month (when in month format)',
      (tester) async {
        DateTime? selectedDay;
        DateTime? focusedDay;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: DateTime.utc(2021, 8, 16),
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: DateTime.utc(2021, 8, 16),
              onDaySelected: (selected, focused) {
                selectedDay = selected;
                focusedDay = focused;
              },
            ),
          ),
        );

        expect(selectedDay, isNull);
        expect(focusedDay, isNull);

        final tappedDay = DateTime.utc(2021, 9);
        final tappedDayKey = cellContentKey(tappedDay);

        final expectedFocusedDay = DateTime.utc(2021, 8, 31);

        await tester.tap(find.byKey(tappedDayKey));
        await tester.pumpAndSettle();
        expect(selectedDay, tappedDay);
        expect(focusedDay, expectedFocusedDay);
      },
    );
  });

  group('onDayLongPressed callback test:', () {
    testWidgets(
      'selects correct day when long pressed',
      (tester) async {
        DateTime? selectedDay;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              onDayLongPressed: (selected, focused) {
                selectedDay = selected;
              },
            ),
          ),
        );

        expect(selectedDay, isNull);

        final longPressedDay = DateTime.utc(2021, 7, 18);
        final longPressedDayKey = cellContentKey(longPressedDay);

        await tester.longPress(find.byKey(longPressedDayKey));
        await tester.pumpAndSettle();
        expect(selectedDay, longPressedDay);
      },
    );

    testWidgets(
      'focuses correct day when long pressed',
      (tester) async {
        DateTime? focusedDay;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              onDayLongPressed: (selected, focused) {
                focusedDay = focused;
              },
            ),
          ),
        );

        expect(focusedDay, isNull);

        final longPressedDay = DateTime.utc(2021, 7, 18);
        final longPressedDayKey = cellContentKey(longPressedDay);

        await tester.longPress(find.byKey(longPressedDayKey));
        await tester.pumpAndSettle();
        expect(focusedDay, longPressedDay);
      },
    );

    testWidgets(
      'properly selects and focuses on outside cell long press - previous month (when in month format)',
      (tester) async {
        DateTime? selectedDay;
        DateTime? focusedDay;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              onDayLongPressed: (selected, focused) {
                selectedDay = selected;
                focusedDay = focused;
              },
            ),
          ),
        );

        expect(selectedDay, isNull);
        expect(focusedDay, isNull);

        final longPressedDay = DateTime.utc(2021, 6, 30);
        final longPressedDayKey = cellContentKey(longPressedDay);

        final expectedFocusedDay = DateTime.utc(2021, 7);

        await tester.longPress(find.byKey(longPressedDayKey));
        await tester.pumpAndSettle();
        expect(selectedDay, longPressedDay);
        expect(focusedDay, expectedFocusedDay);
      },
    );

    testWidgets(
      'properly selects and focuses on outside cell long press - next month (when in month format)',
      (tester) async {
        DateTime? selectedDay;
        DateTime? focusedDay;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: DateTime.utc(2021, 8, 16),
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: DateTime.utc(2021, 8, 16),
              onDayLongPressed: (selected, focused) {
                selectedDay = selected;
                focusedDay = focused;
              },
            ),
          ),
        );

        expect(selectedDay, isNull);
        expect(focusedDay, isNull);

        final longPressedDay = DateTime.utc(2021, 9);
        final longPressedDayKey = cellContentKey(longPressedDay);

        final expectedFocusedDay = DateTime.utc(2021, 8, 31);

        await tester.longPress(find.byKey(longPressedDayKey));
        await tester.pumpAndSettle();
        expect(selectedDay, longPressedDay);
        expect(focusedDay, expectedFocusedDay);
      },
    );
  });

  group('onRangeSelection callback test:', () {
    testWidgets(
      'proper values are returned when second tapped day is after the first one',
      (tester) async {
        DateTime? rangeStart;
        DateTime? rangeEnd;
        DateTime? focusedDay;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              rangeSelectionMode: RangeSelectionMode.enforced,
              onRangeSelected: (start, end, focused) {
                rangeStart = start;
                rangeEnd = end;
                focusedDay = focused;
              },
            ),
          ),
        );

        expect(rangeStart, isNull);
        expect(rangeEnd, isNull);
        expect(focusedDay, isNull);

        final firstTappedDay = DateTime.utc(2021, 7, 8);
        final secondTappedDay = DateTime.utc(2021, 7, 21);

        final firstTappedDayKey = cellContentKey(firstTappedDay);
        final secondTappedDayKey = cellContentKey(secondTappedDay);

        final expectedFocusedDay = secondTappedDay;

        await tester.tap(find.byKey(firstTappedDayKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(secondTappedDayKey));
        await tester.pumpAndSettle();
        expect(rangeStart, firstTappedDay);
        expect(rangeEnd, secondTappedDay);
        expect(focusedDay, expectedFocusedDay);
      },
    );

    testWidgets(
      'proper values are returned when second tapped day is before the first one',
      (tester) async {
        DateTime? rangeStart;
        DateTime? rangeEnd;
        DateTime? focusedDay;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              rangeSelectionMode: RangeSelectionMode.enforced,
              onRangeSelected: (start, end, focused) {
                rangeStart = start;
                rangeEnd = end;
                focusedDay = focused;
              },
            ),
          ),
        );

        expect(rangeStart, isNull);
        expect(rangeEnd, isNull);
        expect(focusedDay, isNull);

        final firstTappedDay = DateTime.utc(2021, 7, 14);
        final secondTappedDay = DateTime.utc(2021, 7, 7);

        final firstTappedDayKey = cellContentKey(firstTappedDay);
        final secondTappedDayKey = cellContentKey(secondTappedDay);

        final expectedFocusedDay = secondTappedDay;

        await tester.tap(find.byKey(firstTappedDayKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(secondTappedDayKey));
        await tester.pumpAndSettle();
        expect(rangeStart, secondTappedDay);
        expect(rangeEnd, firstTappedDay);
        expect(focusedDay, expectedFocusedDay);
      },
    );

    testWidgets(
      'long press toggles rangeSelectionMode when onDayLongPress callback is null - initial mode is toggledOff',
      (tester) async {
        DateTime? rangeStart;
        DateTime? rangeEnd;
        DateTime? focusedDay;
        DateTime? selectedDay;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              onDaySelected: (selected, focused) {
                selectedDay = selected;
                focusedDay = focused;
              },
              onRangeSelected: (start, end, focused) {
                rangeStart = start;
                rangeEnd = end;
                focusedDay = focused;
              },
            ),
          ),
        );

        expect(rangeStart, isNull);
        expect(rangeEnd, isNull);
        expect(focusedDay, isNull);
        expect(selectedDay, isNull);

        final firstTappedDay = DateTime.utc(2021, 7, 8);
        final secondTappedDay = DateTime.utc(2021, 7, 21);

        final firstTappedDayKey = cellContentKey(firstTappedDay);
        final secondTappedDayKey = cellContentKey(secondTappedDay);

        final expectedFocusedDay = secondTappedDay;

        await tester.longPress(find.byKey(firstTappedDayKey));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(firstTappedDayKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(secondTappedDayKey));
        await tester.pumpAndSettle();
        expect(rangeStart, firstTappedDay);
        expect(rangeEnd, secondTappedDay);
        expect(focusedDay, expectedFocusedDay);
        expect(selectedDay, isNull);
      },
    );

    testWidgets(
      'long press toggles rangeSelectionMode when onDayLongPress callback is null - initial mode is toggledOn',
      (tester) async {
        DateTime? rangeStart;
        DateTime? rangeEnd;
        DateTime? focusedDay;
        DateTime? selectedDay;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              rangeSelectionMode: RangeSelectionMode.toggledOn,
              onDaySelected: (selected, focused) {
                selectedDay = selected;
                focusedDay = focused;
              },
              onRangeSelected: (start, end, focused) {
                rangeStart = start;
                rangeEnd = end;
                focusedDay = focused;
              },
            ),
          ),
        );

        expect(rangeStart, isNull);
        expect(rangeEnd, isNull);
        expect(focusedDay, isNull);
        expect(selectedDay, isNull);

        final firstTappedDay = DateTime.utc(2021, 7, 8);
        final secondTappedDay = DateTime.utc(2021, 7, 21);

        final firstTappedDayKey = cellContentKey(firstTappedDay);
        final secondTappedDayKey = cellContentKey(secondTappedDay);

        final expectedFocusedDay = secondTappedDay;

        await tester.longPress(find.byKey(firstTappedDayKey));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(firstTappedDayKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(secondTappedDayKey));
        await tester.pumpAndSettle();
        expect(rangeStart, isNull);
        expect(rangeEnd, isNull);
        expect(focusedDay, expectedFocusedDay);
        expect(selectedDay, secondTappedDay);
      },
    );

    testWidgets(
      'rangeSelectionMode.enforced disables onDaySelected callback',
      (tester) async {
        DateTime? rangeStart;
        DateTime? rangeEnd;
        DateTime? focusedDay;
        DateTime? selectedDay;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              rangeSelectionMode: RangeSelectionMode.enforced,
              onDaySelected: (selected, focused) {
                selectedDay = selected;
                focusedDay = focused;
              },
              onRangeSelected: (start, end, focused) {
                rangeStart = start;
                rangeEnd = end;
                focusedDay = focused;
              },
            ),
          ),
        );

        expect(rangeStart, isNull);
        expect(rangeEnd, isNull);
        expect(focusedDay, isNull);
        expect(selectedDay, isNull);

        final firstTappedDay = DateTime.utc(2021, 7, 8);
        final secondTappedDay = DateTime.utc(2021, 7, 21);

        final firstTappedDayKey = cellContentKey(firstTappedDay);
        final secondTappedDayKey = cellContentKey(secondTappedDay);

        final expectedFocusedDay = secondTappedDay;

        await tester.longPress(find.byKey(firstTappedDayKey));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(firstTappedDayKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(secondTappedDayKey));
        await tester.pumpAndSettle();
        expect(rangeStart, firstTappedDay);
        expect(rangeEnd, secondTappedDay);
        expect(focusedDay, expectedFocusedDay);
        expect(selectedDay, isNull);
      },
    );

    testWidgets(
      'rangeSelectionMode.disabled enforces onDaySelected callback',
      (tester) async {
        DateTime? rangeStart;
        DateTime? rangeEnd;
        DateTime? focusedDay;
        DateTime? selectedDay;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              rangeSelectionMode: RangeSelectionMode.disabled,
              onDaySelected: (selected, focused) {
                selectedDay = selected;
                focusedDay = focused;
              },
              onRangeSelected: (start, end, focused) {
                rangeStart = start;
                rangeEnd = end;
                focusedDay = focused;
              },
            ),
          ),
        );

        expect(rangeStart, isNull);
        expect(rangeEnd, isNull);
        expect(focusedDay, isNull);
        expect(selectedDay, isNull);

        final firstTappedDay = DateTime.utc(2021, 7, 8);
        final secondTappedDay = DateTime.utc(2021, 7, 21);

        final firstTappedDayKey = cellContentKey(firstTappedDay);
        final secondTappedDayKey = cellContentKey(secondTappedDay);

        final expectedFocusedDay = secondTappedDay;

        await tester.longPress(find.byKey(firstTappedDayKey));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(firstTappedDayKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(secondTappedDayKey));
        await tester.pumpAndSettle();
        expect(rangeStart, isNull);
        expect(rangeEnd, isNull);
        expect(focusedDay, expectedFocusedDay);
        expect(selectedDay, secondTappedDay);
      },
    );
  });

  group('Range selection test:', () {
    testWidgets(
      'range selection has correct start and end point',
      (tester) async {
        final rangeStart = DateTime.utc(2021, 7, 8);
        final rangeEnd = DateTime.utc(2021, 7, 21);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              rangeStartDay: rangeStart,
              rangeEndDay: rangeEnd,
            ),
          ),
        );

        final rangeStartKey = cellContentKey(rangeStart);
        final rangeStartCellContent =
            tester.widget(find.byKey(rangeStartKey)) as CellContent;

        expect(rangeStartCellContent.isRangeStart, true);
        expect(rangeStartCellContent.isRangeEnd, false);
        expect(rangeStartCellContent.isWithinRange, true);

        final rangeEndKey = cellContentKey(rangeEnd);
        final rangeEndCellContent =
            tester.widget(find.byKey(rangeEndKey)) as CellContent;

        expect(rangeEndCellContent.isRangeStart, false);
        expect(rangeEndCellContent.isRangeEnd, true);
        expect(rangeEndCellContent.isWithinRange, true);
      },
    );

    testWidgets(
      'days within range selection are marked as inWithinRange',
      (tester) async {
        final rangeStart = DateTime.utc(2021, 7, 8);
        final rangeEnd = DateTime.utc(2021, 7, 13);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              rangeStartDay: rangeStart,
              rangeEndDay: rangeEnd,
            ),
          ),
        );

        final dayCount = rangeEnd.difference(rangeStart).inDays - 1;
        expect(dayCount, 4);

        for (int i = 1; i <= dayCount; i++) {
          final testDay = rangeStart.add(Duration(days: i));

          expect(testDay.isAfter(rangeStart), true);
          expect(testDay.isBefore(rangeEnd), true);

          final testDayKey = cellContentKey(testDay);
          final testDayCellContent =
              tester.widget(find.byKey(testDayKey)) as CellContent;

          expect(testDayCellContent.isWithinRange, true);
        }
      },
    );

    testWidgets(
      'days outside range selection are not marked as inWithinRange',
      (tester) async {
        final rangeStart = DateTime.utc(2021, 7, 8);
        final rangeEnd = DateTime.utc(2021, 7, 13);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              rangeStartDay: rangeStart,
              rangeEndDay: rangeEnd,
            ),
          ),
        );

        final oobStart = rangeStart.subtract(const Duration(days: 1));
        final oobEnd = rangeEnd.add(const Duration(days: 1));

        final oobStartKey = cellContentKey(oobStart);
        final oobStartCellContent =
            tester.widget(find.byKey(oobStartKey)) as CellContent;

        final oobEndKey = cellContentKey(oobEnd);
        final oobEndCellContent =
            tester.widget(find.byKey(oobEndKey)) as CellContent;

        expect(oobStartCellContent.isWithinRange, false);
        expect(oobEndCellContent.isWithinRange, false);
      },
    );
  });

  group('Timezone support:', () {
    setUpAll(() {
      tzdata.initializeTimeZones();
    });

    testWidgets(
      'April 2026 Europe/Berlin shows correct days despite DST spring-forward (the original bug)',
      (tester) async {
        final location = tz.getLocation('Europe/Berlin');
        final focusedDay = tz.TZDateTime(location, 2026, 4, 15);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: focusedDay,
              firstDay: tz.TZDateTime(location, 2026),
              lastDay: tz.TZDateTime(location, 2026, 12, 31),
              currentDay: focusedDay,
              timeZone: location,
            ),
          ),
        );

        // April 1, 2026 is Wednesday. Sunday start → 3 leading days (Mar 29-31).
        // April 30 is Thursday → 2 trailing days (May 1-2).
        // Grid: Mar 29 → May 2 (35 days, 5 rows).
        final firstVisibleDay = tz.TZDateTime(location, 2026, 3, 29);
        final lastVisibleDay = tz.TZDateTime(location, 2026, 5, 2);

        expect(
          find.byKey(cellContentKey(firstVisibleDay)),
          findsOneWidget,
        );
        expect(
          find.byKey(cellContentKey(lastVisibleDay)),
          findsOneWidget,
        );

        // The DST spring-forward (Mar 29) is the first visible day.
        // Verify April 1 (Wednesday) is present — this was the bug scenario.
        final april1 = tz.TZDateTime(location, 2026, 4);
        expect(find.byKey(cellContentKey(april1)), findsOneWidget);

        // March 28 must NOT be in the grid (this was the DST bug symptom)
        final march28 = tz.TZDateTime(location, 2026, 3, 28);
        expect(find.byKey(cellContentKey(march28)), findsNothing);
      },
    );

    testWidgets(
      'correct day count in month view with timezone',
      (tester) async {
        final location = tz.getLocation('Europe/Berlin');
        final focusedDay = tz.TZDateTime(location, 2026, 4, 15);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: focusedDay,
              firstDay: tz.TZDateTime(location, 2026),
              lastDay: tz.TZDateTime(location, 2026, 12, 31),
              currentDay: focusedDay,
              timeZone: location,
            ),
          ),
        );

        final dayCells = tester.widgetList(find.byType(CellContent));
        expect(dayCells.length, 35);
      },
    );

    testWidgets(
      'onDaySelected returns TZDateTime when timezone is set',
      (tester) async {
        final location = tz.getLocation('America/New_York');
        final focusedDay = tz.TZDateTime(location, 2026, 7, 15);
        DateTime? selectedDay;
        DateTime? focusedDayResult;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: focusedDay,
              firstDay: tz.TZDateTime(location, 2026, 5),
              lastDay: tz.TZDateTime(location, 2026, 9, 30),
              currentDay: focusedDay,
              timeZone: location,
              onDaySelected: (selected, focused) {
                selectedDay = selected;
                focusedDayResult = focused;
              },
            ),
          ),
        );

        final tappedDay = tz.TZDateTime(location, 2026, 7, 20);
        final tappedDayKey = cellContentKey(tappedDay);

        await tester.tap(find.byKey(tappedDayKey));
        await tester.pumpAndSettle();

        expect(selectedDay, isNotNull);
        expect(selectedDay, isA<tz.TZDateTime>());
        expect((selectedDay! as tz.TZDateTime).location, location);
        expect(selectedDay!.year, 2026);
        expect(selectedDay!.month, 7);
        expect(selectedDay!.day, 20);

        expect(focusedDayResult, isA<tz.TZDateTime>());
      },
    );

    testWidgets(
      'page swiping works correctly with timezone',
      (tester) async {
        final location = tz.getLocation('America/New_York');
        final focusedDay = tz.TZDateTime(location, 2026, 7, 15);
        DateTime? updatedFocusedDay;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: focusedDay,
              firstDay: tz.TZDateTime(location, 2026, 5),
              lastDay: tz.TZDateTime(location, 2026, 9, 30),
              currentDay: focusedDay,
              timeZone: location,
              onPageChanged: (day) {
                updatedFocusedDay = day;
              },
            ),
          ),
        );

        expect(find.text('July 2026'), findsOneWidget);

        await tester.drag(
          find.byType(CellContent).first,
          const Offset(-500, 0),
        );
        await tester.pumpAndSettle();

        expect(updatedFocusedDay, isNotNull);
        expect(updatedFocusedDay, isA<tz.TZDateTime>());
        expect(updatedFocusedDay!.month, 8);
        expect(find.text('August 2026'), findsOneWidget);
      },
    );

    testWidgets(
      'week format across DST spring-forward shows 7 cells',
      (tester) async {
        final location = tz.getLocation('Europe/Berlin');
        // Focused on March 30 (Monday). Sunday start → week starts Mar 29 (DST day).
        final focusedDay = tz.TZDateTime(location, 2026, 3, 30);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: focusedDay,
              firstDay: tz.TZDateTime(location, 2026),
              lastDay: tz.TZDateTime(location, 2026, 12, 31),
              currentDay: focusedDay,
              timeZone: location,
              calendarFormat: CalendarFormat.week,
            ),
          ),
        );

        final dayCells = tester.widgetList(find.byType(CellContent));
        expect(dayCells.length, 7);
      },
    );

    testWidgets(
      'range selection works with timezone-aware dates',
      (tester) async {
        final location = tz.getLocation('America/Chicago');
        final focusedDay = tz.TZDateTime(location, 2026, 7, 15);
        DateTime? rangeStart;
        DateTime? rangeEnd;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: focusedDay,
              firstDay: tz.TZDateTime(location, 2026, 5),
              lastDay: tz.TZDateTime(location, 2026, 9, 30),
              currentDay: focusedDay,
              timeZone: location,
              rangeSelectionMode: RangeSelectionMode.enforced,
              onRangeSelected: (start, end, focused) {
                rangeStart = start;
                rangeEnd = end;
              },
            ),
          ),
        );

        final firstTap = tz.TZDateTime(location, 2026, 7, 8);
        final secondTap = tz.TZDateTime(location, 2026, 7, 21);

        await tester.tap(find.byKey(cellContentKey(firstTap)));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(cellContentKey(secondTap)));
        await tester.pumpAndSettle();

        expect(rangeStart, isA<tz.TZDateTime>());
        expect(rangeEnd, isA<tz.TZDateTime>());
        expect(rangeStart!.day, 8);
        expect(rangeEnd!.day, 21);
      },
    );

    testWidgets(
      'selectedDayPredicate works with TZDateTime',
      (tester) async {
        final location = tz.getLocation('Europe/London');
        final focusedDay = tz.TZDateTime(location, 2026, 7, 15);
        final selectedDay = tz.TZDateTime(location, 2026, 7, 20);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: focusedDay,
              firstDay: tz.TZDateTime(location, 2026, 5),
              lastDay: tz.TZDateTime(location, 2026, 9, 30),
              currentDay: focusedDay,
              timeZone: location,
              selectedDayPredicate: (day) => isSameDay(day, selectedDay),
            ),
          ),
        );

        final selectedKey = cellContentKey(selectedDay);
        final selectedCell =
            tester.widget(find.byKey(selectedKey)) as CellContent;
        expect(selectedCell.isSelected, true);
      },
    );

    testWidgets(
      'currentDay marking works with TZDateTime',
      (tester) async {
        final location = tz.getLocation('Asia/Tokyo');
        final currentDay = tz.TZDateTime(location, 2026, 7, 15);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: currentDay,
              firstDay: tz.TZDateTime(location, 2026, 5),
              lastDay: tz.TZDateTime(location, 2026, 9, 30),
              currentDay: currentDay,
              timeZone: location,
            ),
          ),
        );

        final currentDayKey = cellContentKey(currentDay);
        final currentDayCell =
            tester.widget(find.byKey(currentDayKey)) as CellContent;
        expect(currentDayCell.isToday, true);
      },
    );

    testWidgets(
      'cross-timezone: focusedDay March 1 in ahead-TZ stays March when app TZ is behind',
      (tester) async {
        // Simulates the exact bug scenario:
        // Device timezone: Asia/Singapore (UTC+8)
        // App timezone: Europe/Berlin (UTC+1)
        // DateTime(2027, 3, 1) midnight SGT = Feb 28 16:00 UTC
        // Old code would show February; fixed code shows March.
        final singapore = tz.getLocation('Asia/Singapore');
        final berlin = tz.getLocation('Europe/Berlin');

        final focusedDay = tz.TZDateTime(singapore, 2027, 3);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: focusedDay,
              firstDay: tz.TZDateTime(berlin, 2027),
              lastDay: tz.TZDateTime(berlin, 2027, 12, 31),
              currentDay: tz.TZDateTime(berlin, 2027, 3),
              timeZone: berlin,
            ),
          ),
        );

        expect(find.text('March 2027'), findsOneWidget);

        final march1Key = cellContentKey(tz.TZDateTime(berlin, 2027, 3));
        expect(find.byKey(march1Key), findsOneWidget);
      },
    );

    testWidgets(
      'cross-timezone: focusedDay Jan 1 in Asia/Tokyo targeted to America/New_York stays January',
      (tester) async {
        // Jan 1 00:00 JST = Dec 31 10:00 EST via epoch.
        // Old code would display December; fixed code displays January.
        final tokyo = tz.getLocation('Asia/Tokyo');
        final newYork = tz.getLocation('America/New_York');

        final focusedDay = tz.TZDateTime(tokyo, 2027);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: focusedDay,
              firstDay: tz.TZDateTime(newYork, 2026, 10),
              lastDay: tz.TZDateTime(newYork, 2027, 6, 30),
              currentDay: tz.TZDateTime(newYork, 2027),
              timeZone: newYork,
            ),
          ),
        );

        expect(find.text('January 2027'), findsOneWidget);

        final jan1Key = cellContentKey(tz.TZDateTime(newYork, 2027));
        expect(find.byKey(jan1Key), findsOneWidget);
      },
    );

    testWidgets(
      'cross-timezone: onDaySelected preserves calendar date across timezone gap',
      (tester) async {
        final tokyo = tz.getLocation('Asia/Tokyo');
        final chicago = tz.getLocation('America/Chicago');
        DateTime? selectedDay;

        final focusedDay = tz.TZDateTime(tokyo, 2027, 3, 15);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: focusedDay,
              firstDay: tz.TZDateTime(chicago, 2027),
              lastDay: tz.TZDateTime(chicago, 2027, 6, 30),
              currentDay: tz.TZDateTime(chicago, 2027, 3, 15),
              timeZone: chicago,
              onDaySelected: (selected, focused) {
                selectedDay = selected;
              },
            ),
          ),
        );

        final tappedDay = tz.TZDateTime(chicago, 2027, 3, 20);
        await tester.tap(find.byKey(cellContentKey(tappedDay)));
        await tester.pumpAndSettle();

        expect(selectedDay, isNotNull);
        expect(selectedDay!.year, 2027);
        expect(selectedDay!.month, 3);
        expect(selectedDay!.day, 20);
      },
    );
  });
}
