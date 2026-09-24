import 'package:flutter/material.dart';

import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 底部 Drawer 标题对齐方式
enum SantoBottomDrawerTitleAlign {
  /// 左侧
  left,

  /// 居中
  center,
}

/// 底部弹出的抽屉面板
///
/// 独立组件,带标题/描述 Header、右侧关闭按钮,支持配置标题对齐、
/// 点击遮罩是否关闭、底部安全区域。
/// 通过 [SantoBottomDrawer.show] 静态方法打开。
///
/// 高度模式:未设置 [height] 时自适应内容(最大为 [maxHeight],默认屏幕
/// 高度的 85%),此时内容建议使用可滚动控件或内容高度可控;设置 [height]
/// 后为固定高度,内容区通过 [Expanded] 撑满,可自由使用 [Expanded]/[Flexible]。
///
/// 使用示例：
/// ```dart
/// SantoBottomDrawer.show(
///   context: context,
///   title: '标题',
///   desc: '描述文案',
///   titleAlign: SantoBottomDrawerTitleAlign.center,
///   child: Text('内容'),
/// );
/// ```
class SantoBottomDrawer extends StatelessWidget {
  /// 标题文案,优先级低于 [titleWidget]
  final String? title;

  /// 自定义标题控件,设置后 [title] 失效
  final Widget? titleWidget;

  /// 标题下方的描述文案
  final String? desc;

  /// 标题对齐方式,默认左侧
  final SantoBottomDrawerTitleAlign titleAlign;

  /// 是否显示右侧关闭按钮,默认 true
  final bool showCloseButton;

  /// 关闭按钮点击回调,触发后抽屉关闭
  final VoidCallback? onClose;

  /// 点击遮罩是否关闭,默认 true
  final bool barrierDismissible;

  /// 遮罩层颜色,默认半透明黑色
  final Color? maskColor;

  /// 抽屉固定高度,默认 null 自适应内容
  final double? height;

  /// 自适应内容时的最大高度,默认屏幕高度的 85%
  final double? maxHeight;

  /// 顶部圆角,不传时取主题 radiusMd
  final double? radius;

  /// 抽屉背景色,不传时取主题 fillBase
  final Color? backgroundColor;

  /// 内容区是否处理底部安全区域,默认 true
  final bool bottomSafeArea;

  /// 内容区内边距,不传时四周取主题 hSpacingLg / vSpacingLg(不含安全区)
  final EdgeInsets? contentPadding;

  /// 内容区控件
  final Widget child;

  const SantoBottomDrawer({
    Key? key,
    this.title,
    this.titleWidget,
    this.desc,
    this.titleAlign = SantoBottomDrawerTitleAlign.left,
    this.showCloseButton = true,
    this.onClose,
    this.barrierDismissible = true,
    this.maskColor,
    this.height,
    this.maxHeight,
    this.radius,
    this.backgroundColor,
    this.bottomSafeArea = true,
    this.contentPadding,
    required this.child,
  }) : super(key: key);

  /// 显示底部抽屉
  ///
  /// * [barrierDismissible] 点击遮罩是否关闭,默认 true
  /// * 其余参数见 [SantoBottomDrawer]
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    Widget? titleWidget,
    String? desc,
    SantoBottomDrawerTitleAlign titleAlign = SantoBottomDrawerTitleAlign.left,
    bool showCloseButton = true,
    VoidCallback? onClose,
    bool barrierDismissible = true,
    Color? maskColor,
    double? height,
    double? maxHeight,
    double? radius,
    Color? backgroundColor,
    bool bottomSafeArea = true,
    EdgeInsets? contentPadding,
    required Widget child,
  }) {
    return Navigator.of(context).push<T>(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: barrierDismissible,
        barrierColor: maskColor ??
            SantoThemeConfigurator.instance.getConfig().commonConfig.fillMask,
        pageBuilder: (context, animation, secondaryAnimation) {
          return SantoBottomDrawer(
            title: title,
            titleWidget: titleWidget,
            desc: desc,
            titleAlign: titleAlign,
            showCloseButton: showCloseButton,
            onClose: onClose,
            barrierDismissible: barrierDismissible,
            maskColor: maskColor,
            height: height,
            maxHeight: maxHeight,
            radius: radius,
            backgroundColor: backgroundColor,
            bottomSafeArea: bottomSafeArea,
            contentPadding: contentPadding,
            child: child,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
      ),
    );
  }

  void _close(BuildContext context) {
    onClose?.call();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final effectiveMaxHeight =
        maxHeight ?? MediaQuery.of(context).size.height * 0.85;
    final safeAreaBottom =
        bottomSafeArea ? MediaQuery.of(context).padding.bottom : 0.0;
    // 内容区底部安全区处理方式与 SantoFloatingPanel 一致:
    // - 背景铺满到屏幕底部(包含安全区)
    // - contentPadding 完整应用到四边(底部含 contentPadding.bottom,
    //   非滚动内容不会贴到屏幕底)
    // - 底部安全区通过 MediaQuery 传递,由可滚动内容自身消费
    final EdgeInsets resolvedContentPadding = contentPadding ??
        EdgeInsets.symmetric(
          horizontal: commonConfig.hSpacingLg,
          vertical: commonConfig.vSpacingLg,
        );
    final bottomPadding = resolvedContentPadding.bottom;
    Widget content = Padding(
      padding: EdgeInsets.fromLTRB(
        resolvedContentPadding.left,
        resolvedContentPadding.top,
        resolvedContentPadding.right,
        bottomPadding,
      ),
      child: child,
    );
    if (safeAreaBottom > 0) {
      content = MediaQuery(
        data: MediaQuery.of(context).copyWith(
          padding: EdgeInsets.only(bottom: safeAreaBottom),
        ),
        child: content,
      );
    }
    // 键盘弹起时整体上移到键盘上方,避免输入区域被键盘遮挡
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: keyboardInset),
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: () {}, // 阻止事件穿透到遮罩
          child: Material(
            color: backgroundColor ?? commonConfig.fillBase,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(radius ?? commonConfig.radiusMd),
            ),
            clipBehavior: Clip.antiAlias,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: height ?? 0,
                  maxHeight: height ?? effectiveMaxHeight,
                ),
                child: Column(
                  mainAxisSize:
                      height != null ? MainAxisSize.max : MainAxisSize.min,
                  children: [
                    _buildHeader(context),
                    if (height != null)
                      Expanded(child: content)
                    else
                      Flexible(
                        // 自适应高度:内容本身是滚动控件(ScrollView)时直接交给
                        // Flexible,由其自身在 maxHeight 内滚动(套
                        // SingleChildScrollView 会让 ListView 拿到无界高度);
                        // 普通内容由外层 SingleChildScrollView 兜底滚动
                        child: child is ScrollView
                            ? content
                            : SingleChildScrollView(child: content),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Header:标题/描述(左对齐或居中) + 右侧关闭按钮
  Widget _buildHeader(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    if (title == null && titleWidget == null && !showCloseButton) {
      return const SizedBox.shrink();
    }

    // 只显示关闭按钮时标题为空
    Widget titleContent = titleWidget ??
        (title == null ? const SizedBox.shrink() : Text(title!));
    titleContent = Column(
      crossAxisAlignment: titleAlign == SantoBottomDrawerTitleAlign.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DefaultTextStyle(
          style: TextStyle(
            fontSize: commonConfig.fontSizeHead,
            fontWeight: FontWeight.w500,
            color: commonConfig.colorTextBase,
          ),
          child: titleContent,
        ),
        if (desc != null) ...[
          SizedBox(height: commonConfig.vSpacingXs),
          Text(
            desc!,
            style: TextStyle(
              fontSize: commonConfig.fontSizeCaption,
              color: commonConfig.colorTextSecondary,
            ),
          ),
        ],
      ],
    );

    final closeButton = showCloseButton
        ? GestureDetector(
            onTap: () => _close(context),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.all(commonConfig.vSpacingSm),
              child: Icon(Icons.close,
                  size: 20, color: commonConfig.colorTextSecondary),
            ),
          )
        : null;

    Widget header;
    if (titleAlign == SantoBottomDrawerTitleAlign.center) {
      header = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(child: SizedBox()),
          Flexible(child: titleContent),
          Expanded(
            child: Align(
              alignment: Alignment.topRight,
              child: closeButton ?? const SizedBox(),
            ),
          ),
        ],
      );
    } else {
      header = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: titleContent),
          ?closeButton,
        ],
      );
    }

    return Padding(
      padding: EdgeInsets.only(
          left: commonConfig.hSpacingLg,
          top: commonConfig.vSpacingMd,
          right: 12,
          bottom: 0),
      child: header,
    );
  }
}
