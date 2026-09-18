import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

/// SantoRadio 单选框示例
class RadioExample extends StatefulWidget {
  @override
  State<RadioExample> createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioExample> {
  /// 当前选中的省份,演示外部受控
  String? _selectedCity = 'index:1';

  Color get _primary =>
      SantoThemeConfigurator.instance.getConfig().commonConfig.brandPrimary;

  Color get _unselected => SantoThemeConfigurator.instance
      .getConfig()
      .commonConfig
      .borderColorBase;

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'Radio 单选框',
      backgroundColor: const Color(0xFFF5F6FA),
      children: <Widget>[
        ExampleIntro('radio'),
        SantoSection(
          title: '横向单选框',
          description: 'SantoRadioGroup 设置 direction 为 horizontal 横向排列',
          child: SantoRadioGroup(
            selectId: '1',
            direction: Axis.horizontal,
            directionalRadios: const [
              SantoRadio(id: '0', title: '单选标题', showDivider: false),
              SantoRadio(id: '1', title: '单选标题', showDivider: false),
              SantoRadio(id: '2', title: '上限四字', showDivider: false),
            ],
          ),
        ),
        SantoSection(
          title: '横向换行',
          description: 'rowCount 控制每行个数,超出自动换行',
          child: SantoRadioGroup(
            selectId: '0',
            direction: Axis.horizontal,
            rowCount: 3,
            directionalRadios: const [
              SantoRadio(id: '0', title: '单选', showDivider: false),
              SantoRadio(id: '1', title: '单选', showDivider: false),
              SantoRadio(id: '2', title: '单选', showDivider: false),
              SantoRadio(id: '3', title: '单选', showDivider: false),
              SantoRadio(id: '4', title: '单选', showDivider: false),
              SantoRadio(id: '5', title: '单选', showDivider: false),
            ],
          ),
        ),
        SantoSection(
          title: '纵向单选框',
          description: 'direction 为 vertical 时逐行排列(选中项可外部受控)',
          child: SantoRadioGroup(
            selectId: _selectedCity,
            direction: Axis.vertical,
            onRadioGroupChange: (id) => setState(() => _selectedCity = id),
            directionalRadios: const [
              SantoRadio(id: 'index:0', title: '单选标题一'),
              SantoRadio(id: 'index:1', title: '单选标题二'),
              SantoRadio(id: 'index:2', title: '单选标题三'),
            ],
          ),
        ),
        SantoSection(
          title: '单选框状态',
          description: 'enable 为 false 时置灰且不可点击',
          child: SantoRadioGroup(
            selectId: '0',
            child: const Column(
              children: [
                SantoRadio(id: '0', title: '选项禁用-已选', enable: false),
                SantoRadio(id: '1', title: '选项禁用-默认', enable: false),
              ],
            ),
          ),
        ),
        SantoSection(
          title: '勾选样式',
          description: 'radioStyle 内置圆形、方形、无背景勾选、镂空圆点四种样式',
          child: Column(
            children: [
              for (final entry in const [
                ('圆形', SantoRadioStyle.circle),
                ('方形', SantoRadioStyle.square),
                ('对号', SantoRadioStyle.check),
                ('镂空圆点', SantoRadioStyle.hollowCircle),
              ])
                SantoRadioGroup(
                  selectId: '0',
                  direction: Axis.horizontal,
                  directionalRadios: [
                    SantoRadio(
                      id: '0',
                      title: '${entry.$1}-选中',
                      radioStyle: entry.$2,
                      showDivider: false,
                    ),
                    SantoRadio(
                      id: '1',
                      title: '未选中',
                      radioStyle: entry.$2,
                      showDivider: false,
                    ),
                  ],
                ),
            ],
          ),
        ),
        SantoSection(
          title: '勾选显示位置',
          description: 'contentDirection 控制内容在指示器左侧或右侧',
          child: Column(
            children: [
              SantoRadioGroup(
                selectId: '0',
                contentDirection: SantoContentDirection.right,
                child: const SantoRadio(id: '0', title: '内容在右'),
              ),
              SantoRadioGroup(
                selectId: '0',
                contentDirection: SantoContentDirection.left,
                child: const SantoRadio(id: '0', title: '内容在左'),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '非通栏样式',
          description: 'passThrough 为 true 时整体裁切圆角,行间显示下划线',
          child: SantoRadioGroup(
            selectId: 'index:0',
            direction: Axis.vertical,
            passThrough: true,
            directionalRadios: const [
              SantoRadio(id: 'index:0', title: '单选标题一'),
              SantoRadio(id: 'index:1', title: '单选标题二'),
              SantoRadio(id: 'index:2', title: '单选标题三'),
            ],
          ),
        ),
        SantoSection(
          title: '横向显示下划线',
          description: 'showDivider 为 true 时横向单选框下方显示下划线',
          child: SantoRadioGroup(
            selectId: '0',
            direction: Axis.horizontal,
            showDivider: true,
            directionalRadios: const [
              SantoRadio(id: '0', title: '单选', showDivider: false),
              SantoRadio(id: '1', title: '单选', showDivider: false),
              SantoRadio(id: '2', title: '单选', showDivider: false),
            ],
          ),
        ),
        SantoSection(
          title: '纵向卡片样式',
          description: 'cardMode 为 true 时展示为卡片,选中显示边框与左上角勾选角标',
          child: SantoRadioGroup(
            selectId: 'index:1',
            cardMode: true,
            direction: Axis.vertical,
            directionalRadios: const [
              SantoRadio(
                id: 'index:0',
                title: '单选',
                subTitle: '描述信息',
                subTitleMaxLine: 2,
                cardMode: true,
              ),
              SantoRadio(
                id: 'index:1',
                title: '单选',
                subTitle: '描述信息',
                subTitleMaxLine: 2,
                cardMode: true,
              ),
              SantoRadio(
                id: 'index:2',
                title: '单选',
                subTitle: '描述信息',
                subTitleMaxLine: 2,
                cardMode: true,
              ),
            ],
          ),
        ),
        SantoSection(
          title: '横向卡片样式',
          description: '卡片模式横向排列,单个卡片等宽自适应',
          child: SantoRadioGroup(
            selectId: 'index:1',
            cardMode: true,
            direction: Axis.horizontal,
            directionalRadios: const [
              SantoRadio(id: 'index:0', title: '单选', cardMode: true),
              SantoRadio(id: 'index:1', title: '单选', cardMode: true),
              SantoRadio(id: 'index:2', title: '单选', cardMode: true),
            ],
          ),
        ),
        SantoSection(
          title: '自定义颜色与字体',
          description: 'selectColor、disableColor、titleStyle 均可自定义',
          child: SantoRadioGroup(
            selectId: 'index:0',
            child: Column(
              children: [
                SantoRadio(
                  id: 'index:0',
                  title: '自定义选中色',
                  selectColor: const Color(0xFFE34D59),
                  disableColor: const Color(0xFFF9DCDE),
                ),
                const SantoRadio(
                  id: 'index:1',
                  title: '自定义文字颜色与字号',
                  titleColor: Color(0xFF07C160),
                  titleStyle: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
