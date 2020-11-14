import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class NavigationEvent {}

class PagePushed extends NavigationEvent {
  final Page<dynamic> page;

  PagePushed(this.page);
}

class PagePopped extends NavigationEvent {}

class NavigationBloc extends Bloc<NavigationEvent, List<Page<dynamic>>> {
  NavigationBloc() : super([ColorPage(depth: 0)]);

  @override
  Stream<List<Page>> mapEventToState(NavigationEvent event) async* {
    if (event is PagePushed) {
      yield [...state, event.page];
    } else if (event is PagePopped) {
      if (state.length > 1) {
        yield [...state]..removeLast();
      }
    }
  }
}

void main() {
  runApp(
    MaterialApp(
      home: BlocProvider(
        create: (context) => NavigationBloc(),
        child: BlocBuilder<NavigationBloc, List<Page<dynamic>>>(
          builder: (context, state) {
            return Navigator(
              pages: state,
              onPopPage: (route, result) {
                final didPop = route.didPop(result);
                if (!didPop) {
                  return false;
                }

                context.read<NavigationBloc>().add(PagePopped());

                return true;
              },
            );
          },
        ),
      ),
    ),
  );
}

class ColorPage extends Page<void> {
  final int depth;

  ColorPage({@required this.depth});

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute<void>(
      settings: this,
      builder: (context) => Scaffold(
        body: SafeArea(
          child: _Page(
            depth: depth,
          ),
        ),
      ),
    );
  }
}

class _Page extends StatelessWidget {
  final int depth;

  const _Page({@required this.depth});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _NavigationControls(
          onPreviousPressed: () {
            final navigatorState = Navigator.of(context);
            if (navigatorState.canPop()) {
              navigatorState.pop();
            }
          },
          onNextPressed: () {
            context
                .read<NavigationBloc>()
                .add(PagePushed(ColorPage(depth: depth + 1)));
          },
        ),
        Expanded(
          child: _ColorWidget(depth: depth),
        ),
      ],
    );
  }
}

class _NavigationControls extends StatelessWidget {
  final VoidCallback onPreviousPressed;
  final VoidCallback onNextPressed;

  const _NavigationControls({
    this.onPreviousPressed,
    this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (onPreviousPressed != null)
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: onPreviousPressed,
          ),
        if (onNextPressed != null)
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: onNextPressed,
          ),
      ],
    );
  }
}

class _ColorWidget extends StatelessWidget {
  final int depth;

  const _ColorWidget({@required this.depth});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _colorGenerator[depth],
      child: Center(
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Text('$depth'),
        ),
      ),
    );
  }
}

// #region colors

class _ColorGenerator {
  static const colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.pink,
    Colors.lime,
    Colors.cyan,
    Colors.orange,
  ];

  Color operator [](int index) {
    assert(index >= 0);
    return colors[index % colors.length];
  }
}

final _colorGenerator = _ColorGenerator();

// #endregion
