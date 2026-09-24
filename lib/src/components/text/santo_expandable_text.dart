import 'package:santo_ui/src/l10n/santo_intl.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

typedef TextExpandedCallback = Function(bool);

/// 具备展开收起功能的文字面板
///
/// 布局规则：
///     在文本的右下角有更多或者收起按钮
///     当文本超过指定的[maxLines]时，剩余文本隐藏
///     点击更多，则显示全部文本
///
/// ```dart
///   SantoExpandableText(
///      text: '在文本的右下角有更多或者收起按钮',
///   )
///
///   SantoExpandableText(
///      text: '具备展开收起功能的文字面板，在文本的右下角有更多或者收起按钮',
///      maxLines: 2,
///      onExpanded: (value) {
///      },
///   )
///
///
/// ```
///
/// 相关文本组件如下:
///  * [SantoBubbleText], 气泡背景的展开收起文本组件
///
class SantoExpandableText extends StatefulWidget {
  ///显示的文本
  final String text;

  ///显示的最多行数
  final int? maxLines;

  /// 文本的样式
  final TextStyle? textStyle;

  /// 展开或者收起的时候的回调
  final TextExpandedCallback? onExpanded;

  /// 更多按钮渐变色的初始色 默认白色
  final Color? color;

  const SantoExpandableText(
      {Key? key,
      required this.text,
      this.maxLines = 1000000,
      this.textStyle,
      this.onExpanded,
      this.color})
      : super(key: key);

  _SantoExpandableTextState createState() => _SantoExpandableTextState();
}

class _SantoExpandableTextState extends State<SantoExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    TextStyle style = _defaultTextStyle();
    return LayoutBuilder(
      builder: (context, size) {
        final span = TextSpan(text: widget.text, style: style);
        final tp = TextPainter(
            text: span,
            maxLines: widget.maxLines,
            textDirection: TextDirection.ltr,
            ellipsis: 'EllipseText');
        tp.layout(maxWidth: size.maxWidth);
        if (tp.didExceedMaxLines) {
          if (this._expanded) {
            return _expandedText(context, widget.text);
          } else {
            return _foldedText(context, widget.text);
          }
        } else {
          return _regularText(widget.text, style);
        }
      },
    );
  }

  Widget _foldedText(context, String text) {
    return Stack(
      children: <Widget>[
        Text(
          widget.text,
          style: _defaultTextStyle(),
          maxLines: widget.maxLines,
          overflow: TextOverflow.clip,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: _clickExpandTextWidget(context),
        )
      ],
    );
  }

  Widget _clickExpandTextWidget(context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    Color btnColor = widget.color ?? commonConfig.fillBase;

    Text tx = Text(
      SantoIntl.of(context).localizedResource.more,
      style: TextStyle(
        color: commonConfig.brandPrimary,
        fontSize: commonConfig.fontSizeBase,
      ),
    );
    Container cnt = Container(
      padding: EdgeInsets.only(left: commonConfig.hSpacingLg),
      alignment: Alignment.centerRight,
      child: tx,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [btnColor.withAlpha(100), btnColor, btnColor],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      )),
    );
    return GestureDetector(
      child: cnt,
      onTap: () {
        setState(() {
          _expanded = true;
          if (null != widget.onExpanded) {
            widget.onExpanded!(_expanded);
          }
        });
      },
    );
  }

  Widget _expandedText(context, String text) {
    return RichText(
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        text: TextSpan(text: text, style: _defaultTextStyle(), children: [
          _foldButtonSpan(context),
        ]));
  }

  TextStyle _defaultTextStyle() {
    TextStyle style = widget.textStyle ??
        TextStyle(
          fontSize: SantoThemeConfigurator.instance
              .getConfig()
              .commonConfig
              .fontSizeBase,
          fontWeight: FontWeight.w400,
          color: SantoThemeConfigurator.instance
              .getConfig()
              .commonConfig
              .colorTextBase,
        );
    return style;
  }

  InlineSpan _foldButtonSpan(context) {
    return TextSpan(
        text: ' '+ SantoIntl.of(context).localizedResource.collapse,
        style: TextStyle(
          color: SantoThemeConfigurator.instance
              .getConfig()
              .commonConfig
              .brandPrimary,
          fontSize: SantoThemeConfigurator.instance
              .getConfig()
              .commonConfig
              .fontSizeBase,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            setState(() {
              _expanded = false;
              if (null != widget.onExpanded) {
                widget.onExpanded!(_expanded);
              }
            });
          });
  }

  Widget _regularText(text, style) {
    return Text(text, style: style);
  }
}
