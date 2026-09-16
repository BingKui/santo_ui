import 'package:flutter/material.dart';

import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 分页模式
enum SantoPaginationMode {
  /// 多页模式:展示页码列表
  multi,

  /// 简单模式:只展示"当前页/总页数"
  simple,
}

/// 分页高度
const double kSantoPaginationHeight = 40;

/// 分页项最小宽度
const double kSantoPaginationItemMinWidth = 36;

/// 上一页/下一页的固定宽度
const double kSantoPaginationButtonWidth = 60;

/// 分页圆角
const double kSantoPaginationRadius = 12;

/// 上一页/下一页的左右内边距
const double kSantoPaginationButtonPadding = 8;

/// 贴外框左侧的圆角(上一页)
const BorderRadius _leftEdgeRadius = BorderRadius.only(
  topLeft: Radius.circular(kSantoPaginationRadius),
  bottomLeft: Radius.circular(kSantoPaginationRadius),
);

/// 贴外框右侧的圆角(下一页)
const BorderRadius _rightEdgeRadius = BorderRadius.only(
  topRight: Radius.circular(kSantoPaginationRadius),
  bottomRight: Radius.circular(kSantoPaginationRadius),
);

/// 整条只有一个分页项时的圆角
const BorderRadius _allEdgeRadius = BorderRadius.all(
  Radius.circular(kSantoPaginationRadius),
);

/// 分页组件:把大量数据分页展示
///
/// 参考 vant Pagination:多页模式展示页码并支持省略号,简单模式展示"当前页/总页数"。
/// 组件为受控组件,[current] 为当前页,[onChange] 回传点击后的页码。
///
/// 示例:
/// ```dart
/// SantoPagination(
///   current: _page,
///   totalItems: 50,
///   itemsPerPage: 10,
///   onChange: (page) => setState(() => _page = page),
/// )
/// ```
class SantoPagination extends StatelessWidget {
  /// 分页模式,默认多页模式
  final SantoPaginationMode mode;

  /// 当前页码,从 1 开始
  final int current;

  /// 页码变化回调
  final ValueChanged<int>? onChange;

  /// 总条数,配合 [itemsPerPage] 算出总页数
  final int totalItems;

  /// 每页条数
  final int itemsPerPage;

  /// 总页数,大于 0 时优先于 [totalItems] 与 [itemsPerPage]
  final int pageCount;

  /// 多页模式下同时展示的页码数量
  final int showPageSize;

  /// 是否展示省略号,点击省略号跳到相邻页
  final bool forceEllipses;

  /// 是否展示上一页按钮
  final bool showPrevButton;

  /// 是否展示下一页按钮
  final bool showNextButton;

  /// 上一页文案
  final String? prevText;

  /// 下一页文案
  final String? nextText;

  const SantoPagination({
    Key? key,
    this.mode = SantoPaginationMode.multi,
    this.current = 1,
    this.onChange,
    this.totalItems = 0,
    this.itemsPerPage = 10,
    this.pageCount = 0,
    this.showPageSize = 5,
    this.forceEllipses = false,
    this.showPrevButton = true,
    this.showNextButton = true,
    this.prevText,
    this.nextText,
  }) : super(key: key);

  /// 总页数:显式 [pageCount] 优先,否则按总条数向上取整,至少 1 页
  int get _totalPages {
    final int count = pageCount > 0
        ? pageCount
        : (itemsPerPage > 0 ? (totalItems / itemsPerPage).ceil() : 1);
    return count < 1 ? 1 : count;
  }

  /// 当前页码,越界时按边界展示
  int get _currentPage => current.clamp(1, _totalPages);

  /// 多页模式展示的页码,`text` 为 '...' 表示省略号
  List<_SantoPageItem> _buildPageItems() {
    final int count = _totalPages;
    final int page = _currentPage;
    final List<_SantoPageItem> items = <_SantoPageItem>[];

    // 页码数不足 showPageSize 时全部展示
    final bool isMaxSized = showPageSize < count;
    int startPage = 1;
    int endPage = count;

    if (isMaxSized) {
      // 当前页尽量居中
      startPage = page - showPageSize ~/ 2;
      if (startPage < 1) {
        startPage = 1;
      }
      endPage = startPage + showPageSize - 1;

      // 右边界超出时整组左移
      if (endPage > count) {
        endPage = count;
        startPage = endPage - showPageSize + 1;
      }
    }

    for (int number = startPage; number <= endPage; number++) {
      items.add(_SantoPageItem(
        number: number,
        text: '$number',
        active: number == page,
      ));
    }

    // 省略号:点击跳到相邻页
    if (isMaxSized && showPageSize > 0 && forceEllipses) {
      if (startPage > 1) {
        items.insert(0, _SantoPageItem(number: startPage - 1, text: '...'));
      }
      if (endPage < count) {
        items.add(_SantoPageItem(number: endPage + 1, text: '...'));
      }
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final SantoCommonConfig commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final int count = _totalPages;
    final int page = _currentPage;
    final bool simple = mode == SantoPaginationMode.simple;
    final List<_SantoPageItem> pageItems =
        simple ? <_SantoPageItem>[] : _buildPageItems();
    final int itemCount = (showPrevButton ? 1 : 0) +
        (simple ? 1 : pageItems.length) +
        (showNextButton ? 1 : 0);
    final List<Widget> cells = <Widget>[];
    int itemIndex = 0;

    // 外框圆角由第一项/最后一项承担:没有上一页/下一页时由页码项承担
    BorderRadius? takeEdgeRadius() {
      final bool isFirst = itemIndex == 0;
      final bool isLast = itemIndex == itemCount - 1;
      itemIndex++;
      if (isFirst && isLast) return _allEdgeRadius;
      if (isFirst) return _leftEdgeRadius;
      if (isLast) return _rightEdgeRadius;
      return null;
    }

    // 拼装分页项,项与项之间插入分割线
    void addCell(Widget cell) {
      if (cells.isNotEmpty) {
        cells.add(_buildDivider(commonConfig));
      }
      cells.add(cell);
    }

    if (showPrevButton) {
      addCell(_buildCell(
        commonConfig,
        text: prevText ?? '上一页',
        disabled: page <= 1,
        button: true,
        width: kSantoPaginationButtonWidth,
        borderRadius: takeEdgeRadius(),
        onTap: () => _select(page - 1, count),
      ));
    }

    if (simple) {
      // 简单模式的中间文案与上一页/下一页等宽
      addCell(_buildCell(
        commonConfig,
        text: '$page/$count',
        width: kSantoPaginationButtonWidth,
        textColor: commonConfig.colorTextSecondary,
        borderRadius: takeEdgeRadius(),
      ));
    } else {
      for (final _SantoPageItem item in pageItems) {
        // 页码项默认按最小宽度排布,空间不足时收窄,避免整条溢出
        addCell(Flexible(
          fit: FlexFit.loose,
          child: _buildCell(
            commonConfig,
            text: item.text,
            active: item.active,
            borderRadius: takeEdgeRadius(),
            onTap: () => _select(item.number, count),
          ),
        ));
      }
    }

    if (showNextButton) {
      addCell(_buildCell(
        commonConfig,
        text: nextText ?? '下一页',
        disabled: page >= count,
        button: true,
        width: kSantoPaginationButtonWidth,
        borderRadius: takeEdgeRadius(),
        onTap: () => _select(page + 1, count),
      ));
    }

    // 整条外框:第一项贴左圆角、最后一项贴右圆角(各自的底色自带圆角,不裁切子节点,
    // 否则外框的四角 border 会被格子底色盖住);整条宽度由内容决定
    return Container(
      height: kSantoPaginationHeight,
      decoration: BoxDecoration(
        color: commonConfig.fillBase,
        borderRadius: BorderRadius.all(Radius.circular(kSantoPaginationRadius)),
        border: Border.all(
          color: commonConfig.borderColorBase,
          width: commonConfig.borderWidthSm,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: cells,
      ),
    );
  }

  /// 页码越界时按边界回传
  void _select(int page, int count) {
    final int target = page.clamp(1, count);
    if (target != current) {
      onChange?.call(target);
    }
  }

  /// 项与项之间的分割线
  Widget _buildDivider(SantoCommonConfig commonConfig) {
    return Container(
      width: commonConfig.borderWidthSm,
      color: commonConfig.dividerColorBase,
    );
  }

  /// 单个分页项
  ///
  /// 宽度自适应内容:页码项不小于 [kSantoPaginationItemMinWidth],上一页/下一页
  /// 固定为 [kSantoPaginationButtonWidth];底色用 [Material] 承载,
  /// 否则 Container 的底色会盖住点击水波纹。
  Widget _buildCell(
    SantoCommonConfig commonConfig, {
    required String text,
    double? width,
    bool active = false,
    bool button = false,
    bool disabled = false,
    Color? textColor,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
  }) {
    final Widget content = Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: kSantoPaginationButtonPadding),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Flexible 让文字拿到有界约束,超长时走省略号
          Flexible(
            child: _buildText(
              commonConfig,
              text,
              active: active,
              button: button,
              disabled: disabled,
              textColor: textColor,
            ),
          ),
        ],
      ),
    );

    final Widget sized = width != null
        ? SizedBox(width: width, child: content)
        : ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: kSantoPaginationItemMinWidth),
            child: content,
          );

    return Material(
      color: active
          ? commonConfig.brandPrimary
          : (button ? commonConfig.fillBody : commonConfig.fillBase),
      borderRadius: borderRadius,
      child:
          onTap == null ? sized : InkWell(onTap: disabled ? null : onTap, child: sized),
    );
  }

  /// 分页文案
  Widget _buildText(
    SantoCommonConfig commonConfig,
    String text, {
    bool active = false,
    bool button = false,
    bool disabled = false,
    Color? textColor,
  }) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: commonConfig.fontSizeBase,
        fontWeight: active ? FontWeight.w500 : FontWeight.w400,
        color: active
            ? commonConfig.colorTextBaseInverse
            : (textColor ??
                (disabled
                    ? commonConfig.colorTextDisabled
                    : (button
                        ? commonConfig.colorTextBase
                        : commonConfig.brandPrimary))),
      ),
    );
  }
}

/// 分页项数据
class _SantoPageItem {
  /// 点击后跳转的页码
  final int number;

  /// 展示文案,'...' 表示省略号
  final String text;

  /// 是否为当前页
  final bool active;

  const _SantoPageItem({
    required this.number,
    required this.text,
    this.active = false,
  });
}
