import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MaterialApp(home: App()));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24),
        child: BlocProvider(
          create: (context) => BlahBloc(),
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
              RemoteCamerasSnackBarShowingElevatedButtonWhichExistsOnlyToGetABuildContext(),
            ],
          ),
        ),
      ),
    );
  }
}

class RemoteCamerasSnackBarShowingElevatedButtonWhichExistsOnlyToGetABuildContext
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showSnackBar(context, 'Widget'),
      child: Text('Widget'),
    );
  }
}

void _showSnackBar(BuildContext context, String text) {
  final state = BlocProvider.of<BlahBloc>(context).state;
  final scaffoldState = Scaffold.of(context);
  scaffoldState.hideCurrentSnackBar();
  scaffoldState.showSnackBar(SnackBar(content: Text('$text $state')));
}

// ------------------------------

class BlahBloc extends Bloc<void, String> {
  @override
  String get initialState => 'BLoC found';

  @override
  Stream<String> mapEventToState(void _) async* {}
}
