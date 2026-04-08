# TableCalendar TZ

A fork of [table_calendar](https://github.com/aleksanderwozniak/table_calendar) that adds **timezone support** with correct DST handling.

Highly customizable, feature-packed calendar widget for Flutter.

| ![Image](https://raw.githubusercontent.com/aleksanderwozniak/table_calendar/assets/table_calendar_styles.gif) | ![Image](https://raw.githubusercontent.com/aleksanderwozniak/table_calendar/assets/table_calendar_builders.gif) |
| :-----------------------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------------------: |
|                                     **TableCalendar** with custom styles                                      |                                     **TableCalendar** with custom builders                                      |

## Why this fork?

The original `table_calendar` normalizes all dates to **UTC**, which works well for most use cases. However, if your app needs to display a calendar in a specific timezone (e.g., showing meetings in `Europe/Berlin` or `America/New_York`), there is no built-in way to do that.

This fork adds a `timeZone` parameter that accepts a `tz.Location`, enabling timezone-aware calendar rendering. All date calculations use **calendar-aware date construction** (`TZDateTime(loc, y, m, d)`) instead of `Duration`-based arithmetic, ensuring the grid is always correct — even when visible days span a **DST (Daylight Saving Time)** boundary.

Without calendar-aware arithmetic, `Duration`-based operations like `subtract(Duration(days: 3))` treat days as exactly 24 hours. During DST spring-forward (23-hour day) or fall-back (25-hour day), this produces off-by-one errors in the calendar grid. This fork avoids that entirely.

## Features

- Everything from the original `table_calendar` package
- **New `timeZone` parameter** for timezone-aware calendar rendering
- Calendar-aware date arithmetic that correctly handles DST transitions
- Regression tests covering spring-forward and fall-back scenarios across multiple timezones

## Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  table_calendar_tz: ^1.0.3
```

Or use a Git dependency:

```yaml
dependencies:
  table_calendar_tz:
    git:
      url: https://github.com/arkarmintun1/table_calendar_tz.git
```

## Usage

The API is identical to the original `table_calendar`. Just update your import:

```dart
import 'package:table_calendar_tz/table_calendar_tz.dart';
```

### Basic setup

```dart
TableCalendar(
  firstDay: DateTime.utc(2010, 10, 16),
  lastDay: DateTime.utc(2030, 3, 14),
  focusedDay: DateTime.now(),
);
```

### With timezone support

```dart
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

// Initialize timezone data once at app startup
tz_data.initializeTimeZones();
final location = tz.getLocation('Europe/Berlin');

TableCalendar(
  firstDay: tz.TZDateTime(location, 2010, 10, 16),
  lastDay: tz.TZDateTime(location, 2030, 3, 14),
  focusedDay: tz.TZDateTime.now(location),
  timeZone: location,
);
```

### Adding interactivity

```dart
selectedDayPredicate: (day) {
  return isSameDay(_selectedDay, day);
},
onDaySelected: (selectedDay, focusedDay) {
  setState(() {
    _selectedDay = selectedDay;
    _focusedDay = focusedDay;
  });
},
onFormatChanged: (format) {
  setState(() {
    _calendarFormat = format;
  });
},
onPageChanged: (focusedDay) {
  _focusedDay = focusedDay;
},
```

### Events

Supply events via `eventLoader`:

```dart
eventLoader: (day) {
  return _getEventsForDay(day);
},
```

When using a `Map<DateTime, List<T>>`, use a `LinkedHashMap` with `isSameDay` for correct equality:

```dart
final events = LinkedHashMap(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(eventSource);
```

### Custom UI with CalendarBuilders

Use [CalendarBuilders](https://pub.dev/documentation/table_calendar/latest/table_calendar/CalendarBuilders-class.html) to selectively override any part of the UI:

```dart
calendarBuilders: CalendarBuilders(
  dowBuilder: (context, day) {
    if (day.weekday == DateTime.sunday) {
      final text = DateFormat.E().format(day);
      return Center(
        child: Text(text, style: TextStyle(color: Colors.red)),
      );
    }
  },
),
```

### Locale

```dart
TableCalendar(
  locale: 'pl_PL',
);
```

Initialize date formatting first:

```dart
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}
```

| ![Image](https://raw.githubusercontent.com/aleksanderwozniak/table_calendar/assets/en_US.png) | ![Image](https://raw.githubusercontent.com/aleksanderwozniak/table_calendar/assets/pl_PL.png) | ![Image](https://raw.githubusercontent.com/aleksanderwozniak/table_calendar/assets/fr_FR.png) | ![Image](https://raw.githubusercontent.com/aleksanderwozniak/table_calendar/assets/zh_CN.png) |
| :-------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------: |
|                                           `'en_US'`                                           |                                           `'pl_PL'`                                           |                                           `'fr_FR'`                                           |                                           `'zh_CN'`                                           |

## Credits

Based on [table_calendar](https://github.com/aleksanderwozniak/table_calendar) by Aleksander Woźniak.
