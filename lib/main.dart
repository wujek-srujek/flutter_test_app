import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      onGenerateRoute: (settings) {
        return MaterialPageRoute<void>(
          builder: (context) => Scaffold(
            body: SafeArea(
              child: _Page(
                depth: settings.arguments as int ?? 0,
              ),
            ),
          ),
        );
      },
    ),
  );
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
            Navigator.of(context).pushNamed<void>(
              '/next',
              arguments: depth + 1,
            );
          },
        ),
        Expanded(
          child: _ColorWidget(depth: depth),
        ),
        Expanded(
          child: _NavigatorSubPage(),
        ),
      ],
    );
  }
}

class _NavigatorSubPage extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();

  Widget build(BuildContext context) {
    return Column(
      children: [
        _NavigationControls(
          onPreviousPressed: () {
            final navigatorState = navigatorKey.currentState;
            if (navigatorState.canPop()) {
              navigatorState.pop();
            }
          },
          onNextPressed: () {
            navigatorKey.currentState.pushNamed<void>(
              '/next',
              arguments: 0,
            );
          },
        ),
        Expanded(
          child: Navigator(
            key: navigatorKey,
            onGenerateRoute: (settings) {
              return route(0);
            },
          ),
        ),
      ],
    );
  }

  Route<void> route(int depth) {
    return MaterialPageRoute<void>(
      builder: (context) {
        return _ColorWidget(depth: depth);
      },
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
