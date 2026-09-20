import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

/// SantoIcon 图标示例
class IconExample extends StatefulWidget {
  const IconExample({Key? key}) : super(key: key);

  @override
  State<IconExample> createState() => _IconExampleState();
}

class _IconExampleState extends State<IconExample> {
  /// 搜索结果最多渲染多少个,避免一次铺开上千个 SVG
  static const int _maxResultCount = 60;

  /// 有实心版的图标名称
  static final Set<String> _solidNames = SantoSolidIcons.all.toSet();

  /// 搜索关键字
  String _query = '';

  /// 常用图标一览:名称 + SantoIcons 常量
  static const List<(String, String)> _commonIcons = [
    ('search', SantoIcons.search),
    ('xmark', SantoIcons.xmark),
    ('check', SantoIcons.check),
    ('checkCircle', SantoIcons.checkCircle),
    ('plus', SantoIcons.plus),
    ('minus', SantoIcons.minus),
    ('edit', SantoIcons.edit),
    ('trash', SantoIcons.trash),
    ('copy', SantoIcons.copy),
    ('refresh', SantoIcons.refresh),
    ('filter', SantoIcons.filter),
    ('settings', SantoIcons.settings),
    ('eye', SantoIcons.eye),
    ('eyeClosed', SantoIcons.eyeClosed),
    ('infoCircle', SantoIcons.infoCircle),
    ('helpCircle', SantoIcons.helpCircle),
    ('warningTriangle', SantoIcons.warningTriangle),
    ('star', SantoIcons.star),
    ('bell', SantoIcons.bell),
    ('mail', SantoIcons.mail),
    ('message', SantoIcons.message),
    ('calendar', SantoIcons.calendar),
    ('clock', SantoIcons.clock),
    ('page', SantoIcons.page),
    ('upload', SantoIcons.upload),
    ('download', SantoIcons.download),
    ('camera', SantoIcons.camera),
    ('user', SantoIcons.user),
    ('group', SantoIcons.group),
    ('home', SantoIcons.home),
    ('lock', SantoIcons.lock),
    ('link', SantoIcons.link),
    ('arrowLeft', SantoIcons.arrowLeft),
    ('arrowRight', SantoIcons.arrowRight),
    ('arrowUp', SantoIcons.arrowUp),
    ('arrowDown', SantoIcons.arrowDown),
    ('navArrowLeft', SantoIcons.navArrowLeft),
    ('navArrowRight', SantoIcons.navArrowRight),
    ('navArrowUp', SantoIcons.navArrowUp),
    ('navArrowDown', SantoIcons.navArrowDown),
    ('menu', SantoIcons.menu),
    ('moreHoriz', SantoIcons.moreHoriz),
  ];

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;

    return SantoPageLayout(
      title: 'Icon 图标',
      children: <Widget>[
        ExampleIntro('icon'),
        SantoSection(
          title: '图标搜索',
          description:
              '输入关键字对全部 ${SantoIcons.all.length} 个常规图标做名称过滤（子串匹配，最多展示 $_maxResultCount 个）；'
              '每条给出主图，若该名称也有实心版，右侧会浅色并排显示',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoInputText(
                hintText: '搜索图标名称，如 arrow、user、circle',
                onChanged: (String value) {
                  setState(() {
                    _query = value;
                  });
                },
              ),
              const SantoSpace.gap(12, direction: SantoSpaceDirection.vertical),
              _buildSearchResult(commonConfig),
            ],
          ),
        ),
        SantoSection(
          title: '基础用法',
          description: '名称即 SVG 文件名,不传 size / color 时跟随主题默认值',
          child: const SantoIcon(SantoIcons.search),
        ),
        SantoSection(
          title: '尺寸',
          description: 'size 传入边长,对应主题 iconSizeXxs / Xs / Sm / Md / Lg 五档',
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _sizeItem('xxs 8', SantoIcons.star, commonConfig.iconSizeXxs),
              _sizeItem('xs 12', SantoIcons.star, commonConfig.iconSizeXs),
              _sizeItem('sm 14', SantoIcons.star, commonConfig.iconSizeSm),
              _sizeItem('md 16', SantoIcons.star, commonConfig.iconSizeMd),
              _sizeItem('lg 32', SantoIcons.star, commonConfig.iconSizeLg),
            ],
          ),
        ),
        SantoSection(
          title: '颜色',
          description: 'color 覆盖默认色,与主题品牌色配合表达状态',
          child: Row(
            children: [
              _colorItem('品牌色', SantoIcons.checkCircle, commonConfig.brandPrimary),
              _colorItem('成功', SantoIcons.checkCircle, commonConfig.brandSuccess),
              _colorItem('警告', SantoIcons.warningTriangle, commonConfig.brandWarning),
              _colorItem('错误', SantoIcons.warningTriangle, commonConfig.brandError),
              _colorItem('次要', SantoIcons.infoCircle, commonConfig.colorTextSecondary),
              _colorItem('禁用', SantoIcons.infoCircle, commonConfig.colorTextDisabled),
            ],
          ),
        ),
        SantoSection(
          title: '与文字并排',
          description: '图标为固定边长,可与文本组合成行内信息',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  SantoIcon(SantoIcons.infoCircle, size: 14),
                  SantoSpace.gap(4),
                  Text('资料提交后 1 个工作日内完成审核'),
                ],
              ),
              const SantoSpace.gap(12, direction: SantoSpaceDirection.vertical),
              const Row(
                children: [
                  SantoIcon(
                    SantoIcons.warningTriangle,
                    size: 14,
                    color: Color(0xFFFA8C16),
                  ),
                  SantoSpace.gap(4),
                  Text('当前账号未完成实名认证'),
                ],
              ),
            ],
          ),
        ),
        SantoSection(
          title: '可点击图标',
          description: '图标本身不带交互,配合手势组件使用',
          child: GestureDetector(
            onTap: () => SantoToast.show('点击了收藏图标', context),
            child: const Row(
              children: [
                SantoIcon(SantoIcons.star, size: 20, color: Color(0xFFFAAD14)),
                SantoSpace.gap(4),
                Text('收藏'),
              ],
            ),
          ),
        ),
        SantoSection(
          title: '常用图标',
          description: 'SantoIcons 收录的常用图标,全量图标见下一节',
          child: SantoSpace(
            wrap: true,
            size: SantoSpaceSize.large,
            children: [
              for (final (label, name) in _commonIcons)
                SizedBox(
                  width: 68,
                  child: Column(
                    children: [
                      SantoIcon(name, size: 24),
                      const SantoSpace.gap(4, direction: SantoSpaceDirection.vertical),
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: commonConfig.fontSizeCaption,
                          color: commonConfig.colorTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        SantoSection(
          title: '按名称直接使用',
          description:
              'SantoIcons 之外的图标可直接传 SVG 文件名;'
              '全部 1383 个常规图标见 assets/iconoir 目录',
          child: Row(
            children: const [
              SantoIcon('activity', size: 20),
              SantoSpace.gap(12),
              SantoIcon('airplane', size: 20),
              SantoSpace.gap(12),
              SantoIcon('bonfire', size: 20),
              SantoSpace.gap(12),
              SantoIcon('compact-disc', size: 20),
              SantoSpace.gap(12),
              SantoIcon('rocket', size: 20),
            ],
          ),
        ),
        SantoSection(
          title: '实心风格（solid）',
          description:
              'solid 置 true 从常规描边切到实心风格；solid 共 288 个，名称见 SantoSolidIcons，'
              '是常规名称的子集（同名），如 search、xmark 没有实心版',
          child: Row(
            children: const [
              SantoIcon(SantoIcons.star, size: 24),
              SantoSpace.gap(8),
              SantoIcon(SantoSolidIcons.star, solid: true, size: 24),
              SantoSpace.gap(20),
              SantoIcon(SantoIcons.checkCircle, size: 24),
              SantoSpace.gap(8),
              SantoIcon(SantoSolidIcons.checkCircle, solid: true, size: 24),
              SantoSpace.gap(20),
              SantoIcon(
                SantoIcons.warningTriangle,
                size: 24,
                color: Color(0xFFFAAD14),
              ),
              SantoSpace.gap(8),
              SantoIcon(
                SantoSolidIcons.warningTriangle,
                solid: true,
                size: 24,
                color: Color(0xFFFAAD14),
              ),
              SantoSpace.gap(20),
              SantoIcon(SantoSolidIcons.heart, solid: true, size: 24),
              SantoSpace.gap(8),
              SantoIcon(SantoSolidIcons.bookmark, solid: true, size: 24),
            ],
          ),
        ),
        const SantoSpace.gap(24, direction: SantoSpaceDirection.vertical),
      ],
    );
  }

  /// 搜索结果区:未输入时给提示,输入后按名称过滤
  Widget _buildSearchResult(SantoCommonConfig commonConfig) {
    final TextStyle hintStyle = TextStyle(
      fontSize: commonConfig.fontSizeCaption,
      color: commonConfig.colorTextSecondary,
    );
    final String keyword = _query.trim().toLowerCase();

    if (keyword.isEmpty) {
      return Text(
        '共 ${SantoIcons.all.length} 个常规图标，其中 ${SantoSolidIcons.all.length} 个有实心版；'
        '输入关键字开始搜索',
        style: hintStyle,
      );
    }

    final List<String> matched = SantoIcons.all
        .where((String name) => name.contains(keyword))
        .toList();
    if (matched.isEmpty) {
      return Text('没有匹配「${_query.trim()}」的图标', style: hintStyle);
    }

    final List<String> shown = matched.length > _maxResultCount
        ? matched.sublist(0, _maxResultCount)
        : matched;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          matched.length > shown.length
              ? '共 ${matched.length} 个匹配，显示前 ${shown.length} 个'
              : '共 ${matched.length} 个匹配',
          style: hintStyle,
        ),
        const SantoSpace.gap(12, direction: SantoSpaceDirection.vertical),
        SantoSpace(
          wrap: true,
          size: SantoSpaceSize.large,
          children: [
            for (final String name in shown) _resultCell(commonConfig, name),
          ],
        ),
      ],
    );
  }

  /// 单个搜索结果:常规图标,有实心版时并排展示实心图标
  Widget _resultCell(SantoCommonConfig commonConfig, String name) {
    return SizedBox(
      width: 84,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SantoIcon(name, size: 24),
              if (_solidNames.contains(name)) ...[
                const SantoSpace.gap(4),
                SantoIcon(
                  name,
                  solid: true,
                  size: 24,
                  color: commonConfig.colorTextSecondary,
                ),
              ],
            ],
          ),
          const SantoSpace.gap(4, direction: SantoSpaceDirection.vertical),
          Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: commonConfig.fontSizeCaption,
              color: commonConfig.colorTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sizeItem(String label, String name, double size) {
    return Expanded(
      child: Column(
        children: [
          SantoIcon(name, size: size),
          const SantoSpace.gap(6, direction: SantoSpaceDirection.vertical),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  Widget _colorItem(String label, String name, Color color) {
    return Expanded(
      child: Column(
        children: [
          SantoIcon(name, size: 24, color: color),
          const SantoSpace.gap(6, direction: SantoSpaceDirection.vertical),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}
