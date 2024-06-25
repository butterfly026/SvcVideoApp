import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/data/repository/community/community_repository.dart';
import 'package:flutter_video_community/global/widgets/loading_dialog.dart';
import 'package:get/get.dart';

class ReleasePostController extends GetxController {
  final TextEditingController titleEditingController = TextEditingController();
  final TextEditingController contentEditingController =
      TextEditingController();

  /// 服务项目
  final TextEditingController serviceItemsEditingController =
      TextEditingController();

  /// 消费情况
  final TextEditingController situationEditingController =
      TextEditingController();

  /// 联系方式
  final TextEditingController contactEditingController =
      TextEditingController();

  Rx<Result?> cityResult = Rx(null);

  CommunityRepository get _repository => null == Get.context
      ? CommunityRepository()
      : RepositoryProvider.of<CommunityRepository>(Get.context!);

  Future<void> release(
    BuildContext context,
  ) async {
    try {
      LoadingDialog.show(context);
      final arguments = Get.arguments;
      final city = cityResult.value;
      final dataMap = <String, dynamic>{
        'title': titleEditingController.text,
        'content': contentEditingController.text,
        'area': '${city?.provinceName}-${city?.cityName}-${city?.areaName}',
        'areaCode': city?.areaId,
        'serviceItems': serviceItemsEditingController.text,
        'situation': situationEditingController.text,
        'contact': contentEditingController.text,
        'type': arguments,
      };
      _repository.addSocAttendant(dataMap);
      LoadingDialog.dismiss();
    } catch (error) {
      LoadingDialog.dismiss();
    }
  }

  Future<void> showCityPicker(
    BuildContext context,
  ) async {
    CityPickers.showCityPicker(
      context: context,
      barrierOpacity: 0.6,
      itemExtent: Dimens.gap_dp56,
      confirmWidget: Text(
        '确定',
        style: TextStyle(
          fontSize: Dimens.font_sp20,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      cancelWidget: Text(
        '取消',
        style: TextStyle(
          fontSize: Dimens.font_sp20,
          color: const Color.fromRGBO(127, 127, 127, 1),
        ),
      ),
      itemBuilder: (item, list, index) {
        return Center(
          child: Text(
            '$item',
            maxLines: 1,
            style: TextStyle(fontSize: Dimens.gap_dp20),
          ),
        );
      },
    ).then(
      (value) {
        cityResult.value = value;
      },
    );
  }
}
