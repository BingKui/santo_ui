import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 文本省略位置
///
/// 对标 Vant TextEllipsis 的 position:
///  * [start] 省略开头,省略号在开头,保留结尾文本
///  * [middle] 省略中间,保留开头与结尾文本
///  * [end] 省略结尾,省略号在结尾(默认)
enum SantoTextEllipsisPosition {
  start,
  middle,
  end,
}

/// 文本行高,对标 Vant 的 --van-text-ellipsis-line-height
const double kSantoTextEllipsisLineHeight = 1.6;

/// 多行文本省略
///
/// 对标 Vant TextEllipsis:内容超出 [rows] 行时折叠,并在末尾跟上展开操作;
/// 内容未超出时原样展示、不出现操作文案。
///
/// 省略位置由 [position] 控制,折叠时超出的文本替换为 [dots],
/// 展开操作紧跟在省略号之后,保证与文本同行。
///
/// 示例:
/// ```dart
/// SantoTextEllipsis(content: '慢慢来,比较快')
///
/// SantoTextEllipsis(
///   content: '慢慢来,比较快',
///   rows: 2,
///   expandText: '展开',
///   collapseText: '收起',
/// )
/// ```
class SantoTextEllipsis extends StatefulWidget {
  /// 需要展示的文本内容
  final String content;

  /// 展示的行数,超出后折叠,默认 1
  final int rows;

  /// 折叠时显示的省略文案,默认 '...'
  final String dots;

  /// 展开操作的文案
  final String expandText;

  /// 收起操作的文案
  final String collapseText;

  /// 省略位置,默认 [SantoTextEllipsisPosition.end]
  final SantoTextEllipsisPosition position;

  /// 文本样式,默认字号 14、基础文字色、行高 [kSantoTextEllipsisLineHeight]
  final TextStyle? textStyle;

  /// 展开/收起操作的样式,默认品牌主题色
  final TextStyle? actionStyle;

  /// 自定义展开/收起操作,expanded 表示当前是否为展开态
  ///
  /// 返回的 span 替换默认的操作文案;需要自定义点击行为时,
  /// 请在返回的 span 上自行挂载 recognizer,此时不再响应
  /// [onClickAction] 与 [SantoTextEllipsisState.toggle]
  final InlineSpan Function(BuildContext context, bool expanded)? actionBuilder;

  /// 点击展开/收起操作时的回调,参数为点击后的展开状态
  final ValueChanged<bool>? onClickAction;

  const SantoTextEllipsis({
    Key? key,
    this.content = '',
    this.rows = 1,
    this.dots = '...',
    this.expandText = '',
    this.collapseText = '',
    this.position = SantoTextEllipsisPosition.end,
    this.textStyle,
    this.actionStyle,
    this.actionBuilder,
    this.onClickAction,
  })  : assert(rows > 0, 'rows 必须大于 0'),
        super(key: key);

  @override
  SantoTextEllipsisState createState() => SantoTextEllipsisState();
}

class SantoTextEllipsisState extends State<SantoTextEllipsis> {
  bool _expanded = false;
  TapGestureRecognizer? _actionRecognizer;

  /// 当前是否为展开态
  bool get expanded => _expanded;

  /// 切换展开/收起,[isExpanded] 为空时取反
  void toggle([bool? isExpanded]) {
    final bool next = isExpanded ?? !_expanded;
    if (next == _expanded) return;
    setState(() => _expanded = next);
  }

  @override
  void dispose() {
    _actionRecognizer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle style = _resolveTextStyle(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // 宽度不受限时文本不会折行,无需省略
        if (!constraints.hasBoundedWidth) {
          return Text(widget.content, style: style);
        }

        final _SantoEllipsisResult result =
            _ellipsis(context, style, constraints.maxWidth);
        if (!result.hasAction) {
          return Text(widget.content, style: style);
        }

        return Text.rich(
          TextSpan(
            children: <InlineSpan>[
              TextSpan(text: _expanded ? widget.content : result.text),
              _buildActionSpan(context),
            ],
          ),
          style: style,
        );
      },
    );
  }

  TextStyle _resolveTextStyle(BuildContext context) {
    final SantoCommonConfig common =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return widget.textStyle ??
        TextStyle(
          fontSize: common.fontSizeBase,
          color: common.colorTextBase,
          height: kSantoTextEllipsisLineHeight,
        );
  }

  /// 折叠文案与展开/收起操作的 span
  InlineSpan _buildActionSpan(BuildContext context) {
    final InlineSpan? custom = widget.actionBuilder?.call(context, _expanded);
    if (custom != null) return custom;

    if (_actionRecognizer == null) {
      _actionRecognizer = TapGestureRecognizer()..onTap = _onActionTap;
    }

    final SantoCommonConfig common =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return TextSpan(
      text: _expanded ? widget.collapseText : widget.expandText,
      style: widget.actionStyle ?? TextStyle(color: common.brandPrimary),
      recognizer: _actionRecognizer,
    );
  }

  void _onActionTap() {
    toggle();
    widget.onClickAction?.call(_expanded);
  }

  /// 计算折叠文案:二分查找能放下 [dots] 与展开操作的最大文本
  _SantoEllipsisResult _ellipsis(
    BuildContext context,
    TextStyle style,
    double maxWidth,
  ) {
    final TextPainter painter = TextPainter(
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: widget.rows,
    );

    try {
      painter.text = TextSpan(text: widget.content, style: style);
      painter.layout(maxWidth: maxWidth);
      // 内容未超出限定的行数时不展示展开操作
      if (!painter.didExceedMaxLines) {
        return const _SantoEllipsisResult(hasAction: false, text: '');
      }

      final InlineSpan action = _buildActionSpan(context);
      final String content = widget.content;
      final String dots = widget.dots;

      /// 候选文案连同展开操作是否能放进 [rows] 行内
      bool fits(String candidate) {
        painter.text = TextSpan(
          style: style,
          children: <InlineSpan>[TextSpan(text: candidate), action],
        );
        painter.layout(maxWidth: maxWidth);
        return !painter.didExceedMaxLines;
      }

      String text;
      switch (widget.position) {
        case SantoTextEllipsisPosition.end:
          int left = 0;
          int right = content.length;
          while (right - left > 1) {
            final int middle = ((left + right) / 2).round();
            if (fits(content.substring(0, middle) + dots)) {
              left = middle;
            } else {
              right = middle;
            }
          }
          text = content.substring(0, left) + dots;
          break;
        case SantoTextEllipsisPosition.start:
          int left = 0;
          int right = content.length;
          while (right - left > 1) {
            final int middle = ((left + right) / 2).round();
            if (fits(dots + content.substring(middle))) {
              right = middle;
            } else {
              left = middle;
            }
          }
          text = dots + content.substring(right);
          break;
        case SantoTextEllipsisPosition.middle:
          text = _ellipsisMiddle(content, dots, fits);
          break;
      }

      return _SantoEllipsisResult(hasAction: true, text: text);
    } finally {
      painter.dispose();
    }
  }

  /// 省略中间:两端同时二分,左侧保留开头、右侧保留结尾
  String _ellipsisMiddle(
    String content,
    String dots,
    bool Function(String candidate) fits,
  ) {
    String tail(int leftStart, int leftEnd, int rightStart, int rightEnd) {
      if (leftEnd - leftStart <= 1 && rightEnd - rightStart <= 1) {
        return content.substring(0, leftStart) + dots + content.substring(rightEnd);
      }

      final int leftMiddle = ((leftStart + leftEnd) / 2).floor();
      final int rightMiddle = ((rightStart + rightEnd) / 2).ceil();
      final String candidate =
          content.substring(0, leftMiddle) + dots + content.substring(rightMiddle);

      if (!fits(candidate)) {
        return tail(leftStart, leftMiddle, rightMiddle, rightEnd);
      }
      return tail(leftMiddle, leftEnd, rightStart, rightMiddle);
    }

    final int middle = content.length >> 1;
    return tail(0, middle, middle, content.length);
  }
}

class _SantoEllipsisResult {
  const _SantoEllipsisResult({required this.hasAction, required this.text});

  /// 内容是否超出限定的行数
  final bool hasAction;

  /// 折叠时展示的文本
  final String text;
}
