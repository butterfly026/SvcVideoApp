import 'package:flutter_video_community/data/models/game/game.dart';
import 'package:flutter_video_community/data/models/game/game_withdrawal_record.dart';
import 'package:flutter_video_community/data/models/index/user.dart';
import 'package:flutter_video_community/data/models/mine/order_history_model.dart';
import 'package:flutter_video_community/data/repository/game/game_api.dart';
import 'package:flutter_video_community/data/repository/index/index_repository.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/utils/cache_util.dart';

class GameRepository {
  final GameApi _api = GameApi();

  Future<List<GameWithdrawalRecordModel>> getGameWithdrawalRecord(int pageNum, int pageSize) async {
    final response = await _api.getGameWithdrawalRecord(pageNum, pageSize);
    List<GameWithdrawalRecordModel> orderHistoryList = [];
    final jsonList = response.data as List;
    for (final item in jsonList) {
      orderHistoryList.add(
        GameWithdrawalRecordModel.fromJson(item as Map<String, dynamic>),
      );
    }
    return orderHistoryList;
  }

  Future<GameModel> gameInfo() async {
    final response = await _api.gameInfo();
    final data = GameModel.fromJson(
      response.data as Map<String, dynamic>,
    );
    return data;
  }

  Future<String> gameBalance() async {
    Map<String, dynamic> dataMap = {};
    UserModel? user = CacheUtil.getUserInfoFromCache();
    if (user == null || AppTool.isEmpty(user.userId)) {
      return '';
    }
    dataMap['userId'] = user.userId;
    final response = await _api.gameBalance(dataMap);
    final balance = response.data as String?;
    return balance ?? '0.0';
  }

  Future<String> gameUrl(
    Map<String, dynamic> dataMap,
  ) async {
    final response = await _api.gameUrl(dataMap);
    final gameUrl = response.data as String?;
    return gameUrl ?? '';
  }

  Future<List<GameActivityModel>> gameActivityList() async {
    final response = await _api.gameActivityList();
    final dataList = <GameActivityModel>[];
    if (response.data is List) {
      for (final item in response.data) {
        dataList.add(
          GameActivityModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }
    return dataList;
  }

  Future<void> gameWithdraw(
    Map<String, dynamic> dataMap,
  ) async {
    await _api.gameWithdraw(dataMap);
  }
}
