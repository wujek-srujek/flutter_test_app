import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    print('### _AppState.build()');
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
          ],
        ),
        body: LoggingCounterBlocProvider(
          create: (context) {
            print('### BlocProvider.create()');
            return CounterBloc();
          },
          child: CounterWidget(),
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

class LoggingCounterBlocProvider extends BlocProvider<CounterBloc> {
  LoggingCounterBlocProvider({ValueBuilder<CounterBloc> create, Widget child})
      : super(create: create, child: child) {
    print('### LoggingCounterBlocProvider()');
  }
}

class IncrementedEvent {}

class CounterBloc extends Bloc<IncrementedEvent, int> {
  CounterBloc() {
    print('### $hashCode CounterBloc()');
  }

  @override
  int get initialState => 0;

  @override
  Stream<int> mapEventToState(IncrementedEvent event) async* {
    print('### $hashCode CounterBloc.mapEventToState(${event.runtimeType})');
    yield state + 1;
  }
}
