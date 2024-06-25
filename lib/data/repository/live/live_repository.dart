import 'package:flutter_video_community/data/models/live/live_anchor.dart';
import 'package:flutter_video_community/data/models/live/live_cat.dart';

import 'live_api.dart';

class LiveRepository {
  final LiveApi _api = LiveApi();


  Future<List<LiveCatModel>> getLiveCatList() async {
    final response = await _api.liveCatList();
    final dataList = <LiveCatModel>[];
    if (response.data is List) {
      for (final item in response.data) {
        dataList.add(
          LiveCatModel.fromJson(
            item as Map<String, dynamic>,
          ),
        );
      }
    }
    return dataList;
  }


  Future<List<LiveAnchorModel>> getLiveAnchorList(
      String catId, int pageIndex, int pageSize) async {
    final response = await _api.liveAnchorList(catId, pageIndex, pageSize);
    final dataList = <LiveAnchorModel>[];
    if (response.data is List) {
      for (final item in response.data) {
        dataList.add(
          LiveAnchorModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }
    return dataList;
  }

}
