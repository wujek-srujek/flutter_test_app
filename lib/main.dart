import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool showCounterFirst;

  @override
  void initState() {
    super.initState();
    showCounterFirst = true;
  }

  @override
  Widget build(BuildContext context) {
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
            IconButton(
              icon: Icon(Icons.swap_vert),
              onPressed: () {
                setState(() {
                  showCounterFirst = !showCounterFirst;
                });
              },
            ),
          ],
        ),
        body: Column(
          children: showCounterFirst
              ? [
                  CounterWidget(),
                  Text('Blabla', style: Theme.of(context).textTheme.headline4),
                ]
              : [
                  Text('Blabla', style: Theme.of(context).textTheme.headline4),
                  CounterWidget(),
                ],
        ),
      ),
    );
  }
}

class CounterWidget extends StatefulWidget {
  const CounterWidget({Key key}) : super(key: key);

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
