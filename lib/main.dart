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
            counterWidget,
            counterWidget,
          ],
        ),
      ),
    );
  }
}

class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int count;

  @override
  void initState() {
    super.initState();
    count = 0;
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
