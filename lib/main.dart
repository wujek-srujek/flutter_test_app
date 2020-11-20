import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              icon: Icon(Icons.swap_vert),
              onPressed: () {
                setState(() {
                  showCounterFirst = !showCounterFirst;
                });
              },
            ),
          ],
        ),
        body: BlocProvider(
          create: (context) => CounterBloc(),
          child: Column(
            children: showCounterFirst
                ? [
                    CounterWidget(),
                    Text(
                      'Blah',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ]
                : [
                    Text(
                      'Blah',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    CounterWidget(),
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
    return Center(
      child: Column(
        children: [
          BlocBuilder<CounterBloc, int>(
            builder: (context, state) {
              return Text(
                '$state',
                style: Theme.of(context).textTheme.headline2,
              );
            },
          ),
          FloatingActionButton(
            onPressed: () {
              BlocProvider.of<CounterBloc>(context).add(IncrementedEvent());
            },
            child: Icon(Icons.add),
          )
        ],
      ),
    );
  }
}

// CounterBloc

class IncrementedEvent {}

class CounterBloc extends Bloc<IncrementedEvent, int> {
  @override
  int get initialState => 0;

  @override
  Stream<int> mapEventToState(IncrementedEvent event) async* {
    yield state + 1;
  }
}
