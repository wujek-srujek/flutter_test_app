import 'dart:async';

Future<int> calculate(int seconds) async {
  print('### ${DateTime.now()} calculation will start');
  await Future.delayed(Duration(seconds: seconds));
  print('### ${DateTime.now()} calculation finished');
  return 42;
}
