import 'dart:async';

import 'package:clock/clock.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test_app/tasks.dart';
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

  test('calculation finishes with currect result', () async {
    final result = await calculate(3);

    expect(result, 42);
  });

  test('calculation finishes with correct result but much faster', () {
    int seconds = 365 * 24 * 60 * 60;
    final result = fakeAsync((fakeAsync) {
      print('### fake async start: ${clock.now()}');
      int futureResult;
      calculate(seconds).then((value) {
        futureResult = value;
      });
      fakeAsync.elapse(Duration(seconds: seconds));
      print('### fake async stop: ${clock.now()}');

      return futureResult;
    });

    expect(result, 42);
  });
}
