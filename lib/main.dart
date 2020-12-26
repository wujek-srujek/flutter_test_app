import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: _Pager<void>(
            nextRoute: (depth) {
              return _pageRouteBuilder(
                (_) => Column(
                  children: [
                    Expanded(
                      child: _Page(depth: depth),
                    ),
                    Expanded(
                      child: _Pager<void>(
                        nextRoute: (depth) {
                          return _pageRouteBuilder(
                            (_) => FittedBox(child: Text('$depth')),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    ),
  );
}

PageRouteBuilder<T> _pageRouteBuilder<T>(WidgetBuilder builder) {
  return PageRouteBuilder(
    // transitionDuration: Duration(seconds: 3),
    // reverseTransitionDuration: Duration(seconds: 3),
    pageBuilder: (context, animation, secondaryAnimation) {
      return builder(context);
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: Offset(1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset.zero,
            end: Offset(-1, 0),
          ).animate(secondaryAnimation),
          child: child,
        ),
      );
    },
  );
}

class _Page extends StatelessWidget {
  final int depth;

  const _Page({@required this.depth});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _ColorWidget(depth: depth),
        ),
      ],
    );
  }
}

class _Pager<T> extends StatefulWidget {
  final Route<T> Function(int) nextRoute;

  _Pager({@required this.nextRoute});

  @override
  _PagerState<T> createState() => _PagerState<T>();
}

class _PagerState<T> extends State<_Pager<T>> {
  final navigatorKey = GlobalKey<NavigatorState>();

  int depth;

  @override
  void initState() {
    super.initState();
    depth = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            depth > 0
                ? IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      final navigatorState = navigatorKey.currentState;
                      if (navigatorState.canPop()) {
                        setState(() {
                          --depth;
                        });
                        navigatorState.pop();
                      }
                    },
                  )
                : SizedBox.shrink(),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                setState(() {
                  ++depth;
                });
                navigatorKey.currentState.pushNamed<T>(
                  '/next',
                );
              },
            ),
          ],
        ),
        Expanded(
          child: Navigator(
            key: navigatorKey,
            onGenerateRoute: (settings) {
              return widget.nextRoute(depth);
            },
          ),
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
