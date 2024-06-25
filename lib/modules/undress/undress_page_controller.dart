import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/data/repository/main/main_repository.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/global/widgets/loading_dialog.dart';
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class UndressPageController extends GetxController {
  RxString imageUrl = RxString('');

  MainRepository get _repository => null == Get.context
      ? MainRepository()
      : RepositoryProvider.of<MainRepository>(Get.context!);

  Rx<AdsRsp?> adsRsp = Rx(null);

  @override
  void onReady() async {
    super.onReady();
    adsRsp.value = await GlobalController.to.getAdsData();
  }

  Future<void> pickAsset(
    BuildContext context,
  ) async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: const AssetPickerConfig(
        maxAssets: 1,
        requestType: RequestType.image,
      ),
    );
    if (null != result && result.isNotEmpty) {
      final assetEntity = result.first;
      final assetFile = await assetEntity.file;

      if (null != assetFile) {
        try {
          if (context.mounted) {
            LoadingDialog.show(context);
          }
          final uploadData = await _repository.uploadImage(assetFile);
          LoadingDialog.dismiss();
          imageUrl.value = uploadData.url;
        } catch (error) {
          LoadingDialog.dismiss();
        }
      }
    }
  }

  Future<void> submit(
    BuildContext context,
  ) async {
    if (imageUrl.isEmpty) {
      return;
    }
    try {
      if (context.mounted) {
        LoadingDialog.show(context);
      }
      final dataMap = <String, dynamic>{
        'original': imageUrl.value,
      };
      await _repository.undress(dataMap);
      LoadingDialog.dismiss();
    } catch (error) {
      LoadingDialog.dismiss();
    }
  }
}
