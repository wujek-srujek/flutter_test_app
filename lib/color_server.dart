import 'dart:io';
import 'dart:math';

DateTime get t => DateTime.now();

Future main(List<String> arguments) async {
  int latency;
  if (arguments.isNotEmpty) {
    latency = int.parse(arguments.first);
  } else {
    latency = 500;
  }

  final server = await HttpServer.bind(
    InternetAddress.loopbackIPv4,
    42666,
  );
  print('Listening on localhost:${server.port}');
  print('Latency: $latency ms');

  final r = Random();

  await for (HttpRequest request in server) {
    final params = request.uri.queryParameters;
    final eventTag = params['eventTag'] ?? '<unknown>';
    print('[$t] event [$eventTag] start');

    int count;
    try {
      count = int.parse(params['count']);
    } catch (e, s) {
      print('[$t] event [$eventTag] failed with $e: $s');
    }

    if (count == null) {
      print('[$t] event [$eventTag] failed without valid \'count\'');
      request.response.statusCode = 404;
    } else if (count < 0) {
      print('[$t] event [$eventTag] failed with negative \'count\' $count');
      request.response.statusCode = 404;
    } else {
      for (var i = 0; i < count; ++i) {
        request.response.writeln(
          '255,${r.nextInt(256)},${r.nextInt(256)},${r.nextInt(256)}',
        );
      }
    }

    // Add artificial latency.
    await Future.delayed(Duration(milliseconds: latency));

    print('[$t] event [$eventTag] for [$count] images end');

    await request.response.close();
  }
}
