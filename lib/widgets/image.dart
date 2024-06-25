import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';

export 'package:extended_image/extended_image.dart'
    show ExtendedImageMode, ExtendedImageState, GestureConfig;

typedef FailedBuilder = Widget Function();

/// 根据ExtendedImage二次封装，方便后期扩展更换
class RHExtendedImage extends StatefulWidget {
  const RHExtendedImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.failedAsset,
    this.failedTips,
    this.failedWidget,
    this.shape = BoxShape.rectangle,
    this.borderRadius = BorderRadius.zero,
    this.fit = BoxFit.cover,
    this.mode = ExtendedImageMode.none,
    this.color,
    InitGestureConfigHandler? initGestureConfigHandler,
  })  : assert(failedWidget == null || (failedTips == null)),
        initGestureConfigHandler =
            mode == ExtendedImageMode.gesture ? initGestureConfigHandler : null;

  factory RHExtendedImage.network(
    String url, {
    Key? key,
    double scale = 1.0,
    int retries = 3,
    Duration? timeLimit,
    Map<String, String>? headers,
    bool cache = true,
    Duration timeRetry = const Duration(milliseconds: 100),
    double? width,
    double? height,
    String? failedAsset,
    String? failedTips,
    Widget? failedWidget,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius borderRadius = BorderRadius.zero,
    BoxFit fit = BoxFit.cover,
    ExtendedImageMode mode = ExtendedImageMode.none,
    InitGestureConfigHandler? initGestureConfigHandler,
    bool useCache = true,
    int? cacheWidth,
    int? cacheHeight,
    bool isCompress = false,
  }) {
    ImageProvider imageProvider;
    imageProvider = ExtendedNetworkImageProvider(
      url,
      scale: scale,
      headers: headers,
      cache: cache,
      retries: retries,
      timeRetry: timeRetry,
      timeLimit: timeLimit,
      cacheRawData: true,
    );
    return RHExtendedImage(
      key: key,
      image: null != cacheWidth || null != cacheHeight
          ? ExtendedResizeImage.resizeIfNeeded(
              provider: imageProvider,
              cacheWidth: cacheWidth,
              cacheHeight: cacheHeight,
              compressionRatio: 0.4,
            )
          : imageProvider,
      width: width,
      height: height,
      failedAsset: failedAsset,
      failedTips: failedTips,
      failedWidget: failedWidget,
      shape: shape,
      borderRadius: borderRadius,
      fit: fit,
      mode: mode,
      initGestureConfigHandler:
          mode == ExtendedImageMode.gesture ? initGestureConfigHandler : null,
    );
  }

  // factory RHExtendedImage.file(
  //   File file, {
  //   Key? key,
  //   double scale = 1.0,
  //   double? width,
  //   double? height,
  //   String? failedAsset,
  //   String? failedTips,
  //   Widget? failedWidget,
  //   BoxShape shape = BoxShape.rectangle,
  //   BorderRadius borderRadius = BorderRadius.zero,
  //   BoxFit fit = BoxFit.cover,
  //   ExtendedImageMode mode = ExtendedImageMode.none,
  //   InitGestureConfigHandler? initGestureConfigHandler,
  // }) {
  //   return RHExtendedImage(
  //     key: key,
  //     image: ExtendedFileImageProvider(file, scale: scale),
  //     width: width,
  //     height: height,
  //     failedAsset: failedAsset,
  //     failedTips: failedTips,
  //     failedWidget: failedWidget,
  //     shape: shape,
  //     borderRadius: borderRadius,
  //     fit: fit,
  //     mode: mode,
  //     initGestureConfigHandler: initGestureConfigHandler,
  //   );
  // }

  factory RHExtendedImage.asset(
    String name, {
    Key? key,
    double? scale,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    String? failedAsset,
    String? failedTips,
    Widget? failedWidget,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius borderRadius = BorderRadius.zero,
    BoxFit fit = BoxFit.cover,
    ExtendedImageMode mode = ExtendedImageMode.none,
    InitGestureConfigHandler? initGestureConfigHandler,
    int? cacheWidth,
    int? cacheHeight,
    Color? color,
  }) {
    return RHExtendedImage(
      key: key,
      image: scale != null
          ? ExtendedExactAssetImageProvider(
              name,
              bundle: bundle,
              scale: scale,
              package: package,
            )
          : ExtendedAssetImageProvider(name, bundle: bundle, package: package),
      width: width,
      height: height,
      failedAsset: failedAsset,
      failedTips: failedTips,
      failedWidget: failedWidget,
      shape: shape,
      borderRadius: borderRadius,
      fit: fit,
      mode: mode,
      color: color,
      initGestureConfigHandler: initGestureConfigHandler,
    );
  }

  factory RHExtendedImage.memory(
    Uint8List bytes, {
    Key? key,
    double scale = 1.0,
    double? width,
    double? height,
    String? failedAsset,
    String? failedTips,
    Widget? failedWidget,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius borderRadius = BorderRadius.zero,
    BoxFit fit = BoxFit.cover,
    ExtendedImageMode mode = ExtendedImageMode.none,
    InitGestureConfigHandler? initGestureConfigHandler,
  }) {
    return RHExtendedImage(
      key: key,
      image: ExtendedMemoryImageProvider(bytes, scale: scale),
      width: width,
      height: height,
      failedAsset: failedAsset,
      failedTips: failedTips,
      failedWidget: failedWidget,
      shape: shape,
      borderRadius: borderRadius,
      fit: fit,
      mode: mode,
      initGestureConfigHandler: initGestureConfigHandler,
    );
  }

  /// The image to display.
  final ImageProvider image;
  final double? width;
  final double? height;
  final BoxShape shape;
  final BorderRadius borderRadius;
  final BoxFit fit;
  final ExtendedImageMode mode;
  final InitGestureConfigHandler? initGestureConfigHandler;
  final String? failedAsset;
  final String? failedTips;
  final Widget? failedWidget;
  final Color? color;

  @override
  RHExtendedImageState createState() => RHExtendedImageState();
}

class RHExtendedImageState extends State<RHExtendedImage> {
  late Widget oldWidget;
  double? width;
  double? height;
  late BoxFit fit;

  InitGestureConfigHandler defaultGestureConfigHandler =
      (ExtendedImageState imageState) {
    return GestureConfig(
      minScale: 0.9,
      animationMinScale: 0.7,
      maxScale: 3.0,
      animationMaxScale: 3.5,
    );
  };

  LoadStateChanged get _defaultLoadStateChanged =>
      (ExtendedImageState imageState) {
        Widget? child;
        switch (imageState.extendedImageLoadState) {
          case LoadState.loading:
            child = SizedBox(
              width: imageState.imageWidget.width,
              height: imageState.imageWidget.height,
              child: CupertinoActivityIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
            break;
          case LoadState.completed:
            child = null;
            break;
          case LoadState.failed:
            child = widget.failedWidget ??
                Container(
                  width: imageState.imageWidget.width,
                  height: imageState.imageWidget.height,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    borderRadius: widget.borderRadius,
                  ),
                  child: Center(
                    child: RHExtendedImage.asset(
                      Images.logo.assetName,
                      width: Dimens.gap_dp30,
                      height: Dimens.gap_dp30,
                    ),
                  ),
                );
            break;
        }
        return child;
      };

  @override
  void initState() {
    super.initState();
    width = widget.width;
    height = widget.height;
    fit = widget.fit;
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider image = widget.image;
    if (widget.image is ExtendedNetworkImageProvider) {
      if ((widget.image as ExtendedNetworkImageProvider).url.isEmpty) {
        image = ExtendedAssetImageProvider(widget.failedAsset ?? '');
        width = null;
        height = null;
        fit = BoxFit.contain;
      }
    }
    Widget imageWidget = ExtendedImage(
      image: image,
      width: width,
      height: height,
      shape: widget.shape,
      borderRadius: widget.borderRadius,
      fit: fit,
      mode: widget.mode,
      gaplessPlayback: true,
      color: widget.color ?? const Color(0x00000000),
      colorBlendMode: BlendMode.multiply,
      clearMemoryCacheWhenDispose: true,
      clearMemoryCacheIfFailed: true,
      initGestureConfigHandler: widget.mode == ExtendedImageMode.gesture
          ? widget.initGestureConfigHandler ?? defaultGestureConfigHandler
          : null,
      loadStateChanged: _defaultLoadStateChanged,
    );
    if (widget.image is ExtendedNetworkImageProvider) {
      if ((widget.image as ExtendedNetworkImageProvider).url.isEmpty) {
        imageWidget = SizedBox(
          width: widget.width,
          height: widget.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: imageWidget),
              if (widget.failedTips != null) Gaps.vGap8,
              if (widget.failedTips != null)
                Text(
                  widget.failedTips!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
        );
      }
    }
    return imageWidget;
  }
}
