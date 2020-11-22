import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool redFirst;

  @override
  void initState() {
    super.initState();
    redFirst = true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.swap_vert),
                onPressed: () {
                  setState(() {
                    redFirst = !redFirst;
                  });
                  final scaffoldState = Scaffold.of(context);
                  scaffoldState.hideCurrentSnackBar();
                  scaffoldState.showSnackBar(
                    SnackBar(content: Text('Swapped')),
                  );
                },
              ),
            ),
          ],
        ),
        body: Column(
          children: redFirst
              ? [
                  CounterWidget(color: Colors.red),
                  CounterWidget(color: Colors.green),
                ]
              : [
                  CounterWidget(color: Colors.green),
                  CounterWidget(color: Colors.red),
                ],
        ),
      ),
    );
  }
}

class CounterWidget extends StatefulWidget {
  final Color color;

  const CounterWidget({this.color});

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
      color: widget.color,
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
