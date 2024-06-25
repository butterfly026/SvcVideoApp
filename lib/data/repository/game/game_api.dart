import 'package:flutter_video_community/utils/http/http.dart';
import 'package:flutter_video_community/utils/http/src/service.dart';

class GameApi {

  Future<HttpResponse> getGameWithdrawalRecord(int pageNum, int pageSize) async {
    return await httpService.get(
      '/game/api/getGameExchangeRecord',
      data: <String, dynamic>{
      'pageNum': pageNum,
      'pageSize': pageSize
    },
    );
  }

  Future<HttpResponse> gameInfo() async {
    return await httpService.get(
      '/game/api/getGameInitInfo',
    );
  }

  Future<HttpResponse> gameBalance(Map<String, dynamic> dataMap,) async {
    return await httpService.get(
      '/game/api/getBalance',
      data: dataMap
    );
  }

  Future<HttpResponse> gameUrl(Map<String, dynamic> dataMap) async {
    return await httpService.get(
      '/game/api/getGameUrl',
      data: dataMap
    );
  }

  Future<HttpResponse> gameActivityList() async {
    return await httpService.get(
      '/game/api/getActivity',
    );
  }

  Future<HttpResponse> gameWithdraw(
    Map<String, dynamic> dataMap,
  ) async {
    return await httpService.post(
      '/game/api/cashOut',
      data: dataMap,
      showErrorToast: true,
    );
  }
}
