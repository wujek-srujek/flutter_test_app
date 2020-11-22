import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    print('### _AppState.build()');
    final counterWidget = CounterWidget();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {});
              },
            ),
          ],
        ),
        body: Column(
          children: [
            counterWidget,
            StreamBuilder<int>(
              stream: counterWidget.currentCount,
              builder: (context, snapshot) {
                return Text('Current count is: ${snapshot.data}');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CounterWidget extends StatefulWidget {
  final _CounterWidgetState _state;

  CounterWidget() : _state = _CounterWidgetState();

  @override
  _CounterWidgetState createState() => _state;

  Stream<int> get currentCount => _state.controller.stream;
}

class _CounterWidgetState extends State<CounterWidget> {
  int count;
  StreamController<int> controller = StreamController();

  @override
  void initState() {
    super.initState();
    count = 0;
    controller.sink.add(count);
    print('### $hashCode _CounterWidgetState.initState()');
  }

  @override
  void didUpdateWidget(covariant CounterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('### $hashCode _CounterWidgetState.didUpdateWidget()');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('### $hashCode _CounterWidgetState.didChangeDependencies()');
  }

  @override
  void deactivate() {
    super.deactivate();
    print('### $hashCode _CounterWidgetState.deactivate()');
  }

  @override
  void dispose() {
    super.dispose();
    controller.close();
    print('### $hashCode _CounterWidgetState.dispose()');
  }

  @override
  void reassemble() {
    super.reassemble();
    print('### _CounterWidgetState.reassemble()');
  }

  @override
  Widget build(BuildContext context) {
    print('### _CounterWidgetState.build()');
    return Container(
      child: Center(
        child: Column(
          children: [
            Text('$count', style: Theme.of(context).textTheme.headline2),
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  ++count;
                  controller.sink.add(count);
                });
              },
              child: Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }
}
