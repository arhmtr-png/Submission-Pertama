import 'package:flutter_test/flutter_test.dart';
Duration delayToNext11am(DateTime now) {
  final today11 = DateTime(now.year, now.month, now.day, 11);
  final next = now.isBefore(today11)
      ? today11
      : today11.add(const Duration(days: 1));
  return next.difference(now);
}

void main() {
  test('initialDelay when before 11am', () {
    final now = DateTime(2025, 10, 13, 9, 30); // 9:30
    final d = delayToNext11am(now);
    expect(d.inHours, equals(1));
    expect(d.inMinutes % 60, equals(30));
  });

  test('initialDelay when after 11am', () {
    final now = DateTime(2025, 10, 13, 11, 0); // exactly 11:00 -> next day
    final d = delayToNext11am(now);
    expect(d.inHours, equals(24));
  });

  test('initialDelay late at night', () {
    final now = DateTime(2025, 10, 13, 23, 15); // 23:15
    final d = delayToNext11am(now);
    expect(d.inHours, equals(11));
    expect(d.inMinutes % 60, equals(45));
  });
}
