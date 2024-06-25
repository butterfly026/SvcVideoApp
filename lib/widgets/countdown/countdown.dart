import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountdownWidget extends StatelessWidget {
  const CountdownWidget({
    super.key,
    this.seconds = 60,
    required this.onComplete,
    this.childBuilder,
  });

  final int seconds;
  final Widget? Function(BuildContext context, int milliseconds)? childBuilder;
  final Function() onComplete;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CountdownCubit(seconds),
      child: BlocBuilder<CountdownCubit, int>(
        builder: (context, state) {
          if (state == 0) {
            Future.delayed(Duration.zero, () {
              onComplete.call();
            });
          }
          return childBuilder?.call(context, state) ??
              Text(
                '$state',
                style: Theme.of(context).textTheme.displayMedium,
              );
        },
      ),
    );
  }
}

class CountdownCubit extends Cubit<int> {
  CountdownCubit(this.countdownSeconds) : super(countdownSeconds) {
    startCountdown();
  }

  int countdownSeconds = 60;

  StreamSubscription<int>? _streamSubscription;

  Future<void> startCountdown() async {
    _streamSubscription?.cancel();
    _streamSubscription = Stream.periodic(
      const Duration(seconds: 1),
      (x) {
        return countdownSeconds - x - 1;
      },
    ).take(countdownSeconds).listen((duration) {
      emit(duration);
    });
  }

  Future<void> cancel() async {
    _streamSubscription?.cancel();
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}

class CountdownModel {
  CountdownModel({
    this.hour1 = 0,
    this.hour2 = 0,
    this.minutes1 = 0,
    this.minutes2 = 0,
    this.seconds1 = 0,
    this.seconds2 = 0,
    this.hours = 0,
    this.minutes = 0,
    this.seconds = 0,
  });

  static CountdownModel parse(Duration duration) {
    final int hours = duration.inHours % 24;
    final int minutes = duration.inMinutes % 60;
    final int seconds = duration.inSeconds % 60;
    final countdownModel = CountdownModel();

    countdownModel.hours = hours;
    countdownModel.minutes = minutes;
    countdownModel.seconds = seconds;

    // debugPrint('data time hours: $hours minutes: $minutes seconds: $seconds');

    if (hours >= 10) {
      final hoursList = '$hours'.split('');
      countdownModel.hour1 = int.parse(hoursList.first);
      countdownModel.hour2 = int.parse(hoursList.last);
    } else {
      countdownModel.hour1 = 0;
      countdownModel.hour2 = hours;
    }
    if (minutes >= 10) {
      final minutesList = '$minutes'.split('');
      countdownModel.minutes1 = int.parse(minutesList.first);
      countdownModel.minutes2 = int.parse(minutesList.last);
    } else {
      countdownModel.minutes1 = 0;
      countdownModel.minutes2 = minutes;
    }
    if (seconds >= 10) {
      final secondsList = '$seconds'.split('');
      countdownModel.seconds1 = int.parse(secondsList.first);
      countdownModel.seconds2 = int.parse(secondsList.last);
    } else {
      countdownModel.seconds1 = 0;
      countdownModel.seconds2 = seconds;
    }
    return countdownModel;
  }

  int hour1;
  int hour2;
  int minutes1;
  int minutes2;
  int seconds1;
  int seconds2;

  int hours;
  int minutes;
  int seconds;
}
