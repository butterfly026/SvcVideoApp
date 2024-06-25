import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/modules/main/mine/settings/account/credentials/scan_credentials_controller.dart';
import 'package:flutter_video_community/utils/device.dart';
import 'package:flutter_video_community/utils/permission.dart';
import 'package:flutter_video_community/widgets/app_bar.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:image/image.dart' as img;
import 'package:zxing2/qrcode.dart';
import 'get_image_from_picker_stub.dart'
    if (dart.library.io) 'get_image_from_picker_io.dart'
    if (dart.library.html) 'get_image_from_picker_web.dart';

class ScanCredentialsPage extends StatefulWidget {
  const ScanCredentialsPage({super.key});

  @override
  State<StatefulWidget> createState() => _ScanCredentialsPageState();
}

class _ScanCredentialsPageState extends State<ScanCredentialsPage> {
  var controller = Get.put(ScanCredentialsController());

  @override
  void reassemble() {
    super.reassemble();
    if (DeviceUtil.isAndroid) {
      controller.controller?.pauseCamera();
    } else if (DeviceUtil.isIOS) {
      controller.controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 180.0
        : 300.0;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          RHExtendedImage.asset(
            Images.imgBgHeader.assetName,
            width: double.infinity,
            height: Dimens.gap_dp1 * 375,
            fit: BoxFit.fill,
          ),
          Column(
            children: [
              CustomAppBar(
                title: const Text('身份卡找回'),
                backgroundColor: Colors.transparent,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark,
                ),
                actions: [
                  Container(
                    alignment: Alignment.center,
                    height: double.infinity,
                    margin: EdgeInsets.only(right: Dimens.gap_dp12),
                    child: GestureDetector(
                      onTap: () async {
                        bool hasPermission =
                            await PermissionUtil().requestPhotoPermission();
                        if (hasPermission) {
                          if (DeviceUtil.isAndroid) {
                            controller.onGalleryButtonTapped();
                          } else if (DeviceUtil.isWeb) {
                            Uint8List? bytesFromPicker =
                                await getImageFromPicker();
                            parseImage(bytesFromPicker);
                          } else if (DeviceUtil.isIOS) {
                            Uint8List? bytesFromPicker =
                                await getImageFromPicker();
                            parseImage(bytesFromPicker);
                          }
                        } else {
                          showToast('权限申请不通过');
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimens.gap_dp10,
                        ),
                        child: Text(
                          "相册",
                          style: TextStyle(
                            fontSize: Dimens.font_sp14,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  color: const Color(0xFF20202C),
                  child: QRView(
                    key: controller.qrKey,
                    onQRViewCreated: controller.onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.orange,
                      borderRadius: 10,
                      borderLength: 10,
                      borderWidth: 10,
                      cutOutSize: scanArea,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void parseImage(Uint8List? bytes) {
    if (bytes == null) {
      return;
    }
    var image = img.decodePng(bytes);
    if (image == null) {
      return;
    }
    LuminanceSource source = RGBLuminanceSource(
        image.width,
        image.height,
        image
            .convert(numChannels: 4)
            .getBytes(order: img.ChannelOrder.abgr)
            .buffer
            .asInt32List());
    var bitmap = BinaryBitmap(GlobalHistogramBinarizer(source));

    var reader = QRCodeReader();
    var result = reader.decode(bitmap);

    controller.onQRScanStringSuccess(result.text);
  }
}
