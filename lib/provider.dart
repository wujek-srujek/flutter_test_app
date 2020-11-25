import 'package:flutter/material.dart';

class ValueNotifierProvider<T> extends StatefulWidget {
  final ValueNotifier<T> Function(BuildContext) create;
  final Widget child;

  const ValueNotifierProvider({
    @required this.create,
    @required this.child,
  });

  @override
  _ValueNotifierProviderState<T> createState() =>
      _ValueNotifierProviderState<T>();

  static ValueNotifier<T> of<T>(BuildContext context) {
    final inheritedNotifier = context.dependOnInheritedWidgetOfExactType<
        _InheritedValueNotifierProvider<T>>();
    if (inheritedNotifier == null) {
      throw ArgumentError('Requested data not found in context.');
    }

    return inheritedNotifier.notifier;
  }
}

class _ValueNotifierProviderState<T> extends State<ValueNotifierProvider<T>> {
  ValueNotifier<T> notifier;

  @override
  void initState() {
    super.initState();
    notifier = widget.create(context);
  }

  @override
  void dispose() {
    super.dispose();
    notifier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedValueNotifierProvider(
      valueNotifier: notifier,
      child: widget.child,
    );
  }
}

class _InheritedValueNotifierProvider<T>
    extends InheritedNotifier<ValueNotifier<T>> {
  _InheritedValueNotifierProvider({
    @required ValueNotifier<T> valueNotifier,
    @required Widget child,
  }) : super(child: child, notifier: valueNotifier);
}
