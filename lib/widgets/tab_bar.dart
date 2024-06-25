import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:oktoast/oktoast.dart';

import 'gradient_text.dart';

final double _kTabHeight = Dimens.gap_dp38;

class CustomTabBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomTabBar({
    Key? key,
    required this.tabs,
    this.controller,
    this.minimum,
    this.selectedShapeBorder,
    this.unselectedShapeBorder,
    this.onTap,
    this.onChanged,
    this.isScrollable = true,
  }) : super(key: key);

  final bool isScrollable;
  final List<Tab> tabs;
  final TabController? controller;
  final EdgeInsets? minimum;
  final ShapeBorder? selectedShapeBorder;
  final ShapeBorder? unselectedShapeBorder;
  final void Function(int index)? onTap;
  final void Function(int index)? onChanged;

  @override
  Size get preferredSize => Size.fromHeight(_kTabHeight);

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with TickerProviderStateMixin {
  final _duration = 250;
  final GlobalKey _tabsContainerKey = GlobalKey();
  final GlobalKey _tabsParentKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  late AnimationController _animationController;
  late List<GlobalKey> _tabKeys;
  TabController? _controller;
  int _currentIndex = 0;
  int _prevIndex = -1;
  int _aniIndex = 0;
  double _prevAniValue = 0;
  late bool _textLTR;

  @override
  void initState() {
    super.initState();
    _tabKeys = widget.tabs.map<GlobalKey>((item) => GlobalKey()).toList();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _duration),
    );

    _animationController.value = 1.0;
    _animationController.addListener(() {
      setState(() {});
    });
  }

  bool get _controllerIsValid => _controller?.animation != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(debugCheckHasMaterial(context));
    _updateTabController();
  }

  @override
  void didUpdateWidget(CustomTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _updateTabController();
    }

    if (widget.tabs.length > oldWidget.tabs.length) {
      final int delta = widget.tabs.length - oldWidget.tabs.length;
      _tabKeys.addAll(List<GlobalKey>.generate(delta, (int n) => GlobalKey()));
    } else if (widget.tabs.length < oldWidget.tabs.length) {
      _tabKeys.removeRange(widget.tabs.length, oldWidget.tabs.length);
    }
  }

  @override
  void dispose() {
    if (_controllerIsValid) {
      _controller!.animation!.removeListener(_handleTabAnimation);
      _controller!.removeListener(_handleController);
    }
    _controller = null;
    _scrollController.dispose();
    super.dispose();
  }

  void _updateTabController() {
    final TabController newController =
        widget.controller ?? DefaultTabController.of(context);

    if (newController == _controller) return;

    if (_controllerIsValid) {
      _controller?.animation!.removeListener(_handleTabAnimation);
      _controller?.removeListener(_handleController);
    }
    _controller = newController;
    _controller?.animation!.addListener(_handleTabAnimation);
    _controller?.addListener(_handleController);
    _currentIndex = _controller!.index;
  }

  void _handleController() {
    if (_controller!.indexIsChanging) _goToIndex(_controller!.index);
  }

  Widget _buildTabItem(int index, Tab tab) {
    final tabBarTheme = TabBarTheme.of(context);
    var animationValue = 0.0;
    if (index == _currentIndex) {
      animationValue = _animationController.value;
    } else if (index == _prevIndex) {
      animationValue = 1 - _animationController.value;
    } else {
      animationValue = 0;
    }

    final textStyle = TextStyle.lerp(
      tabBarTheme.unselectedLabelStyle,
      tabBarTheme.labelStyle,
      animationValue,
    );

    final borderColor =
        tabBarTheme.labelColor ?? Theme.of(context).colorScheme.primary;

    final boxDecoration = ShapeDecoration.lerp(
      ShapeDecoration(
        color: tabBarTheme.unselectedLabelColor ??
            Theme.of(context).colorScheme.surface,
        shape: widget.unselectedShapeBorder ??
            StadiumBorder(
              side: BorderSide(color: borderColor, width: Dimens.gap_dp2),
            ),
        // shape: RoundedRectangleBorder(
        //   side: BorderSide(color: borderColor, width: 2.w),
        //   borderRadius: BorderRadius.circular(12.w),
        // ),
      ),
      ShapeDecoration(
        color: tabBarTheme.labelColor ?? Theme.of(context).colorScheme.primary,
        shape: widget.selectedShapeBorder ??
            StadiumBorder(
                side: BorderSide(color: borderColor, width: Dimens.gap_dp2)),
        // shape: RoundedRectangleBorder(
        //   side: BorderSide(color: borderColor, width: 2.w),
        //   borderRadius: BorderRadius.circular(12.w),
        // ),
      ),
      animationValue,
    );

    return GestureDetector(
      key: _tabKeys[index],
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _controller?.animateTo(index);
        widget.onTap?.call(index);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: (tabBarTheme.labelPadding?.horizontal ?? 0) / 2,
        ).copyWith(
          left: index == 0 ? 0 : null,
          right: index == widget.tabs.length - 1 ? 0 : null,
        ),
        alignment: Alignment.center,
        padding: index == 0
            ? EdgeInsets.only(right: Dimens.gap_dp8)
            : EdgeInsets.symmetric(horizontal: Dimens.gap_dp8),
        decoration: null,
        child: DefaultTextStyle.merge(
          style: textStyle,
          child: Text(tab.text ?? ''),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(() {
      if (_controller!.length != widget.tabs.length) {
        throw FlutterError(
            "Controller's length property (${_controller!.length}) does not match the "
            "number of tabs (${widget.tabs.length}) present in TabBar's tabs property.");
      }
      return true;
    }());
    if (_controller!.length == 0) return Container(height: _kTabHeight);

    _textLTR = Directionality.of(context).index == 1;

    Widget tabsChild = SafeArea(
      top: false,
      bottom: false,
      minimum: widget.minimum ??
          const EdgeInsets.symmetric(
            horizontal: AppTheme.margin,
          ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(widget.tabs.length, (index) {
          var item = _buildTabItem(index, widget.tabs[index]);
          if (!widget.isScrollable) item = Expanded(child: item);
          return item;
        }),
      ),
    );

    if (widget.isScrollable) {
      tabsChild = SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: tabsChild,
      );
    }

    return AnimatedBuilder(
      animation: _animationController,
      key: _tabsParentKey,
      builder: (context, child) => SizedBox(
        key: _tabsContainerKey,
        height: widget.preferredSize.height,
        child: child,
      ),
      child: tabsChild,
    );
  }

  _handleTabAnimation() {
    _aniIndex = ((_controller!.animation!.value > _prevAniValue)
            ? _controller!.animation!.value
            : _prevAniValue)
        .round();
    if (!_controller!.indexIsChanging && _aniIndex != _currentIndex) {
      _setCurrentIndex(_aniIndex);
    }
    _prevAniValue = _controller!.animation!.value;
  }

  _goToIndex(int index) {
    if (index != _currentIndex) {
      _setCurrentIndex(index);
      _controller?.animateTo(index);
    }
  }

  _setCurrentIndex(int index) {
    setState(() {
      _prevIndex = _currentIndex;
      _currentIndex = index;
    });
    _scrollTo(index);
    _triggerAnimation();
    if (null != widget.onChanged) {
      widget.onChanged!(index);
    }
  }

  _triggerAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  _scrollTo(int index) {
    if (!widget.isScrollable) return;
    final RenderBox tabsContainer =
        _tabsContainerKey.currentContext!.findRenderObject() as RenderBox;
    final tabsContainerPosition = tabsContainer.localToGlobal(Offset.zero).dx;
    final tabsContainerOffset = Offset(-tabsContainerPosition, 0);
    double screenWidth = tabsContainer.size.width;

    RenderBox renderBox =
        _tabKeys[index].currentContext?.findRenderObject() as RenderBox;
    double size = renderBox.size.width;
    double position = renderBox.localToGlobal(tabsContainerOffset).dx;

    double offset = (position + size / 2) - screenWidth / 2;

    if (offset < 0) {
      renderBox = (_textLTR ? _tabKeys.first : _tabKeys.last)
          .currentContext
          ?.findRenderObject() as RenderBox;
      position = renderBox.localToGlobal(tabsContainerOffset).dx;
      if (position > offset) offset = position - AppTheme.margin;
    } else {
      renderBox = (_textLTR ? _tabKeys.last : _tabKeys.first)
          .currentContext
          ?.findRenderObject() as RenderBox;
      position = renderBox.localToGlobal(tabsContainerOffset).dx;
      size = renderBox.size.width;

      if (position + size < screenWidth) screenWidth = position + size;

      if (position + size - offset < screenWidth) {
        offset = position + size - screenWidth;
        if (offset > 0) offset += AppTheme.margin;
      }
    }
    offset *= (_textLTR ? 1 : -1);

    _scrollController.animateTo(
      offset + _scrollController.offset,
      duration: Duration(milliseconds: _duration),
      curve: Curves.easeInOut,
    );
  }
}
