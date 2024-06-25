import 'package:flutter_video_community/utils/http/http.dart';
import 'package:flutter_video_community/utils/http/src/service.dart';

class MineApi {
  Future<HttpResponse> getRechargePackage(String rechargeType) async {
    return await httpService.get(
      '/app/api/getRechargePackage',
      data: <String, dynamic>{
        'type': rechargeType,
      },
    );
  }

  Future<HttpResponse> getPayChannelList(String rechargeType) async {
    return await httpService.get(
      '/pay/payChannel/getPayChannelList',
      data: <String, dynamic>{
        'busType': rechargeType,
      },
    );
  }

  Future<HttpResponse> getCouponList() async {
    return await httpService.get(
      '/app/api/getAppUserCardList',
    );
  }

  Future<HttpResponse> getOrderHistory(String rechargeType, int pageNum, int pageSize) async {
    return await httpService.get(
      '/pay/api/getHistoryOrder',
      data: <String, dynamic>{
        'busType': rechargeType,
        'pageNum': pageNum,
        'pageSize': pageSize
      },
    );
  }
}
