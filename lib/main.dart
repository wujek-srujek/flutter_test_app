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
        body: ValueListenableBuilder<int>(
          valueListenable: countData,
          builder: (context, value, child) {
            return InheritedCountData(
              countData: countData,
              child: child,
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CounterWidget(),
              Divider(color: Colors.black, thickness: 8),
              DescendantLevel1(),
            ],
          ),
        ),
      ),
    );
  }
}

class InheritedCountData extends InheritedWidget {
  final CountData countData;

  InheritedCountData({
    @required this.countData,
    @required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static CountData of(BuildContext context) {
    final inheritedData =
        context.dependOnInheritedWidgetOfExactType<InheritedCountData>();
    return inheritedData.countData;
  }
}

class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('### CounterWidget.didChangeDependencies()');
  }

  @override
  Widget build(BuildContext context) {
    print('### CounterWidget.build()');

    final countData = InheritedCountData.of(context);

    return Center(
      child: Column(
        children: [
          Text(
            '${countData.value}',
            style: Theme.of(context).textTheme.headline2,
          ),
          FloatingActionButton(
            onPressed: () => ++countData.value,
            child: Icon(Icons.add),
          )
        ],
      ),
    );
  }
}

class DescendantLevel1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('### DescendantLevel1.build()');

    return Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: DescendantLevel2(),
      ),
    );
  }
}

class DescendantLevel2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('### DescendantLevel2.build()');

    return Container(
      color: Colors.green,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: DescendantLevel3(),
      ),
    );
  }
}

class DescendantLevel3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('### DescendantLevel3.build()');

    final countData = InheritedCountData.of(context);

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
