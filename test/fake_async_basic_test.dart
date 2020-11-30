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

  test('in & out and in & out of fake async', () async {
    Object result = fakeAsync((fakeAsync) {
      final delay = Duration(days: 365);

      final slowTask = Future.delayed(delay);
      expectLater(slowTask, completes);

      fakeAsync.elapse(delay);

      return 666;
    });
    expect(result, 666);

    result = fakeAsync((fakeAsync) {
      final delay = Duration(days: result);

      final slowTask = Future.delayed(delay);
      expectLater(slowTask, completes);

      fakeAsync.elapse(delay);

      return true;
    });
    expect(result, isTrue);
  });
}
