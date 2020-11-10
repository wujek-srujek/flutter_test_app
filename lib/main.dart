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
            Builder(
              builder: (subContext) => ElevatedButton(
                onPressed: () => _showSnackBar(subContext, 'Inline'),
                child: Text('Inline'),
              ),
            ),
            _createButton(),
          ],
        ),
      ),
    );
  }
}

Widget _createButton() {
  return Builder(
    builder: (subContext) => ElevatedButton(
      onPressed: () => _showSnackBar(subContext, 'Functional'),
      child: Text('Functional'),
    ),
  );
}

void _showSnackBar(BuildContext context, String text) {
  final scaffoldState = Scaffold.of(context);
  scaffoldState.hideCurrentSnackBar();
  scaffoldState.showSnackBar(SnackBar(content: Text(text)));
}
