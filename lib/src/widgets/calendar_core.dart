// Copyright 2026 Arkar Min Tun
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:table_calendar_tz/src/shared/utils.dart';
import 'package:table_calendar_tz/src/widgets/calendar_page.dart';
import 'package:timezone/timezone.dart' as tz;

class CalendarCore extends StatelessWidget {
  final DateTime? focusedDay;
  final DateTime firstDay;
  final DateTime lastDay;
  final CalendarFormat calendarFormat;
  final DayBuilder? dowBuilder;
  final DayBuilder? weekNumberBuilder;
  final FocusedDayBuilder dayBuilder;
  final bool sixWeekMonthsEnforced;
  final bool dowVisible;
  final bool weekNumbersVisible;
  final Decoration? dowDecoration;
  final Decoration? rowDecoration;
  final TableBorder? tableBorder;
  final EdgeInsets? tablePadding;
  final double? dowHeight;
  final double? rowHeight;
  final BoxConstraints constraints;
  final int? previousIndex;
  final StartingDayOfWeek startingDayOfWeek;
  final PageController? pageController;
  final ScrollPhysics? scrollPhysics;
  final tz.Location? timeZone;
  final void Function(int, DateTime) onPageChanged;

  const CalendarCore({
    super.key,
    this.dowBuilder,
    required this.dayBuilder,
    required this.onPageChanged,
    required this.firstDay,
    required this.lastDay,
    required this.constraints,
    this.dowHeight,
    this.rowHeight,
    this.startingDayOfWeek = StartingDayOfWeek.sunday,
    this.calendarFormat = CalendarFormat.month,
    this.pageController,
    this.focusedDay,
    this.timeZone,
    this.previousIndex,
    this.sixWeekMonthsEnforced = false,
    this.dowVisible = true,
    this.weekNumberBuilder,
    required this.weekNumbersVisible,
    this.dowDecoration,
    this.rowDecoration,
    this.tableBorder,
    this.tablePadding,
    this.scrollPhysics,
  }) : assert(!dowVisible || (dowHeight != null && dowBuilder != null));

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      physics: scrollPhysics,
      itemCount: _getPageCount(calendarFormat, firstDay, lastDay),
      itemBuilder: (context, index) {
        final baseDay = _getBaseDay(calendarFormat, index);
        final visibleRange = _getVisibleRange(calendarFormat, baseDay);
        final visibleDays = _daysInRange(visibleRange.start, visibleRange.end);

        final actualDowHeight = dowVisible ? dowHeight! : 0.0;
        final constrainedRowHeight = constraints.hasBoundedHeight
            ? (constraints.maxHeight - actualDowHeight) /
                _getRowCount(calendarFormat, baseDay)
            : null;

        return CalendarPage(
          visibleDays: visibleDays,
          dowVisible: dowVisible,
          dowDecoration: dowDecoration,
          rowDecoration: rowDecoration,
          tableBorder: tableBorder,
          tablePadding: tablePadding,
          dowBuilder: (context, day) {
            return SizedBox(
              height: dowHeight,
              child: dowBuilder?.call(context, day),
            );
          },
          dayBuilder: (context, day) {
            DateTime baseDay;
            final previousFocusedDay = focusedDay;
            if (previousFocusedDay == null || previousIndex == null) {
              baseDay = _getBaseDay(calendarFormat, index);
            } else {
              baseDay =
                  _getFocusedDay(calendarFormat, previousFocusedDay, index);
            }

            return SizedBox(
              height: constrainedRowHeight ?? rowHeight,
              child: dayBuilder(context, day, baseDay),
            );
          },
          dowHeight: dowHeight,
          weekNumberVisible: weekNumbersVisible,
          weekNumberBuilder: (context, day) {
            return SizedBox(
              height: constrainedRowHeight ?? rowHeight,
              child: weekNumberBuilder?.call(context, day),
            );
          },
        );
      },
      onPageChanged: (index) {
        DateTime baseDay;
        final previousFocusedDay = focusedDay;
        if (previousFocusedDay == null || previousIndex == null) {
          baseDay = _getBaseDay(calendarFormat, index);
        } else {
          baseDay = _getFocusedDay(calendarFormat, previousFocusedDay, index);
        }

        return onPageChanged(index, baseDay);
      },
    );
  }

  int _getPageCount(CalendarFormat format, DateTime first, DateTime last) {
    switch (format) {
      case CalendarFormat.month:
        return _getMonthCount(first, last) + 1;
      case CalendarFormat.twoWeeks:
        return _getTwoWeekCount(first, last) + 1;
      case CalendarFormat.week:
        return _getWeekCount(first, last) + 1;
    }
  }

  int _getMonthCount(DateTime first, DateTime last) {
    final yearDif = last.year - first.year;
    final monthDif = last.month - first.month;

    return yearDif * 12 + monthDif;
  }

  int _getWeekCount(DateTime first, DateTime last) {
    final weekStart = _firstDayOfWeek(first);
    final lastUtc = DateTime.utc(last.year, last.month, last.day);
    final startUtc =
        DateTime.utc(weekStart.year, weekStart.month, weekStart.day);
    return lastUtc.difference(startUtc).inDays ~/ 7;
  }

  int _getTwoWeekCount(DateTime first, DateTime last) {
    final weekStart = _firstDayOfWeek(first);
    final lastUtc = DateTime.utc(last.year, last.month, last.day);
    final startUtc =
        DateTime.utc(weekStart.year, weekStart.month, weekStart.day);
    return lastUtc.difference(startUtc).inDays ~/ 14;
  }

  DateTime _getFocusedDay(
    CalendarFormat format,
    DateTime prevFocusedDay,
    int pageIndex,
  ) {
    if (pageIndex == previousIndex) {
      return prevFocusedDay;
    }

    final pageDif = pageIndex - previousIndex!;
    DateTime day;

    switch (format) {
      case CalendarFormat.month:
        day = _createDateTime(
          prevFocusedDay.year,
          prevFocusedDay.month + pageDif,
        );
      case CalendarFormat.twoWeeks:
        day = _createDateTime(
          prevFocusedDay.year,
          prevFocusedDay.month,
          prevFocusedDay.day + pageDif * 14,
        );
      case CalendarFormat.week:
        day = _createDateTime(
          prevFocusedDay.year,
          prevFocusedDay.month,
          prevFocusedDay.day + pageDif * 7,
        );
    }

    if (day.isBefore(firstDay)) {
      day = firstDay;
    } else if (day.isAfter(lastDay)) {
      day = lastDay;
    }

    return day;
  }

  DateTime _getBaseDay(CalendarFormat format, int pageIndex) {
    DateTime day;

    switch (format) {
      case CalendarFormat.month:
        day = _createDateTime(firstDay.year, firstDay.month + pageIndex);
      case CalendarFormat.twoWeeks:
        day = _createDateTime(
          firstDay.year,
          firstDay.month,
          firstDay.day + pageIndex * 14,
        );
      case CalendarFormat.week:
        day = _createDateTime(
          firstDay.year,
          firstDay.month,
          firstDay.day + pageIndex * 7,
        );
    }

    if (day.isBefore(firstDay)) {
      day = firstDay;
    } else if (day.isAfter(lastDay)) {
      day = lastDay;
    }

    return day;
  }

  DateTimeRange _getVisibleRange(CalendarFormat format, DateTime focusedDay) {
    switch (format) {
      case CalendarFormat.month:
        return _daysInMonth(focusedDay);
      case CalendarFormat.twoWeeks:
        return _daysInTwoWeeks(focusedDay);
      case CalendarFormat.week:
        return _daysInWeek(focusedDay);
    }
  }

  DateTimeRange _daysInWeek(DateTime focusedDay) {
    final daysBefore = _getDaysBefore(focusedDay);
    final firstToDisplay = _createDateTime(
      focusedDay.year,
      focusedDay.month,
      focusedDay.day - daysBefore,
    );
    final lastToDisplay = _createDateTime(
      firstToDisplay.year,
      firstToDisplay.month,
      firstToDisplay.day + 7,
    );
    return DateTimeRange(start: firstToDisplay, end: lastToDisplay);
  }

  DateTimeRange _daysInTwoWeeks(DateTime focusedDay) {
    final daysBefore = _getDaysBefore(focusedDay);
    final firstToDisplay = _createDateTime(
      focusedDay.year,
      focusedDay.month,
      focusedDay.day - daysBefore,
    );
    final lastToDisplay = _createDateTime(
      firstToDisplay.year,
      firstToDisplay.month,
      firstToDisplay.day + 14,
    );
    return DateTimeRange(start: firstToDisplay, end: lastToDisplay);
  }

  DateTimeRange _daysInMonth(DateTime focusedDay) {
    final first = _firstDayOfMonth(focusedDay);
    final daysBefore = _getDaysBefore(first);
    final firstToDisplay =
        _createDateTime(first.year, first.month, first.day - daysBefore);

    if (sixWeekMonthsEnforced) {
      final end = _createDateTime(
        firstToDisplay.year,
        firstToDisplay.month,
        firstToDisplay.day + 42,
      );
      return DateTimeRange(start: firstToDisplay, end: end);
    }

    final last = _lastDayOfMonth(focusedDay);
    final daysAfter = _getDaysAfter(last);
    final lastToDisplay =
        _createDateTime(last.year, last.month, last.day + daysAfter);

    return DateTimeRange(start: firstToDisplay, end: lastToDisplay);
  }

  List<DateTime> _daysInRange(DateTime first, DateTime last) {
    final dayCount = DateTime.utc(last.year, last.month, last.day)
            .difference(DateTime.utc(first.year, first.month, first.day))
            .inDays +
        1;
    return List.generate(
      dayCount,
      (index) => _createDateTime(first.year, first.month, first.day + index),
    );
  }

  DateTime _firstDayOfWeek(DateTime week) {
    final daysBefore = _getDaysBefore(week);
    return _createDateTime(week.year, week.month, week.day - daysBefore);
  }

  DateTime _firstDayOfMonth(DateTime month) {
    final location = timeZone;

    if (location == null) {
      return DateTime.utc(month.year, month.month);
    }

    return tz.TZDateTime(location, month.year, month.month);
  }

  DateTime _lastDayOfMonth(DateTime month) {
    final location = timeZone;

    if (location == null) {
      return DateTime.utc(month.year, month.month + 1, 0);
    }

    return tz.TZDateTime(location, month.year, month.month + 1, 0);
  }

  int _getRowCount(CalendarFormat format, DateTime focusedDay) {
    if (format == CalendarFormat.twoWeeks) {
      return 2;
    } else if (format == CalendarFormat.week) {
      return 1;
    } else if (sixWeekMonthsEnforced) {
      return 6;
    }

    final first = _firstDayOfMonth(focusedDay);
    final daysBefore = _getDaysBefore(first);
    final firstToDisplay =
        _createDateTime(first.year, first.month, first.day - daysBefore);

    final last = _lastDayOfMonth(focusedDay);
    final daysAfter = _getDaysAfter(last);
    final lastToDisplay =
        _createDateTime(last.year, last.month, last.day + daysAfter);

    final lastUtc = DateTime.utc(
      lastToDisplay.year,
      lastToDisplay.month,
      lastToDisplay.day,
    );
    final firstUtc = DateTime.utc(
      firstToDisplay.year,
      firstToDisplay.month,
      firstToDisplay.day,
    );
    return (lastUtc.difference(firstUtc).inDays + 1) ~/ 7;
  }

  DateTime _createDateTime(int year, int month, [int day = 1]) {
    final location = timeZone;

    if (location == null) {
      return DateTime.utc(year, month, day);
    }

    return tz.TZDateTime(location, year, month, day);
  }

  int _getDaysBefore(DateTime firstDay) {
    return (firstDay.weekday + 7 - getWeekdayNumber(startingDayOfWeek)) % 7;
  }

  int _getDaysAfter(DateTime lastDay) {
    final invertedStartingWeekday = 8 - getWeekdayNumber(startingDayOfWeek);

    final daysAfter = 7 - ((lastDay.weekday + invertedStartingWeekday) % 7);
    if (daysAfter == 7) {
      return 0;
    }

    return daysAfter;
  }
}
