import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_picker/picker.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.onConfirm,
    this.minimum,
  });

  final Widget child;
  final String? title;
  final void Function()? onConfirm;
  final EdgeInsets? minimum;

  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    String? title,
    void Function()? onConfirm,
    EdgeInsets? minimum,
    bool enableDrag = true,
  }) {
    return showCustomModalBottomSheet<T>(
      context: context,
      enableDrag: enableDrag,
      barrierColor: const Color(0xFF09101D).withOpacity(0.7),
      containerWidget: (context, animation, child) {
        return CustomBottomSheet(
          title: title,
          onConfirm: onConfirm,
          minimum: minimum,
          child: child,
        );
      },
      builder: builder,
    );
  }

  static Future<DateTime?> showDateTime({
    required BuildContext context,
    String? title,
    int type = PickerDateTimeType.kYMD,
    DateTime? value,
    DateTime? minValue,
    DateTime? maxValue,
  }) {
    final adapter = DateTimePickerAdapter(
      type: type,
      isNumberMonth: true,
      value: value,
      minValue: minValue,
      maxValue: maxValue,
    );
    final delimiters = <PickerDelimiter>[];
    if (type == PickerDateTimeType.kYMDHM) {
      delimiters.add(PickerDelimiter(
        column: 4,
        child: const Center(child: Text(':')),
      ));
    }
    return show<DateTime>(
      context: context,
      title: title,
      enableDrag: false,
      builder: (BuildContext context) => _BottomSheetWithPicker(
        adapter: adapter,
        delimiters: delimiters,
      ),
      onConfirm: () {
        Navigator.of(context).pop(DateTime.tryParse(adapter.text));
      },
    );
  }

  static Future<T?> showPicker<T>({
    required BuildContext context,
    double? height,
    int? selectedIndex,
    List<T> items = const [],
    String? title,
    required Widget Function(T value) builder,
  }) async {
    final textStyle = TextStyle(
      fontSize: Dimens.font_sp18,
      height: 1.2,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.onBackground,
    );
    final adapter = PickerDataAdapter<T>(
      data: List.generate(items.length, (index) {
        return PickerItem(
          value: items[index],
          text: DefaultTextStyle.merge(
            style: textStyle,
            child: Center(child: builder(items[index])),
          ),
        );
      }),
    );
    return show<T>(
      context: context,
      title: title,
      enableDrag: false,
      builder: (context) => _BottomSheetWithPicker(
        adapter: adapter,
        height: height,
        selecteds: [selectedIndex ?? 0],
      ),
      onConfirm: () {
        Navigator.of(context).pop(adapter.getSelectedValues().first);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      minimum: const EdgeInsets.only(top: AppTheme.margin),
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: Theme.of(context).bottomSheetTheme.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimens.gap_dp10),
            topRight: Radius.circular(Dimens.gap_dp10),
          ),
        ),
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ModalSheetAppBar(
                title: title,
                submit: onConfirm,
              ),
              Flexible(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  controller: ModalScrollController.of(context),
                  child: SafeArea(
                    top: false,
                    bottom: false,
                    minimum: (minimum ?? const EdgeInsets.all(AppTheme.margin))
                        .copyWith(top: title != null ? 0 : null),
                    child: child,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ModalSheetAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ModalSheetAppBar({
    super.key,
    this.title,
    this.prefixWidget,
    this.submit,
    this.close,
    this.showDivider = false,
  });

  final String? title;
  final Widget? prefixWidget;
  final bool? showDivider;
  final void Function()? submit;
  final void Function()? close;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            title ?? '',
            style: Theme.of(context).appBarTheme.toolbarTextStyle!.copyWith(
                  fontSize: Dimens.font_sp20,
                ),
          ),
          centerTitle: true,
          actions: [
            if (submit != null)
              TextButton(
                onPressed: submit,
                child: Text(
                  '确定',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: Dimens.font_sp16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
          ],
        ),
        if (showDivider ?? false) const Divider(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _BottomSheetWithPicker extends StatelessWidget {
  const _BottomSheetWithPicker({
    super.key,
    required this.adapter,
    this.height,
    this.selecteds,
    this.delimiters,
  });

  final PickerAdapter<dynamic> adapter;
  final double? height;
  final List<int>? selecteds;
  final List<PickerDelimiter>? delimiters;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: Dimens.font_sp18,
      height: 1.2,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.onBackground,
    );
    return DefaultTextStyle.merge(
      style: textStyle,
      child: Picker(
        adapter: adapter,
        selecteds: selecteds,
        itemExtent: Dimens.gap_dp48,
        height: height ?? Dimens.gap_dp10 * 22,
        backgroundColor: Colors.transparent,
        containerColor: Colors.transparent,
        hideHeader: true,
        textStyle: textStyle,
        delimiter: delimiters,
      ).makePicker(),
    );
  }
}
