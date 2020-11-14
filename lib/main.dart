import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: App(overlayColor: Colors.red, bottom: true)));
}

class App extends StatelessWidget {
  final Color overlayColor;
  final bool bottom;

  const App({this.overlayColor, this.bottom});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Blah(overlayColor: overlayColor, bottom: bottom),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return App(overlayColor: Colors.green, bottom: false);
              },
            ),
          );
        },
      ),
    );
  }
}

class Blah extends StatefulWidget {
  final Color overlayColor;
  final bool bottom;

  const Blah({this.overlayColor, this.bottom});

  @override
  _BlahState createState() => _BlahState();
}

class _BlahState extends State<Blah> {
  OverlayEntry overlayEntry;
  Timer autoHideTimer;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: toggleOverlay,
      child: Text('Toggle overlay'),
    );
  }

  void toggleOverlay() {
    if (overlayEntry == null) {
      showOverlay();
    } else {
      hideOverlay();
    }
  }

  void showOverlay() {
    // #region calculations
    final size = context.size;
    final offset = MatrixUtils.transformPoint(
      context.findRenderObject().getTransformTo(null),
      Offset.zero,
    );
    final left = offset.dx;
    final top =
        widget.bottom ? offset.dy + size.height : offset.dy - size.height;
    // #endregion

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: top,
          left: left,
          child: Container(
            color: widget.overlayColor,
            width: size.width,
            height: size.height,
          ),
        );
      },
    );

    Navigator.of(context).overlay.insert(overlayEntry);

    autoHideTimer = Timer(Duration(seconds: 3), hideOverlay);
  }

  void hideOverlay() {
    if (overlayEntry != null) {
      autoHideTimer.cancel();
      autoHideTimer = null;
      overlayEntry.remove();
      overlayEntry = null;
    }
  }
}
