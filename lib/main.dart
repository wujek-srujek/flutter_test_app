import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => UsersBloc(
          IdClient(),
          ColorClient(),
        ),
        child: Scaffold(
          appBar: AppBar(),
          body: Page(),
        ),
      ),
    );
  }
}

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              context.read<UsersBloc>().add(UsersRequested());
            },
            child: Text('Load data'),
          ),
          Expanded(
            child: BlocBuilder<UsersBloc, UsersState>(
              builder: (context, state) {
                if (state is UsersLoadingSuccess) {
                  final users = state.users;
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];

                      return ListTile(
                        leading: Container(
                          height: 50,
                          width: 50,
                          color: user.image,
                        ),
                        title: Text(user.id),
                      );
                    },
                  );
                } else if (state is UsersLoadingInProgress) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ==============================

class User {
  final String id;
  final Color image;

  User(this.id, this.image);
}

final _random = Random();

DateTime get t => DateTime.now();

// UsersBloc ==============================

// Events

var _eventNumber = 0;

abstract class UsersEvent {}

class UsersRequested extends UsersEvent {
  final tag = 'E${++_eventNumber}';

  @override
  String toString() {
    return '$runtimeType $tag';
  }
}

// States

abstract class UsersState {
  final String eventTag;

  UsersState(this.eventTag);

  @override
  String toString() {
    return '$runtimeType $eventTag';
  }
}

class UsersInitial extends UsersState {
  UsersInitial(String eventTag) : super(eventTag);
}

class UsersLoadingInProgress extends UsersState {
  UsersLoadingInProgress(String eventTag) : super(eventTag);
}

class UsersLoadingSuccess extends UsersState {
  final List<User> users;

  UsersLoadingSuccess(String eventTag, this.users) : super(eventTag);
}

// BLoC

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final IdClient _idClient;
  final ColorClient _colorClient;

  UsersBloc(this._idClient, this._colorClient)
      : super(UsersInitial('<initial>'));

  @override
  Stream<UsersState> mapEventToState(UsersEvent event) async* {
    if (event is UsersRequested) {
      // await Future.delayed(Duration(milliseconds: 100));
      yield UsersLoadingInProgress(event.tag);

      final count = _random.nextInt(5) + 5;

      final loadedIds = await _idClient.loadIds(count);

      final loadedColors = await _colorClient.loadColors(count, event.tag);

      if (state is! UsersLoadingInProgress) {
        throw 'Oh noes, inconsistent state for event [$event]!';
      }
      if (loadedIds.length != loadedColors.length) {
        throw 'Oh noes, inconsistent lengths for event [$event]!';
      }

      final users = List.generate(loadedIds.length, (index) {
        return User(loadedIds[index], loadedColors[index]);
      });

      yield UsersLoadingSuccess(event.tag, users);
    }
  }

  @override
  void onEvent(UsersEvent event) {
    print('### [$t] added new event [$event], current state [$state]');
  }

  @override
  void onTransition(UsersState state, UsersState newState) {
    print('### [$t] yielding new state [$newState]');
  }
}

// Clients ==============================

class IdClient {
  Future<List<String>> loadIds(int count) async {
    await Future.delayed(Duration(milliseconds: 500));

    return List.generate(
      count,
      (_) => '${_random.nextInt(100000) + 100000}',
    );
  }
}

class ColorClient {
  final client = HttpClient();

  Future<List<Color>> loadColors(int count, String eventTag) async {
    final request = await client.getUrl(
      Uri.parse('http://localhost:42666?count=$count&eventTag=$eventTag'),
    );
    final response = await request.close();
    // No error handling, please forgive me, that's not the point here.
    final data = (await ascii.decoder.bind(response).join()).trim();

    return data.split('\n').map((colorLine) {
      final argb = colorLine.split(',').map((part) {
        return int.parse(part);
      }).toList();
      return Color.fromARGB(argb[0], argb[1], argb[2], argb[3]);
    }).toList();
  }
}

// Poor man's BLoC ==============================

// Bloc

abstract class Bloc<E, S> {
  final StreamController<E> _events = StreamController<E>();
  final StreamController<S> _states = StreamController<S>();

  StreamSubscription<S> _statesSubscription;
  S _state;

  Bloc(this._state) {
    final statesStream = transformEvents(
      _events.stream.doOnData(onEvent),
      mapEventToState,
    );
    final transformedStatesStream =
        transformStates(statesStream).distinct().doOnData((newState) {
      onTransition(_state, newState);
    });
    _statesSubscription = transformedStatesStream.listen((newState) {
      _state = newState;
      _states.add(_state);
    });
  }

  @mustCallSuper
  Future<void> close() async {
    await _events.close();
    await _states.close();
    return _statesSubscription.cancel();
  }

  void add(E event) {
    _events.add(event);
  }

  S get state => _state;

  Stream<S> get states => _states.stream;

  @visibleForOverriding
  Stream<S> transformEvents(
    Stream<E> events,
    Stream<S> Function(E) convert,
  ) {
    // By default, events are processed sequentially to completion.
    return events.asyncExpand(convert);
  }

  @visibleForOverriding
  Stream<S> transformStates(Stream<S> statesStream) {
    // By default, states are not processed.
    return statesStream;
  }

  @visibleForOverriding
  void onEvent(E event) {}

  @visibleForOverriding
  void onTransition(S state, S newState) {}

  @visibleForOverriding
  Stream<S> mapEventToState(E event);
}

// BlocProvider

class BlocProvider<B extends Bloc<dynamic, dynamic>> extends StatelessWidget {
  final B Function(BuildContext context) create;
  final Widget child;

  const BlocProvider({
    @required this.create,
    @required this.child,
  })  : assert(create != null),
        assert(child != null);

  @override
  Widget build(BuildContext context) {
    return Provider<B>(
      create: create,
      dispose: (context, bloc) {
        bloc?.close();
      },
      child: child,
    );
  }
}

// BlocBuilder

class BlocBuilder<B extends Bloc<dynamic, S>, S> extends StatefulWidget {
  final Widget Function(BuildContext, S) builder;

  const BlocBuilder({@required this.builder});

  @override
  _BlocBuilderState<B, S> createState() => _BlocBuilderState<B, S>();
}

class _BlocBuilderState<B extends Bloc<dynamic, S>, S>
    extends State<BlocBuilder<B, S>> {
  B bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.read<B>();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<S>(
      initialData: bloc.state,
      stream: bloc.states,
      builder: (context, snapshot) {
        return widget.builder(context, snapshot.data);
      },
    );
  }
}
