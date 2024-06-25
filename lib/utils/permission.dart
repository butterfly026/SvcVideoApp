import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_device/safe_device.dart';
import 'package:vpn_check/vpn_check.dart';

import 'device.dart';

class PermissionUtil {
  static Future<Map<Permission, PermissionStatus>> request(
    Permission permission,
  ) async {
    final List<Permission> permissions = <Permission>[permission];
    return await permissions.request();
  }

  static bool isDenied(Map<Permission, PermissionStatus> result) {
    var isDenied = false;
    result.forEach((key, value) {
      if (value == PermissionStatus.denied) {
        isDenied = true;
        return;
      }
    });
    return isDenied;
  }

  /// 检查权限
  static Future<bool> checkGranted(Permission permission) async {
    PermissionStatus storageStatus = await permission.status;
    if (storageStatus == PermissionStatus.granted) {
      /// 已授权
      return true;
    } else {
      /// 拒绝授权
      return false;
    }
  }

  Future<bool> requestPhotoPermission() async {
    if (DeviceUtil.isAndroid) {
      final AndroidDeviceInfo androidInfo =
          await DeviceInfoPlugin().androidInfo;
      int androidVersion = androidInfo.version.sdkInt;
      if (androidVersion <= 32) {
        await PermissionUtil.request(Permission.storage);
        return await PermissionUtil.checkGranted(Permission.storage);
      } else {
        await PermissionUtil.request(Permission.photos);
        return await PermissionUtil.checkGranted(Permission.photos);
      }
    } else {
      await PermissionUtil.request(Permission.photos);
      return await PermissionUtil.checkGranted(Permission.photos);
    }
  }

  Future<bool> requestStoragePermission() async {
    if (DeviceUtil.isAndroid) {
      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
      int androidVersion = androidInfo.version.sdkInt;
      if (androidVersion < 32) {
        await Permission.storage.request();
        return await Permission.storage.isGranted;
      } else {
        await Permission.manageExternalStorage.request();
        return await Permission.manageExternalStorage.isGranted;
      }
    } else {
      await Permission.storage.request();
      return await Permission.storage.isGranted;
    }
  }


  static Future<bool> isSafeDevice() async {
    return await SafeDevice.isSafeDevice;
  }

  // 检查 VPN 使用情况的方法
  static Future<bool> isVpnActive() async {
    final vpnChecker = VPNChecker(); // 创建 VPN 检查器实例
    bool isVpnActive = false; // 标志变量，用于存储 VPN 状态

    try {
      isVpnActive = await vpnChecker.isVPNEnabled(); // 调用方法检查 VPN 是否启用
    } on VPNUnhandledException catch (e) { // 捕获未处理的 VPN 异常
      print(e);
      // 处理异常，例如返回 false 或重新抛出异常
      return false;
    } catch (e) {
      print('发生错误：$e');
      // 处理其他可能的异常
      return false;
    }

    // 监听 VPN 活动流
    final subscription = vpnChecker.vpnActivityStream.listen(
      (isActive) {
        isVpnActive = isActive;
        print('VPN 是否活动：$isActive');
      },
      cancelOnError: false,
    );

    // 考虑在不再需要时取消订阅
    // subscription.cancel();

    return isVpnActive; // 返回 VPN 状态
  }


}
