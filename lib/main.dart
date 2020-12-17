import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

      print('### [$t] before loadColors() for event [${event.tag}]');
      final loadedColors = await _colorClient.loadColors(count, event.tag);
      print('### [$t] after loadColors() for event [${event.tag}]');
      if (loadedColors == null) {
        // Request cancelled, nothing to do.
        print('### [$t] early exit for aborted event [${event.tag}]');
        return;
      }

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
  Stream<Transition<UsersEvent, UsersState>> transformEvents(
    Stream<UsersEvent> events,
    transitionFn,
  ) {
    return events.switchMap(transitionFn);
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
  Future<List<String>> loadIds(int count) async {
    await Future.delayed(Duration(milliseconds: 500));

    return List.generate(
      count,
      (_) => '${_random.nextInt(100000) + 100000}',
    );
  }
}

class _CancellationSentinel {}

class ColorClient {
  final client = HttpClient();

  HttpClientRequest _currentRequest;

  Future<List<Color>> loadColors(int count, String eventTag) async {
    print('### [$t] loadColors() for event [$eventTag] start');
    _currentRequest?.abort(_CancellationSentinel());
    _currentRequest = await client.getUrl(
      Uri.parse('http://localhost:42666?count=$count&eventTag=$eventTag'),
    );
    HttpClientResponse response;
    try {
      response = await _currentRequest.close();
    } on _CancellationSentinel {
      print('### [$t] loadColors() for event [$eventTag] aborted');
      return null;
    }
    // No error handling, please forgive me, that's not the point here.
    final data = (await ascii.decoder.bind(response).join()).trim();

    print('### [$t] loadColors() for event [$eventTag] end');
    return data.split('\n').map((colorLine) {
      final argb = colorLine.split(',').map((part) {
        return int.parse(part);
      }).toList();
      return Color.fromARGB(argb[0], argb[1], argb[2], argb[3]);
    }).toList();
  }
}
