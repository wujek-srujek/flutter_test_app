import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CounterWidget(),
            Divider(color: Colors.black, thickness: 8),
            DescendantLevel1(),
          ],
        ),
      ),
    );
  }
}

class CounterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            '<count>',
            style: Theme.of(context).textTheme.headline2,
          ),
          FloatingActionButton(
            onPressed: () {},
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
    return Container(
      alignment: Alignment.center,
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          color: Colors.white,
          child: Text(
            '<count>',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
      ),
    );
  }
}
