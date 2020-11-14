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
  final overlayKey = GlobalKey<OverlayState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: toggleOverlay,
          child: Text('Toggle overlay'),
        ),
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              height: 200,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: widget.overlayColor),
              ),
              height: 150,
              width: 150,
              child: Overlay(key: overlayKey),
            ),
            Container(
              color: Colors.cyan,
              height: 50,
              width: 50,
            ),
          ],
        ),
      ],
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
    overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          child: Container(
            color: widget.overlayColor,
          ),
        );
      },
    );

    overlayKey.currentState.insert(overlayEntry);

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
