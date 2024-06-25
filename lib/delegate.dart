// ignore_for_file: always_specify_types, strict_raw_type, noop_primitive_operations

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'utils/console.dart';

/// An interface for observing the behavior of [Bloc] instances.
class RhObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    Console.logD(
      'currentState ${transition.currentState} nextState ${transition.nextState}',
    );
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    Console.logD('${bloc.toString()} ${event.toString()}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    Zone.current.handleUncaughtError(error, stackTrace);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    Console.logD('${bloc.runtimeType} $change');
  }
}
