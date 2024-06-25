
import 'package:flutter_video_community/data/repository/game/game_repository.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:get/get.dart';

class GamePlayLogic extends GetxController {

  final RxString gameUrl = RxString('');
  final GameRepository _gameRepo = Global.getIt<GameRepository>();


  void requestGameUrl(String? code) async {
    if (AppTool.isEmpty(code)) {
      return;
    }
    try {
      final dataMap = <String, dynamic>{
        'code': code,
      };
      final resp = await _gameRepo.gameUrl(dataMap);
      gameUrl.value = resp;
    } catch (error) {
    }
  }

}