import 'package:flutter/material.dart';
import 'package:santo_ui/santo_ui.dart';

import 'example_intro_data.dart';

/// 示例页头部:对标 antd 组件文档首屏
///
/// 自上而下依次是:组件标题 → 一句话说明 → 使用方式(import 与主类名)
/// → 分割线 → 何时使用(段落正文 + 要点列表),用来替换原先的「规则」块。
///
/// 文案统一维护在 [kExampleIntroData],页面只传组件 key(与示例目录名一致):
/// ```dart
/// SantoPageLayout(
///   title: '按钮',
///   children: <Widget>[
///     ExampleIntro('button'),
///     ...
///   ],
/// )
/// ```
class ExampleIntro extends StatelessWidget {
  /// 组件 key,与 [kExampleIntroData] 的键一致(取示例目录名,如 `button`)
  final String component;

  /// 标题覆盖,不传时用注册表里的标题
  final String? title;

  const ExampleIntro(this.component, {Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SantoCommonConfig common =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final ExampleIntroData? data = kExampleIntroData[component];
    assert(data != null, 'ExampleIntro 缺少注册文案:$component');
    if (data == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title ?? data.title,
          style: TextStyle(
            fontSize: common.fontSizeHeadLg,
            fontWeight: FontWeight.w500,
            color: common.colorTextBase,
          ),
        ),
        SizedBox(height: common.vSpacingSm),
        Text(
          data.description,
          style: TextStyle(
            fontSize: common.fontSizeBase,
            color: common.colorTextSecondary,
            height: 1.5,
          ),
        ),
        SizedBox(height: common.vSpacingMd),
        _buildUsage(common, data),
        SizedBox(height: common.vSpacingLg),
        Container(height: common.borderWidthSm, color: common.dividerColorBase),
        SizedBox(height: common.vSpacingMd),
        _buildWhenToUse(common, data),
      ],
    );
  }

  /// 使用方式:import 语句 + 主入口类名
  Widget _buildUsage(SantoCommonConfig common, ExampleIntroData data) {
    final TextStyle codeStyle = TextStyle(
      fontSize: common.fontSizeCaption,
      height: 1.4,
      color: common.colorTextImportant,
      fontFamily: 'monospace',
      fontFamilyFallback: const <String>['Menlo', 'Courier New'],
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 42,
          child: Text(
            '使用',
            style: TextStyle(
              fontSize: common.fontSizeBase,
              color: common.colorTextSecondary,
              height: 1.4,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: common.hSpacingSm,
              vertical: common.vSpacingSm,
            ),
            decoration: BoxDecoration(
              color: common.brandPrimary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(common.radiusXs),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("import 'package:santo_ui/santo_ui.dart';", style: codeStyle),
                for (final String widget in data.widgets) ...<Widget>[
                  SizedBox(height: common.vSpacingXs),
                  Text(
                    widget,
                    style: codeStyle.copyWith(color: common.brandPrimary),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 何时使用:段落正文 + 要点列表
  Widget _buildWhenToUse(SantoCommonConfig common, ExampleIntroData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 3,
              height: common.fontSizeSubHead,
              decoration: BoxDecoration(
                color: common.brandPrimary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: common.hSpacingSm),
            Text(
              '何时使用',
              style: TextStyle(
                fontSize: common.fontSizeHead,
                fontWeight: FontWeight.w500,
                color: common.colorTextBase,
              ),
            ),
          ],
        ),
        if (data.whenToUseDesc != null) ...<Widget>[
          SizedBox(height: common.vSpacingSm),
          Text(
            data.whenToUseDesc!,
            style: TextStyle(
              fontSize: common.fontSizeBase,
              color: common.colorTextSecondary,
              height: 1.5,
            ),
          ),
        ],
        if (data.whenToUse.isNotEmpty) SizedBox(height: common.vSpacingSm),
        for (final ExampleIntroPoint point in data.whenToUse)
          Padding(
            padding: EdgeInsets.only(top: common.vSpacingSm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  // 与首行文字中线对齐
                  margin: const EdgeInsets.only(top: 6),
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: common.brandPrimary,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: common.hSpacingSm),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '${point.name}:',
                          style: TextStyle(
                            fontSize: common.fontSizeBase,
                            fontWeight: FontWeight.w500,
                            color: common.colorTextBase,
                            height: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: point.description,
                          style: TextStyle(
                            fontSize: common.fontSizeBase,
                            color: common.colorTextSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
