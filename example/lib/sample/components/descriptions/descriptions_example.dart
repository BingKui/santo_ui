import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

/// Descriptions 描述列表示例(SantoDescriptions)
class DescriptionsExample extends StatelessWidget {
  const DescriptionsExample({Key? key}) : super(key: key);

  /// 基础项:姓名 / 电话 / 住址
  static const List<SantoDescriptionsItem> _basicItems =
      <SantoDescriptionsItem>[
    SantoDescriptionsItem(label: '姓名', child: Text('张三')),
    SantoDescriptionsItem(label: '电话', child: Text('1810000000')),
    SantoDescriptionsItem(label: '住址', child: Text('浙江省杭州市西湖区文一西路 969 号')),
  ];

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;

    return SantoPageLayout(
      title: 'Descriptions 描述列表',
      children: <Widget>[
        ExampleIntro('descriptions'),
        const SantoSection(
          title: '基础用法',
          description: '键值成对展示,默认单列;colon 默认为 true,标签后自动带冒号',
          child: SantoDescriptions(items: _basicItems),
        ),
        const SantoSection(
          title: '单列左对齐',
          description: '传 labelWidth 固定标签列宽,内容过长换行时左边界依然对齐',
          child: SantoDescriptions(
            labelWidth: 92,
            items: <SantoDescriptionsItem>[
              SantoDescriptionsItem(label: '姓名', child: Text('张三')),
              SantoDescriptionsItem(label: '电话', child: Text('1810000000')),
              SantoDescriptionsItem(
                label: '住址',
                child: Text('浙江省杭州市西湖区文一西路 969 号 5 号楼 12 层,内容较长时会自动换行'),
              ),
              SantoDescriptionsItem(label: '备注', child: Text('无')),
            ],
          ),
        ),
        const SantoSection(
          title: '标签紧随内容',
          description: '不传 labelWidth 时标签紧随内容,适合标签长短不一的场景',
          child: SantoDescriptions(
            items: <SantoDescriptionsItem>[
              SantoDescriptionsItem(label: '姓名', child: Text('张三')),
              SantoDescriptionsItem(label: '联系电话', child: Text('1810000000')),
              SantoDescriptionsItem(label: '常用邮箱', child: Text('zhangsan@santo.com')),
            ],
          ),
        ),
        const SantoSection(
          title: '两列',
          description: 'column 设为 2 时每行放两项;span 可让一项跨列占满整行',
          child: SantoDescriptions(
            column: 2,
            items: <SantoDescriptionsItem>[
              SantoDescriptionsItem(label: '姓名', child: Text('张三')),
              SantoDescriptionsItem(label: '电话', child: Text('1810000000')),
              SantoDescriptionsItem(
                label: '住址',
                child: Text('浙江省杭州市西湖区文一西路 969 号'),
                span: 2,
              ),
              SantoDescriptionsItem(label: '状态', child: Text('在职')),
              SantoDescriptionsItem(label: '工号', child: Text('A0001')),
            ],
          ),
        ),
        const SantoSection(
          title: '纵向布局',
          description: 'layout 设为 vertical 时标签在上、内容在下,适合窄屏或长文案',
          child: SantoDescriptions(
            layout: SantoDescriptionsLayout.vertical,
            items: <SantoDescriptionsItem>[
              SantoDescriptionsItem(label: '姓名', child: Text('张三')),
              SantoDescriptionsItem(
                label: '住址',
                child: Text('浙江省杭州市西湖区文一西路 969 号 5 号楼'),
              ),
              SantoDescriptionsItem(label: '备注', child: Text('长期合作客户')),
            ],
          ),
        ),
        const SantoSection(
          title: '带边框',
          description: 'bordered 为 true 时单元格带边框,配合 column 能看出网格线',
          child: SantoDescriptions(
            column: 2,
            bordered: true,
            items: <SantoDescriptionsItem>[
              SantoDescriptionsItem(label: '姓名', child: Text('张三')),
              SantoDescriptionsItem(label: '电话', child: Text('1810000000')),
              SantoDescriptionsItem(label: '状态', child: Text('在职')),
              SantoDescriptionsItem(label: '工号', child: Text('A0001')),
            ],
          ),
        ),
        SantoSection(
          title: '尺寸',
          description: 'size 分 small / medium / large 三档,标签与内容字号随档位变化',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _sizeCaption(commonConfig, 'small:12 号'),
              const SantoDescriptions(
                size: SantoDescriptionsSize.small,
                items: _basicItems,
              ),
              SantoSpace.gap(
                commonConfig.vSpacingMd,
                direction: SantoSpaceDirection.vertical,
              ),
              _sizeCaption(commonConfig, 'medium:14 号(默认)'),
              const SantoDescriptions(items: _basicItems),
              SantoSpace.gap(
                commonConfig.vSpacingMd,
                direction: SantoSpaceDirection.vertical,
              ),
              _sizeCaption(commonConfig, 'large:16 号'),
              const SantoDescriptions(
                size: SantoDescriptionsSize.large,
                items: _basicItems,
              ),
            ],
          ),
        ),
        SantoSection(
          title: '自定义标签与冒号',
          description: 'labelWidget 可放图标等自定义标签;colon 设为 false 去掉冒号',
          child: SantoDescriptions(
            colon: false,
            items: <SantoDescriptionsItem>[
              SantoDescriptionsItem(
                labelWidget: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SantoIcon(SantoIcons.user, size: 16),
                    const SantoSpace.gap(4),
                    Text(
                      '用户',
                      style: TextStyle(
                        fontSize: commonConfig.fontSizeBase,
                        color: commonConfig.colorTextSecondary,
                      ),
                    ),
                  ],
                ),
                child: const Text('张三'),
              ),
              const SantoDescriptionsItem(label: '电话', child: Text('1810000000')),
              const SantoDescriptionsItem(label: '住址', child: Text('浙江省杭州市西湖区文一西路 969 号')),
            ],
          ),
        ),
        SantoSection(
          title: '内容自定义',
          description: 'child 可放任意组件:标签旁挂问号提示,行尾放跳转箭头',
          child: SantoDescriptions(
            items: <SantoDescriptionsItem>[
              SantoDescriptionsItem(
                labelWidget: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('月租'),
                    const SantoSpace.gap(4),
                    const _QuestionHint(text: '月租为含税价格,按自然月结算'),
                  ],
                ),
                child: const Text('¥ 3,800.00'),
              ),
              const SantoDescriptionsItem(
                label: '合同',
                child: Row(
                  children: <Widget>[
                    Expanded(child: Text('查看合同详情')),
                    SantoIcon(SantoIcons.navArrowRight, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SantoSection(
          title: '标题与操作',
          description: 'title 展示在列表上方,extra 靠右放置操作入口',
          child: SantoDescriptions(
            title: '用户信息',
            extra: SantoIcon(SantoIcons.moreHoriz),
            labelWidth: 92,
            items: _basicItems,
          ),
        ),
        const SantoSpace.gap(24, direction: SantoSpaceDirection.vertical),
      ],
    );
  }

  /// 尺寸档位说明文案
  Widget _sizeCaption(SantoCommonConfig commonConfig, String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: commonConfig.fontSizeCaption,
        color: commonConfig.colorTextSecondary,
      ),
    );
  }
}

/// 问号提示:点击后在图标旁弹出 [SantoTooltip]
class _QuestionHint extends StatefulWidget {
  const _QuestionHint({required this.text});

  /// 提示文案
  final String text;

  @override
  State<_QuestionHint> createState() => _QuestionHintState();
}

class _QuestionHintState extends State<_QuestionHint> {
  final GlobalKey _tipKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return GestureDetector(
      key: _tipKey,
      onTap: () => SantoTooltip.show(
        context,
        widget.text,
        _tipKey,
        hasCloseIcon: true,
      ),
      child: SantoIcon(
        SantoIcons.helpCircle,
        size: commonConfig.iconSizeSm,
        color: commonConfig.colorTextSecondary,
      ),
    );
  }
}
