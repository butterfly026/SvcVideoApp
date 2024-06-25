import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_video_community/data/models/game/withdraw.dart';
import 'package:flutter_video_community/data/models/index/user.dart';
import 'package:flutter_video_community/data/repository/game/game_repository.dart';
import 'package:flutter_video_community/global/enum/pay.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/global/widgets/loading_dialog.dart';
import 'package:flutter_video_community/modules/main/game/game_page_controller.dart';
import 'package:flutter_video_community/widgets/custom_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

class WithdrawalPageController extends GetxController {
  static WithdrawalPageController get to => Get.find();

  /// 姓名
  final TextEditingController nameInputController = TextEditingController();

  /// 银行卡号
  final TextEditingController cardNumberInputController =
      TextEditingController();

  /// 银行卡号
  final TextEditingController bankBranchInputController =
      TextEditingController();

  final TextEditingController usdtAddressInputController =
      TextEditingController();

  /// 支付宝账号
  final TextEditingController alipayAccountInputController =
      TextEditingController();

  /// 提现金额
  final TextEditingController withdrawalAmountInputController =
      TextEditingController();

  final List<PayType> payTypeList = [
    PayType.bank,
    PayType.alipay,
    PayType.usdt,
  ];
  final List<UsdtType> usdtTypeList = [
    UsdtType.trc20,
    UsdtType.erc20,
  ];
  final List<String> bankList = [
    '中国银行',
    '建设银行',
    '招商银行',
    '农业银行',
    '邮政银行',
    '中信银行',
    '交通银行',
  ];

  RxString currentBank = RxString('');

  List<String> get payTypeValues => payTypeList.map((e) => e.value).toList();

  List<String> get usdtTypeValues => usdtTypeList.map((e) => e.value).toList();

  /// 当前提现方式
  Rx<PayType?> currentPayType = Rx(null);
  Rx<UsdtType?> currentUsdtType = Rx(null);

  String get payTypeValue =>
      null == currentPayType.value ? '请选择提现方式' : currentPayType.value!.value;

  String get usdtTypeValue =>
      null == currentUsdtType.value ? '请选择协议网络' : currentUsdtType.value!.value;

  String get bankValue => currentBank.isEmpty ? '请选择银行' : currentBank.value;

  GameRepository get _repository => Global.getIt<GameRepository>();

  //
  // IndexRepository get _indexRepository => null == Get.context
  //     ? IndexRepository()
  //     : RepositoryProvider.of<IndexRepository>(Get.context!);

  // 用户信息
  Rx<UserModel?> userInfo = Rx(null);

  @override
  void onReady() {
    super.onReady();
    loadData();
  }

  Future<void> showPayTypeDialog(
    BuildContext context,
  ) async {
    FocusScope.of(context).requestFocus(FocusNode());
    final result = await CustomBottomSheet.showPicker<String>(
      context: context,
      items: payTypeValues,
      title: '提现方式',
      builder: (value) => Text(value),
    );
    if (null != result) {
      currentPayType.value = PayTypeMatcher.match(result);
      update();
    }
  }

  Future<void> showUsdtTypeDialog(
    BuildContext context,
  ) async {
    FocusScope.of(context).requestFocus(FocusNode());
    final result = await CustomBottomSheet.showPicker<String>(
      context: context,
      items: usdtTypeValues,
      title: '协议网络',
      builder: (value) => Text(value),
    );
    if (null != result) {
      currentUsdtType.value = UsdtTypeMatcher.match(result);
      update();
    }
  }

  Future<void> showBankDialog(
    BuildContext context,
  ) async {
    FocusScope.of(context).requestFocus(FocusNode());
    final result = await CustomBottomSheet.showPicker<String>(
      context: context,
      items: bankList,
      title: '银行名称',
      builder: (value) => Text(value),
    );
    if (null != result) {
      currentBank.value = result;
      update();
    }
  }

  Future<void> submit(
    BuildContext context,
  ) async {
    if (null == currentPayType.value) {
      showToast('请选择提现方式');
      return;
    }
    if (nameInputController.text.isEmpty) {
      showToast('请输入姓名');
      return;
    }
    if (currentPayType.value == PayType.bank) {
      if (currentBank.isEmpty) {
        showToast('请选择银行');
        return;
      }
      if (cardNumberInputController.text.isEmpty) {
        showToast('请输入银行卡号');
        return;
      }
      if (bankBranchInputController.text.isEmpty) {
        showToast('请输入开户支行');
        return;
      }
    } else if (currentPayType.value == PayType.alipay) {
      if (alipayAccountInputController.text.isEmpty) {
        showToast('请输入支付宝账号');
        return;
      }
    } else if (currentPayType.value == PayType.usdt) {
      if (null == currentUsdtType.value) {
        showToast('请选择协议网络');
        return;
      }
      if (usdtAddressInputController.text.isEmpty) {
        showToast('请输入协议地址');
        return;
      }
    }

    if (withdrawalAmountInputController.text.isEmpty) {
      showToast('请输入提现金额');
      return;
    }

    try {
      String exchangeAccount = '';
      if (currentPayType.value == PayType.bank) {
        final BankModel data = BankModel(
          accountHolder: nameInputController.text,
          accountNumber: cardNumberInputController.text,
          bankName: currentBank.value,
          branch: bankBranchInputController.text,
        );
        exchangeAccount = jsonEncode(data);
      } else if (currentPayType.value == PayType.alipay) {
        final AlipayModel data = AlipayModel(
          accountHolder: nameInputController.text,
          alipayAccount: alipayAccountInputController.text,
        );
        exchangeAccount = jsonEncode(data);
      } else if (currentPayType.value == PayType.usdt) {
        final UsdtModel data = UsdtModel(
          walletAddress: usdtAddressInputController.text,
          usdtChain: usdtTypeValue,
        );
        exchangeAccount = jsonEncode(data);
      }

      final amount = int.parse(
        withdrawalAmountInputController.text,
      );

      LoadingDialog.show(context);

      final dataMap = <String, dynamic>{
        'balance': amount,
        'exchangeAccount': exchangeAccount,
      };
      await _repository.gameWithdraw(dataMap);

      LoadingDialog.dismiss();
    } catch (error) {
      LoadingDialog.dismiss();
    }
  }

  /// 初始化
  Future<void> loadData() async {
    GamePageController.to.getGameBalance();
    update();
  }

  @override
  void onClose() {
    nameInputController.dispose();
    cardNumberInputController.dispose();
    withdrawalAmountInputController.dispose();
    alipayAccountInputController.dispose();
    bankBranchInputController.dispose();
    usdtAddressInputController.dispose();
    super.onClose();
  }
}
