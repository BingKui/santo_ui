import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 折叠面板容器
///
/// 包含多个 [SantoCollapsePanel]，支持手风琴模式（同时只展开一个面板）。
///
/// 使用示例：
/// ```dart
/// SantoCollapse(
///   accordion: true,
///   children: [
///     SantoCollapsePanel(title: '面板1', child: Text('内容1')),
///     SantoCollapsePanel(title: '面板2', child: Text('内容2')),
///   ],
/// )
/// ```
class SantoCollapse extends StatefulWidget {
  /// 是否为手风琴模式（同时只展开一个），默认 false
  final bool accordion;

  /// 面板列表
  final List<SantoCollapsePanel> children;

  const SantoCollapse({
    Key? key,
    this.accordion = false,
    required this.children,
  }) : super(key: key);

  @override
  State<SantoCollapse> createState() => _SantoCollapseState();
}

class _SantoCollapseState extends State<SantoCollapse> {
  /// 记录每个面板的展开状态
  late List<bool> _expandedStates;

  @override
  void initState() {
    super.initState();
    _expandedStates =
        widget.children.map((panel) => panel.expanded ?? false).toList();
  }

  @override
  void didUpdateWidget(covariant SantoCollapse oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 当 children 数量变化时重新初始化状态列表
    if (widget.children.length != oldWidget.children.length) {
      _expandedStates =
          widget.children.map((panel) => panel.expanded ?? false).toList();
    }
  }

  void _onPanelTap(int index) {
    setState(() {
      if (widget.accordion) {
        // 手风琴模式：关闭其他面板
        for (int i = 0; i < _expandedStates.length; i++) {
          _expandedStates[i] = (i == index) ? !_expandedStates[i] : false;
        }
      } else {
        _expandedStates[index] = !_expandedStates[index];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.children.length, (index) {
        final panel = widget.children[index];
        return _SantoCollapsePanelWidget(
          title: panel.title,
          expanded: _expandedStates[index],
          onExpandChanged: panel.onExpandChanged,
          onTap: () {
            _onPanelTap(index);
            panel.onExpandChanged?.call(_expandedStates[index]);
          },
          child: panel.child,
        );
      }),
    );
  }
}

/// 折叠面板单个面板
///
/// 可展开/收起的内容区域，通常作为 [SantoCollapse] 的子组件使用。
class SantoCollapsePanel extends StatelessWidget {
  /// 面板标题
  final Widget title;

  /// 初始是否展开，默认 false
  final bool? expanded;

  /// 面板内容
  final Widget child;

  /// 展开/收起状态变化回调
  final ValueChanged<bool>? onExpandChanged;

  const SantoCollapsePanel({
    Key? key,
    required this.title,
    this.expanded,
    required this.child,
    this.onExpandChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 当独立使用时，由 _SantoCollapsePanelWidget 包装
    return _SantoCollapsePanelWidget(
      title: title,
      expanded: expanded ?? false,
      child: child,
      onTap: () {},
    );
  }
}

/// 折叠面板内部实现组件
class _SantoCollapsePanelWidget extends StatelessWidget {
  final Widget title;
  final bool expanded;
  final Widget child;
  final VoidCallback onTap;
  final ValueChanged<bool>? onExpandChanged;

  const _SantoCollapsePanelWidget({
    Key? key,
    required this.title,
    required this.expanded,
    required this.child,
    required this.onTap,
    this.onExpandChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 标题区域
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(child: title),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 22,
                    color: commonConfig.colorTextHint,
                  ),
                ),
              ],
            ),
          ),
        ),
        // 内容区域（带动画）
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: child,
          ),
          crossFadeState: expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
        // 分割线
        Divider(
          height: 1,
          thickness: 0.5,
          color: commonConfig.dividerColorBase,
        ),
      ],
    );
  }
}
