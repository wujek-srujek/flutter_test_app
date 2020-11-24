import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class CountData extends ValueNotifier<int> {
  CountData(int value) : super(value);
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  CountData countData;

  @override
  void initState() {
    super.initState();
    countData = CountData(0);
  }

  @override
  void dispose() {
    super.dispose();
    countData.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CounterWidget(countData: countData),
            Divider(color: Colors.black, thickness: 8),
            DescendantLevel1(countData: countData),
          ],
        ),
      ),
    );
  }
}

class CounterWidget extends StatelessWidget {
  final CountData countData;

  const CounterWidget({@required this.countData});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            '${countData.value}',
            style: Theme.of(context).textTheme.headline2,
          ),
          FloatingActionButton(
            onPressed: () {
              ++countData.value;
            },
            child: Icon(Icons.add),
          )
        ],
      ),
    );
  }
}

class DescendantLevel1 extends StatelessWidget {
  final CountData countData;

  const DescendantLevel1({@required this.countData});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: DescendantLevel2(countData: countData),
      ),
    );
  }
}

class DescendantLevel2 extends StatelessWidget {
  final CountData countData;

  const DescendantLevel2({@required this.countData});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: DescendantLevel3(countData: countData),
      ),
    );
  }
}

class DescendantLevel3 extends StatelessWidget {
  final CountData countData;

  const DescendantLevel3({@required this.countData});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          color: Colors.white,
          child: Text(
            '${countData.value}',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
      ),
    );
  }
}
