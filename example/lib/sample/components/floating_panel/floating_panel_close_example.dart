import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

/// FloatingPanel 标头右侧关闭按钮示例
///
/// header 里放标题 + 右侧关闭图标,点击后受控收起到最小锚点;
/// 关闭按钮要放在 header 插槽内,面板本身不提供 close 配置。
class FloatingPanelCloseExample extends StatefulWidget {
  const FloatingPanelCloseExample({Key? key}) : super(key: key);

  @override
  State<FloatingPanelCloseExample> createState() =>
      _FloatingPanelCloseExampleState();
}

class _FloatingPanelCloseExampleState
    extends State<FloatingPanelCloseExample> {
  late final List<double> _anchors;

  double _height = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final screenHeight = MediaQuery.of(context).size.height;
    _anchors = [100, screenHeight * 0.35, screenHeight * 0.85];
    _height = _anchors[1];
  }

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      backgroundColor: const Color(0xFFF5F6FA),
      title: 'FloatingPanel · 右侧关闭',
      // 内容自带滚动(Column + Expanded),由内层列表避让面板
      scrollable: false,
      children: <Widget>[
        ExampleIntro('floating_panel'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 420),
            children: [
              for (int i = 1; i <= 12; i++)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '背景内容卡片 $i',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
            ],
          ),
        ),
      ],
      // 浮层面板:标头右侧放关闭按钮,点击收起到最小锚点
      overlay: SantoFloatingPanel(
        anchors: _anchors,
        height: _height,
        onHeightChange: (height) => setState(() => _height = height),
        header: Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 12, 8),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  '筛选条件',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              // 样式对齐 AppBar 返回按钮(SantoBackLeading):
              // 32×32 点击区 + InkWell 圆角 12 + SantoIcon 20 colorTextBase
              SizedBox(
                width: 32,
                height: 32,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _close,
                    child: Center(
                      child: SantoIcon(
                        SantoIcons.xmark,
                        size: 20,
                        color: SantoThemeConfigurator.instance
                            .getConfig()
                            .commonConfig
                            .colorTextBase,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        child: ListView(
          children: [
            for (int i = 1; i <= 16; i++)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Text(
                  '筛选项 $i',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _close() {
    setState(() => _height = _anchors.first);
    SantoToast.show('面板已收起', context);
  }
}
