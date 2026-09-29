import 'package:flutter/material.dart';
import 'package:santo_ui/src/components/loading/santo_loading.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 时间轴节点的预设色,取主题里的语义色
///
/// @since v2.3.0
enum SantoTimelineColor {
  /// 品牌色(默认)
  blue,

  /// 失败色
  red,

  /// 成功色
  green,

  /// 失效文字色
  gray,
}

/// 时间轴的排布模式(对标 antd mode)
///
/// @since v2.3.0
enum SantoTimelineMode {
  /// 轴线在起始侧:纵向时内容在轴线右侧,横向时内容在轴线下方(默认)
  start,

  /// 节点交替分布在轴线两侧
  alternate,

  /// 轴线在结束侧:纵向时内容在轴线左侧,横向时内容在轴线上方
  end,
}

/// 时间轴的排布方向(对标 antd orientation)
///
/// @since v2.3.0
enum SantoTimelineOrientation {
  /// 纵向:节点自上而下排列(默认)
  vertical,

  /// 横向:节点自左向右排列
  horizontal,
}

/// 节点样式(对标 antd variant)
///
/// @since v2.3.0
enum SantoTimelineVariant {
  /// 空心节点:描边取节点色,内部填充组件背景色(默认)
  outlined,

  /// 实心节点:整颗节点填充为节点色
  filled,
}

/// 节点相对轴线的侧位(对标 antd placement)
///
/// @since v2.3.0
enum SantoTimelinePlacement {
  /// 起始侧:纵向为轴线左侧,横向为轴线上方
  start,

  /// 结束侧:纵向为轴线右侧,横向为轴线下方
  end,
}

/// 时间轴的一个节点(对标 antd Timeline 的 items 单元)
///
/// @since v2.3.0
class SantoTimelineItem {
  /// 标题/时间文案,排在轴线的一侧
  final String? title;

  /// 自定义标题,优先级高于 [title]
  final Widget? titleWidget;

  /// 节点内容
  final Widget? content;

  /// 节点色预设,默认 [SantoTimelineColor.blue]
  final SantoTimelineColor? color;

  /// 自定义节点色,优先级高于 [color]
  final Color? dotColor;

  /// 自定义节点,优先级高于 [color] / [dotColor]
  final Widget? icon;

  /// 是否为进行中的幽灵节点:节点展示加载指示器,指向它的那段轴线转为虚线
  final bool loading;

  /// 自定义该节点在轴线的哪一侧,不传时由 [SantoTimeline.mode] 决定
  final SantoTimelinePlacement? placement;

  const SantoTimelineItem({
    this.title,
    this.titleWidget,
    this.content,
    this.color,
    this.dotColor,
    this.icon,
    this.loading = false,
    this.placement,
  });

  /// 是否配置了标题
  bool get hasTitle => title != null || titleWidget != null;
}

/// 时间轴:按时间顺序展示一系列节点(对标 antd Timeline)
///
/// 纵向支持三种排布:[SantoTimelineMode.start] 轴线在左、内容在右;
/// [SantoTimelineMode.end] 轴线在右、内容在左;[SantoTimelineMode.alternate] 内容左右交替。
/// 传入 [SantoTimelineItem.title] 后,标题与内容分列轴线两侧(轴线居中或按 [titleSpan] 偏移)。
///
/// 横向把节点自左向右排开:start 时内容在轴线下方,end 时内容在轴线上方,alternate 时上下交替。
/// 横向的内容建议单行展示,交替模式下上下的可用高度均为一半。
///
/// ```dart
/// SantoTimeline(
///   items: const <SantoTimelineItem>[
///     SantoTimelineItem(title: '2015-09-01', content: Text('创建服务站点')),
///     SantoTimelineItem(title: '2015-09-01', content: Text('解决网络问题'), color: SantoTimelineColor.red),
///     SantoTimelineItem(content: Text('技术测试')),
///   ],
/// )
/// ```
///
/// @since v2.3.0
class SantoTimeline extends StatelessWidget {
  /// 节点列表,按传入顺序自上而下(或自左向右)排布
  final List<SantoTimelineItem> items;

  /// 排布模式,默认 [SantoTimelineMode.start]
  final SantoTimelineMode mode;

  /// 排布方向,默认 [SantoTimelineOrientation.vertical]
  final SantoTimelineOrientation orientation;

  /// 节点样式,默认 [SantoTimelineVariant.outlined]
  final SantoTimelineVariant variant;

  /// 是否倒序渲染节点(节点的侧位仍按传入顺序决定,对标 antd reverse)
  final bool reverse;

  /// 标题列宽度(逻辑像素),仅纵向且存在标题时生效;
  /// 为 null 时标题列与内容列各占一半(轴线居中)
  final double? titleSpan;

  const SantoTimeline({
    super.key,
    required this.items,
    this.mode = SantoTimelineMode.start,
    this.orientation = SantoTimelineOrientation.vertical,
    this.variant = SantoTimelineVariant.outlined,
    this.reverse = false,
    this.titleSpan,
  });

  /// 节点直径,对标 antd 的 itemHeadSize
  static const double _dotSize = 10;

  /// 节点描边宽度,对标 antd 的 dotBorderWidth
  static const double _dotBorderWidth = 2;

  /// 轴线宽度,对标 antd 的 tailWidth
  static const double _railWidth = 2;

  /// 自定义节点的最大边长,超出轴线槽位时上下左右对称溢出
  static const double _customDotMaxSize = 40;

  /// 文本行高倍数:节点圆心与首行文字中线对齐
  static const double _lineHeightFactor = 1.5;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final SantoCommonConfig commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;

    // 侧位按传入顺序决定,reverse 只改渲染顺序
    final List<_SantoTimelineNode> nodes = <_SantoTimelineNode>[
      for (int i = 0; i < items.length; i++)
        _SantoTimelineNode(
          item: items[i],
          onEndSide: _isOnEndSide(items[i], i),
        ),
    ];
    final List<_SantoTimelineNode> rendered =
        reverse ? nodes.reversed.toList() : nodes;
    final bool hasTitle = rendered.any((node) => node.item.hasTitle);

    return orientation == SantoTimelineOrientation.horizontal
        ? _buildHorizontal(commonConfig, rendered)
        : _buildVertical(commonConfig, rendered, hasTitle);
  }

  /// 节点是否排在轴线的结束侧
  bool _isOnEndSide(SantoTimelineItem item, int index) {
    if (item.placement != null) {
      return item.placement == SantoTimelinePlacement.end;
    }
    switch (mode) {
      case SantoTimelineMode.start:
        return false;
      case SantoTimelineMode.end:
        return true;
      case SantoTimelineMode.alternate:
        return index.isOdd;
    }
  }

  // ============================ 纵向 ============================

  Widget _buildVertical(
    SantoCommonConfig commonConfig,
    List<_SantoTimelineNode> nodes,
    bool hasTitle,
  ) {
    // 轴线槽取图标尺寸,保证自定义节点与加载指示器放得下
    final double axisExtent = commonConfig.iconSizeMd;
    final double textGap = commonConfig.hSpacingMd;
    final double itemGap = commonConfig.vSpacingMd;
    // 节点圆心相对行顶的偏移:与首行文字中线对齐
    final double dotTop = commonConfig.fontSizeBase * _lineHeightFactor / 2 -
        _dotSize / 2;
    // 有标题或左右交替时,节点分列轴线两侧
    final bool twoColumn = hasTitle || mode == SantoTimelineMode.alternate;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (int i = 0; i < nodes.length; i++)
          _verticalNode(
            commonConfig,
            nodes[i],
            isFirst: i == 0,
            isLast: i == nodes.length - 1,
            twoColumn: twoColumn,
            incomingDashed: nodes[i].item.loading,
            outgoingDashed:
                i + 1 < nodes.length && nodes[i + 1].item.loading,
            dotTop: dotTop,
            axisExtent: axisExtent,
            textGap: textGap,
            itemGap: itemGap,
          ),
      ],
    );
  }

  Widget _verticalNode(
    SantoCommonConfig commonConfig,
    _SantoTimelineNode node, {
    required bool isFirst,
    required bool isLast,
    required bool twoColumn,
    required bool incomingDashed,
    required bool outgoingDashed,
    required double dotTop,
    required double axisExtent,
    required double textGap,
    required double itemGap,
  }) {
    final SantoTimelineItem item = node.item;
    final bool isEnd = node.onEndSide;
    final double bottomGap = isLast ? 0 : itemGap;

    // 轴线槽:首个节点不留上半段,末个节点不留下半段,中间节点两段相接
    final Widget axis = SizedBox(
      width: axisExtent,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: dotTop,
            child: isFirst
                ? null
                : _verticalRail(commonConfig, dashed: incomingDashed),
          ),
          _dotSlot(commonConfig, item),
          if (!isLast)
            Expanded(
              child: _verticalRail(commonConfig, dashed: outgoingDashed),
            ),
          if (!isLast)
            SizedBox(
              height: itemGap,
              child: _verticalRail(commonConfig, dashed: outgoingDashed),
            ),
        ],
      ),
    );

    final Widget content = Padding(
      padding: EdgeInsets.only(
        left: isEnd ? 0 : textGap,
        right: isEnd ? textGap : 0,
        bottom: bottomGap,
      ),
      child: Align(
        alignment: isEnd ? Alignment.topRight : Alignment.topLeft,
        child: _contentWidget(commonConfig, item),
      ),
    );

    final List<Widget> children = <Widget>[];
    if (twoColumn) {
      final Widget title = Padding(
        padding: EdgeInsets.only(
          left: isEnd ? textGap : 0,
          right: isEnd ? 0 : textGap,
          bottom: bottomGap,
        ),
        child: Align(
          alignment: isEnd ? Alignment.topLeft : Alignment.topRight,
          child: _titleWidget(commonConfig, item),
        ),
      );
      final Widget titleSlot = titleSpan == null || titleSpan! <= 0
          ? Expanded(child: title)
          : SizedBox(width: titleSpan, child: title);
      if (isEnd) {
        children.addAll(<Widget>[
          Expanded(child: content),
          axis,
          titleSlot,
        ]);
      } else {
        children.addAll(<Widget>[
          titleSlot,
          axis,
          Expanded(child: content),
        ]);
      }
    } else if (isEnd) {
      children.addAll(<Widget>[Expanded(child: content), axis]);
    } else {
      children.addAll(<Widget>[axis, Expanded(child: content)]);
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  // ============================ 横向 ============================

  Widget _buildHorizontal(
    SantoCommonConfig commonConfig,
    List<_SantoTimelineNode> nodes,
  ) {
    final double railGap = commonConfig.vSpacingSm;
    final bool alternate = mode == SantoTimelineMode.alternate;

    final List<Widget> children = <Widget>[
      for (int i = 0; i < nodes.length; i++)
        Expanded(
          child: _horizontalNode(
            commonConfig,
            nodes[i],
            isFirst: i == 0,
            isLast: i == nodes.length - 1,
            alternate: alternate,
            railGap: railGap,
            nextLoading: i + 1 < nodes.length && nodes[i + 1].item.loading,
          ),
        ),
    ];

    if (alternate) {
      // 上下两侧均分,保证各节点圆心落在同一条轴线上
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      );
    }
    return Row(
      crossAxisAlignment:
          mode == SantoTimelineMode.end ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _horizontalNode(
    SantoCommonConfig commonConfig,
    _SantoTimelineNode node, {
    required bool isFirst,
    required bool isLast,
    required bool alternate,
    required double railGap,
    required bool nextLoading,
  }) {
    final SantoTimelineItem item = node.item;
    final bool isEnd = node.onEndSide;

    final Widget railRow = SizedBox(
      height: _dotSize,
      child: Row(
        children: <Widget>[
          // 首个节点的左半段与末个节点的右半段留空,轴线起止于首末节点
          Expanded(
            child: isFirst
                ? const SizedBox.shrink()
                : _horizontalRail(commonConfig, dashed: item.loading),
          ),
          _dotSlot(commonConfig, item),
          Expanded(
            child: isLast
                ? const SizedBox.shrink()
                : _horizontalRail(commonConfig, dashed: nextLoading),
          ),
        ],
      ),
    );

    final Widget title = _horizontalText(commonConfig, _titleWidget(commonConfig, item));
    final Widget content =
        _horizontalText(commonConfig, _contentWidget(commonConfig, item));

    if (alternate) {
      // 交替布局:标题与内容分列轴线上下,按侧位互换
      final Widget upWidget = isEnd ? content : title;
      final Widget downWidget = isEnd ? title : content;
      return Column(
        children: <Widget>[
          Expanded(
            child: Align(alignment: Alignment.bottomCenter, child: upWidget),
          ),
          railRow,
          Expanded(
            child: Align(alignment: Alignment.topCenter, child: downWidget),
          ),
        ],
      );
    }

    final List<Widget> texts = mode == SantoTimelineMode.end
        ? <Widget>[content, title]
        : <Widget>[title, content];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (mode != SantoTimelineMode.end) railRow,
        if (mode != SantoTimelineMode.end) SizedBox(height: railGap),
        ...texts,
        if (mode == SantoTimelineMode.end) SizedBox(height: railGap),
        if (mode == SantoTimelineMode.end) railRow,
      ],
    );
  }

  Widget _horizontalText(SantoCommonConfig commonConfig, Widget child) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: commonConfig.gapXs),
      child: Align(alignment: Alignment.center, child: child),
    );
  }

  // ============================ 公共 ============================

  Widget _titleWidget(SantoCommonConfig commonConfig, SantoTimelineItem item) {
    final Widget? title = item.titleWidget ??
        (item.title == null ? null : Text(item.title!));
    if (title == null) {
      return const SizedBox.shrink();
    }
    return DefaultTextStyle.merge(
      style: TextStyle(
        fontSize: commonConfig.fontSizeBase,
        height: _lineHeightFactor,
        color: commonConfig.colorTextSecondary,
      ),
      child: title,
    );
  }

  Widget _contentWidget(SantoCommonConfig commonConfig, SantoTimelineItem item) {
    final Widget content = item.content ?? const SizedBox.shrink();
    return DefaultTextStyle.merge(
      style: TextStyle(
        fontSize: commonConfig.fontSizeBase,
        height: _lineHeightFactor,
        color: commonConfig.colorTextBase,
      ),
      child: content,
    );
  }

  /// 轴线槽位:节点在其内部水平居中,自定义节点与加载指示器可对称溢出
  ///
  /// 槽位高度只有节点直径,加载指示器比它大,必须走 [OverflowBox] 拿回自身尺寸,
  /// 否则会被紧约束压成椭圆
  Widget _dotSlot(SantoCommonConfig commonConfig, SantoTimelineItem item) {
    final double axisExtent = commonConfig.iconSizeMd;
    final Widget dot = _dot(commonConfig, item);
    return SizedBox(
      width: axisExtent,
      height: _dotSize,
      child: item.icon == null && !item.loading
          ? Center(child: dot)
          : OverflowBox(
              maxWidth: _customDotMaxSize,
              maxHeight: _customDotMaxSize,
              child: dot,
            ),
    );
  }

  Widget _dot(SantoCommonConfig commonConfig, SantoTimelineItem item) {
    final Color color = _dotColor(commonConfig, item);
    if (item.loading) {
      return SantoLoading(size: SantoLoadingSize.small, color: color);
    }
    if (item.icon != null) {
      return item.icon!;
    }
    final bool filled = variant == SantoTimelineVariant.filled;
    return Container(
      width: _dotSize,
      height: _dotSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? color : commonConfig.fillBase,
        border: filled
            ? null
            : Border.all(color: color, width: _dotBorderWidth),
      ),
    );
  }

  Color _dotColor(SantoCommonConfig commonConfig, SantoTimelineItem item) {
    if (item.dotColor != null) {
      return item.dotColor!;
    }
    switch (item.color ?? SantoTimelineColor.blue) {
      case SantoTimelineColor.blue:
        return commonConfig.brandPrimary;
      case SantoTimelineColor.red:
        return commonConfig.brandError;
      case SantoTimelineColor.green:
        return commonConfig.brandSuccess;
      case SantoTimelineColor.gray:
        return commonConfig.colorTextDisabled;
    }
  }

  Widget _verticalRail(SantoCommonConfig commonConfig, {required bool dashed}) {
    return SizedBox(
      width: _railWidth,
      height: double.infinity,
      child: dashed
          ? CustomPaint(
              painter: _DashedRailPainter(
                color: commonConfig.dividerColorBase,
                axis: Axis.vertical,
              ),
            )
          : ColoredBox(color: commonConfig.dividerColorBase),
    );
  }

  Widget _horizontalRail(SantoCommonConfig commonConfig,
      {required bool dashed}) {
    return SizedBox(
      height: _railWidth,
      width: double.infinity,
      child: dashed
          ? CustomPaint(
              painter: _DashedRailPainter(
                color: commonConfig.dividerColorBase,
                axis: Axis.horizontal,
              ),
            )
          : ColoredBox(color: commonConfig.dividerColorBase),
    );
  }
}

/// 渲染顺序里的一个节点:记录节点数据与最终侧位
class _SantoTimelineNode {
  final SantoTimelineItem item;
  final bool onEndSide;

  const _SantoTimelineNode({required this.item, required this.onEndSide});
}

/// 虚线轴线绘制(加载中的幽灵节点前一段轴线为虚线)
class _DashedRailPainter extends CustomPainter {
  final Color color;
  final Axis axis;

  static const double _dashLength = 4;
  static const double _dashGap = 3;

  const _DashedRailPainter({required this.color, required this.axis});

  @override
  void paint(Canvas canvas, Size size) {
    final double thickness =
        axis == Axis.horizontal ? size.height : size.width;
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.butt;

    final double total = axis == Axis.horizontal ? size.width : size.height;
    double start = 0;
    while (start < total) {
      final double end = (start + _dashLength) < total ? start + _dashLength : total;
      canvas.drawLine(
        axis == Axis.horizontal
            ? Offset(start, size.height / 2)
            : Offset(size.width / 2, start),
        axis == Axis.horizontal
            ? Offset(end, size.height / 2)
            : Offset(size.width / 2, end),
        paint,
      );
      start = end + _dashGap;
    }
  }

  @override
  bool shouldRepaint(_DashedRailPainter oldDelegate) {
    return color != oldDelegate.color || axis != oldDelegate.axis;
  }
}
