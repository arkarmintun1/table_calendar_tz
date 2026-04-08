// Copyright 2026 Arkar Min Tun
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter_test/flutter_test.dart';
import 'package:table_calendar_tz/src/shared/utils.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

void main() {
  setUpAll(() {
    tzdata.initializeTimeZones();
  });

  group('isSameDay() tests:', () {
    test('Same day, different time', () {
      final dateA = DateTime(2020, 5, 10, 4, 32, 16);
      final dateB = DateTime(2020, 5, 10, 8, 21, 44);

      expect(isSameDay(dateA, dateB), true);
    });

    test('Different day, same time', () {
      final dateA = DateTime(2020, 5, 10, 4, 32, 16);
      final dateB = DateTime(2020, 5, 11, 4, 32, 16);

      expect(isSameDay(dateA, dateB), false);
    });

    test('UTC and local time zone', () {
      final dateA = DateTime.utc(2020, 5, 10);
      final dateB = DateTime(2020, 5, 10);

      expect(isSameDay(dateA, dateB), true);
    });

    test('Both null returns false', () {
      expect(isSameDay(null, null), false);
    });

    test('First null returns false', () {
      expect(isSameDay(null, DateTime.utc(2020, 5, 10)), false);
    });

    test('Second null returns false', () {
      expect(isSameDay(DateTime.utc(2020, 5, 10), null), false);
    });

    test('TZDateTime same day, different time', () {
      final location = tz.getLocation('America/New_York');
      final dateA = tz.TZDateTime(location, 2026, 4, 1, 9, 30);
      final dateB = tz.TZDateTime(location, 2026, 4, 1, 17, 45);

      expect(isSameDay(dateA, dateB), true);
    });

    test('TZDateTime different day', () {
      final location = tz.getLocation('America/New_York');
      final dateA = tz.TZDateTime(location, 2026, 4, 1, 23, 59);
      final dateB = tz.TZDateTime(location, 2026, 4, 2, 0, 1);

      expect(isSameDay(dateA, dateB), false);
    });

    test('TZDateTime vs UTC DateTime for same calendar day', () {
      final location = tz.getLocation('Asia/Tokyo');
      final dateA = tz.TZDateTime(location, 2026, 7, 15);
      final dateB = DateTime.utc(2026, 7, 15);

      expect(isSameDay(dateA, dateB), true);
    });

    test('TZDateTimes in different timezones, same calendar day', () {
      final tokyo = tz.getLocation('Asia/Tokyo');
      final newYork = tz.getLocation('America/New_York');
      final dateA = tz.TZDateTime(tokyo, 2026, 7, 15);
      final dateB = tz.TZDateTime(newYork, 2026, 7, 15);

      expect(isSameDay(dateA, dateB), true);
    });
  });

  group('normalizeDate() tests:', () {
    test('Local time zone gets converted to UTC', () {
      final dateA = DateTime(2020, 5, 10, 4, 32, 16);
      final dateB = normalizeDate(dateA);

      expect(dateB.isUtc, true);
    });

    test('Date is unchanged', () {
      final dateA = DateTime(2020, 5, 10, 4, 32, 16);
      final dateB = normalizeDate(dateA);

      expect(dateB.year, 2020);
      expect(dateB.month, 5);
      expect(dateB.day, 10);
    });

    test('Time gets trimmed', () {
      final dateA = DateTime(2020, 5, 10, 4, 32, 16);
      final dateB = normalizeDate(dateA);

      expect(dateB.hour, 0);
      expect(dateB.minute, 0);
      expect(dateB.second, 0);
      expect(dateB.millisecond, 0);
      expect(dateB.microsecond, 0);
    });

    test('Returns TZDateTime when provided location', () {
      final location = tz.getLocation('America/New_York');
      final source = DateTime.utc(2020, 3, 8, 5, 45); // 00:45 local before DST

      final normalized = normalizeDate(source, location: location);

      expect(normalized, isA<tz.TZDateTime>());
      expect((normalized as tz.TZDateTime).location, location);
      expect(normalized.hour, 0);
      expect(normalized.minute, 0);
    });

    test('Preserves TZDateTime location without explicit location', () {
      final location = tz.getLocation('Asia/Tokyo');
      final source = tz.TZDateTime(location, 2021, 12, 31, 22, 15);

      final normalized = normalizeDate(source);

      expect(normalized, isA<tz.TZDateTime>());
      expect((normalized as tz.TZDateTime).location, location);
      expect(normalized.hour, 0);
      expect(normalized.minute, 0);
    });

    test('Explicit location overrides TZDateTime original location', () {
      final tokyo = tz.getLocation('Asia/Tokyo');
      final berlin = tz.getLocation('Europe/Berlin');
      final source = tz.TZDateTime(tokyo, 2026, 6, 15, 10, 30);

      final normalized = normalizeDate(source, location: berlin);

      expect(normalized, isA<tz.TZDateTime>());
      expect((normalized as tz.TZDateTime).location, berlin);
      expect(normalized.hour, 0);
      expect(normalized.minute, 0);
    });

    test('Preserves correct date during DST spring-forward', () {
      final location = tz.getLocation('America/New_York');
      // March 8, 2026 2:00 AM is when spring-forward happens in US Eastern
      final source = tz.TZDateTime(location, 2026, 3, 8, 14, 30);

      final normalized = normalizeDate(source, location: location);

      expect(normalized, isA<tz.TZDateTime>());
      expect(normalized.year, 2026);
      expect(normalized.month, 3);
      expect(normalized.day, 8);
      expect(normalized.hour, 0);
    });

    test('Preserves correct date during DST fall-back', () {
      final location = tz.getLocation('America/New_York');
      // November 1, 2026 2:00 AM is when fall-back happens in US Eastern
      final source = tz.TZDateTime(location, 2026, 11, 1, 14, 30);

      final normalized = normalizeDate(source, location: location);

      expect(normalized, isA<tz.TZDateTime>());
      expect(normalized.year, 2026);
      expect(normalized.month, 11);
      expect(normalized.day, 1);
      expect(normalized.hour, 0);
    });

    test('UTC DateTime without location returns UTC', () {
      final source = DateTime.utc(2026, 6, 15, 14, 30);
      final normalized = normalizeDate(source);

      expect(normalized.isUtc, true);
      expect(normalized, isNot(isA<tz.TZDateTime>()));
      expect(normalized.year, 2026);
      expect(normalized.month, 6);
      expect(normalized.day, 15);
      expect(normalized.hour, 0);
    });

    test(
        'Preserves calendar date when source TZ is ahead of target TZ (cross-timezone date shift)',
        () {
      // Simulates: device in Asia/Singapore (UTC+8), app TZ = Europe/Berlin (UTC+1).
      // TZDateTime(singapore, 2027, 3, 1) at midnight SGT = Feb 28 16:00 UTC.
      // Old code: TZDateTime.from() would convert via epoch → Feb 28 in Berlin.
      // Fixed code: must preserve March 1.
      final singapore = tz.getLocation('Asia/Singapore');
      final berlin = tz.getLocation('Europe/Berlin');
      final source = tz.TZDateTime(singapore, 2027, 3);

      final normalized = normalizeDate(source, location: berlin);

      expect(normalized, isA<tz.TZDateTime>());
      expect((normalized as tz.TZDateTime).location, berlin);
      expect(normalized.year, 2027);
      expect(normalized.month, 3);
      expect(normalized.day, 1);
      expect(normalized.hour, 0);
    });

    test(
        'Preserves calendar date when source TZ is behind target TZ (cross-timezone date shift)',
        () {
      // Simulates: device in America/Los_Angeles (UTC-8), app TZ = Asia/Tokyo (UTC+9).
      // TZDateTime(la, 2027, 1, 1, 23, 0) at 11 PM PST = Jan 2 07:00 UTC.
      // Old code: TZDateTime.from() would convert via epoch → Jan 2 in Tokyo.
      // Fixed code: must preserve January 1.
      final la = tz.getLocation('America/Los_Angeles');
      final tokyo = tz.getLocation('Asia/Tokyo');
      final source = tz.TZDateTime(la, 2027, 1, 1, 23);

      final normalized = normalizeDate(source, location: tokyo);

      expect(normalized, isA<tz.TZDateTime>());
      expect((normalized as tz.TZDateTime).location, tokyo);
      expect(normalized.year, 2027);
      expect(normalized.month, 1);
      expect(normalized.day, 1);
      expect(normalized.hour, 0);
    });

    test('Preserves calendar date at month boundary (last day of month)', () {
      // March 31 in a far-ahead TZ, targeted to a far-behind TZ.
      // Epoch conversion could shift to March 30.
      final tokyo = tz.getLocation('Asia/Tokyo');
      final honolulu = tz.getLocation('Pacific/Honolulu');
      final source = tz.TZDateTime(tokyo, 2027, 3, 31);

      final normalized = normalizeDate(source, location: honolulu);

      expect(normalized, isA<tz.TZDateTime>());
      expect(normalized.year, 2027);
      expect(normalized.month, 3);
      expect(normalized.day, 31);
      expect(normalized.hour, 0);
    });

    test('Preserves calendar date at year boundary (Jan 1 vs Dec 31)', () {
      final tokyo = tz.getLocation('Asia/Tokyo');
      final newYork = tz.getLocation('America/New_York');
      // Jan 1 00:00 JST = Dec 31 10:00 EST via epoch
      final source = tz.TZDateTime(tokyo, 2027);

      final normalized = normalizeDate(source, location: newYork);

      expect(normalized, isA<tz.TZDateTime>());
      expect(normalized.year, 2027);
      expect(normalized.month, 1);
      expect(normalized.day, 1);
      expect(normalized.hour, 0);
    });

    test('Preserves calendar date with plain DateTime and explicit location',
        () {
      // Plain DateTime(2027, 3, 1) — its epoch depends on device TZ.
      // With our fix, we use .year/.month/.day directly, so it always stays March 1.
      final berlin = tz.getLocation('Europe/Berlin');
      final source = DateTime(2027, 3);

      final normalized = normalizeDate(source, location: berlin);

      expect(normalized, isA<tz.TZDateTime>());
      expect(normalized.year, 2027);
      expect(normalized.month, 3);
      expect(normalized.day, 1);
      expect(normalized.hour, 0);
    });
  });

  group('getWeekdayNumber() tests:', () {
    test('Monday returns number 1', () {
      expect(getWeekdayNumber(StartingDayOfWeek.monday), 1);
    });

    test('Tuesday returns number 2', () {
      expect(getWeekdayNumber(StartingDayOfWeek.tuesday), 2);
    });

    test('Wednesday returns number 3', () {
      expect(getWeekdayNumber(StartingDayOfWeek.wednesday), 3);
    });

    test('Saturday returns number 6', () {
      expect(getWeekdayNumber(StartingDayOfWeek.saturday), 6);
    });

    test('Sunday returns number 7', () {
      expect(getWeekdayNumber(StartingDayOfWeek.sunday), 7);
    });

    test('All days return sequential 1-7', () {
      for (int i = 0; i < StartingDayOfWeek.values.length; i++) {
        expect(getWeekdayNumber(StartingDayOfWeek.values[i]), i + 1);
      }
    });
  });
}
