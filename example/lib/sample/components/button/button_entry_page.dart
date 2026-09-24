import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

/// 按钮示例,分组与 antd Button 文档保持一致
///
/// SantoButton 是库内唯一的按钮入口:类型、尺寸、颜色、形状、图标等差异
/// 全部通过参数配置,不再提供大小/主次/幽灵等独立的按钮组件。
class ButtonEntryPage extends StatefulWidget {
  @override
  State<ButtonEntryPage> createState() => _ButtonEntryPageState();
}

class _ButtonEntryPageState extends State<ButtonEntryPage> {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: '按钮',
      children: <Widget>[
        ExampleIntro('button'),
        _buildTypeSection(),
        _buildGhostSection(),
        _buildDangerSection(),
        _buildIconSection(),
        _buildIconPlacementSection(),
        _buildLoadingSection(),
        _buildSizeSection(),
        _buildDisabledSection(),
        _buildBlockSection(),
        _buildColorVariantSection(),
        _buildShapeSection(),
        _buildCustomDisabledBgSection(),
        _buildMultipleSection(),
      ],
    );
  }

  /// 统一走轻提示,便于验证点击回调
  Widget _button({
    String text = '按钮',
    SantoButtonType? type,
    SantoButtonColor? color,
    SantoButtonVariant? variant,
    SantoButtonSize size = SantoButtonSize.middle,
    SantoButtonShape shape = SantoButtonShape.normal,
    SantoButtonIconPlacement iconPlacement = SantoButtonIconPlacement.start,
    bool danger = false,
    bool ghost = false,
    bool block = false,
    bool loading = false,
    bool isEnable = true,
    Widget? icon,
    double? iconSize,
    double? fontSize,
    Color? disableBackgroundColor,
    Color? disableTextColor,
    EdgeInsetsGeometry? insertPadding,
  }) {
    return SantoButton(
      text: text,
      type: type,
      color: color,
      variant: variant,
      size: size,
      shape: shape,
      iconPlacement: iconPlacement,
      danger: danger,
      ghost: ghost,
      block: block,
      loading: loading,
      isEnable: isEnable,
      icon: icon,
      iconSize: iconSize,
      fontSize: fontSize,
      disableBackgroundColor: disableBackgroundColor,
      disableTextColor: disableTextColor,
      insertPadding: insertPadding,
      onTap: () => SantoToast.show('点击了$text', context),
    );
  }

  Widget _wrap(List<Widget> children) {
    return Wrap(spacing: 12, runSpacing: 12, children: children);
  }

  /// 按钮类型(对标 antd 的语法糖 demo)
  Widget _buildTypeSection() {
    return SantoSection(
      title: '按钮类型',
      description: 'type 是对标 antd 的语法糖:主按钮品牌色实心;默认按钮白底实线边框;'
          '虚线按钮白底虚线边框;文本按钮无底无边框;链接按钮文字为主题色',
      child: _wrap(<Widget>[
        _button(text: '主按钮', type: SantoButtonType.primary),
        _button(text: '默认按钮', type: SantoButtonType.normal),
        _button(text: '虚线按钮', type: SantoButtonType.dashed),
        _button(text: '文本按钮', type: SantoButtonType.text),
        _button(text: '链接按钮', type: SantoButtonType.link),
      ]),
    );
  }

  /// 幽灵按钮(对标 antd ghost demo)
  Widget _buildGhostSection() {
    return SantoSection(
      title: '幽灵按钮',
      description: 'ghost 为 true 时背景透明、文字与边框取该按钮颜色的主色(默认色用反色白),'
          '用于深色或灰色背景之上',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFBFC7CF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: _wrap(<Widget>[
          _button(text: '主按钮', type: SantoButtonType.primary, ghost: true),
          _button(text: '默认按钮', type: SantoButtonType.normal, ghost: true),
          _button(text: '虚线按钮', type: SantoButtonType.dashed, ghost: true),
          _button(
            text: '危险按钮',
            type: SantoButtonType.primary,
            danger: true,
            ghost: true,
          ),
        ]),
      ),
    );
  }

  /// 危险按钮
  Widget _buildDangerSection() {
    return SantoSection(
      title: '危险按钮',
      description: 'danger 为 true 时颜色切换为失败色,用于删除、授权等风险操作,可与任意 type 组合',
      child: _wrap(<Widget>[
        _button(text: '危险主按钮', type: SantoButtonType.primary, danger: true),
        _button(text: '危险默认按钮', type: SantoButtonType.normal, danger: true),
        _button(text: '危险虚线按钮', type: SantoButtonType.dashed, danger: true),
        _button(text: '危险文本按钮', type: SantoButtonType.text, danger: true),
        _button(text: '危险链接按钮', type: SantoButtonType.link, danger: true),
      ]),
    );
  }

  /// 图标按钮
  Widget _buildIconSection() {
    return SantoSection(
      title: '图标按钮',
      description: 'icon 传入图标;shape 为 circle 时是纯图标圆形按钮,此时可以不传文案',
      child: _wrap(<Widget>[
        _button(
          text: '搜索',
          type: SantoButtonType.primary,
          icon: const Icon(Icons.search, size: 16, color: Colors.white),
        ),
        _button(
          text: '下载',
          type: SantoButtonType.normal,
          icon: const Icon(Icons.download, size: 16),
        ),
        _button(
          text: '下载',
          type: SantoButtonType.normal,
          icon: const Icon(Icons.download, size: 24),
          iconSize: 24,
        ),
        SantoButton(
          icon: const Icon(Icons.search, size: 16, color: Colors.white),
          type: SantoButtonType.primary,
          shape: SantoButtonShape.circle,
          onTap: () => SantoToast.show('点击了圆形图标按钮', context),
        ),
        SantoButton(
          icon: const Icon(Icons.search, size: 16, color: Colors.white),
          type: SantoButtonType.primary,
          shape: SantoButtonShape.circle,
          size: SantoButtonSize.large,
          onTap: () => SantoToast.show('点击了大号圆形图标按钮', context),
        ),
      ]),
    );
  }

  /// 图标位置
  Widget _buildIconPlacementSection() {
    return SantoSection(
      title: '图标位置',
      description: 'iconPlacement 支持 start(默认)、end、top、bottom;top/bottom 即图文按钮的上下排布',
      child: _wrap(<Widget>[
        _button(
          text: '搜索',
          type: SantoButtonType.primary,
          icon: const Icon(Icons.search, size: 16, color: Colors.white),
        ),
        _button(
          text: '下一步',
          type: SantoButtonType.primary,
          iconPlacement: SantoButtonIconPlacement.end,
          icon: const Icon(Icons.arrow_forward, size: 16, color: Colors.white),
        ),
        _button(
          text: '下载',
          type: SantoButtonType.normal,
          iconPlacement: SantoButtonIconPlacement.end,
          icon: const Icon(Icons.download, size: 16),
        ),
        _button(
          text: '图标在上',
          type: SantoButtonType.primary,
          iconPlacement: SantoButtonIconPlacement.top,
          iconSize: 24,
          icon: const Icon(Icons.arrow_upward, size: 24, color: Colors.white),
        ),
        _button(
          text: '图标在下',
          type: SantoButtonType.normal,
          iconPlacement: SantoButtonIconPlacement.bottom,
          iconSize: 24,
          icon: const Icon(Icons.arrow_downward, size: 24),
        ),
      ]),
    );
  }

  /// 加载中
  Widget _buildLoadingSection() {
    return SantoSection(
      title: '加载中',
      description: 'loading 为 true 时文案前展示 loading 图标且不可点击,避免重复提交',
      child: _wrap(<Widget>[
        _button(text: '提交', type: SantoButtonType.primary, loading: true),
        _button(text: '提交', type: SantoButtonType.normal, loading: true),
        _button(text: '提交', type: SantoButtonType.dashed, loading: true),
        _button(
          text: '提交',
          type: SantoButtonType.primary,
          loading: true,
          iconPlacement: SantoButtonIconPlacement.end,
        ),
      ]),
    );
  }

  /// 多种尺寸
  Widget _buildSizeSection() {
    return SantoSection(
      title: '多种尺寸',
      description: 'size 分 large、middle(默认)、small 三档,分别对应 48/32/24 的高度与 16/14/12 的字号;'
          '中号按钮最小宽度为 84',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _wrap(<Widget>[
            _button(
              text: '大号按钮',
              type: SantoButtonType.primary,
              size: SantoButtonSize.large,
            ),
            _button(text: '中号按钮', type: SantoButtonType.primary),
            _button(
              text: '小号按钮',
              type: SantoButtonType.primary,
              size: SantoButtonSize.small,
            ),
          ]),
          const SizedBox(height: 12),
          _wrap(<Widget>[
            _button(
              text: '大号按钮',
              type: SantoButtonType.normal,
              size: SantoButtonSize.large,
            ),
            _button(text: '中号按钮', type: SantoButtonType.normal),
            _button(
              text: '小号按钮',
              type: SantoButtonType.normal,
              size: SantoButtonSize.small,
            ),
          ]),
        ],
      ),
    );
  }

  /// 禁用
  Widget _buildDisabledSection() {
    return SantoSection(
      title: '禁用',
      description: 'isEnable 为 false 时按钮置灰且不响应点击;实心按钮置灰底色,描边与文本类按钮文字置灰',
      child: _wrap(<Widget>[
        _button(text: '主按钮', type: SantoButtonType.primary, isEnable: false),
        _button(text: '默认按钮', type: SantoButtonType.normal, isEnable: false),
        _button(text: '虚线按钮', type: SantoButtonType.dashed, isEnable: false),
        _button(text: '文本按钮', type: SantoButtonType.text, isEnable: false),
        _button(text: '链接按钮', type: SantoButtonType.link, isEnable: false),
        _button(
          text: '危险主按钮',
          type: SantoButtonType.primary,
          danger: true,
          isEnable: false,
        ),
      ]),
    );
  }

  /// block 按钮
  Widget _buildBlockSection() {
    return SantoSection(
      title: 'block 按钮',
      description: 'block 为 true 时按钮撑满父布局宽度,高度仍由 size 决定',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _button(text: '确定', type: SantoButtonType.primary, block: true),
          const SizedBox(height: 12),
          _button(text: '取消', type: SantoButtonType.normal, block: true),
          const SizedBox(height: 12),
          _button(
            text: '小号 block',
            type: SantoButtonType.primary,
            size: SantoButtonSize.small,
            block: true,
          ),
        ],
      ),
    );
  }

  /// 颜色与变体(对标 antd color + variant)
  Widget _buildColorVariantSection() {
    return SantoSection(
      title: '颜色与变体',
      description: '同时设置 color 与 variant 可以派生出更多变体按钮:'
          'color 取主题的语义色(neutral/primary/danger/success/warning/info),'
          'variant 分 outlined/dashed/solid/filled/text/link',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (final SantoButtonColor buttonColor in SantoButtonColor.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  for (final SantoButtonVariant buttonVariant
                      in SantoButtonVariant.values)
                    _button(
                      text: buttonVariant.name,
                      color: buttonColor,
                      variant: buttonVariant,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// 形状
  Widget _buildShapeSection() {
    return SantoSection(
      title: '按钮形状',
      description: 'shape 为 normal 是圆角矩形,round 是两端半圆,circle 是圆形(仅图标)',
      child: _wrap(<Widget>[
        _button(
          text: '圆角矩形',
          type: SantoButtonType.primary,
          size: SantoButtonSize.large,
        ),
        _button(
          text: '两端半圆',
          type: SantoButtonType.primary,
          size: SantoButtonSize.large,
          shape: SantoButtonShape.round,
        ),
        _button(
          text: '两端半圆',
          type: SantoButtonType.normal,
          shape: SantoButtonShape.round,
        ),
        SantoButton(
          icon: const Icon(Icons.search, size: 16, color: Colors.white),
          type: SantoButtonType.primary,
          shape: SantoButtonShape.circle,
          onTap: () => SantoToast.show('点击了圆形按钮', context),
        ),
      ]),
    );
  }

  /// 自定义禁用底色(对标 antd Custom disabled backgroundColor)
  Widget _buildCustomDisabledBgSection() {
    return SantoSection(
      title: '自定义禁用底色',
      description: '通过 disableBackgroundColor 与 disableTextColor 自定义禁用态配色',
      child: _wrap(<Widget>[
        _button(
          text: '默认禁用配色',
          type: SantoButtonType.primary,
          isEnable: false,
        ),
        _button(
          text: '自定义禁用配色',
          type: SantoButtonType.primary,
          isEnable: false,
          disableBackgroundColor: const Color(0xFF1677FF).withOpacity(0.2),
          disableTextColor: const Color(0xFF1677FF).withOpacity(0.4),
        ),
      ]),
    );
  }

  /// 按钮组合:原按钮面板/吸底按钮面板已删除,组合布局由调用方拼装
  Widget _buildMultipleSection() {
    return SantoSpace(
      direction: SantoSpaceDirection.vertical,
      customSize:
          SantoThemeConfigurator.instance.getConfig().commonConfig.gapMd,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SantoSection(
          title: '按钮组合',
          description: 'Row 中主按钮与次按钮平分可用宽度,间距 10,主按钮在右符合操作区习惯',
          child: Row(
            children: <Widget>[
              Expanded(
                child: _button(text: '次按钮', type: SantoButtonType.normal),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _button(text: '主按钮', type: SantoButtonType.primary),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '带图文按钮的组合',
          description: '图文按钮(图标在上、文字在下)放在左侧,主按钮占满剩余宽度,模拟常见的底部操作栏',
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
            color: Colors.white,
            child: Row(
              children: <Widget>[
                _button(
                  text: '已选(2)',
                  type: SantoButtonType.text,
                  iconPlacement: SantoButtonIconPlacement.top,
                  iconSize: 24,
                  fontSize: 12,
                  insertPadding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  icon: const Icon(Icons.check_circle_outline, size: 24),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _button(
                    text: '确定',
                    type: SantoButtonType.primary,
                    size: SantoButtonSize.large,
                    block: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
