import 'dart:math' as math;

import 'package:santo_ui/src/components/icon/santo_icon.dart';
import 'package:santo_ui/src/components/icon/santo_icons.dart';
import 'package:santo_ui/src/components/popup/santo_measure_size.dart';
import 'package:santo_ui/src/components/tabbar/normal/santo_tabbar_controller.dart';
import 'package:santo_ui/src/theme/santo_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// 单个tab选中的回调
/// [state]:当前组件的State对象，[SantoTabBarState]
/// [index]:当前组件的角标
typedef SantoTabBarOnTap = Function(SantoTabBarState state, int index);

const double _tagDefaultSize = 75.0;
const int _scrollableLimitTabLength = 4;

/// tab 项圆角底色的左右内边距默认取 gapMd

/// 选中 tab 项底色的透明度
const int _tabItemSelectedAlpha = 0x14;

/// tab 项徽标距 tab 项右上角的距离
const double _tabBadgeInset = 4.0;

/// 带小红点的Tabbar
// ignore: must_be_immutable
class SantoTabBar extends StatefulWidget {
  /// SantoTabBarBadge填充的数据，长度匹配控制器的TabController.length
  final List<BadgeTab>? tabs;

  /// [SantoTabBar] 的tab模式
  /// 默认：[SantoTabBarBadgeMode.average]（按照屏幕平均分配模式）
  final SantoTabBarBadgeMode mode;

  /// 是否能滑动(当tab数量大于4个，默认都是滚动的，再设置此属性无效)
  final bool isScroll;

  /// Tabbar的整体高度
  final double? tabHeight;

  /// TabBar的padding
  final EdgeInsetsGeometry padding;

  /// 控制Tab的切换
  final TabController? controller;

  /// TabBar背景颜色,不传时取主题 fillBase
  final Color? backgroundColor;

  /// 指示器的颜色
  final Color? indicatorColor;

  /// 指示器的高度,即选中项底部 border 的粗细
  final double? indicatorWeight;

  /// 选中Tab文本的颜色
  final Color? labelColor;

  /// 选中Tab文本的样式
  final TextStyle? labelStyle;

  /// Tab文本的Padding
  final EdgeInsetsGeometry labelPadding;

  /// 未选中Tab文本的颜色
  final Color? unselectedLabelColor;

  /// 未中Tab文本的样式
  final TextStyle? unselectedLabelStyle;

  /// 处理拖拽开始行为方式，默认DragStartBehavior.start
  final DragStartBehavior dragStartBehavior;

  /// Tab的选中点击事件
  final SantoTabBarOnTap? onTap;

  /// 添加的Tab的宽度(指定tabWidth就不会均分屏幕宽度)
  final double? tabWidth;

  /// 是否显示分隔线
  final bool hasDivider;

  /// 是否显示角标
  final bool hasIndex;

  /// 展开更多Tabs
  final bool showMore;

  /// 展开更多弹框标题
  final String? moreWindowText;

  /// 更多弹框弹出的时候
  final VoidCallback? onMorePop;

  /// 更多弹框关闭控制器
  final SantoCloseWindowController? closeController;

  /// tag间距
  final double? tagSpacing;

  /// 每行tag数
  final int? preLineTagCount;

  /// tag高度
  final double? tagHeight;

  SantoTabBarConfig? themeData;

  SantoTabBar({
    required this.tabs,
    this.mode = SantoTabBarBadgeMode.average,
    this.isScroll = false,
    this.tabHeight,
    this.padding = EdgeInsets.zero,
    this.controller,
    this.backgroundColor,
    this.indicatorColor,
    this.indicatorWeight,
    this.labelColor,
    this.labelStyle,
    this.labelPadding = EdgeInsets.zero,
    this.unselectedLabelColor,
    this.unselectedLabelStyle,
    this.dragStartBehavior = DragStartBehavior.start,
    this.onTap,
    this.tabWidth,
    this.hasDivider = false,
    this.hasIndex = false,
    this.showMore = false,
    this.moreWindowText,
    this.onMorePop,
    this.closeController,
    this.themeData,
    this.tagSpacing,
    this.preLineTagCount,
    this.tagHeight,
  }) : assert(tabs != null) {
    this.themeData ??= SantoTabBarConfig();
    this.themeData = SantoThemeConfigurator.instance
        .getConfig(configId: this.themeData!.configId)
        .tabBarConfig
        .merge(this.themeData);
    this.themeData = this.themeData!.merge(SantoTabBarConfig(
          backgroundColor: backgroundColor,
          tabHeight: tabHeight,
          indicatorHeight: indicatorWeight,
          labelStyle: SantoTextStyle.withStyle(labelStyle),
          unselectedLabelStyle: SantoTextStyle.withStyle(unselectedLabelStyle),
          tagSpacing: tagSpacing,
          preLineTagCount: preLineTagCount,
          tagHeight: tagHeight,
        ));
  }

  @override
  SantoTabBarState createState() => SantoTabBarState(closeController);
}

/// SantoTabBarBadge的tab分配模式
enum SantoTabBarBadgeMode {
  /// 原始的默认TabBar的分配模式
  origin,

  /// 默认的按照4.5等分模式
  average
}

class SantoTabBarState extends State<SantoTabBar> {
  /// 展开更多的按钮宽度
  final double _moreSpacing = 50;

  /// SantoTabBarBadge展开更多数据处理控制器
  late SantoTabbarController _santoTabbarController;

  /// SantoTabBarBadge展开更多关闭处理控制器
  SantoCloseWindowController? _closeWindowController;

  SantoTabBarState(SantoCloseWindowController? closeController) {
    this._closeWindowController = closeController;
  }

  @override
  void initState() {
    super.initState();
    _santoTabbarController = SantoTabbarController();
    // 监听更多弹框tab选中变化的时候
    _santoTabbarController.addListener(() {
      _closeWindowController?.syncWindowState(_santoTabbarController.isShow);
      // 更新TabBar选中位置
      if (widget.controller != null) {
        widget.controller!.animateTo(_santoTabbarController.selectIndex);
      }
      // 刷新选中TabBar小红点
      refreshBadgeState(_santoTabbarController.selectIndex);
      // 更新Tabbar更多图标样式
      setState(() {});
    });

    _closeWindowController?.getCloseController().stream.listen((event) {
      _santoTabbarController.hide();
      _santoTabbarController.entry?.remove();
      _santoTabbarController.entry = null;
    });

    widget.controller?.addListener(_handleTabIndexChangeTick);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller?.removeListener(_handleTabIndexChangeTick);
  }

  void _handleTabIndexChangeTick() {
    if (widget.controller?.index.toDouble() ==
        widget.controller?.animation?.value) {
      _santoTabbarController.selectIndex = widget.controller?.index ?? 0;
      _santoTabbarController.isShow = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      constraints: BoxConstraints(minHeight: widget.themeData!.tabHeight),
      color: widget.themeData!.backgroundColor,
      child: LayoutBuilder(builder: (context, constraints) {
        // 按实际可用宽度布局,tab 被放进卡片/带内边距的容器时才不会溢出
        final double availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;
        // tab 项底色与底部 border 跟随控制器的动画进度,取同一个数据源
        final TabController? controller =
            widget.controller ?? DefaultTabController.maybeOf(context);
        return widget.showMore
            ? Row(
                children: <Widget>[
                  Container(
                    width: availableWidth - _moreSpacing,
                    child: _buildTabBar(availableWidth, controller),
                  ),
                  showMoreWidget(context)
                ],
              )
            : _buildTabBar(availableWidth, controller);
      }),
    );
  }

  // 构建TabBar样式
  TabBar _buildTabBar(double availableWidth, TabController? controller) {
    bool _isScrollable = widget.tabs!.length > _scrollableLimitTabLength ||
        widget.tabWidth != null ||
        widget.isScroll;
    return TabBar(
        tabAlignment: _isScrollable ? TabAlignment.start : TabAlignment.fill,
        tabs: fillWidgetByDataList(
            _isScrollable, availableWidth, controller?.animation),
        controller: widget.controller,
        isScrollable: _isScrollable,
        labelColor: widget.labelColor ?? widget.themeData!.labelStyle.color,
        labelStyle: widget.labelStyle ??
            widget.themeData!.labelStyle.generateTextStyle(),
        // labelPadding 由 tab 项自己承担(见 _tabItemContent),
        // 否则点击/波纹区域会比圆角底色区域大一圈
        labelPadding: EdgeInsets.zero,
        unselectedLabelColor: widget.unselectedLabelColor ??
            widget.themeData!.unselectedLabelStyle.color,
        unselectedLabelStyle: widget.unselectedLabelStyle ??
            widget.themeData!.unselectedLabelStyle.generateTextStyle(),
        dragStartBehavior: widget.dragStartBehavior,
        splashBorderRadius: BorderRadius.all(
            Radius.circular(widget.themeData!.commonConfig.radiusMd)),
        dividerColor: Colors.transparent,
        dividerHeight: 0,
        onTap: (index) {
          if (widget.onTap != null) {
            widget.onTap!(this, index);
            _santoTabbarController.setSelectIndex(index);
            _santoTabbarController.isShow = false;
            _santoTabbarController.entry?.remove();
            _santoTabbarController.entry = null;
          }
        },
        // 选中样式由 tab 项自己的圆角底色 + 底部 border 绘制,
        // 内置指示器连同其撑高一并关闭(indicatorWeight 由 border 层消费)
        indicator: const BoxDecoration(),
        indicatorWeight: 0,
      );
  }

  // 展开更多Widget
  Widget showMoreWidget(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Visibility(
      visible: widget.showMore,
      child: GestureDetector(
        onTap: () {
          if (!_santoTabbarController.isShow &&
              widget.controller!.index.toDouble() ==
                  widget.controller!.animation!.value) {
            _santoTabbarController.show();
            if (widget.onMorePop != null) {
              widget.onMorePop!();
            }
            showMoreWindow(context);
            setState(() {});
          } else {
            hideMoreWindow();
            setState(() {});
          }
        },
        child: Container(
            alignment: Alignment.center,
            width: _moreSpacing,
            height: widget.themeData!.tabHeight,
            decoration: BoxDecoration(
              color: commonConfig.fillBase,
              boxShadow: [
                BoxShadow(
                    color: SantoThemeConfigurator.instance
                        .getConfig()
                        .commonConfig
                        .shadowColor,
                    offset: Offset(-3, 0),
                    spreadRadius: -1)
              ],
            ),
            // chevron 在 24 viewBox 里只占一半宽度,盒子取 20 视觉线宽才约 10px
            child: !_santoTabbarController.isShow
                ? const SantoIcon(SantoIcons.navArrowDown, size: 20)
                : SantoIcon(SantoIcons.navArrowUp,
                    size: 20, color: commonConfig.brandPrimary)),
      ),
    );
  }

  /// 更新选中tab的小红点状态
  /// [index] tab索引
  void refreshBadgeState(int index) {
    setState(() {
      BadgeTab badgeTab = widget.tabs![index];
      if (badgeTab.isAutoDismiss) {
        badgeTab.badgeNum = null;
        badgeTab.badgeText = null;
        badgeTab.showRedBadge = false;
      }
    });
  }

  List<Widget> fillWidgetByDataList(
      bool isScrollable, double availableWidth, Animation<double>? animation) {
    List<Widget> widgets = <Widget>[];
    List<BadgeTab>? tabList = widget.tabs;
    if (tabList != null && tabList.isNotEmpty) {
      double? minWidth;
      if (widget.tabWidth != null) {
        minWidth = widget.tabWidth;
      } else {
        double tabUseWidth = widget.showMore
            ? availableWidth - _moreSpacing
            : availableWidth;
        if (tabList.length <= _scrollableLimitTabLength) {
          minWidth = tabUseWidth / tabList.length;
        } else {
          minWidth = tabUseWidth / 4.5;
        }
      }
      for (int i = 0; i < tabList.length; i++) {
        BadgeTab badgeTab = tabList[i];
        if (widget.mode == SantoTabBarBadgeMode.average) {
          widgets.add(_wrapAverageWidget(
              badgeTab, minWidth, i == tabList.length - 1, i, animation));
        } else {
          widgets.add(_wrapOriginWidget(
              badgeTab, i == tabList.length - 1, isScrollable, i, animation));
        }
      }
    }
    return widgets;
  }

  /// tab 项的左右内边距:外部 labelPadding 与默认内边距取大者
  EdgeInsets get _tabItemInsets {
    final EdgeInsets labelPadding =
        widget.labelPadding.resolve(TextDirection.ltr);
    final double itemPadding = widget.themeData!.commonConfig.gapMd;
    return EdgeInsets.only(
      left: math.max(labelPadding.left, itemPadding),
      right: math.max(labelPadding.right, itemPadding),
      top: labelPadding.top,
      bottom: labelPadding.bottom,
    );
  }

  /// 选中进度:无动画时按初始索引,否则按控制器插值取 [0, 1]
  double _selectedRate(Animation<double>? animation, int index) {
    if (animation == null) {
      return index == 0 ? 1.0 : 0.0;
    }
    return 1 - math.min(1, (animation.value - index).abs());
  }

  /// tab 项:内容居中,徽标固定在 tab 项右上角
  ///
  /// 选中底色与底部 border 跟随 [animation] 插值,取同一个数据源,
  /// 因此不会出现选中样式落在不同 tab 上的情况。
  Widget _tabItemContent(
      BadgeTab badgeTab, int index, Animation<double>? animation) {
    final Color selectedColor = (widget.labelColor ??
            widget.themeData!.labelStyle.color ??
            widget.themeData!.commonConfig.brandPrimary)
        .withAlpha(_tabItemSelectedAlpha);
    final Color indicatorColor =
        widget.indicatorColor ?? widget.themeData!.labelStyle.color!;
    final Widget? badge = _buildBadge(badgeTab);

    return Container(
      height: 47,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: <Widget>[
          // 选中圆角底色(未选中为全透明)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: animation ?? const AlwaysStoppedAnimation<double>(0),
              builder: (BuildContext context, Widget? child) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: selectedColor.withAlpha(
                        (_tabItemSelectedAlpha * _selectedRate(animation, index))
                            .round()),
                    borderRadius: BorderRadius.all(Radius.circular(
                        widget.themeData!.commonConfig.radiusMd)),
                  ),
                );
              },
            ),
          ),
          // 选中项底部 border:通栏宽,裁切进圆角区域内,与底色同源插值
          Positioned.fill(
            child: AnimatedBuilder(
              animation: animation ?? const AlwaysStoppedAnimation<double>(0),
              builder: (BuildContext context, Widget? child) {
                return ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(
                      widget.themeData!.commonConfig.radiusMd)),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: widget.themeData!.indicatorHeight,
                      color: indicatorColor.withAlpha(
                          (255 * _selectedRate(animation, index)).round()),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: _tabItemInsets,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Visibility(
                    visible: widget.hasIndex && badgeTab.topText != null,
                    child: Text(
                      badgeTab.topText ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                Text(
                  badgeTab.text!,
                  maxLines: 1,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: widget.themeData!.commonConfig.fontSizeSubHead),
                ),
              ],
            ),
          ),
          if (badge != null)
            Positioned(
              top: _tabBadgeInset,
              right: _tabBadgeInset,
              child: badge,
            ),
        ],
      ),
    );
  }

  /// tab 右上角徽标:数字优先,其次文案,最后红点
  Widget? _buildBadge(BadgeTab badgeTab) {
    final bool visible = (badgeTab.badgeNum != null
            ? badgeTab.badgeNum! > 0
            : false) ||
        badgeTab.showRedBadge ||
        (badgeTab.badgeText != null ? badgeTab.badgeText!.isNotEmpty : false);
    if (!visible) return null;

    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    String text = "";
    EdgeInsets padding = EdgeInsets.only(
        left: commonConfig.hSpacingXs, right: commonConfig.hSpacingXs);
    double largeSize = 8.0;
    if (badgeTab.badgeNum != null) {
      largeSize = 16.0;
      if (badgeTab.badgeNum! < 10) {
        padding = EdgeInsets.symmetric(horizontal: commonConfig.hSpacingXs);
        text = badgeTab.badgeNum!.toString();
      } else if (badgeTab.badgeNum! > 99) {
        padding = EdgeInsets.fromLTRB(
            commonConfig.hSpacingXs, 3, commonConfig.hSpacingXs, 2);
        text = "99+";
      } else {
        padding = EdgeInsets.fromLTRB(
            commonConfig.hSpacingXs, 3, commonConfig.hSpacingXs, 2);
        text = badgeTab.badgeNum!.toString();
      }
    } else if (badgeTab.badgeText != null &&
        badgeTab.badgeText!.isNotEmpty) {
      largeSize = 16.0;
      padding = EdgeInsets.fromLTRB(
          commonConfig.hSpacingXs, 3, commonConfig.hSpacingXs, 3);
      text = badgeTab.badgeText!;
    }

    return Badge(
      largeSize: largeSize,
      padding: padding,
      backgroundColor: commonConfig.brandImportant,
      label: Text(
        text,
        style: TextStyle(
            color: commonConfig.colorTextBaseInverse,
            fontSize: widget.themeData!.commonConfig.fontSizeCaptionSm,
            height: 1),
      ),
    );
  }

  /// 原始的自适应的tab样式
  Widget _wrapOriginWidget(BadgeTab badgeTab, bool lastElement,
      bool isScrollable, int index, Animation<double>? animation) {
    final Widget contentWidget = _tabItemContent(badgeTab, index, animation);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        isScrollable
            ? contentWidget
            : Expanded(
                child: contentWidget,
              ),
        Visibility(
          visible: widget.hasDivider && !lastElement,
          child: Container(
            width: 1,
            height: 20,
            color: SantoThemeConfigurator.instance
                  .getConfig()
                  .commonConfig
                  .dividerColorBase,
          ),
        )
      ],
    );
  }

  /// 定制的等分tab样式
  Widget _wrapAverageWidget(BadgeTab badgeTab, double? minWidth,
      bool lastElement, int index, Animation<double>? animation) {
    return Container(
      width: minWidth,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(child: _tabItemContent(badgeTab, index, animation)),
          Visibility(
            visible: widget.hasDivider && !lastElement,
            child: Container(
              width: 1,
              height: 20,
              color: SantoThemeConfigurator.instance
                  .getConfig()
                  .commonConfig
                  .dividerColorBase,
            ),
          )
        ],
      ),
    );
  }

  /// 展开更多
  void showMoreWindow(BuildContext context) {
    final RenderBox dropDownItemRenderBox =
        context.findRenderObject() as RenderBox;
    var position =
        dropDownItemRenderBox.localToGlobal(Offset.zero, ancestor: null);
    var size = dropDownItemRenderBox.size;
    _santoTabbarController.top = size.height + position.dy;

    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return GestureDetector(
        onTap: () {
          hideMoreWindow();
        },
        onVerticalDragStart: (_) {
          hideMoreWindow();
        },
        onHorizontalDragStart: (_) {
          hideMoreWindow();
        },
        child: Container(
          padding: EdgeInsets.only(
            top: _santoTabbarController.top!,
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                width: MediaQuery.of(context).size.width,
                left: 0,
                child: Material(
                  color: SantoThemeConfigurator.instance
                      .getConfig()
                      .commonConfig
                      .fillMask,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height -
                        _santoTabbarController.top!,
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: _TabBarOverlayWidget(
                        tabs: widget.tabs,
                        onTap: (index) {
                          if (widget.onTap != null) {
                            widget.onTap!(this, index);
                          }
                        },
                        moreWindowText: widget.moreWindowText,
                        santoTabbarController: _santoTabbarController,
                        themeData: widget.themeData!,
                        spacing: widget.themeData!.tagSpacing,
                        preLineTagCount: widget.themeData!.preLineTagCount,
                        tagHeight: widget.themeData!.tagHeight,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
    _santoTabbarController.screenHeight = MediaQuery.of(context).size.height;
    if (_santoTabbarController.entry != null) {
      resetEntry();
    }
    _santoTabbarController.entry = overlayEntry;
    Overlay.of(context).insert(_santoTabbarController.entry!);
  }

  void resetEntry() {
    _santoTabbarController.entry?.remove();
    _santoTabbarController.entry = null;
  }

  void hideMoreWindow() {
    if (_santoTabbarController.isShow) {
      _santoTabbarController.hide();
      resetEntry();
    }
  }
}

/// 更多弹框样式
// ignore: must_be_immutable
class _TabBarOverlayWidget extends StatefulWidget {
  List<BadgeTab>? tabs;

  String? moreWindowText;

  SantoTabbarController? santoTabbarController;

  SantoTabBarConfig themeData;

  /// tag间距
  double spacing;

  /// 每行tag数
  int preLineTagCount;

  /// tag高度
  double? tagHeight;

  /// Tab的选中点击事件
  final ValueChanged<int>? onTap;

  _TabBarOverlayWidget(
      {this.tabs,
      this.onTap,
      this.moreWindowText,
      this.santoTabbarController,
      required this.themeData,
      this.spacing = 12.0,
      this.preLineTagCount = 4,
      this.tagHeight});

  @override
  _TabBarOverlayWidgetState createState() => _TabBarOverlayWidgetState();
}

class _TabBarOverlayWidgetState extends State<_TabBarOverlayWidget> {
  /// tag宽度
  double _tagWidth = _tagDefaultSize;

  double _padding =
      SantoThemeConfigurator.instance.getConfig().commonConfig.vSpacingLg;

  double _parentWidth = 0.0;

  @override
  Widget build(BuildContext context) {
    return createMoreWindowView();
  }

  /// 展开更多弹框样式
  Widget createMoreWindowView() {
    return MeasureSize(
      onChanged: (size) {
        setState(() {
          _parentWidth = size.width;
        });
      },
      child: Container(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {},
          onVerticalDragStart: (_) {},
          onHorizontalDragStart: (_) {},
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    EdgeInsets.all(widget.themeData.commonConfig.vSpacingLg),
                color: widget.themeData.commonConfig.fillBase,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Visibility(
                        visible: widget.moreWindowText != null &&
                            widget.moreWindowText!.isNotEmpty,
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom:
                                  widget.themeData.commonConfig.vSpacingMd),
                          child: Text(
                            widget.moreWindowText ?? "",
                            style: TextStyle(
                                fontSize: widget
                                    .themeData.commonConfig.fontSizeSubHead,
                                color:
                                    widget.themeData.commonConfig.colorTextBase,
                                fontWeight: FontWeight.w700),
                          ),
                        )),
                    Container(
                      padding: EdgeInsets.only(
                          top: widget.themeData.commonConfig.gapMd),
                      child: _createMoreItems(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _createMoreItems() {
    // 计算tag的宽度
    _tagWidth = (_parentWidth -
            widget.spacing * (widget.preLineTagCount - 1) -
            _padding * 2) /
        widget.preLineTagCount;
    _tagWidth = _tagWidth <= _tagDefaultSize ? _tagDefaultSize : _tagWidth;
    List<Widget> widgets = <Widget>[];
    List<BadgeTab>? tabList = widget.tabs;
    if (tabList != null && tabList.isNotEmpty) {
      for (int i = 0; i < tabList.length; i++) {
        BadgeTab badgeTab = tabList[i];
        widgets.add(_createMoreItemWidget(badgeTab, i));
      }
    }
    return Wrap(
      spacing: widget.spacing,
      runSpacing: widget.themeData.commonConfig.gapMd,
      children: widgets,
    );
  }

  Widget _createMoreItemWidget(BadgeTab badgeTab, int index) {
    return GestureDetector(
      onTap: () {
        if (widget.santoTabbarController!.selectIndex == index) {
          widget.santoTabbarController?.setSelectIndex(index);
          widget.santoTabbarController?.isShow = false;
          widget.santoTabbarController?.entry?.remove();
          widget.santoTabbarController?.entry = null;
          setState(() {});
        } else {
          if (widget.onTap != null) {
            widget.onTap!(index);
          }
          widget.santoTabbarController!.setSelectIndex(index);
          widget.santoTabbarController?.isShow = false;
          widget.santoTabbarController?.entry?.remove();
          widget.santoTabbarController?.entry = null;
          setState(() {});
        }
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: widget.santoTabbarController!.selectIndex == index
                ? widget.themeData.tagSelectedBgColor
                : widget.themeData.tagNormalBgColor,
            borderRadius: BorderRadius.circular(widget.themeData.tagRadius)),
        height: widget.tagHeight,
        width: _tagWidth,
        child: Text(
          badgeTab.text ?? '',
          textAlign: TextAlign.center,
          maxLines: 1,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          style: widget.santoTabbarController!.selectIndex == index
              ? widget.themeData.tagSelectedTextStyle.generateTextStyle()
              : widget.themeData.tagNormalTextStyle.generateTextStyle(),
        ),
      ),
    );
  }
}

/// SantoTabBar tab 的展示配置
class BadgeTab {
  BadgeTab(
      {this.text,
      this.badgeNum,
      this.topText,
      this.badgeText,
      this.showRedBadge = false,
      this.isAutoDismiss = true});

  /// Tab文本
  final String? text;

  /// 红点数字
  int? badgeNum;

  /// tab顶部文本信息
  String? topText;

  /// 红点显示的文本
  String? badgeText;

  /// 是否显示小红点，默认badgeNum没设置，不显示
  bool showRedBadge;

  /// 小红点是否自动消失
  bool isAutoDismiss;
}
