# Changelog

All notable changes to **table_calendar_tz** will be documented in this file.

This project is a fork of [table_calendar](https://github.com/aleksanderwozniak/table_calendar) (v3.2.0).

## 1.0.3

- Fix cross-timezone date shift bug where `TZDateTime.from()` converted dates via epoch, causing calendar dates to shift when device and app timezones differ (e.g. device in Singapore, app in Berlin would show Feb 28 instead of March 1)
- Replace all `TZDateTime.from(date, location)` calls with direct component construction `TZDateTime(location, date.year, date.month, date.day)` in `normalizeDate`, `_firstDayOfMonth`, and `_lastDayOfMonth`
- Add cross-timezone regression tests for `normalizeDate`, `TableCalendar`, and `TableCalendarBase`

## 1.0.2

- Fix version number display in README
- Update CHANGELOG with new changes

## 1.0.1

- Fix README to accurately describe the fork (timezone addition, not upstream bug fix)
- Add comprehensive test suite for timezone and DST scenarios
- Fix all linting issues (`require_trailing_commas`, `avoid_redundant_argument_values`)
- Move original author attribution to NOTICE file
- Update copyright headers across all source files

## 1.0.0

- Fork from [table_calendar](https://github.com/aleksanderwozniak/table_calendar) v3.2.0
- Add `timeZone` parameter to `TableCalendar` and `TableCalendarBase` for timezone-aware rendering
- Replace all `Duration`-based date arithmetic with calendar-aware construction (`TZDateTime(loc, y, m, d)`) to handle DST transitions correctly
- Fix `normalizeDate` to preserve `TZDateTime` location when no explicit location is provided
- Rename package to `table_calendar_tz`
- Rename barrel file to `lib/table_calendar_tz.dart`
- Add `timezone` package dependency
- Add regression tests for DST spring-forward and fall-back across multiple timezones
