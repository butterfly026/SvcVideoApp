import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_video_community/data/repository/index/index_repository.dart';
import 'package:flutter_video_community/utils/cache.dart';

class EquityTimeCubit extends Cubit<Duration> {
  EquityTimeCubit(Duration duration) : super(duration) {
    startCountdown(duration);
  }

  StreamSubscription<int>? _streamSubscription;

  Future<void> startCountdown(Duration duration) async {
    final countdownSeconds = duration.inSeconds;
    _streamSubscription?.cancel();
    _streamSubscription = Stream.periodic(
      const Duration(seconds: 1),
      (x) {
        return countdownSeconds - x - 1;
      },
    ).take(countdownSeconds).listen((value) {
      final loginModel = Cache.getInstance().login;
      if (null != loginModel) {
        loginModel.newUserEquityTime = value;
        IndexRepository().persistLoginResult(loginModel);
      }
      emit(
        Duration(seconds: value),
      );
    });
  }

  Future<void> cancel() async {
    _streamSubscription?.cancel();
  }

  @override
  Future<void> close() {
    cancel();
    return super.close();
  }
}
