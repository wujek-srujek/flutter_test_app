import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TabbedPage(),
    );
  }
}

const kSleepDuration = Duration(seconds: 3);

class TabbedPage extends StatefulWidget {
  @override
  _TabbedPageState createState() => _TabbedPageState();
}

class _TabbedPageState extends State<TabbedPage>
    with SingleTickerProviderStateMixin {
  final List<Tab> tabs = [
    Tab(text: 'LEFT'),
    Tab(text: 'RIGHT'),
  ];

  TabController tabController;

  bool funky;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: tabs.length);
    funky = false;
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: tabController,
          tabs: tabs,
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: tabs.map((tab) {
          final side = tab.text;
          return Container(
            color: funky ? Colors.yellow : Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'This is the $side tab',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await Future.delayed(kSleepDuration);
                    setState(() {
                      funky = !funky;
                    });
                  },
                  child: Text('Press me'),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
