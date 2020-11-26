import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListenableProvider(
        create: (context) => ValueNotifier(0),
        child: Scaffold(
          appBar: AppBar(
            title: CountText(large: false),
          ),
          body: Column(
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

class CounterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('### CounterWidget.build()');

    return Center(
      child: Column(
        children: [
          CountText(),
          Builder(
            builder: (context) {
              return FloatingActionButton(
                onPressed: () {
                  final countData = Provider.of<ValueNotifier<int>>(context);
                  ++countData.value;
                },
                child: Icon(Icons.add),
              );
            },
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

    return Container(
      alignment: Alignment.center,
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          color: Colors.white,
          child: CountText(),
        ),
      ),
    );
  }
}

class CountText extends StatelessWidget {
  final bool large;

  const CountText({this.large = true});

  @override
  Widget build(BuildContext context) {
    print('### $hashCode CountText.build()');

    final countData = Provider.of<ValueNotifier<int>>(context);

    return Text(
      '${countData.value}',
      style: large ? Theme.of(context).textTheme.headline2 : null,
    );
  }
}
