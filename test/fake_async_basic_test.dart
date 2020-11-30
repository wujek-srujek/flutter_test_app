import 'dart:async';

import 'package:clock/clock.dart';
import 'package:fake_async/fake_async.dart';
import 'package:test/test.dart';

void main() {
  test('time-dependent tests runs slow', () {
    final slowTask = Future.delayed(Duration(seconds: 3));
    expectLater(slowTask, completes);
  });

  test('fake async makes time-dependent test run fast', () {
    fakeAsync((fakeAsync) {
      print(clock.now());
      final delay = Duration(days: 365);

      final slowTask = Future.delayed(delay);
      expectLater(slowTask, completes);

      fakeAsync.elapse(delay);

      print(clock.now());
    });
  });
}
