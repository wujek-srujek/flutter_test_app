import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool showsSubtitle;

  @override
  void initState() {
    super.initState();
    showsSubtitle = false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.replay),
                onPressed: () {
                  setState(() {
                    showsSubtitle = !showsSubtitle;
                  });
                  final scaffoldState = Scaffold.of(context);
                  scaffoldState.hideCurrentSnackBar();
                  scaffoldState.showSnackBar(
                    SnackBar(content: Text('Reloaded')),
                  );
                },
              ),
            ),
          ],
        ),
        body: Column(
          children: showsSubtitle
              ? [
                  CounterWidget(),
                  Text('Blah', style: Theme.of(context).textTheme.headline4),
                ]
              : [
                  CounterWidget(),
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
  }

  @override
  Widget build(BuildContext context) {
    print('### _CounterWidgetState.build()');
    return Center(
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
    );
  }
}
