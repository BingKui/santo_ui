import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 页脚链接数据类
///
/// 用于描述页脚中的链接信息
class SantoFooterLink {
  /// 链接文字
  final String text;

  /// 点击回调
  final VoidCallback? onTap;

  /// 页脚链接构造函数
  const SantoFooterLink({
    required this.text,
    this.onTap,
  });
}

/// 页脚组件
///
/// 用于页面底部区域，支持显示文字、链接和 logo
/// 内容居中排列
///
/// 示例：
/// ```dart
/// SantoFooter(
///   text: '© 2024 Santo Inc.',
///   links: [
///     SantoFooterLink(text: '关于我们', onTap: () {}),
///     SantoFooterLink(text: '联系方式', onTap: () {}),
///   ],
/// )
/// ```
///
class SantoFooter extends StatelessWidget {
  /// 底部文字，如版权信息
  final String? text;

  /// 链接列表
  final List<SantoFooterLink>? links;

  /// 自定义 logo 组件
  final Widget? logo;

  /// 文字样式
  final TextStyle? textStyle;

  /// 链接文字样式
  final TextStyle? linkStyle;

  /// 各部分之间的间距，默认 12
  final double spacing;

  /// 上边距，默认 24
  final double topPadding;

  /// 下边距，默认 24
  final double bottomPadding;

  /// 页脚组件构造函数
  const SantoFooter({
    Key? key,
    this.text,
    this.links,
    this.logo,
    this.textStyle,
    this.linkStyle,
    this.spacing = 12,
    this.topPadding = 24,
    this.bottomPadding = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
          16, topPadding, 16, bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo
          if (logo != null) ...[
            logo!,
            SizedBox(height: spacing),
          ],
          // 链接
          if (links != null && links!.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildLinks(commonConfig),
            ),
            SizedBox(height: spacing),
          ],
          // 文字
          if (text != null)
            Text(
              text!,
              textAlign: TextAlign.center,
              style: textStyle ??
                  TextStyle(
                    fontSize: 12,
                    color: commonConfig.colorTextSecondary,
                  ),
            ),
        ],
      ),
    );
  }

  /// 构建链接列表，用分割线分隔
  List<Widget> _buildLinks(commonConfig) {
    final List<Widget> items = [];
    final linkTextStyle = linkStyle ??
        TextStyle(
          fontSize: 14,
          color: commonConfig.colorLink ?? commonConfig.brandPrimary,
        );
    final dividerColor = commonConfig.dividerColorBase;

    for (int i = 0; i < links!.length; i++) {
      if (i > 0) {
        items.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              width: 1,
              height: 14,
              color: dividerColor,
            ),
          ),
        );
      }
      items.add(
        GestureDetector(
          onTap: links![i].onTap,
          child: Text(
            links![i].text,
            style: linkTextStyle,
          ),
        ),
      );
    }
    return items;
  }
}
