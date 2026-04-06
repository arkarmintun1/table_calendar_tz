// Copyright 2026 Arkar Min Tun
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:table_calendar_tz/src/shared/utils.dart';

ValueKey<String> dateToKey(DateTime date, {String prefix = ''}) {
  return ValueKey('$prefix${date.year}-${date.month}-${date.day}');
}

const calendarFormatMap = {
  CalendarFormat.month: 'Month',
  CalendarFormat.twoWeeks: 'Two weeks',
  CalendarFormat.week: 'week',
};
