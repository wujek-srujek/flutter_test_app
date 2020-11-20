import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final firstCounterKey = Key('first_counter_key');
  final secondCounterKey = Key('second_counter_key');

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Key topKey;
  Key bottomKey;

  @override
  void initState() {
    super.initState();
    topKey = firstCounterKey;
    bottomKey = secondCounterKey;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.swap_vert),
              onPressed: () {
                setState(() {
                  final tmp = topKey;
                  topKey = bottomKey;
                  bottomKey = tmp;
                });
                final scaffoldState = scaffoldKey.currentState;
                scaffoldState.hideCurrentSnackBar();
                scaffoldState.showSnackBar(
                  SnackBar(content: Text('Swapped')),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            CounterWidget(key: topKey),
            CounterWidget(key: bottomKey),
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
