import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: App()));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => _showSnackBar(context, 'Inline'),
              child: Text('Inline'),
            ),
            _createButton(context),
          ],
        ),
      ),
    );
  }
}

Widget _createButton(BuildContext context) {
  return ElevatedButton(
    onPressed: () => _showSnackBar(context, 'Functional'),
    child: Text('Functional'),
  );
}

void _showSnackBar(BuildContext context, String text) {
  final scaffoldState = Scaffold.of(context);
  scaffoldState.hideCurrentSnackBar();
  scaffoldState.showSnackBar(SnackBar(content: Text(text)));
}
