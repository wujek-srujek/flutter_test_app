import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

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
  StreamController<List<String>> loadedIdsController;

  @override
  void initState() {
    super.initState();
    loadedIdsController = StreamController();
  }

  @override
  void dispose() {
    loadedIdsController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => UsersBloc(
          ColorClient(),
          loadedIdsController.stream,
        ),
        child: Scaffold(
          appBar: AppBar(),
          body: Page(
            IdClient(),
            loadedIdsController.sink,
          ),
        ),
      ),
    );
  }
}

class Page extends StatelessWidget {
  final Sink<List<String>> loadedIdsSink;
  final IdClient idClient;

  Page(this.idClient, this.loadedIdsSink);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              final count = _random.nextInt(5) + 5;
              final loadedIds = idClient.loadIds(count);
              loadedIdsSink.add(loadedIds);
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
  final List<String> loadedIds;

  UsersRequested(this.loadedIds);

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
  final ColorClient _colorClient;

  StreamSubscription<List<String>> _loadedIdsSubscription;
  List<String> _loadedIds;

  UsersBloc(
    this._colorClient,
    Stream<List<String>> loadedIdsStream,
  ) : super(UsersInitial('<initial>')) {
    _loadedIdsSubscription = loadedIdsStream.listen((loadedIds) {
      add(UsersRequested(loadedIds));
    });
  }

  @override
  Future<void> close() async {
    await _loadedIdsSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<UsersState> mapEventToState(UsersEvent event) async* {
    if (event is UsersRequested) {
      // await Future.delayed(Duration(milliseconds: 100));
      yield UsersLoadingInProgress(event.tag);

      _loadedIds = event.loadedIds;

      final count = _loadedIds.length;

      final loadedColors = await _colorClient.loadColors(count, event.tag);

      if (state is! UsersLoadingInProgress) {
        throw 'Oh noes, inconsistent state for event [$event]!';
      }

      if (_loadedIds.length != loadedColors.length) {
        throw 'Oh noes, inconsistent lengths for event [$event]!';
      }

      final users = List.generate(_loadedIds.length, (index) {
        return User(_loadedIds[index], loadedColors[index]);
      });

      yield UsersLoadingSuccess(event.tag, users);
    }
  }

  @override
  void onEvent(UsersEvent event) {
    super.onEvent(event);
    print('### [$t] added new event [$event], current state [$state]');
  }

  @override
  void onTransition(Transition<UsersEvent, UsersState> transition) {
    super.onTransition(transition);
    print('### [$t] yielding new state [${transition.nextState}]');
  }
}

// Clients ==============================

class IdClient {
  List<String> loadIds(int count) {
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
