

import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/utils/santo_tools.dart';
import 'package:flutter/material.dart';

/// 气泡背景的文本
/// 气泡：背景色为Color(0xFFF8F8F8)的灰色Container
///      右上角为不规则小三角
///
/// ```dart
///   SantoInsertInfo(
///      infoText: '在文本的右下角有更多或者收起按钮',
///   )
///
///   SantoInsertInfo(
///      infoText: '具备展开收起功能的文字面板，在文本的右下角有更多或者收起按钮',
///      maxLines: 2,
///   )
///
/// ```
///
/// 相关文本组件如下:
///  * [SantoExpandableText], 气泡背景的展开收起文本组件
///  * [SantoBubbleText], 气泡背景的文本组件
///
class SantoInsertInfo extends StatelessWidget {

  /// 显示的文本
  final String infoText;

  /// 最多显示的行数，如果实际的行数超标，就折断
  final int maxLines;

  /// create SantoInsertInfo
  const SantoInsertInfo({Key? key, required this.infoText, this.maxLines = 2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Text tx = Text(
      infoText,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: SantoThemeConfigurator.instance
            .getConfig()
            .commonConfig
            .colorTextBase,
      ),
    );

    Color color = const Color(0xFFF8F8F8);
    Image image = SantoTools.getAssetImage('icons/icon_right_top_pointer.png');

    Widget bubbleText = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: color,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(0),
                    topRight: const Radius.circular(12),
                    bottomLeft: const Radius.circular(12),
                    bottomRight: const Radius.circular(12))),
            padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
            child: tx,
          ),
        )
      ],
    );
    return ColoredBox(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          image,
          bubbleText,
        ],
      ),
    );
  }
}
