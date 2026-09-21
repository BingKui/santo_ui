import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

/// Card 卡片示例（SantoCard）
class SantoCardExample extends StatefulWidget {
  const SantoCardExample({Key? key}) : super(key: key);

  @override
  State<SantoCardExample> createState() => _SantoCardExampleState();
}

class _SantoCardExampleState extends State<SantoCardExample> {
  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;

    return SantoPageLayout(
      title: 'Card 卡片',
      children: <Widget>[
        ExampleIntro('card'),
        SantoSection(
          title: '基础用法',
          description: '只传 child 时是一块纯阴影容器:浅灰背景、12 圆角、0.5 边框与柔和阴影',
          child: const SantoCard(
            padding: EdgeInsets.all(15),
            child: Text('基础卡片,这里放内容区域'),
          ),
        ),
        SantoSection(
          title: '标题与操作',
          description: 'title 靠左、extra 靠右,头部下方自动补分割线,内容区自动取主题内边距',
          child: SantoCard(
            title: '卡片标题',
            extra: const SantoIcon(SantoIcons.moreHoriz),
            child: const Text('头部由 title / extra 组成,内容紧跟其后'),
          ),
        ),
        SantoSection(
          title: '自定义标题',
          description: 'titleWidget 可放任意组件,优先级高于 title',
          child: SantoCard(
            titleWidget: Row(
              children: [
                const SantoIcon(SantoIcons.star, size: 16),
                const SantoSpace.gap(4),
                Text(
                  '带图标的标题',
                  style: TextStyle(
                    fontSize: commonConfig.fontSizeSubHead,
                    fontWeight: FontWeight.w500,
                    color: commonConfig.colorTextBase,
                  ),
                ),
              ],
            ),
            extra: const SantoIcon(SantoIcons.arrowRight, size: 16),
            child: const Text('标题与操作区都可以完全自定义'),
          ),
        ),
        SantoSection(
          title: '元信息',
          description: 'meta 承载头像 + 标题 + 描述,对应 antd Card.Meta',
          child: const SantoCard(
            meta: SantoCardMeta(
              avatar: SantoAvatar(
                text: 'S',
                size: 40,
                backgroundColor: Color(0xFF1677FF),
              ),
              title: 'Santo UI',
              description: '基于 Flutter 的企业级组件库,元信息区下面才是卡片内容。',
            ),
            child: Text('卡片内容'),
          ),
        ),
        SantoSection(
          title: '不同圆角',
          description: 'circular 依次为 4、12、24,对比不同圆角大小',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SantoCard(
                padding: EdgeInsets.all(12),
                circular: 4,
                child: Text('circular: 4'),
              ),
              const SantoSpace.gap(12, direction: SantoSpaceDirection.vertical),
              const SantoCard(
                padding: EdgeInsets.all(12),
                child: Text('circular: 12(默认)'),
              ),
              const SantoSpace.gap(12, direction: SantoSpaceDirection.vertical),
              const SantoCard(
                padding: EdgeInsets.all(12),
                circular: 24,
                child: Text('circular: 24'),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '自定义阴影',
          description: 'shadowColor / blurRadius / spreadRadius / offset 组合柔和与硬阴影',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SantoCard(
                padding: EdgeInsets.all(12),
                shadowColor: Color(0x331677FF),
                blurRadius: 12,
                child: Text('蓝色柔和阴影 blurRadius: 12'),
              ),
              const SantoSpace.gap(12, direction: SantoSpaceDirection.vertical),
              const SantoCard(
                padding: EdgeInsets.all(12),
                shadowColor: Color(0x22000000),
                blurRadius: 0,
                spreadRadius: 2,
                offset: Offset(3, 3),
                child: Text('硬阴影 offset: (3, 3), spreadRadius: 2'),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '自定义背景色和边框',
          description: 'color 设置背景色,borderWidth 传 0 去掉默认边框',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SantoCard(
                padding: EdgeInsets.all(12),
                color: Color(0xFFE8F3FF),
                borderWidth: 0,
                child: Text('浅蓝背景,无边框'),
              ),
              const SantoSpace.gap(12, direction: SantoSpaceDirection.vertical),
              const SantoCard(
                padding: EdgeInsets.all(12),
                borderWidth: 1,
                child: Text('默认背景,1px 边框'),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '数字信息卡片',
          description: 'SantoEnhanceNumberCard 的用法:主数字用 Bebas 字体放大,'
              'rowCount 控制每行列数,preDesc / lastDesc 在数字前后补单位,numberInfoIcon 展示跳转箭头',
          child: SantoEnhanceNumberCard(
            rowCount: 2,
            itemChildren: [
              SantoNumberInfoItemModel(
                title: '待办事项',
                number: '3',
                preDesc: '共',
                lastDesc: '项',
              ),
              SantoNumberInfoItemModel(
                title: '本周新增',
                number: '12',
                lastDesc: '项',
              ),
              SantoNumberInfoItemModel(
                title: '异常项',
                number: '2',
                lastDesc: '项',
                numberInfoIcon: SantoNumberInfoIcon.arrow,
                iconTapCallBack: (SantoNumberInfoItemModel data) {},
              ),
            ],
          ),
        ),
        const SantoSpace.gap(24, direction: SantoSpaceDirection.vertical),
      ],
    );
  }
}
