// Copyright 2026 Arkar Min Tun
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/widgets.dart';
import 'package:timezone/timezone.dart' as tz;

/// Signature for a function that creates a widget for a given `day`.
typedef DayBuilder = Widget? Function(BuildContext context, DateTime day);

/// Signature for a function that creates a widget for a given `day`.
/// Additionally, contains the currently focused day.
typedef FocusedDayBuilder = Widget? Function(
  BuildContext context,
  DateTime day,
  DateTime focusedDay,
);

/// Signature for a function returning text that can be localized and formatted with `DateFormat`.
typedef TextFormatter = String Function(DateTime date, dynamic locale);

/// Gestures available for the calendar.
enum AvailableGestures { none, verticalSwipe, horizontalSwipe, all }

/// Formats that the calendar can display.
enum CalendarFormat { month, twoWeeks, week }

/// Days of the week that the calendar can start with.
enum StartingDayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

/// Returns a numerical value associated with given `weekday`.
///
/// Returns 1 for `StartingDayOfWeek.monday`, all the way to 7 for `StartingDayOfWeek.sunday`.
int getWeekdayNumber(StartingDayOfWeek weekday) {
  return StartingDayOfWeek.values.indexOf(weekday) + 1;
}

/// Returns `date` normalized to midnight within provided [location] or UTC when absent.
/// If [date] is a [tz.TZDateTime] and no [location] is given, its location is preserved.
DateTime normalizeDate(DateTime date, {tz.Location? location}) {
  final loc = location ?? (date is tz.TZDateTime ? date.location : null);

  if (loc == null) {
    return DateTime.utc(date.year, date.month, date.day);
  }

  final target = tz.TZDateTime.from(date, loc);
  return tz.TZDateTime(loc, target.year, target.month, target.day);
}

/// Checks if two DateTime objects are the same day.
/// Returns `false` if either of them is null.
bool isSameDay(DateTime? a, DateTime? b) {
  if (a == null || b == null) {
    return false;
  }

  return a.year == b.year && a.month == b.month && a.day == b.day;
}
